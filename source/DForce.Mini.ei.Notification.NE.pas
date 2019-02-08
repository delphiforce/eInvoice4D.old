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
unit DForce.Mini.ei.Notification.NE;

interface

uses
  DForce.ei.Notification.NE.Base, DForce.Mini.ei.Notification.Interfaces,
  System.Classes;

type
  TeiNotificationNEmini = class(TXMLNotificaNEType, IeiNotificationNEmini, IeiNotificationCommonMini)
  private
    FRawXML: string;
  protected
    function ToString: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    function InvoiceAccepted: Boolean;
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses
  System.SysUtils, DForce.ei.Exception, DForce.Mini.ei.Utils;

{ TeiNotificationNEmini }

function TeiNotificationNEmini.GetRawXML: string;
begin
  Result := FRawXML;
end;

function TeiNotificationNEmini.InvoiceAccepted: Boolean;
begin
  Result := (Trim(EsitoCommittente.Esito) = 'EC01');
end;

procedure TeiNotificationNEmini.SaveToFile(const AFileName: String);
var
  LFileStream: TFileStream;
begin
  if FileExists(AFileName) then
    raise eiGenericException.Create(Format('File "%s" already exists', [AFileName]));
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    TeiUtilsMini.StringToStream(LFileStream, ToString);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiNotificationNEmini.SaveToStream(const AStream: TStream);
begin
  TeiUtilsMini.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNEmini.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNEmini.ToString: String;
begin
  result := self.GetRawXML;
end;

end.
