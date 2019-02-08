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
unit DForce.ei.Provider.Base;

interface

// DO NOT REMOVE !!! IPPeerClient necessary for all REST calls in derived classes
// DO NOT REMOVE !!! IPPeerClient necessary for all REST calls in derived classes
// DO NOT REMOVE !!! IPPeerClient necessary for all REST calls in derived classes
uses IPPeerClient, DForce.ei.Response.Interfaces, DForce.ei.Provider.Interfaces,
  DForce.ei.Invoice.Interfaces;

type

  TeiProviderClassRef = class of TeiProviderBase;

  TeiProviderBase = class(TInterfacedObject, IeiProvider)
  private
    FUserName: string;
    FPassword: string;
    FBaseUrlAuth: string;
    FBaseUrlWS: string;
  protected
    function UserName: String;
    function Password: String;
    function BaseUrlAuth: String;
    function BaseUrlWS: String;
    procedure Connect; virtual; abstract;
    procedure Disconnect; virtual; abstract;
    function SendInvoice(const AInvoice: string): IeiResponseCollectionEx; virtual; abstract;
    function ReceiveInvoiceNotifications(const AInvoiceFileName: string): IeiResponseCollectionEx; virtual; abstract;
    function ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime; AEndDate: TDateTime = 0)
      : IeiInvoiceIDCollectionEx; virtual; abstract;
    function ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponseEx; virtual; abstract;
    function ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx; virtual; abstract;
  public
    constructor Create(const AUserName, APassword, ABaseURLWS, ABaseURLAuth: string); virtual;
  end;

implementation

uses System.SysUtils, DForce.ei.Exception;

{ TeiProviderBase }

function TeiProviderBase.BaseUrlAuth: String;
begin
  result := FBaseUrlAuth;
end;

function TeiProviderBase.BaseUrlWS: String;
begin
  result := FBaseUrlWS;
end;

constructor TeiProviderBase.Create(const AUserName, APassword, ABaseURLWS, ABaseURLAuth: string);
begin
  inherited Create;

  if AUserName.Trim.IsEmpty then
    raise eiGenericException.Create('UserName not valid');

  if APassword.Trim.IsEmpty then
    raise eiGenericException.Create('Password not valid');

  if ABaseURLAuth.Trim.IsEmpty then
    raise eiGenericException.Create('BaseUrlAuth not valid');

  if ABaseURLWS.Trim.IsEmpty then
    raise eiGenericException.Create('BaseUrlWS not valid');

  FUserName := AUserName;
  FPassword := APassword;
  FBaseUrlAuth := ABaseURLAuth;
  FBaseUrlWS := ABaseURLWS;
end;

function TeiProviderBase.Password: String;
begin
  result := FPassword;
end;

function TeiProviderBase.UserName: String;
begin
  result := FUserName;
end;

end.
