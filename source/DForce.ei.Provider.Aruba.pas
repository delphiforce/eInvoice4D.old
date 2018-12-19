{***************************************************************************}
{                                                                           }
{           eInvoice4D - (Fatturazione Elettronica per Delphi)              }
{                                                                           }
{           Copyright (C) 2018  Delphi Force                                }
{                                                                           }
{           info@delphiforce.it                                             }
{           https://github.com/delphiforce/eInvoice4D.git                   }
{                                                                  	        }
{           Delphi Force Team                                      	        }
{             Antonio Polito                                                }
{             Carlo Narcisi                                                 }
{             Fabio Codebue                                                 }
{             Marco Mottadelli                                              }
{             Maurizio del Magno                                            }
{             Omar Bossoni                                                  }
{             Thomas Ranzetti                                               }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  This file is part of eInvoice4D                                          }
{                                                                           }
{  Licensed under the GNU Lesser General Public License, Version 3;         }
{  you may not use this file except in compliance with the License.         }
{                                                                           }
{  eInvoice4D is free software: you can redistribute it and/or modify       }
{  it under the terms of the GNU Lesser General Public License as published }
{  by the Free Software Foundation, either version 3 of the License, or     }
{  (at your option) any later version.                                      }
{                                                                           }
{  eInvoice4D is distributed in the hope that it will be useful,            }
{  but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            }
{  GNU Lesser General Public License for more details.                      }
{                                                                           }
{  You should have received a copy of the GNU Lesser General Public License }
{  along with eInvoice4D.  If not, see <http://www.gnu.org/licenses/>.      }
{                                                                           }
{***************************************************************************}
unit DForce.ei.Provider.Aruba;

interface

uses DForce.ei.Provider.Base,
  DForce.ei.Provider.Interfaces,
  DForce.ei.Response.Interfaces;

type

  TeiProviderAruba = class(TeiProviderBase)
  private
    FAccessToken: string;
    { TODO : Implementare sistema di refresh del token in base a lavore expires_in }
    // FStopWatch: TStopWatch;
    procedure Authenticate;
  protected
    procedure Connect; override;
    procedure Disconnect; override;
    function SendInvoice(const AInvoice: string): IeiResponseCollectionEx; override;
    function ReceiveInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx; override;
    procedure ReceivePurchaseInvoices; override;
  end;

implementation

uses System.UITypes,
  REST.Types,
  REST.Client,
  System.NetEncoding,
  System.SysUtils,
  System.StrUtils,
  DForce.ei.Exception,
  System.JSON,
  DForce.ei.Utils,
  DForce.ei.Response.Factory;

procedure TeiProviderAruba.Authenticate;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  LFullTokenJson: TJSONObject;
begin
  LFullTokenJson := nil;
  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try

    LRESTClient.BaseURL := BaseURLAuth;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/x-www-form-urlencoded';

    LRESTRequest.Resource := '/auth/signin';
    LRESTRequest.Method := rmPOST;
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;

    LRESTRequest.AddParameter('grant_type', 'password');
    LRESTRequest.AddParameter('username', UserName);
    LRESTRequest.AddParameter('password', Password);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiRESTAuthException.CreateFmt('Error during auth request: %s', [LRESTResponse.Content]);

    LFullTokenJson := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if not LFullTokenJson.TryGetValue<string>('access_token', FAccessToken) then
      raise eiRESTAuthException.Create('Error during auth request: access_token property not found');
    // if not LFullTokenJson.TryGetValue<string>('expires', LExpiresString) then
    // raise FE_RESTAuthException.Create('Error during auth request: expires property not found');
    { TODO : Introdurre libreria conversione date }
    // FExpires := TeiUtils.DateTimeFromIso8601(LExpiresString);

  finally
    if Assigned(LFullTokenJson) then
      LFullTokenJson.Free;
    LRESTClient.Free;
    LRESTRequest.Free;
    LRESTResponse.Free;
  end;
end;

procedure TeiProviderAruba.Connect;
begin
  inherited;
  Authenticate;
end;

procedure TeiProviderAruba.Disconnect;
begin
  inherited;
  // Nothing
end;

function TeiProviderAruba.SendInvoice(const AInvoice: string): IeiResponseCollectionEx;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  LJSONBody: string;
  JObjResponse: TJSONObject;
  LBase64Invoice: string;
  LResponse: IeiResponseEx;
begin
{$IFNDEF VER280}
  inherited;
  JObjResponse := nil;

  LBase64Invoice := TNetEncoding.Base64.Encode(AInvoice);
  LJSONBody := '{"dataFile" : "' + LBase64Invoice + '", "credential" : "", "domain" : ""}';

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json';

    LRESTRequest.Resource := '/services/invoice/upload';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmPOST;
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);
    LRESTRequest.Body.Add(LJSONBody, TRESTContentType.ctAPPLICATION_JSON);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('Sending invoice error: %d - %s', [LRESTResponse.StatusCode, LRESTResponse.StatusText]));

    Result := TeiResponseFactory.NewResponseCollection;
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    LResponse := TeiResponseFactory.NewResponse;
    with JObjResponse.GetValue('errorCode')
      do LResponse.MsgCode := IfThen(Null, '', Value);
    with JObjResponse.GetValue('errorDescription')
      do LResponse.MsgText := IfThen(Null, '', Value);
    if (LResponse.MsgCode.Trim.IsEmpty)or(LResponse.MsgCode.Equals(StringOfChar('0', LResponse.MsgCode.Length))) then
    begin
      LResponse.ResponseType := rtAcceptedByProvider;
      LResponse.FileName := JObjResponse.GetValue<TJSONString>('uploadFileName').Value;
    end else
    begin
      LResponse.ResponseType := rtRejectedByProvider;
    end;
    Result.Add(LResponse);

  finally
    if Assigned(JObjResponse) then
      JObjResponse.Free;
    LRESTClient.Free;
    LRESTRequest.Free;
    LRESTResponse.Free;
  end;
{$ENDIF VER280}
end;

function TeiProviderAruba.ReceiveInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  LResponse: IeiResponseEx;
  JObjResponse: TJSONObject;
  LJsonNotifications: TJSONArray;
  LJsonNotification: TJSONValue;
begin
  inherited;
  JObjResponse := nil;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json';

    LRESTRequest.Resource := '/services/notification/out/getByInvoiceFilename';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmGET;

    LRESTRequest.AddParameter('invoiceFilename', AInvoiceID);
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('getByInvoiceFilename error: %d - %s', [LRESTResponse.StatusCode, LRESTResponse.StatusText]));

    Result := TeiResponseFactory.NewResponseCollection;
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      LJsonNotifications := JObjResponse.GetValue<TJSONArray>('notifications');
      for LJsonNotification in LJsonNotifications do
      begin
        LResponse := TeiResponseFactory.NewResponse;
        LResponse.ResponseType := TeiUtils.ResponseTypeToEnum(LJsonNotification.GetValue<TJSONString>('docType').Value);
        LResponse.FileName := LJsonNotification.GetValue<TJSONString>('filename').Value;
        LResponse.ResponseDate := TeiUtils.DateTimeUTCFromIso8601(LJsonNotification.GetValue<TJSONString>('date').Value);
        LResponse.NotificationDate := TeiUtils.DateTimeUTCFromIso8601(LJsonNotification.GetValue<TJSONString>('notificationDate').Value);
        LResponse.MsgCode := '';
        LResponse.MsgText := '';
        LResponse.MsgRaw := LJsonNotification.ToString;
        Result.Add(LResponse);
      end;
    end;

  finally
    if Assigned(JObjResponse) then
      JObjResponse.Free;
    LRESTClient.Free;
    LRESTRequest.Free;
    LRESTResponse.Free;
  end;
end;

procedure TeiProviderAruba.ReceivePurchaseInvoices;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  JObjResponse: TJSONObject;
begin
  inherited;
  JObjResponse := nil;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json';

    LRESTRequest.Resource := '/services/invoice/in/findByUsername';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmGET;
    LRESTRequest.AddParameter('username', UserName);
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('ReceivePurchaseInvoices error: %d - %s',
        [LRESTResponse.StatusCode, LRESTResponse.StatusText]));

    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      // to implement...
    end;

  finally
    if Assigned(JObjResponse) then
      JObjResponse.Free;
    LRESTClient.Free;
    LRESTRequest.Free;
    LRESTResponse.Free;
  end;
end;

end.
