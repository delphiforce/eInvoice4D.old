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
unit DForce.ei.Provider.Interfaces;

interface

uses DForce.ei.Response.Interfaces, DForce.ei.Invoice.Interfaces;

type
  TeiRouteType = (rtDirect, rtProxyfied);

  IeiProvider = interface
    ['{D36DE12B-49DA-4D7D-A5D1-1AF6CDC7B2BE}']
    procedure Connect;
    procedure Disconnect;
    function SendInvoice(const AInvoice: string): IeiResponseCollectionEx;
    function ReceiveInvoiceNotifications(const AInvoiceFileName: string): IeiResponseCollectionEx;
    function ReceivePurchaseInvoiceFileNameCollection(const AVatCodeReceiver: string; const AStartDate: TDateTime; AEndDate: TDateTime = 0)
      : IeiInvoiceIDCollectionEx;
    function ReceivePurchaseInvoiceAsXML(const AInvoiceID: string): IeiResponseEx;
    function ReceivePurchaseInvoiceNotifications(const AInvoiceID: string): IeiResponseCollectionEx;
  end;

implementation

end.
