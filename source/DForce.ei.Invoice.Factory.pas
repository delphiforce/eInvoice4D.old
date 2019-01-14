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
  DForce.ei.Invoice.Interfaces, System.Classes, System.SysUtils;

const
  // TargetNamespace = 'http://www.fatturapa.gov.it/sdi/fatturapa/v1.1';
  TargetNamespace = '';

type
  TeiInvoiceFactory = class
  private
    class function InternalNewInvoiceFromBytes(const AXMLBytes: TBytes): IeiInvoiceEx;
  public
    class function NewInvoice: IeiInvoiceEx;
    class function NewInvoiceFromString(const AStringXML: string): IeiInvoiceEx;
    class function NewInvoiceFromStringBase64(const ABase64StringXML: string): IeiInvoiceEx;
    class function NewInvoiceFromFile(const AFileName: string): IeiInvoiceEx;
    class function NewInvoiceFromStream(const AStream: TStream): IeiInvoiceEx;
    class function NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoiceEx;

    class function NewInvoiceCollection: IeiInvoiceCollectionEx;
    class function NewInvoiceIDCollection: IeiInvoiceIDCollectionEx;
  end;

implementation

uses
  Xml.XMLDoc, DForce.ei.Invoice.Ex, System.NetEncoding, DForce.ei.Utils,
  DForce.ei.Exception, System.StrUtils, PKCS7Extractor;

{ TeiInvoiceFactory }

class function TeiInvoiceFactory.InternalNewInvoiceFromBytes(
  const AXMLBytes: TBytes): IeiInvoiceEx;

  procedure DeleteXMLData(var AXML: string; const AFromTag, AToTag: string);
  var
    LStart: Integer;
    LStop: Integer;
  begin
    LStart := Pos(AFromTag, AXML);
    if LStart = 0
      then Exit;
    Inc(LStart, Length(AFromTag));
    LStop := PosEx(AToTag, AXML, LStart);
    if LStop = 0
      then Exit;
    Dec(LStop, LStart);
    Delete(AXML, LStart, LStop);
  end;

var
  LP7M: TPKCS7Message;
  LInStream: TBytesStream;
  LOutStream: TBytesStream;
  LInnerXML: string;
  LEpuratedStringXML: String;
begin
  LInStream := nil;
  LP7M := nil;
  LInnerXML := '';
  try
    LInStream := TBytesStream.Create(AXMLBytes);

    if not PKCS7Extractor.Loaded
      then PKCS7Extractor.Load();

    LP7M := TPKCS7Message.Create;
    if LP7M.LoadFromStream(LInStream) then
    begin
      if not LP7M.Verify
        then raise eiGenericException.Create('PKCS7 verification failed');

      LOutStream := nil;
      try
        LOutStream := TBytesStream.Create;
        LP7M.SaveToStream(LOutStream);
        LInnerXML := TEncoding.UTF8.GetString(LOutStream.Bytes);
      finally
        LOutStream.Free;
      end;
    end else
    begin
      LInnerXML := TEncoding.UTF8.GetString(AXMLBytes);
    end;
  finally
    LP7M.Free;
    LInStream.Free;
  end;

  LEpuratedStringXML := StringReplace(LInnerXML, '<p:', '<', [rfReplaceAll, rfIgnoreCase]);
  LEpuratedStringXML := StringReplace(LEpuratedStringXML, '</p:', '</', [rfReplaceAll, rfIgnoreCase]);
  LEpuratedStringXML := StringReplace(LEpuratedStringXML, '<ns3:', '<', [rfReplaceAll, rfIgnoreCase]);
  LEpuratedStringXML := StringReplace(LEpuratedStringXML, '</ns3:', '</', [rfReplaceAll, rfIgnoreCase]);
  DeleteXMLData(LEpuratedStringXML, '</FatturaElettronicaBody>', '</FatturaElettronica>');
  Result := LoadXMLData(LEpuratedStringXML).GetDocBinding('FatturaElettronica', TeiInvoiceEx, TargetNamespace) as IeiInvoiceEx;
  Result.RawInvoice := AXMLBytes;
end;

class function TeiInvoiceFactory.NewInvoiceCollection: IeiInvoiceCollectionEx;
begin
  Result := TeiInvoiceCollectionEx.Create;
end;

class function TeiInvoiceFactory.NewInvoiceIDCollection: IeiInvoiceIDCollectionEx;
begin
  Result := TeiInvoiceIDCollectionEx.Create;
end;

class function TeiInvoiceFactory.NewInvoice: IeiInvoiceEx;
begin
  Result := NewXMLDocument.GetDocBinding('FatturaElettronica', TeiInvoiceEx, TargetNamespace) as IeiInvoiceEx;
end;

class function TeiInvoiceFactory.NewInvoiceFromString(const AStringXML: String): IeiInvoiceEx;
begin
  //DONE: da qui non mi aspetto p7m che probabilmente avrebbero già dato errori nella conserversione in UTF8
  Result := InternalNewInvoiceFromBytes(TEncoding.UTF8.GetBytes(AStringXML));
end;

class function TeiInvoiceFactory.NewInvoiceFromStringBase64(const ABase64StringXML: string): IeiInvoiceEx;
begin
  Result := InternalNewInvoiceFromBytes(TNetEncoding.Base64.DecodeStringToBytes(ABase64StringXML));
end;

class function TeiInvoiceFactory.NewInvoiceFromFile(const AFileName: String): IeiInvoiceEx;
var
  LStreamIn: TBytesStream;
begin
  LStreamIn := nil;
  try
    LStreamIn := TBytesStream.Create;
    LStreamIn.LoadFromFile(AFileName);
    Result := InternalNewInvoiceFromBytes(LStreamIn.Bytes);
  finally
    LStreamIn.Free;
  end;
end;

class function TeiInvoiceFactory.NewInvoiceFromStream(const AStream: TStream): IeiInvoiceEx;
var
  LStreamIn: TBytesStream;
begin
  LStreamIn := nil;
  try
    LStreamIn := TBytesStream.Create;
    LStreamIn.LoadFromStream(AStream);
    Result := InternalNewInvoiceFromBytes(LStreamIn.Bytes);
  finally
    LStreamIn.Free;
  end;
end;

class function TeiInvoiceFactory.NewInvoiceFromStreamBase64(const AStream: TStream): IeiInvoiceEx;
begin
  Result := NewInvoiceFromStringBase64(TeiUtils.StreamToString(AStream));
end;

end.
