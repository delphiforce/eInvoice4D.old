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
unit DForce.ei.Logger.pfLogger.Adapter;

interface

uses DForce.ei.Logger.Interfaces, System.SysUtils, DForce.ei.Logger.pfLogger;

type
  TeiPfLoggerAdapter = class(TeiLoggerAbstract)
  private
    class var FPfLogger: IPfLogger;
  public
    class constructor Create;
    class procedure LogI(const ALogMessage: string); override;
    class procedure LogW(const ALogMessage: string); override;
    class procedure LogE(const ALogMessage: string); override;
  end;

implementation

{ TeiPfLoggerAdapter }

uses System.IOUtils;

class constructor TeiPfLoggerAdapter.Create;
var
  LLogDir: string;
begin
//  LLogDir := TPath.Combine(GetEnvironmentVariable('PROGRAMDATA'), 'LogFatturaElettronica');
  LLogDir := TPath.Combine(GetEnvironmentVariable('APPDATA'), 'LogFatturaElettronica');
  TDirectory.CreateDirectory(LLogDir);
  FPfLogger := GetPFLogger(TPath.Combine(LLogDir, 'LogFatturaElettronica'));
  FPfLogger.SetLogLevel(llDebug);
end;

class procedure TeiPfLoggerAdapter.LogE(const ALogMessage: string);
begin
  FPfLogger.Error(ALogMessage);
end;

class procedure TeiPfLoggerAdapter.LogI(const ALogMessage: string);
begin
  inherited;
  FPfLogger.Info(ALogMessage);
end;

class procedure TeiPfLoggerAdapter.LogW(const ALogMessage: string);
begin
  inherited;
  FPfLogger.Warning(ALogMessage);
end;

end.
