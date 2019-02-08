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
{  20140616 by ing.Paolo Filippini                                          }
{  Logger multithread.                                                      }
{  Di default il log è salvato in <HOMEDIR>\<application>.log               }
{                                                                           }
{  Uso:                                                                     }
{  - invocare GetPfLogger.metodo: crea da solo l'istanza e la mantiene      }
{  - GetPfLogger(logfilename) consente di indicare il nome del file         }
{  (solo alla prima chiamata)                                               }
{                                                                           }
{  20151103 Ottimizzizazioni e bug fix                                      }
{  20151008 Cambiato percorso di default del log (nella homedir)            }
{***************************************************************************}
unit DForce.ei.Logger.pfLogger;

interface

uses system.SysUtils, Classes, IdUDPClient;

type
  pfLogLevel = (llError, llWarning, llInfo, llDebug);

type
  IpfLogger = interface
    ['{2129E49A-DBA6-44DC-AF07-639EBE68CE44}']
    procedure SetLogLevel(aLogLevel: pfLogLevel);
    function GetLogLevel: string;
    procedure Error(const Value: string);
    procedure NotifyError(const Value: string; const silenzia: boolean = false);
    procedure LogException(const Value: string; const E: Exception);
    // Logga l'eccezione
    procedure NotifyException(const Value: string; const E: Exception; const silenzia: boolean = false);
    // Logga l'eccezione (LogException) e poi la notifica
    procedure Warning(const Value: string);
    procedure NotifyWarning(const Value: string; const silenzia: boolean = false);
    procedure Info(const Value: string);
    procedure Debug(const Value: string);
    procedure EnterSection(const Value: string);
    procedure ExitSection;
  end;

function GetPFLogger(const LogFilename: string = ''): IpfLogger;

function CreatePFLogger(const LogFilename: string = ''): IpfLogger;

implementation

uses system.SyncObjs, system.UITypes, system.ioutils;

type
  TLogThread = class(TThread)
  private
    FLogFileName: string;
    FInternalBuffer: TStrings; // Used to decouple the main buffer
    // FUDPClient1: TIDUDPClient;
    function UpdateLogFile: boolean;
  public
    procedure AppendText(const text: string);
    constructor Create(const LogFilename: string = ''); reintroduce;
    destructor Destroy; override;
    procedure Execute; Override;
  end;

type
  TpfLogger = class(TInterfacedObject, IpfLogger)
  private
    FThread: TLogThread;
    FLogLevel: pfLogLevel;
    FCurrentSection: string;
    procedure Log(const level, text: string);
  protected
    procedure SetLogLevel(aLogLevel: pfLogLevel);
    property LogLevel: pfLogLevel read FLogLevel write SetLogLevel;

    function GetLogLevel: string;

    procedure LogException(const Value: string; const E: Exception);
    procedure NotifyException(const Value: string; const E: Exception; const silenzia: boolean = false);
    procedure Error(const Value: string);
    procedure NotifyError(const Value: string; const silenzia: boolean = false);
    procedure Warning(const Value: string);
    procedure NotifyWarning(const Value: string; const silenzia: boolean = false);
    procedure Info(const Value: string);
    procedure Debug(const Value: string);
    procedure EnterSection(const Value: string);
    procedure ExitSection;
  public
    constructor Create(const LogFilename: string = '');
    destructor Destroy; override;
  end;

var
  prvPFLogger: IpfLogger;

const
  TEMPO_CICLO = 200; // tempo di ciclo in ms

function CreatePFLogger(const LogFilename: string = ''): IpfLogger;
begin
  result := TpfLogger.Create(LogFilename);
end;

{ TLogThread }

procedure TLogThread.AppendText(const text: string);
begin
  TMonitor.Enter(FInternalBuffer);
  try
    FInternalBuffer.add(text);
  finally
    TMonitor.Exit(FInternalBuffer);
  end;
end;

constructor TLogThread.Create(const LogFilename: string);
begin
  inherited Create(true);

  FInternalBuffer := TStringList.Create;
  // FUDPClient1 := TIDUDPClient.Create;

  if LogFilename = '' then
    FLogFileName := Tpath.GetHomePath + Tpath.DirectorySeparatorChar + Tpath.GetFileNameWithoutExtension(ParamStr(0)) + '.log'
  else
    FLogFileName := LogFilename;
end;

function TLogThread.UpdateLogFile: boolean;
var
  F: TextFile;
  s: String;
  FullFileName: string;
begin
  FullFileName := Tpath.GetDirectoryName(FLogFileName) + Tpath.DirectorySeparatorChar + 'Log' + Tpath.DirectorySeparatorChar +
    FormatDateTime('YYYYMM', date) + Tpath.DirectorySeparatorChar + Tpath.GetFileNameWithoutExtension(FLogFileName);
  FullFileName := FullFileName + '_' + FormatDateTime('yyyymmdd', date) + '_' + GetEnvironmentVariable('USERNAME') + '.log';
  ForceDirectories(Tpath.GetDirectoryName(FullFileName));
  result := false;
  try
    AssignFile(F, FullFileName);
    try
      if TFile.Exists(FullFileName) then
        Append(F)
      else
        Rewrite(F);
      for s in FInternalBuffer do
      begin
        // if Assigned(FUDPClient1) then
        // begin
        // try
        // // FUDPClient1.Send(TCfgService.GetTAGServerHost, 9999, s);
        // FUDPClient1.Send('thomas-pc', 9999, s);
        // except
        // end;
        // end;
        Writeln(F, s);
      end;

      result := true;
      Flush(F);
    finally
      CloseFile(F);
    end;
  except
  end;

end;

destructor TLogThread.Destroy;
begin
  // Il thread è ormai fermo, non serve il monitor
  // FUDPClient1.Free;
  FInternalBuffer.Clear;
  FInternalBuffer.Free;
  inherited;
end;

procedure TLogThread.Execute;
begin
  while true do
  begin
    sleep(TEMPO_CICLO);

    TMonitor.Enter(FInternalBuffer);
    try
      if FInternalBuffer.Count > 0 then
      begin

        if UpdateLogFile then
          FInternalBuffer.Clear;
      end;

      if terminated then
        Exit;
    finally
      TMonitor.Exit(FInternalBuffer);
    end;
  end;
end;

function GetPFLogger(const LogFilename: string = ''): IpfLogger;
begin
  if not Assigned(prvPFLogger) then
    prvPFLogger := TpfLogger.Create(LogFilename);

  result := prvPFLogger;
end;

{ TpfLogger }

constructor TpfLogger.Create(const LogFilename: string = '');
begin
  inherited Create;

  FCurrentSection := '';

  FThread := TLogThread.Create(LogFilename);
  FThread.FreeOnTerminate := false;
  FThread.Start;

  Info('Servizio di logging attivato');
end;

procedure TpfLogger.Debug(const Value: string);
begin
  if LogLevel >= llDebug then
    Log('DEBUG', Value);
end;

destructor TpfLogger.Destroy;
begin
  Info('Termino il servizio di logging');

  FThread.Terminate;
  FThread.WaitFor;
  FThread.Free;

  inherited;
end;

procedure TpfLogger.EnterSection(const Value: string);
begin
  if FCurrentSection <> '' then
    FCurrentSection := FCurrentSection + '|';

  FCurrentSection := FCurrentSection + Value;

  if LogLevel >= llDebug then
    Log('DEBUG', 'Begin Section');
end;

procedure TpfLogger.Error(const Value: string);
begin
  if LogLevel >= llError then
    Log('ERROR', Value.toupper);
end;

procedure TpfLogger.NotifyError(const Value: string; const silenzia: boolean = false);
begin
  Error(Value);

  // if not silenzia then
  // MessageDlg(Value, mtError, [mbAbort], 0);
end;

procedure TpfLogger.NotifyWarning(const Value: string; const silenzia: boolean = false);
begin
  Warning(Value);
  // if not silenzia then
  // MessageDlg(Value, mtWarning, [mbOk], 0);
end;

procedure TpfLogger.Log(const level, text: string);
var
  s: string;
begin
  if FCurrentSection <> '' then
    s := FCurrentSection + ' ' + text
  else
    s := text;

  s := FormatDateTime('dd/mm hh:nn:ss', now) + '|' + copy(level, 1, 1) + '|' + s;

  FThread.AppendText(s);
end;

procedure TpfLogger.LogException(const Value: string; const E: Exception);
begin
  if LogLevel >= llError then
  begin
    Log('EXCEP', Value);
    Log('EXCEP', 'E.Classname=' + E.ClassName);
    Log('EXCEP', 'E.message=' + E.Message);
  end;
end;

procedure TpfLogger.NotifyException(const Value: string; const E: Exception; const silenzia: boolean = false);
begin
  LogException(Value, E);
  // if not silenzia then
  // MessageDlg(Value, mtError, [mbAbort], 0);
end;

procedure TpfLogger.ExitSection;
var
  arr: TArray<string>;
begin
  arr := FCurrentSection.split(['|']);

  if LogLevel >= llDebug then
    Log('DEBUG', 'Exit Section');

  if length(arr) > 1 then
    FCurrentSection := FCurrentSection.Join('|', arr, 0, length(arr) - 2)
  else
    FCurrentSection := '';
end;

function TpfLogger.GetLogLevel: string;
begin
  case FLogLevel of
    llError:
      result := 'ERROR';
    llWarning:
      result := 'WARNING';
    llInfo:
      result := 'INFORMATION ';
    llDebug:
      result := 'DEBUG';
  else
    result := 'INVALID!';
  end;
end;

procedure TpfLogger.Info(const Value: string);
begin
  if LogLevel >= llInfo then
    Log('INFO', Value);
end;

procedure TpfLogger.SetLogLevel(aLogLevel: pfLogLevel);
begin
  FLogLevel := aLogLevel;
end;

procedure TpfLogger.Warning(const Value: string);
begin
  if LogLevel >= llWarning then
    Log('WARN.', Value);
end;

initialization

prvPFLogger := nil;

end.
