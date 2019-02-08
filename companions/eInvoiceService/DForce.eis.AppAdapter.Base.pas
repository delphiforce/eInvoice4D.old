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
unit DForce.eis.AppAdapter.Base;

interface

uses
  System.SysUtils, System.Classes, DForce.eis.AppAdapter.Interfaces, DForce.ei;

type
  TeiApplicationAdapterBase = class(TDataModule, IeiApplicationAdapter)
  private
  protected
// ---------------- Start: section added for IInterface support ---------------
{$IFNDEF AUTOREFCOUNT}
    [Volatile] FRefCount: Integer;
{$ENDIF}
    function QueryInterface(const IID: TGUID; out Obj): HResult; reintroduce; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
// ---------------- End: section added for IInterface support ---------------
    // Sales invoices to send
    function LoadSalesInvoicesToSend: IeiInvoiceCollection; virtual;
    procedure PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection); virtual;
    // Sales invoices for notification request
    function LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection; virtual;
    procedure PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection); virtual;
    // Purchase invoices
    procedure PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection); virtual;
  end;

implementation

{ %CLASSGROUP 'System.Classes.TPersistent' }

{$R *.dfm}

{ TeiApplicationAdapterBase }

function TeiApplicationAdapterBase.LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection;
begin
  ei.LogI('EIS: Load sales invoices ID for notification request (application adapter)');
end;

function TeiApplicationAdapterBase.LoadSalesInvoicesToSend: IeiInvoiceCollection;
begin
  ei.LogI('EIS: Load sales invoices to send (application adapter)');
end;

procedure TeiApplicationAdapterBase.PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection);
begin
  ei.LogI('EIS: Persist purchase invoices (application adapter)');
end;

procedure TeiApplicationAdapterBase.PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection);
begin
  ei.LogI('EIS: Persist sales invoices response (application adapter)');
end;

procedure TeiApplicationAdapterBase.PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection);
begin
  ei.LogI('EIS: Persist sales notification response (application adapter)');
end;

function TeiApplicationAdapterBase.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TeiApplicationAdapterBase._AddRef: Integer;
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicIncrement(FRefCount);
{$ELSE}
  Result := __ObjAddRef;
{$ENDIF}
end;

function TeiApplicationAdapterBase._Release: Integer;
begin
{$IFNDEF AUTOREFCOUNT}
  Result := AtomicDecrement(FRefCount);
  if Result = 0 then
    Destroy;
{$ELSE}
  Result := __ObjRelease;
{$ENDIF}
end;

end.
