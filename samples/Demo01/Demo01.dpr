program Demo01;

uses
  Vcl.Forms,
  MainFM in 'MainFM.pas' {MainForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

end.

