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
unit DForce.eis.AppAdapter.Mock;

interface

uses System.SysUtils, System.Classes, DForce.eis.AppAdapter.Base, DForce.ei;

type
  TeiApplicationAdapterMock = class(TeiApplicationAdapterBase)
  protected
    // Sales invoices to send
    function LoadSalesInvoicesToSend: IeiInvoiceCollection; override;
    procedure PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection); override;
    // Sales invoices for notification request
    function LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection; override;
    procedure PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection); override;
    // Purchase invoices
    procedure PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection); override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TApplicationAdapterMock }

function TeiApplicationAdapterMock.LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection;
begin
  inherited;
  result := ei.NewInvoiceIDCollection;

  result.Add('IT070260378832_jtlkl.xml');
  result.Add('IT070260378832_jtlkm.xml');
  result.Add('IT070260378832_jtlkn.xml');
end;

function TeiApplicationAdapterMock.LoadSalesInvoicesToSend: IeiInvoiceCollection;
var
  i: Integer;
  LInvoice: IeiInvoice;
begin
  inherited;
  result := ei.NewInvoiceCollection;

  for i := 1 to 3 do
  begin
    LInvoice := ei.NewInvoice;
    LInvoice.FillWithSampleData;
    result.Add(LInvoice);
  end;
end;

procedure TeiApplicationAdapterMock.PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection);
begin
  inherited;

end;

procedure TeiApplicationAdapterMock.PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection);
begin
  inherited;

end;

procedure TeiApplicationAdapterMock.PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection);
begin
  inherited;

end;

end.
