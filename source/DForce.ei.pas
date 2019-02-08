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
unit DForce.ei;

interface

uses DForce.ei.Provider.Interfaces, DForce.ei.Response.Interfaces, System.Classes,
  DForce.ei.Invoice.Interfaces, System.SysUtils, DForce.ei.Logger, DForce.ei.Validation.Interfaces,
  DForce.ei.Notification.Interfaces, DForce.ei.Utils.Sanitizer,
  DForce.ei.Utils.P7mExtractor;

const
  // Delay time in millisec between every provider API call
  // You can set your custom value by calling ei.SetDelay method
  CONST_DELAY = 500;

type

  TeiResponseType = TeiResponseTypeInt;

  IeiInvoice = IeiInvoiceEx;
  IeiInvoiceCollection = IeiInvoiceCollectionEx;

  IeiResponse = IeiResponseEx;
  IeiResponseCollection = IeiResponseCollectionEx;

  IeiInvoiceIDCollection = IeiInvoiceIDCollectionEx;

  IeiValidationResultCollection = IeiValidationResultCollectionInt;
  IeiValidationResult = IeiValidationResultInt;

  IeiNotificationNS = IeiNotificationNSEx;
  IeiNotificationNE = IeiNotificationNEEx;

  ei = class
  private
    class var FProviderID: String; // Current selected provider ID
    class var FProvider: IeiProvider;
    class var FDelay: integer;
  protected
    class function InternalExecute<T, TResult>(const AParam: T; const AMethod: TFunc<T, TResult>): TResult;
    class function ProviderExists: Boolean;
  public
    class constructor Create;

    class function ResponseTypeForHumans(const AResponseType: TeiResponseType): string;
    class function ResponseTypeToString(const AResponseType: TeiResponseType): string;
    class function StringToResponseType(const AResponseType: String): TeiResponseType;

    class procedure LogI(const ALogMessage: string);
    class procedure LogW(const ALogMessage: string);
    class procedure LogE(const ALogMessage: string); overload; // Error
    class procedure LogE(const E: Exception); overload; // Exception
    class procedure LogBlank;
    class procedure LogSeparator;

    class procedure SelectProvider(const AProviderID, AUserName, APassword: String; const ABaseURL: String = '';
      const ABaseURLAuth: String = ''); overload;
    class procedure Connect;
    class procedure Disconnect;
    class procedure ProvidersAsStrings(const AStrings: TStrings); overload;
    class function ProvidersAsStrings: TStrings; overload;

    class function NewResponse: IeiResponse;
    class function NewResponseCollection: IeiResponseCollection;

    class function NewInvoice: IeiInvoice;
    class function NewInvoiceFromString(const AStringXML: String): IeiInvoice;
    class function NewInvoiceFromStringBase64(const ABase64StringXML: String): IeiInvoice;
    class function NewInvoiceFromFile(const AFileName: String): IeiInvoice;
    class function NewInvoiceFromStream(const AStream: TStream): IeiInvoice;
    class function NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoice;

    class function NewNotificationNSFromString(const AStringXML: String): IeiNotificationNS;
    class function NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNS;
    class function NewNotificationNSFromFile(const AFileName: String): IeiNotificationNS;
    class function NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNS;
    class function NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNS;

    class function NewNotificationNEFromString(const AStringXML: String): IeiNotificationNE;
    class function NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNE;
    class function NewNotificationNEFromFile(const AFileName: String): IeiNotificationNE;
    class function NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNE;
    class function NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNE;

    class function NewInvoiceCollection: IeiInvoiceCollection;
    class function NewInvoiceIDCollection: IeiInvoiceIDCollection;

    class function SendInvoice(const AInvoice: String): IeiResponseCollection; overload;
    class function SendInvoice(const AInvoice: IeiInvoice): IeiResponseCollection; overload;
    class function SendInvoiceCollection(const AInvoiceCollection: IeiInvoiceCollection): IeiResponseCollection; overload;
    class procedure SendInvoiceCollection(const AInvoiceCollection: IeiInvoiceCollection;
      const AAfterEachMethod: TProc<IeiResponseCollection>;
      const AOnEachErrorMethod: TProc<IeiResponseCollection, Exception> = nil); overload;

    class function ReceiveInvoiceNotifications(const AInvoiceID: String): IeiResponseCollection;
    class function ReceiveInvoiceCollectionNotifications(const AInvoiceIDCollection: IeiInvoiceIDCollection)
      : IeiResponseCollection; overload;
    class procedure ReceiveInvoiceCollectionNotifications(const AInvoiceIDCollection: IeiInvoiceIDCollection;
      const AAfterEachMethod: TProc<IeiResponseCollection, String>;
      const AOnEachErrorMethod: TProc<IeiResponseCollection, Exception, String> = nil); overload;

    class function ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime;
      AEndDate: TDateTime = 0): IeiInvoiceIDCollectionEx;
    class function ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponse;
    class function ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollection;

    class procedure SetCustomExtractP7mMethod(const AMethod: TeiExtractP7mMethod);
    class procedure SetDelay(const ADelayMilliSec: integer);
  end;

implementation

uses DForce.ei.Exception, DForce.ei.Invoice.Factory, DForce.ei.Provider.Register,
  DForce.ei.Utils, DForce.ei.Response.Factory, DForce.ei.Provider.Notary,
  DForce.ei.Notification.Factory;

{ fe }

class function ei.ProviderExists: Boolean;
begin
  Result := Assigned(FProvider);
end;

class procedure ei.Connect;
begin
  LogSeparator;
  LogI(Format('Trying to connect to %S', [FProviderID]));
  try
    if ProviderExists then
      raise eiGenericException.Create('There is an already connected provider');
    FProvider := TeiProviderRegister.NewProviderInstance(FProviderID); // Set the current selected (and connected) provider instance
    FProvider.Connect;
    LogI(Format('Connected to %S', [FProviderID]));
  except
    on E: Exception do
    begin
      FProvider := nil;
      LogE(E);
      raise;
    end;
  end;
end;

class constructor ei.Create;
begin
  FDelay := CONST_DELAY;
end;

class procedure ei.Disconnect;
begin
  LogI(Format('Disconnecting from %S', [FProviderID]));
  try
    if ProviderExists then
      FProvider.Disconnect;
    FProvider := nil; // Destroy
    LogI(Format('Disconnected from %S', [FProviderID]));
  except
    on E: Exception do
    begin
      LogE(E);
      raise;
    end;
  end;
end;

class function ei.ReceiveInvoiceCollectionNotifications(const AInvoiceIDCollection: IeiInvoiceIDCollection): IeiResponseCollection;
begin
  Result := InternalExecute<IeiInvoiceIDCollection, IeiResponseCollection>(AInvoiceIDCollection,
    function(AInvoiceIDCollection: IeiInvoiceIDCollection): IeiResponseCollection
    var
      LInvoiceID: string;
    begin
      Result := TeiResponseFactory.NewResponseCollection;
      for LInvoiceID in AInvoiceIDCollection do
        Result.AddRange(ei.ReceiveInvoiceNotifications(LInvoiceID));
    end);
end;

class function ei.ReceiveInvoiceNotifications(const AInvoiceID: String): IeiResponseCollection;
begin
  Sleep(FDelay);
  Result := InternalExecute<String, IeiResponseCollection>(AInvoiceID,
    function(Invoice: String): IeiResponseCollection
    begin
      LogI(Format('Getting notifications for invoice "%s"', [AInvoiceID]));
      try
        // Type here the code to be executed...
        Result := FProvider.ReceiveInvoiceNotifications(AInvoiceID);
        LogI(Format('Got notifications for invoice "%s"', [AInvoiceID]));
      except
        on E: Exception do
        begin
          LogE(E);
          raise;
        end;
      end;
    end);
end;

class function ei.InternalExecute<T, TResult>(const AParam: T; const AMethod: TFunc<T, TResult>): TResult;
var
  LProviderAlreadyExists: Boolean;
begin
  // Before execution
  LProviderAlreadyExists := ProviderExists;
  if not LProviderAlreadyExists then
    Connect;
  try
    // Execute
    Result := AMethod(AParam);
  finally
    // After execution
    if not LProviderAlreadyExists then
      Disconnect;
  end;
end;

class function ei.ResponseTypeForHumans(const AResponseType: TeiResponseType): string;
begin
  Result := TeiUtils.ResponseTypeForHumans(AResponseType);
end;

class function ei.ResponseTypeToString(const AResponseType: TeiResponseType): string;
begin
  Result := TeiUtils.ResponseTypeToString(AResponseType);
end;

class procedure ei.LogE(const ALogMessage: string);
begin
  TeiLogger.LogE(ALogMessage);
end;

class procedure ei.LogBlank;
begin
  TeiLogger.LogBlank;
end;

class procedure ei.LogE(const E: Exception);
begin
  TeiLogger.LogE(E);
end;

class procedure ei.LogI(const ALogMessage: string);
begin
  TeiLogger.LogI(ALogMessage);
end;

class procedure ei.LogSeparator;
begin
  TeiLogger.LogSeparator;
end;

class procedure ei.LogW(const ALogMessage: string);
begin
  TeiLogger.LogW(ALogMessage);
end;

class function ei.NewInvoice: IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoice;
end;

class function ei.NewInvoiceCollection: IeiInvoiceCollection;
begin
  Result := TeiInvoiceFactory.NewInvoiceCollection;
end;

class function ei.NewInvoiceFromFile(const AFileName: String): IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoiceFromFile(AFileName);
end;

class function ei.NewInvoiceFromStream(const AStream: TStream): IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoiceFromStream(AStream);
end;

class function ei.NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoiceFromStreamBase64(AStream);
end;

class function ei.NewInvoiceFromString(const AStringXML: String): IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoiceFromString(AStringXML);
end;

class function ei.NewInvoiceFromStringBase64(const ABase64StringXML: String): IeiInvoice;
begin
  Result := TeiInvoiceFactory.NewInvoiceFromStringBase64(ABase64StringXML);
end;

class function ei.NewInvoiceIDCollection: IeiInvoiceIDCollection;
begin
  Result := TeiInvoiceFactory.NewInvoiceIDCollection;
end;

class function ei.NewNotificationNEFromFile(const AFileName: String): IeiNotificationNE;
begin
  Result := TeiNotificationFactory.NewNotificationNEFromFile(AFileName);
end;

class function ei.NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNE;
begin
  Result := TeiNotificationFactory.NewNotificationNEFromStream(AStream);
end;

class function ei.NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNE;
begin
  Result := TeiNotificationFactory.NewNotificationNEFromStreamBase64(AStream);
end;

class function ei.NewNotificationNEFromString(const AStringXML: String): IeiNotificationNE;
begin
  Result := TeiNotificationFactory.NewNotificationNEFromString(AStringXML);
end;

class function ei.NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNE;
begin
  Result := TeiNotificationFactory.NewNotificationNEFromStringBase64(ABase64StringXML);
end;

class function ei.NewNotificationNSFromFile(const AFileName: String): IeiNotificationNS;
begin
  Result := TeiNotificationFactory.NewNotificationNSFromFile(AFileName);
end;

class function ei.NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNS;
begin
  Result := TeiNotificationFactory.NewNotificationNSFromStream(AStream);
end;

class function ei.NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNS;
begin
  Result := TeiNotificationFactory.NewNotificationNSFromStreamBase64(AStream);
end;

class function ei.NewNotificationNSFromString(const AStringXML: String): IeiNotificationNS;
begin
  Result := TeiNotificationFactory.NewNotificationNSFromString(AStringXML);
end;

class function ei.NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNS;
begin
  Result := TeiNotificationFactory.NewNotificationNSFromStringBase64(ABase64StringXML);
end;

class function ei.NewResponse: IeiResponse;
begin
  Result := TeiResponseFactory.NewResponse;
end;

class function ei.NewResponseCollection: IeiResponseCollection;
begin
  Result := TeiResponseFactory.NewResponseCollection;
end;

class procedure ei.ProvidersAsStrings(const AStrings: TStrings);
begin
  TeiProviderRegister.ProvidersAsStrings(AStrings);
end;

class function ei.ProvidersAsStrings: TStrings;
begin
  Result := TeiProviderRegister.ProvidersAsStrings;
end;

class procedure ei.SelectProvider(const AProviderID, AUserName, APassword, ABaseURL, ABaseURLAuth: String);
begin
  LogI(Format('Selecting provider "%s"', [AProviderID]));
  try
    FProviderID := AProviderID; // Set the current selected provider ID
    TeiProviderRegister.UpdateProviderData(AProviderID, AUserName, APassword, ABaseURL, ABaseURLAuth);
    LogI(Format('Provider "%s" is now selected', [AProviderID]));
  except
    on E: Exception do
    begin
      LogE(E);
      raise;
    end;
  end;
end;

class function ei.SendInvoice(const AInvoice: String): IeiResponseCollection;
begin
  Result := SendInvoice(NewInvoiceFromString(AInvoice));
end;

class function ei.SendInvoice(const AInvoice: IeiInvoice): IeiResponseCollection;
begin
  Sleep(FDelay);
  Result := InternalExecute<IeiInvoice, IeiResponseCollection>(AInvoice,
    function(Invoice: IeiInvoice): IeiResponseCollection
    var
      LDocNum: string;
    begin
      LDocNum := AInvoice.FatturaElettronicaBody.Items[0].DatiGenerali.DatiGeneraliDocumento.Numero;
      LogI(Format('Sending invoice "%s"', [LDocNum]));
      try
        Result := FProvider.SendInvoice(AInvoice.ToString);
        Result[0].Invoice := AInvoice; // Inject the Invoice itself in the first (and only) response
        LogI(Format('Invoice "%s" sent', [LDocNum]));
      except
        on E: Exception do
        begin
          LogE(E);
          raise;
        end;
      end;
    end);
end;

class function ei.SendInvoiceCollection(const AInvoiceCollection: IeiInvoiceCollection): IeiResponseCollection;
begin
  Result := InternalExecute<IeiInvoiceCollection, IeiResponseCollection>(AInvoiceCollection,
    function(AInvoiceCollection: IeiInvoiceCollection): IeiResponseCollection
    var
      LInvoice: IeiInvoice;
    begin
      Result := TeiResponseFactory.NewResponseCollection;
      for LInvoice in AInvoiceCollection do
        Result.AddRange(SendInvoice(LInvoice));
    end);
end;

class procedure ei.SendInvoiceCollection(const AInvoiceCollection: IeiInvoiceCollection;
const AAfterEachMethod: TProc<IeiResponseCollection>; const AOnEachErrorMethod: TProc<IeiResponseCollection, Exception>);
begin
  InternalExecute<IeiInvoiceCollection, integer>(AInvoiceCollection,
    function(AInvoiceCollection: IeiInvoiceCollection): integer
    var
      LInvoice: IeiInvoice;
      LResponseCollection: IeiResponseCollection;
    begin
      Result := 0;
      for LInvoice in AInvoiceCollection do
      begin
        try
          LResponseCollection := nil; // Azzera la response perchè se ci sono degli errori potrebbe rimanere quella precedente
          LResponseCollection := SendInvoice(LInvoice);
          Inc(Result);
          if Assigned(AAfterEachMethod) then
            AAfterEachMethod(LResponseCollection);
        except
          on E: Exception do
          begin
            LogE(E);
            if Assigned(AOnEachErrorMethod) then
              AOnEachErrorMethod(LResponseCollection, E)
            else
              raise;
          end;
        end;
      end;
    end);
end;

class procedure ei.SetCustomExtractP7mMethod(const AMethod: TeiExtractP7mMethod);
begin
  TExtractP7m.SetCustomExtractP7mMethod(AMethod);
end;

class procedure ei.SetDelay(const ADelayMilliSec: integer);
begin
  FDelay := ADelayMilliSec;
end;

class function ei.StringToResponseType(const AResponseType: String): TeiResponseType;
begin
  Result := TeiUtils.StringToResponseType(AResponseType);
end;

class procedure ei.ReceiveInvoiceCollectionNotifications(const AInvoiceIDCollection: IeiInvoiceIDCollection;
const AAfterEachMethod: TProc<IeiResponseCollection, String>; const AOnEachErrorMethod: TProc<IeiResponseCollection, Exception, String>);
begin
  InternalExecute<IeiInvoiceIDCollection, IeiResponseCollection>(AInvoiceIDCollection,
    function(AInvoiceIDCollection: IeiInvoiceIDCollection): IeiResponseCollection
    var
      LInvoiceID: string;
      LResponseCollection: IeiResponseCollection;
    begin
      Result := TeiResponseFactory.NewResponseCollection;
      for LInvoiceID in AInvoiceIDCollection do
      begin
        try
          LResponseCollection := nil; // Azzera la response perchè se ci sono degli errori potrebbe rimanere quella precedente
          LResponseCollection := ei.ReceiveInvoiceNotifications(LInvoiceID);
          if Assigned(AAfterEachMethod) then
            AAfterEachMethod(LResponseCollection, LInvoiceID);
        except
          on E: Exception do
          begin
            LogE(E);
            if Assigned(AOnEachErrorMethod) then
              AOnEachErrorMethod(LResponseCollection, E, LInvoiceID)
            else
              raise;
          end;
        end;
      end;
    end);
end;

class function ei.ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime;
AEndDate: TDateTime = 0): IeiInvoiceIDCollectionEx;
begin
  Sleep(FDelay);
  Result := InternalExecute<string, IeiInvoiceIDCollectionEx>('aaa',
    function(dummy: string): IeiInvoiceIDCollectionEx
    begin
      try
        Result := FProvider.ReceivePurchaseInvoiceFileNameCollection(AVatCodeReceiver, AStartDate, AEndDate);
      except
        on E: Exception do
        begin
          LogE(E);
          raise;
        end;
      end;
    end);
end;

class function ei.ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollection;
begin
  Sleep(FDelay);
  Result := InternalExecute<String, IeiResponseCollection>(AInvoiceID,
    function(Invoice: String): IeiResponseCollection
    begin
      LogI(Format('Getting notifications for purchase invoice "%s"', [AInvoiceID]));
      try
        // Type here the code to be executed...
        Result := FProvider.ReceivePurchaseInvoiceNotifications(AInvoiceID);
        LogI(Format('Got notifications for purchase invoice "%s"', [AInvoiceID]));
      except
        on E: Exception do
        begin
          LogE(E);
          raise;
        end;
      end;
    end);
end;

class function ei.ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponseEx;
begin
  Sleep(FDelay);
  Result := InternalExecute<string, IeiResponse>('aaa',
    function(dummy: string): IeiResponse
    begin
      try
        Result := FProvider.ReceivePurchaseInvoiceAsXML(AInvoiceID);
      except
        on E: Exception do
        begin
          LogE(E);
          raise;
        end;
      end;
    end);
end;

initialization

TeiNotary.BuildProviderRegister;

end.
