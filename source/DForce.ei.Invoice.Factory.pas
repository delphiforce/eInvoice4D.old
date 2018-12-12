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
unit DForce.ei.Invoice.Factory;

interface

uses
  DForce.ei.Invoice.Interfaces, System.Classes;

const
  // TargetNamespace = 'http://www.fatturapa.gov.it/sdi/fatturapa/v1.1';
  TargetNamespace = '';

type

  TeiInvoiceFactory = class
  private
    class function InternalNewInvoiceFromString(const AStringXML: String): IeiInvoiceEx;
  public
    class function NewInvoice: IeiInvoiceEx;
    class function NewInvoiceFromString(const AStringXML: String): IeiInvoiceEx;
    class function NewInvoiceFromStringBase64(const ABase64StringXML: String): IeiInvoiceEx;
    class function NewInvoiceFromFile(const AFileName: String): IeiInvoiceEx;
    class function NewInvoiceFromStream(const AStream: TStream): IeiInvoiceEx;
    class function NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoiceEx;

    class function NewInvoiceCollection: IeiInvoiceCollectionEx;
    class function NewInvoiceIDCollection: IeiInvoiceIDCollectionEx;
  end;

implementation

uses
  Xml.XMLDoc, DForce.ei.Invoice.Ex, System.NetEncoding, System.SysUtils,
  DForce.ei.Utils;

{ TeiInvoiceFactory }

class function TeiInvoiceFactory.InternalNewInvoiceFromString(const AStringXML: String): IeiInvoiceEx;
var
  LEpuratedStringXML: String;
begin
  LEpuratedStringXML := StringReplace(AStringXML, '<p:', '<', [rfReplaceAll, rfIgnoreCase]);
  LEpuratedStringXML := StringReplace(LEpuratedStringXML, '</p:', '</', [rfReplaceAll, rfIgnoreCase]);
  Result := LoadXMLData(LEpuratedStringXML).GetDocBinding('FatturaElettronica', TeiInvoiceEx, TargetNamespace) as IeiInvoiceEx;
end;

class function TeiInvoiceFactory.NewInvoice: IeiInvoiceEx;
begin
  Result := NewXMLDocument.GetDocBinding('FatturaElettronica', TeiInvoiceEx, TargetNamespace) as IeiInvoiceEx;
end;

class function TeiInvoiceFactory.NewInvoiceCollection: IeiInvoiceCollectionEx;
begin
  Result := TeiInvoiceCollectionEx.Create;
end;

class function TeiInvoiceFactory.NewInvoiceFromFile(const AFileName: String): IeiInvoiceEx;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := InternalNewInvoiceFromString(TeiUtils.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiInvoiceFactory.NewInvoiceFromStream(const AStream: TStream): IeiInvoiceEx;
begin
  Result := InternalNewInvoiceFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiInvoiceFactory.NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoiceEx;
begin
  Result := NewInvoiceFromStringBase64(TeiUtils.StreamToString(AStream));
end;

class function TeiInvoiceFactory.NewInvoiceFromString(const AStringXML: String): IeiInvoiceEx;
begin
  Result := InternalNewInvoiceFromString(AStringXML);
end;

class function TeiInvoiceFactory.NewInvoiceFromStringBase64(const ABase64StringXML: String): IeiInvoiceEx;
begin
  Result := InternalNewInvoiceFromString(TNetEncoding.Base64.Decode(ABase64StringXML));
end;

class function TeiInvoiceFactory.NewInvoiceIDCollection: IeiInvoiceIDCollectionEx;
begin
  Result := TeiInvoiceIDCollectionEx.Create;
end;

end.
