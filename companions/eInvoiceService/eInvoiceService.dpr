program eInvoiceService;

uses
  Vcl.SvcMgr,
  Vcl.Forms,
  System.SysUtils,
  DForce.eis.MainForm in 'DForce.eis.MainForm.pas' {eInvoiceSrvMainForm},
  DForce.eis.Service in 'DForce.eis.Service.pas' {eInvoiceSrvService: TService},
  DForce.eis.WorkerThread in 'DForce.eis.WorkerThread.pas',
  DForce.eis.AppAdapter.Interfaces in 'DForce.eis.AppAdapter.Interfaces.pas',
  DForce.eis.AppAdapter.Base in 'DForce.eis.AppAdapter.Base.pas' {eiApplicationAdapterBase: TDataModule},
  DForce.eis.AppAdapter.Mock in 'DForce.eis.AppAdapter.Mock.pas' {eiApplicationAdapterMock: TDataModule},
  DForce.eis.AppAdapter.Factory in 'DForce.eis.AppAdapter.Factory.pas',
  DForce.eis.Params in 'DForce.eis.Params.pas',
  DForce.eis.Crypto in 'DForce.eis.Crypto.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  if FindCmdLineSwitch('GUI', ['/'], True) then
  begin
    Vcl.Forms.Application.Initialize;
    Vcl.Forms.Application.MainFormOnTaskbar := True;
    Vcl.Forms.Application.CreateForm(TeInvoiceSrvMainForm, eInvoiceSrvMainForm);
  Vcl.Forms.Application.Run;
  end
  else
  begin
    if not Vcl.SvcMgr.Application.DelayInitialize or Vcl.SvcMgr.Application.Installing then
      Vcl.SvcMgr.Application.Initialize;
    Vcl.SvcMgr.Application.CreateForm(TeInvoiceSrvService, eInvoiceSrvService);
    Vcl.SvcMgr.Application.Run;
  end;

end.
