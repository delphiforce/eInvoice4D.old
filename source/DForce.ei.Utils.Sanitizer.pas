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
unit DForce.ei.Utils.Sanitizer;

interface

uses DForce.ei.Invoice.Base, Xml.XMLIntf;

type

  TeiSanificationType = (stUppercase, stNoSpaces);
  TeiSanificationTypeSet = set of TeiSanificationType;

  TeiSanitizer = class
  private
    class function _InternalSanitizeByTag(var AXMLText: string; const ATag: string; const ASanificationType: TeiSanificationTypeSet;
      const AFromPos: integer = 1): integer;
    class procedure _InternalStringReplace(const AXMLNodeParent: IXMLNode; const AChildNodeName: string;
      const AOldPattern, ANewPattern: string);
  protected
    class procedure SanitizeByTag(var AXMLText: string; const ATag: string; const ASanificationType: TeiSanificationTypeSet);
    class procedure SanitizeEuroChar(const AInvoice: IXMLFatturaElettronicaType);
  public
    class procedure SanitizeXMLText(var AXMLText: string);
    class procedure SanitizeInvoice(const AInvoice: IXMLFatturaElettronicaType);
  end;

implementation

uses System.StrUtils, System.SysUtils;

{ TeiSanitizer }

class procedure TeiSanitizer.SanitizeByTag(var AXMLText: string; const ATag: string; const ASanificationType: TeiSanificationTypeSet);
var
  LFromPos: integer;
begin
  LFromPos := 1;
  while LFromPos <> 0 do
    LFromPos := _InternalSanitizeByTag(AXMLText, ATag, ASanificationType, LFromPos);
end;

class procedure TeiSanitizer.SanitizeEuroChar(const AInvoice: IXMLFatturaElettronicaType);
const
  OLD_PATTERN = '€';
  NEW_PATTERN = '&#8364;';
var
  LDettaglioLinea: IXMLDettaglioLineeType;
  I: integer;
begin
  // AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica.Denominazione
  _InternalStringReplace(AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica, 'Denominazione', OLD_PATTERN,
    NEW_PATTERN);
  // AInvoice.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica.Denominazione
  _InternalStringReplace(AInvoice.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica, 'Denominazione', OLD_PATTERN,
    NEW_PATTERN);
  // Dettaglio linee
  for I := 0 to AInvoice.FatturaElettronicaBody[0].DatiBeniServizi.DettaglioLinee.Count - 1 do
  begin
    LDettaglioLinea := AInvoice.FatturaElettronicaBody[0].DatiBeniServizi.DettaglioLinee[I];
    // LDettaglioLinea.Descrizione
    _InternalStringReplace(LDettaglioLinea, 'Descrizione', OLD_PATTERN, NEW_PATTERN);
  end;
end;

class procedure TeiSanitizer.SanitizeInvoice(const AInvoice: IXMLFatturaElettronicaType);
begin
  SanitizeEuroChar(AInvoice);
end;

class procedure TeiSanitizer.SanitizeXMLText(var AXMLText: string);
begin
  SanitizeByTag(AXMLText, 'CodiceDestinatario', [stUppercase, stNoSpaces]);

  SanitizeByTag(AXMLText, 'IdPaese', [stUppercase]);
  SanitizeByTag(AXMLText, 'IdCodice', [stUppercase, stNoSpaces]);

  SanitizeByTag(AXMLText, 'Ufficio', [stUppercase]);
  SanitizeByTag(AXMLText, 'ProvinciaAlbo', [stUppercase]);
  SanitizeByTag(AXMLText, 'Provincia', [stUppercase]);
  SanitizeByTag(AXMLText, 'Nazione', [stUppercase, stNoSpaces]);

  SanitizeByTag(AXMLText, 'CodiceFiscale', [stUppercase, stNoSpaces]);

  SanitizeByTag(AXMLText, 'IBAN', [stUppercase, stNoSpaces]);
end;

class function TeiSanitizer._InternalSanitizeByTag(var AXMLText: string; const ATag: string;
  const ASanificationType: TeiSanificationTypeSet; const AFromPos: integer): integer;
var
  LStartTag, LEndTag: string;
  LStartTagPos, LEndTagPos, LLength: integer;
  LToSanitize, LSanitized: string;
begin
  LStartTag := '<' + ATag + '>';
  LEndTag := '</' + ATag + '>';

  LStartTagPos := PosEx(LStartTag, AXMLText, AFromPos);
  LEndTagPos := PosEx(LEndTag, AXMLText, LStartTagPos);

  if (LStartTagPos <> 0) and (LEndTagPos <> 0) then
  begin
    LStartTagPos := LStartTagPos + Length(LStartTag);
    LLength := LEndTagPos - LStartTagPos;
    // Uppercase
    if stUppercase in ASanificationType then
    begin
      LToSanitize := Copy(AXMLText, LStartTagPos, LLength);
      LSanitized := UpperCase(LToSanitize);
      AXMLText := StuffString(AXMLText, LStartTagPos, LLength, LSanitized);
    end;
    // NoSpaces
    if stNoSpaces in ASanificationType then
    begin
      LToSanitize := Copy(AXMLText, LStartTagPos, LLength);
      LSanitized := StringReplace(LToSanitize, ' ', '', [rfReplaceAll]);
      // AXMLText := StringReplace(AXMLText, LToSanitize, LSanitized, [rfReplaceAll]);
      AXMLText := StuffString(AXMLText, LStartTagPos, LLength, LSanitized);
    end;
    // Set the result
    result := LStartTagPos + Length(LStartTag);
  end
  else
    result := 0;
end;

class procedure TeiSanitizer._InternalStringReplace(const AXMLNodeParent: IXMLNode; const AChildNodeName: string;
  const AOldPattern, ANewPattern: string);
var
  LXMLNode: IXMLNode;
begin
  LXMLNode := AXMLNodeParent.ChildNodes.FindNode(AChildNodeName);
  if Assigned(LXMLNode) then
    LXMLNode.NodeValue := StringReplace(LXMLNode.Text, AOldPattern, ANewPattern, [rfReplaceAll, rfIgnoreCase]);
end;

end.
