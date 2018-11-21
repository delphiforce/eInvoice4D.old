unit DForce.eis.MainForm;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.AppEvnts,
  DForce.eis.WorkerThread, Vcl.ExtCtrls;

type
  TeInvoiceSrvMainForm = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    btnAvvia: TBitBtn;
    btnFerma: TBitBtn;
    btnInviaERicevi: TBitBtn;
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure btnAvviaClick(Sender: TObject);
    procedure btnFermaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInviaERiceviClick(Sender: TObject);
  private
    { Private declarations }
    FWorkerThread: TeInvoiceWorkerThread;
    function WorkerThreadExists: Boolean;
    procedure StartWorkerThread;
    procedure StopWorkerThread;
    procedure UpdateUIState;
  public
    { Public declarations }
  end;

var
  eInvoiceSrvMainForm: TeInvoiceSrvMainForm;

implementation

{$R *.dfm}

procedure TeInvoiceSrvMainForm.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  UpdateUIState;
end;

procedure TeInvoiceSrvMainForm.btnAvviaClick(Sender: TObject);
begin
  StartWorkerThread;
end;

procedure TeInvoiceSrvMainForm.btnFermaClick(Sender: TObject);
begin
  StopWorkerThread;
end;

procedure TeInvoiceSrvMainForm.btnInviaERiceviClick(Sender: TObject);
begin
  if not WorkerThreadExists then
  begin
    try
      StartWorkerThread;
      btnInviaERicevi.Enabled := False;
      Sleep(100); // Necessary !!
      StopWorkerThread;
    finally
      btnInviaERicevi.Enabled := True;
    end;
  end
  else
    FWorkerThread.ForceSendReceive;
end;

procedure TeInvoiceSrvMainForm.FormDestroy(Sender: TObject);
begin
  if WorkerThreadExists then
    StopWorkerThread;
end;

procedure TeInvoiceSrvMainForm.StartWorkerThread;
begin
  if WorkerThreadExists then
    raise Exception.Create('WorkerThread already started.');
  FWorkerThread := TeInvoiceWorkerThread.Create;
  FWorkerThread.Start;
  UpdateUIState;
end;

procedure TeInvoiceSrvMainForm.StopWorkerThread;
begin
  Screen.Cursor := crHourGlass;
  if not WorkerThreadExists then
    raise Exception.Create('WorkerThread not running.');
  FWorkerThread.Terminate;
  FWorkerThread.WaitFor;
  FreeAndNil(FWorkerThread);
  UpdateUIState;
  Screen.Cursor := crDefault;
end;

procedure TeInvoiceSrvMainForm.UpdateUIState;
begin
  btnAvvia.Enabled := not WorkerThreadExists;
  btnFerma.Enabled := WorkerThreadExists;
  // btnPausa.Enabled := Assigned(FWorkerThread) and (not FWorkerThread.IsPaused);
  // btnContinua.Enabled := Assigned(FWorkerThread) and FWorkerThread.IsPaused;
end;

function TeInvoiceSrvMainForm.WorkerThreadExists: Boolean;
begin
  result := Assigned(FWorkerThread);
end;

end.
