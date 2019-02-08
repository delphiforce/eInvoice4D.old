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
unit DForce.Mini.ei.Invoice.Factory;

interface

uses
  System.Classes, DForce.Mini.ei.Invoice.Interfaces;

const
  // TargetNamespace = 'http://www.fatturapa.gov.it/sdi/fatturapa/v1.1';
  TargetNamespace = '';

type

  TeiInvoiceMiniFactory = class
  private
    class function InternalStreamToString(const AStream: TStream): string;
  public
    class function NewInvoice: IeiInvoiceMini;
    class function NewInvoiceFromString(const AStringXML: String): IeiInvoiceMini;
    class function NewInvoiceFromFile(const AFileName: String): IeiInvoiceMini;
    class function NewInvoiceFromStream(const AStream: TStream): IeiInvoiceMini;
  end;

implementation

uses
  Xml.XMLDoc, DForce.Mini.ei.Invoice, System.SysUtils, DForce.Mini.ei.Utils;

{ TeiInvoiceFactory }

class function TeiInvoiceMiniFactory.InternalStreamToString(const AStream: TStream): string;
var
  LStringStream: TStringStream;
begin
  LStringStream := TStringStream.Create;
  try
    LStringStream.CopyFrom(AStream, 0);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

class function TeiInvoiceMiniFactory.NewInvoice: IeiInvoiceMini;
begin
  Result := NewXMLDocument.GetDocBinding('FatturaElettronica', TeiInvoiceMini, TargetNamespace) as IeiInvoiceMini;
end;

class function TeiInvoiceMiniFactory.NewInvoiceFromFile(const AFileName: String): IeiInvoiceMini;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewInvoiceFromString(InternalStreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiInvoiceMiniFactory.NewInvoiceFromStream(const AStream: TStream): IeiInvoiceMini;
begin
  Result := NewInvoiceFromString(InternalStreamToString(AStream));
end;

class function TeiInvoiceMiniFactory.NewInvoiceFromString(const AStringXML: String): IeiInvoiceMini;
var
  LRootTagName: string;
begin
  LRootTagName := TeiUtilsMini.ExtractRootTagName(AStringXML);
  result := LoadXMLData(TeiUtilsMini.PurgeXML(AStringXML, LRootTagName)).GetDocBinding(LRootTagName, TeiInvoiceMini, TargetNamespace) as IeiInvoiceMini;
end;

end.
