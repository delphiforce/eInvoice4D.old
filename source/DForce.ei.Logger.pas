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
unit DForce.ei.Logger;

interface

uses
  System.SysUtils, Messages;

type
  TeiLogType = (ltInformation, ltWarning, ltError);

  PeiLogRecord = ^TeiLogRecord;
  TeiLogRecord = record
    MsgType: TeiLogType;
    MsgTime: TDateTime;
    MsgText: string;
  end;

  TeiLogger = class
  protected
    class procedure Log(const ALogType: TeiLogType; const ALogMessage: string);
  public
    class procedure LogI(const ALogMessage: string);
    class procedure LogW(const ALogMessage: string);
    class procedure LogE(const ALogMessage: string); overload; // Error
    class procedure LogE(const E: Exception); overload; // Exception
  end;

const
  UM_EILOG = WM_USER + 42;

implementation

uses
  Winapi.Windows, Vcl.Forms;

{ TeiLogger }

class procedure TeiLogger.Log(const ALogType: TeiLogType; const ALogMessage: string);
var
  LRecord: PeiLogRecord;
begin
  New(LRecord);
  LRecord^.MsgType := ALogType;
  LRecord^.MsgTime := Now;
  LRecord^.MsgText := ALogMessage;
  OutputDebugString(PChar(FormatDateTime('dd/mm/yy hh:nn:ss.zzz', LRecord^.MsgTime) + ': ' + LRecord^.MsgText));
  if (Application.Terminated)or(not PostMessage(Application.MainFormHandle, UM_EILOG, 0, LPARAM(LRecord)))
    then Dispose(LRecord);
  //ShowMessage(FormatDateTime('dd/mm/yy hh:nn:ss.zzz', Now) + ': ' + ALogMessage);
end;

class procedure TeiLogger.LogE(const ALogMessage: string);
begin
  Log(TeiLogType.ltError, ALogMessage);
end;

class procedure TeiLogger.LogE(const E: Exception);
begin
  Log(TeiLogType.ltError, Format('%s: %s', [E.ClassName, E.Message]));
end;

class procedure TeiLogger.LogI(const ALogMessage: string);
begin
  Log(TeiLogType.ltInformation, ALogMessage);
end;

class procedure TeiLogger.LogW(const ALogMessage: string);
begin
  Log(TeiLogType.ltWarning, ALogMessage);
end;

end.
