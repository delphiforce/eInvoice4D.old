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
unit DForce.Mini.ei.Utils;

interface

uses
  System.Classes, DForce.Mini.ei.Invoice.Interfaces;

type

  TeiUtilsMini = class
  public
    class procedure StringToStream(const ADestStream: TStream; const ASourceString: String);
    class function StreamToString(const ASourceStream: TStream): string;
    class function PurgeXML(const AStringXML, ARootTag: String): string;
    class function ExtractRootTagName(XMLText:string): string;
  end;

implementation

uses
  DForce.ei.Exception, System.SysUtils, DForce.ei.Encoding;

{ TeiUtilsMini }

class function TeiUtilsMini.ExtractRootTagName(XMLText: string): string;
var
  LEndXmlVersionPos: integer;
  LStartRootTagPos, LDoublePointPos, LEndRootTagPos, LFirstSpacePos: integer;
begin
  LEndXmlVersionPos := Pos('?>', XMLText);
  // Remove the XML version line
  if LEndXmlVersionPos > 0 then
    XMLText := Copy(XMLText, LEndXmlVersionPos+2, Length(XMLText));
  // Detect the "<" for the root  tag
  LStartRootTagPos := Pos('<', XMLText);
  if LStartRootTagPos = 0 then
    raise eiGenericException.Create('StartRootTagPos not found');
  // Detect the ">" for the root  tag
  LEndRootTagPos := Pos('>', XMLText);
  if LEndRootTagPos = 0 then
    raise eiGenericException.Create('EndRootTagPos not found');
  // Detect the first space char after the root name
  LFirstSpacePos := Pos(' ', XMLText);
  if (LFirstSpacePos <> 0) and (LFirstSpacePos < LEndRootTagPos) then
    LEndRootTagPos := LFirstSpacePos;
  // Detect the ":" between the NameSpace and the root tag (if exists)
  LDoublePointPos := Pos(':', XMLText);
  if (LDoublePointPos <> 0) and (LDoublePointPos < LEndRootTagPos) then
    LStartRootTagPos := LDoublePointPos;
  // Extract the root tag name
  Result := Copy(XMLText, LStartRootTagPos+1, (LEndRootTagPos - LStartRootTagPos -1));
end;

class function TeiUtilsMini.PurgeXML(const AStringXML, ARootTag: String): string;
var
  LRootTagPos, LSquareBracketPos: integer;
  LNameSpace: string;
begin
  LNameSpace := '';
  LSquareBracketPos := Pos(':' + ARootTag, AStringXML);
  if LSquareBracketPos > 0 then
  begin
    LRootTagPos := LSquareBracketPos - 1;
    while (AStringXML[LRootTagPos] <> '<') and (LRootTagPos > 0) do
      Dec(LRootTagPos);
    LNameSpace := Copy(AStringXML, LRootTagPos + 1, (LSquareBracketPos - LRootTagPos));
  end;
  result := StringReplace(AStringXML, LNameSpace, '', [rfIgnoreCase, rfReplaceAll]);
end;

class function TeiUtilsMini.StreamToString(const ASourceStream: TStream): string;
var
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  LEncoding := TeiUTFEncodingWithoutBOM.Create;
  LStringStream := TStringStream.Create('', LEncoding);
  try
    LStringStream.CopyFrom(ASourceStream, 0);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

class procedure TeiUtilsMini.StringToStream(const ADestStream: TStream; const ASourceString: String);
var
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  // Check the stream
  if not Assigned(ADestStream) then
    raise eiGenericException.Create('"AStream" parameter not assigned');
  // Save invoice into the stream
  LEncoding := TeiUTFEncodingWithoutBOM.Create;
  LStringStream := TStringStream.Create(ASourceString, LEncoding);
  try
    ADestStream.CopyFrom(LStringStream, 0);
  finally
    LStringStream.Free;
  end;
end;

end.
