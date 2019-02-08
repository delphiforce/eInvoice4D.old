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
unit DForce.ei.Notification.NE.Ex;

interface

uses DForce.ei.Notification.NE.Base, DForce.ei.Notification.Interfaces,
  System.Classes;

type
  TeiNotificationNEEx = class(TXMLNotificaNEType, IeiNotificationNEEx, IeiNotificationCommon)
  private
    FRawXML: string;
  protected
    function ToString: String; reintroduce;
    function ToStringBase64: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
    function InvoiceAccepted: Boolean;
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses System.SysUtils, Xml.XMLDoc, System.NetEncoding, DForce.ei.Exception,
  DForce.ei.Utils;

{ TeiNotificationNEEx }

function TeiNotificationNEEx.GetRawXML: string;
begin
  result := FRawXML;
end;

function TeiNotificationNEEx.InvoiceAccepted: Boolean;
begin
  Result := (Trim(EsitoCommittente.Esito) = 'EC01');
end;

procedure TeiNotificationNEEx.SaveToFile(const AFileName: String);
var
  LFileStream: TFileStream;
begin
  if FileExists(AFileName) then
    raise eiGenericException.Create(Format('File "%s" already exists', [AFileName]));
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    TeiUtils.StringToStream(LFileStream, ToString);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiNotificationNEEx.SaveToStream(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNEEx.SaveToStreamBase64(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToStringBase64);
end;

procedure TeiNotificationNEEx.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNEEx.ToString: String;
begin
  result := self.GetRawXML;
end;

function TeiNotificationNEEx.ToStringBase64: String;
begin
  result := TNetEncoding.Base64.Encode(ToString);
end;

end.
