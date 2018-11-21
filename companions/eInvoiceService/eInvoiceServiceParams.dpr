program eInvoiceServiceParams;

uses
  Vcl.Forms,
  DForce.eisp.Form.Main in 'DForce.eisp.Form.Main.pas' {MainForm},
  DForce.eis.Crypto in 'DForce.eis.Crypto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
