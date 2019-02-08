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
  DForce.ei.Response.Interfaces,
  System.JSON,
  DForce.ei.Invoice.Interfaces,
  DForce.ei.Invoice.Factory;

type

  TeiProviderAruba = class(TeiProviderBase)
  private
    FAccessToken: string;
    { TODO : Implementare sistema di refresh del token in base a lavore expires_in }
    procedure Authenticate;
    function JValueToDateTimeDefault(const AValue, ADefaultValue: TJSONValue): TDateTime;
    function JValueToString(const AJSONValue: TJSONValue): String;
    function JValueToInteger(const AJSONValue: TJSONValue): Integer;
    function JValueToBoolean(const AJSONValue: TJSONValue): boolean;
    function PurgeP7mSignature(const AString: string): string;
    function InternalReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate, AEndDate: TDateTime;
      const APage: Integer; AResult: IeiInvoiceIDCollectionEx): boolean;
  protected
    procedure Connect; override;
    procedure Disconnect; override;
    function SendInvoice(const AInvoice: string): IeiResponseCollectionEx; override;
    function ReceiveInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx; override;
    function ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime;
      AEndDate: TDateTime = 0): IeiInvoiceIDCollectionEx; override;
    function ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponseEx; override;
    function ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx; override;
  end;

implementation

uses System.UITypes,
  REST.Types,
  REST.Client,
  System.NetEncoding,
  System.SysUtils,
  DForce.ei.Exception,
  DForce.ei.Utils,
  DForce.ei.Response.Factory,
  System.Math,
  DateUtils, DForce.ei.Utils.P7mExtractor;

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
      raise eiRESTAuthException.Create('Error during auth request');

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

function TeiProviderAruba.InternalReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string;
  const AStartDate, AEndDate: TDateTime; const APage: Integer; AResult: IeiInvoiceIDCollectionEx): boolean;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  JObjResponse: TJSONObject;
  LJsonNotifications: TJSONArray;
  LJsonNotification: TJSONObject;
  I: Integer;
  LJValue: TJSONValue;
begin
  Result := True;
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

    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    // selection parameters
    LRESTRequest.AddParameter('username', UserName);
    LRESTRequest.AddParameter('page', APage.ToString);
    LRESTRequest.AddParameter('startDate', TeiUtils.DateTimeToUrlParam(AStartDate), TRESTRequestParameterKind.pkGETorPOST,
      [poDoNotEncode]);
    LRESTRequest.AddParameter('endDate', TeiUtils.DateTimeToUrlParam(AEndDate), TRESTRequestParameterKind.pkGETorPOST, [poDoNotEncode]);
    if not AVatCodeReceiver.Trim.IsEmpty then
    begin
      LRESTRequest.AddParameter('countryReceiver', 'IT');
      LRESTRequest.AddParameter('vatcodeReceiver', AVatCodeReceiver);
    end;

    // call
    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('ReceivePurchaseInvoices error: %d - %s',
        [LRESTResponse.StatusCode, LRESTResponse.StatusText]));

    // response
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      LJValue := JObjResponse.Values['content'];
      if (LJValue is TJSONArray) then
      begin
        LJsonNotifications := LJValue as TJSONArray;
        for I := 0 to LJsonNotifications.Count - 1 do
        begin
          LJsonNotification := LJsonNotifications.Items[I] as TJSONObject;
          AResult.Add(JValueToString(LJsonNotification.Values['filename']));
        end;
        Result := JValueToBoolean(JObjResponse.GetValue('last'));
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

function TeiProviderAruba.JValueToDateTimeDefault(const AValue, ADefaultValue: TJSONValue): TDateTime;
begin
  // Value
  if Assigned(AValue) and (not AValue.Null) and not AValue.Value.Trim.IsEmpty then
    Result := TeiUtils.DateTimeUTCFromIso8601(AValue.Value)
  else
    // Default value
    if Assigned(ADefaultValue) and (not ADefaultValue.Null) and not ADefaultValue.Value.Trim.IsEmpty then
      Result := TeiUtils.DateTimeUTCFromIso8601(ADefaultValue.Value)
    else
      Result := 0;
end;

function TeiProviderAruba.JValueToInteger(const AJSONValue: TJSONValue): Integer;
begin
  if Assigned(AJSONValue) and (not AJSONValue.Null) and (not AJSONValue.Value.Trim.IsEmpty) and (AJSONValue is TJSONNumber) then
    Result := (AJSONValue as TJSONNumber).AsInt
  else
    Result := 0;
end;

function TeiProviderAruba.JValueToBoolean(const AJSONValue: TJSONValue): boolean;
begin
  if Assigned(AJSONValue) and (not AJSONValue.Null) and (not AJSONValue.Value.Trim.IsEmpty) and (AJSONValue is TJSONBool) then
    Result := (AJSONValue as TJSONBool).AsBoolean
  else
    Result := False;
end;

function TeiProviderAruba.JValueToString(const AJSONValue: TJSONValue): String;
begin
  if Assigned(AJSONValue) and (not AJSONValue.Null) and (not AJSONValue.Value.Trim.IsEmpty) then
    Result := AJSONValue.Value;
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

  LJSONBody := '{"dataFile" : "' + LBase64Invoice + '","credential" : "","domain" : ""}';
  // Correzione per ambiente TEST Aruba: non accetta fatture con lunghezza > 75 caratteri
  if SameText(BaseURLWS, 'https://testws.fatturazioneelettronica.aruba.it') then
  begin
    LBase64Invoice := LBase64Invoice.Substring(0, 75);
    LJSONBody := '{"dataFile" : "' + LBase64Invoice + '","credential" : "cred_firma","domain" : "dom_firma"}';
  end;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json;charset=UTF-8';

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

    LResponse.MsgCode := JValueToString(JObjResponse.Values['errorCode']);
    LResponse.MsgText := JValueToString(JObjResponse.Values['errorDescription']);
    LResponse.FileName := JValueToString(JObjResponse.Values['uploadFileName']);
    LResponse.ResponseDate := Now;
    LResponse.NotificationDate := LResponse.ResponseDate;

    if LResponse.MsgCode.Trim.IsEmpty or (LResponse.MsgCode.Trim = '0000') then
      LResponse.ResponseType := rtAcceptedByProvider
    else
      LResponse.ResponseType := rtRejectedByProvider;
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
  LJsonNotification: TJSONObject;
  LJValue: TJSONValue;
  I: Integer;
begin
  inherited;
  JObjResponse := nil;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json;charset=UTF-8';

    LRESTRequest.Resource := '/services/notification/out/getByInvoiceFilename';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmGET;

    LRESTRequest.AddParameter('invoiceFilename', AInvoiceID);
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('out/getByInvoiceFilename error: %d - %s', [LRESTResponse.StatusCode,
        LRESTResponse.StatusText]));

    Result := TeiResponseFactory.NewResponseCollection;
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      LJValue := JObjResponse.GetValue('notifications');
      if not(LJValue is TJSONNull) then
      begin
        LJsonNotifications := JObjResponse.GetValue<TJSONArray>('notifications');

        for I := 0 to LJsonNotifications.Count - 1 do
        begin
          LJsonNotification := LJsonNotifications.Items[I] as TJSONObject;
          LResponse := TeiResponseFactory.NewResponse;
          LResponse.MsgCode := '';
          LResponse.MsgText := '';
          LResponse.MsgRaw := JValueToString(LJsonNotification.Values['file']);
          if not LResponse.MsgRaw.IsEmpty then
            LResponse.MsgRaw := TNetEncoding.Base64.Decode(LResponse.MsgRaw);
          LResponse.ResponseType := TeiUtils.ResponseTypeToEnum(LJsonNotification.GetValue<TJSONString>('docType').Value,
            LResponse.MsgRaw);
          LResponse.FileName := JValueToString(LJsonNotification.Values['filename']);
          LResponse.ResponseDate := JValueToDateTimeDefault(LJsonNotification.Values['date'],
            LJsonNotification.Values['notificationDate']);
          LResponse.NotificationDate := JValueToDateTimeDefault(LJsonNotification.Values['notificationDate'],
            LJsonNotification.Values['date']);
          Result.Add(LResponse);
        end;
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

function TeiProviderAruba.ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime;
  AEndDate: TDateTime = 0): IeiInvoiceIDCollectionEx;
var
  LastPage: boolean;
  LCurrentPage: Integer;
begin
  Result := TeiInvoiceFactory.NewInvoiceIDCollection;
  if IsZero(AEndDate) then
    AEndDate := EndOfTheDay(Date);
  LCurrentPage := 1;
  repeat
    LastPage := InternalReceivePurchaseInvoiceFileNameCollection(AVatCodeReceiver, AStartDate, AEndDate, LCurrentPage, Result);
    Inc(LCurrentPage);
  until LastPage;
end;

function TeiProviderAruba.ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponseEx;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  JObjResponse: TJSONObject;
  LXml: string;
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

    LRESTRequest.Resource := '/services/invoice/in/getByFilename';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmGET;

    LRESTClient.ContentType := 'application/json;charset=UTF-8';
    LRESTRequest.AddParameter('filename', AInvoiceID);
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('getByFilename error: %d - %s', [LRESTResponse.StatusCode, LRESTResponse.StatusText]));

    Result := TeiResponseFactory.NewResponse;
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      Result.ResponseType := TeiUtils.ResponseTypeToEnum(JObjResponse.GetValue<TJSONString>('docType').Value);
      Result.FileName := JValueToString(JObjResponse.Values['filename']);
      LXml := JValueToString(JObjResponse.Values['file']);
      if pos('.p7m', LowerCase(Result.FileName)) > 0 then
      begin
        // estrazione xml da file p7m
        Result.MsgRaw := TExtractP7m.Extract(LXml);
        // Result.MsgRaw := TeiUtils.DecodeFromBase64WithPurge(LXml);
        // Result.MsgRaw := PurgeP7mSignature(Result.MsgRaw);
      end
      else
      begin
        // estrazione xml senza p7m
        Result.MsgRaw := LXml;
        if not Result.MsgRaw.IsEmpty then
          Result.MsgRaw := TNetEncoding.Base64.Decode(Result.MsgRaw);
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

function TeiProviderAruba.ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx;
var
  LRESTClient: TRESTClient;
  LRESTRequest: TRESTRequest;
  LRESTResponse: TRESTResponse;
  LResponse: IeiResponseEx;
  JObjResponse: TJSONObject;
  LJsonNotifications: TJSONArray;
  LJsonNotification: TJSONObject;
  LJValue: TJSONValue;
  I: Integer;
begin
  inherited;
  JObjResponse := nil;

  LRESTClient := TRESTClient.Create(nil);
  LRESTRequest := TRESTRequest.Create(nil);
  LRESTResponse := TRESTResponse.Create(nil);
  try
    LRESTClient.BaseURL := BaseURLWS;
    LRESTClient.AllowCookies := True;
    LRESTClient.ContentType := 'application/json;charset=UTF-8';

    LRESTRequest.Resource := '/services/notification/in/getByInvoiceFilename';
    LRESTRequest.Client := LRESTClient;
    LRESTRequest.Response := LRESTResponse;
    LRESTRequest.Method := rmGET;

    LRESTRequest.AddParameter('invoiceFilename', AInvoiceID);
    LRESTRequest.AddParameter('Authorization', Format('Bearer %s', [FAccessToken]), TRESTRequestParameterKind.pkHTTPHEADER,
      [poDoNotEncode]);

    LRESTRequest.Execute;
    if LRESTResponse.StatusCode <> 200 then
      raise eiGenericException.Create(Format('in/getByInvoiceFilename error: %d - %s', [LRESTResponse.StatusCode,
        LRESTResponse.StatusText]));

    Result := TeiResponseFactory.NewResponseCollection;
    JObjResponse := TJSONObject.ParseJSONValue(LRESTResponse.JSONText) as TJSONObject;
    if Assigned(JObjResponse) then
    begin
      LJValue := JObjResponse.GetValue('notifications');
      if not(LJValue is TJSONNull) then
      begin
        LJsonNotifications := JObjResponse.GetValue<TJSONArray>('notifications');

        for I := 0 to LJsonNotifications.Count - 1 do
        begin
          LJsonNotification := LJsonNotifications.Items[I] as TJSONObject;
          LResponse := TeiResponseFactory.NewResponse;
          LResponse.MsgCode := '';
          LResponse.MsgText := '';
          LResponse.MsgRaw := JValueToString(LJsonNotification.Values['file']);
          if not LResponse.MsgRaw.IsEmpty then
            LResponse.MsgRaw := TNetEncoding.Base64.Decode(LResponse.MsgRaw);
          LResponse.ResponseType := TeiUtils.ResponseTypeToEnum(LJsonNotification.GetValue<TJSONString>('docType').Value,
            LResponse.MsgRaw);
          LResponse.FileName := JValueToString(LJsonNotification.Values['filename']);
          LResponse.ResponseDate := JValueToDateTimeDefault(LJsonNotification.Values['date'],
            LJsonNotification.Values['notificationDate']);
          LResponse.NotificationDate := JValueToDateTimeDefault(LJsonNotification.Values['notificationDate'],
            LJsonNotification.Values['date']);
          Result.Add(LResponse);
        end;
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

function TeiProviderAruba.PurgeP7mSignature(const AString: string): string;
var
  LStartPos: Integer;
  LEndPos: Integer;
begin
  // rimuovo tutti i caratteri antecedenti "<?xml" e oltre "FatturaElettronica>"
  LStartPos := pos('?xml', AString);
  Result := AString.Substring(LStartPos - 1);
  LEndPos := pos('FatturaElettronica>', Result);
  Result := '<' + Result.Substring(0, LEndPos + 18);
end;

end.
