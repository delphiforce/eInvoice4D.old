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
unit DForce.ei.Notification.Factory;

interface

uses DForce.ei.Notification.Interfaces, DForce.ei.Notification.NS.Ex,
  DForce.ei.Notification.NE.Ex, System.Classes;

type
  TeiNotificationFactory = class
  public
    // NS notification
    class function NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSEx;
    class function NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNSEx;
    class function NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSEx;
    class function NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSEx;
    class function NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNSEx;
    // NE notification
    class function NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEEx;
    class function NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNEEx;
    class function NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEEx;
    class function NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEEx;
    class function NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNEEx;
  end;

const
  TargetNamespace = '';

implementation

uses System.SysUtils, Xml.XMLDoc, System.NetEncoding, DForce.ei.Utils;

{ TeiNotificationFactory }

class function TeiNotificationFactory.NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSEx;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNSFromString(TeiUtils.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationFactory.NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSEx;
var
  LRootTagName: string;
  LNotificationCommon: IeiNotificationCommon;
begin
  LRootTagName := TeiUtils.ExtractRootTagName(AStringXML);
  result := LoadXMLData(TeiUtils.PurgeXML(AStringXML, LRootTagName)).GetDocBinding(LRootTagName, TeiNotificationNSEx, TargetNamespace) as IeiNotificationNSEx;
  if Supports(result, IeiNotificationCommon, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationFactory.NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEEx;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNEFromString(TeiUtils.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationFactory.NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TNetEncoding.Base64.Decode(ABase64StringXML));
end;

class function TeiNotificationFactory.NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEEx;
var
  LRootTagName: string;
  LNotificationCommon: IeiNotificationCommon;
begin
  LRootTagName := TeiUtils.ExtractRootTagName(AStringXML);
  result := LoadXMLData(TeiUtils.PurgeXML(AStringXML, LRootTagName)).GetDocBinding(LRootTagName, TeiNotificationNEEx, TargetNamespace) as IeiNotificationNEEx;
  if Supports(result, IeiNotificationCommon, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationFactory.NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TNetEncoding.Base64.Decode(ABase64StringXML));
end;

end.
