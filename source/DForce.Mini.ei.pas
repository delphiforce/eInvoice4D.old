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
unit DForce.Mini.ei;

interface

uses
  DForce.Mini.ei.Invoice.Interfaces, System.Classes;

type

  IeiInvoice = IeiInvoiceMini;

  ei = class
  public
    class function NewInvoice: IeiInvoice;
    class function NewInvoiceFromString(const AStringXML: String): IeiInvoice;
    class function NewInvoiceFromFile(const AFileName: String): IeiInvoice;
    class function NewInvoiceFromStream(const AStream: TStream): IeiInvoice;
  end;

implementation

uses
  DForce.Mini.ei.Invoice.Factory;

{ ei }

class function ei.NewInvoice: IeiInvoice;
begin
  Result := TeiInvoiceMiniFactory.NewInvoice;
end;

class function ei.NewInvoiceFromFile(const AFileName: String): IeiInvoice;
begin
  Result := TeiInvoiceMiniFactory.NewInvoiceFromFile(AFileName);
end;

class function ei.NewInvoiceFromStream(const AStream: TStream): IeiInvoice;
begin
  Result := TeiInvoiceMiniFactory.NewInvoiceFromStream(AStream);
end;

class function ei.NewInvoiceFromString(const AStringXML: String): IeiInvoice;
begin
  Result := TeiInvoiceMiniFactory.NewInvoiceFromString(AStringXML);
end;

end.
