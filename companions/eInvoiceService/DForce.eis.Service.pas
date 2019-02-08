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
unit DForce.eis.Service;

interface

uses
  DForce.eis.WorkerThread, Vcl.SvcMgr;

type
  TeInvoiceSrvService = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServicePause(Sender: TService; var Paused: Boolean);
    procedure ServiceContinue(Sender: TService; var Continued: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
    FWorkerThread: TeInvoiceWorkerThread;
  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
  end;

{$R *.dfm}

var
  eInvoiceSrvService: TeInvoiceSrvService;

implementation

uses System.Win.Registry, System.Types, Winapi.Windows, System.SysUtils,
  System.Classes, DForce.eis.Params;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  eInvoiceSrvService.Controller(CtrlCode);
end;

function TeInvoiceSrvService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TeInvoiceSrvService.ServiceAfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + name, false) then
    begin
      Reg.WriteString('Description', 'Servizio eInvoice');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

procedure TeInvoiceSrvService.ServiceContinue(Sender: TService; var Continued: Boolean);
begin
  FWorkerThread.Continue;
  Continued := True;
end;

procedure TeInvoiceSrvService.ServicePause(Sender: TService; var Paused: Boolean);
begin
  FWorkerThread.Pause;
  Paused := True;
end;

procedure TeInvoiceSrvService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  FWorkerThread := TeInvoiceWorkerThread.Create;
  FWorkerThread.Start;
  Started := True;
end;

procedure TeInvoiceSrvService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  FWorkerThread.Terminate;
  FWorkerThread.WaitFor;
  FreeAndNil(FWorkerThread);
  Stopped := True;
end;

procedure TeInvoiceSrvService.ServiceExecute(Sender: TService);
begin
  while not Terminated do
  begin
    ServiceThread.ProcessRequests(false);
    TThread.Sleep(TeisParams.LoopWaitingMillisec);
  end;
end;

end.
