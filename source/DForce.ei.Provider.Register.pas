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
unit DForce.ei.Provider.Register;

interface

uses System.Generics.Collections, DForce.ei.Provider.Interfaces, DForce.ei.Provider.Base,
  System.Classes;

type

  TeiProviderRegisterItem = class;

  TeiProviderRegister = class
  private
    class var FContainer: TObjectDictionary<String, TeiProviderRegisterItem>;
    class procedure Build;
    class procedure CleanUp;
  public
    class procedure ProvidersAsStrings(const AStrings: TStrings); overload;
    class function ProvidersAsStrings: TStrings; overload;
    class function NewProviderInstance(const AProviderID: string): IeiProvider;
    class procedure RegisterProviderClass<T: TeiProviderBase>(const AProviderID: String; const ABaseUrlWS: String = '';
      const ABaseUrlAuth: String = '');
    class procedure UpdateProviderData(const AProviderID, AUserName, APassword, ABaseUrlWS, ABaseUrlAuth: String);
  end;

  TeiProviderRegisterItem = class
  strict private
    FProviderClassRef: TeiProviderClassRef;
    FBaseUrlWS: String;
    FBaseUrlAuth: String;
    FUserName: String;
    FPassword: String;
  strict protected
    procedure SetBaseUrlAuth(const Value: String);
    procedure SetBaseUrlWS(const Value: String);
    procedure SetPasswords(const Value: String);
    procedure SetUserName(const Value: String);
  protected
    property ProviderClassRef: TeiProviderClassRef read FProviderClassRef write FProviderClassRef;
    property BaseUrlWS: String read FBaseUrlWS write SetBaseUrlWS;
    property BaseUrlAuth: String read FBaseUrlAuth write SetBaseUrlAuth;
    property UserName: String read FUserName write SetUserName;
    property Password: String read FPassword write SetPasswords;
  public
    constructor Create(const AProviderClassRef: TeiProviderClassRef; const ABaseUrlWS, ABaseUrlAuth: String);
  end;

implementation

uses DForce.ei.Exception, System.SysUtils;

{ TeiProviderContainer }

class procedure TeiProviderRegister.Build;
begin
  FContainer := TObjectDictionary<String, TeiProviderRegisterItem>.Create([doOwnsValues]);;
end;

class procedure TeiProviderRegister.CleanUp;
begin
  FContainer.Free;
end;

class function TeiProviderRegister.NewProviderInstance(const AProviderID: string): IeiProvider;
var
  LProviderRegisterItem: TeiProviderRegisterItem;
begin
  if not FContainer.ContainsKey(AProviderID) then
    raise eiGenericException.Create(Format('Provider "%s" not registered', [AProviderID]));
  LProviderRegisterItem := FContainer.Items[AProviderID];
  Result := LProviderRegisterItem.ProviderClassRef.Create(LProviderRegisterItem.UserName, LProviderRegisterItem.Password,
    LProviderRegisterItem.BaseUrlWS, LProviderRegisterItem.BaseUrlAuth);
end;

class procedure TeiProviderRegister.ProvidersAsStrings(const AStrings: TStrings);
var
  LStr: String;
begin
  if not Assigned(AStrings) then
    raise eiGenericException.Create('TeiProviderRegister.ProvidersAsStrings: parameter not assigned');
  for LStr in FContainer.Keys do
    AStrings.Add(LStr);
end;

class function TeiProviderRegister.ProvidersAsStrings: TStrings;
begin
  Result := TStringList.Create;
  ProvidersAsStrings(Result);
end;

class procedure TeiProviderRegister.RegisterProviderClass<T>(const AProviderID, ABaseUrlWS, ABaseUrlAuth: String);
begin
  if FContainer.ContainsKey(AProviderID) then
    raise eiGenericException.Create(Format('Provider "%s" already registered', [AProviderID]));
  FContainer.Add(AProviderID, TeiProviderRegisterItem.Create(T, ABaseUrlWS, ABaseUrlAuth));
end;

class procedure TeiProviderRegister.UpdateProviderData(const AProviderID, AUserName, APassword, ABaseUrlWS, ABaseUrlAuth: String);
var
  LProviderRegisterItem: TeiProviderRegisterItem;
begin
  if not FContainer.ContainsKey(AProviderID) then
    raise eiGenericException.Create(Format('Provider "%s" not registered', [AProviderID]));
  LProviderRegisterItem := FContainer.Items[AProviderID];
  LProviderRegisterItem.UserName := AUserName;
  LProviderRegisterItem.Password := APassword;
  LProviderRegisterItem.BaseUrlWS := ABaseUrlWS;
  LProviderRegisterItem.BaseUrlAuth := ABaseUrlAuth;
end;

{ TeiProviderRegisterItem }

constructor TeiProviderRegisterItem.Create(const AProviderClassRef: TeiProviderClassRef; const ABaseUrlWS, ABaseUrlAuth: String);
begin
  FProviderClassRef := AProviderClassRef;
  FBaseUrlWS := ABaseUrlWS.Trim;
  FBaseUrlAuth := ABaseUrlAuth.Trim;
end;

procedure TeiProviderRegisterItem.SetBaseUrlAuth(const Value: String);
begin
  if not Value.Trim.IsEmpty then
    FBaseUrlAuth := Value.Trim;
end;

procedure TeiProviderRegisterItem.SetBaseUrlWS(const Value: String);
begin
  if not Value.Trim.IsEmpty then
    FBaseUrlWS := Value.Trim;
end;

procedure TeiProviderRegisterItem.SetPasswords(const Value: String);
begin
  if not Value.Trim.IsEmpty then
    FPassword := Value.Trim;
end;

procedure TeiProviderRegisterItem.SetUserName(const Value: String);
begin
  if not Value.Trim.IsEmpty then
    FUserName := Value.Trim;
end;

initialization

TeiProviderRegister.Build;

finalization

TeiProviderRegister.CleanUp;

end.
