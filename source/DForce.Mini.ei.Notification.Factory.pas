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
unit DForce.Mini.ei.Notification.Factory;

interface

uses
  DForce.Mini.ei.Notification.Interfaces, System.Classes;

type
  TeiNotificationMiniFactory = class
  public
    // NS notification
    class function NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSmini;
    class function NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSmini;
    class function NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSmini;
    // NE notification
    class function NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEmini;
    class function NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEmini;
    class function NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEmini;
  end;

const
  TargetNamespace = '';

implementation

uses
  Xml.XMLDoc, System.SysUtils, DForce.Mini.ei.Notification.NS,
  DForce.Mini.ei.Notification.NE, DForce.Mini.ei.Utils;

{ TeiNotificationMiniFactory }

class function TeiNotificationMiniFactory.NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEmini;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNEFromString(TeiUtilsMini.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationMiniFactory.NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEmini;
begin
  Result := NewNotificationNEFromString(TeiUtilsMini.StreamToString(AStream));
end;

class function TeiNotificationMiniFactory.NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEmini;
var
  LRootTagName: string;
  LNotificationCommon: IeiNotificationCommonMini;
begin
  LRootTagName := TeiUtilsMini.ExtractRootTagName(AStringXML);
  result := LoadXMLData(TeiUtilsMini.PurgeXML(AStringXML, LRootTagName)).GetDocBinding(LRootTagName, TeiNotificationNEmini, TargetNamespace) as IeiNotificationNEmini;
  if Supports(result, IeiNotificationCommonMini, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSmini;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNSFromString(TeiUtilsMini.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSmini;
begin
  Result := NewNotificationNSFromString(TeiUtilsMini.StreamToString(AStream));
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSmini;
var
  LRootTagName: string;
  LNotificationCommon: IeiNotificationCommonMini;
begin
  LRootTagName := TeiUtilsMini.ExtractRootTagName(AStringXML);
  result := LoadXMLData(TeiUtilsMini.PurgeXML(AStringXML, LRootTagName)).GetDocBinding(LRootTagName, TeiNotificationNSmini, TargetNamespace) as IeiNotificationNSmini;
  if Supports(result, IeiNotificationCommonMini, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

end.
