unit MainFM;

interface

uses Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  Winapi.ShellAPI,
  Vcl.ExtCtrls,
  DForce.ei;

type
  TMainForm = class(TForm)
    btnGeneraXMLDiProva: TButton;
    Memo1: TMemo;
    Button2: TButton;
    btnInviaAProviderSemplice: TButton;
    btnNotifications: TButton;
    lbl1: TLabel;
    Bevel1: TBevel;
    lblInfoArubaAPI: TLabel;
    cmbProvider: TComboBox;
    Label2: TLabel;
    btnInviaFatturaSingola: TButton;
    btnInviaFatturaMultipla: TButton;
    eInvoiceName: TEdit;
    btnLoadFromString: TButton;
    brnLoadFromStringBase4: TButton;
    btnLoadFromStream: TButton;
    btnLoadFromStreamBase64: TButton;
    btnLoadFromFile: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnNotificationsClick(Sender: TObject);
    procedure btnGeneraXMLDiProvaClick(Sender: TObject);
    procedure btnInviaAProviderSempliceClick(Sender: TObject);
    procedure lblInfoArubaAPIDblClick(Sender: TObject);
    procedure btnInviaFatturaSingolaClick(Sender: TObject);
    procedure btnInviaFatturaMultiplaClick(Sender: TObject);
    procedure btnLoadFromStringClick(Sender: TObject);
    procedure brnLoadFromStringBase4Click(Sender: TObject);
    procedure btnLoadFromStreamClick(Sender: TObject);
    procedure btnLoadFromStreamBase64Click(Sender: TObject);
    procedure btnLoadFromFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses xmldom,
  XMLDoc,
  XMLIntf,
  System.IOUtils,
  System.DateUtils,
  System.UITypes;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LElencoProviders: TStrings;
begin
  // Select provider
  ei.SelectProvider('ARUBA_WS_TEST', 'ARUBA0000', 'ArubaPwd');

  LElencoProviders := ei.ProvidersAsStrings;
  try
    cmbProvider.Items.Assign(LElencoProviders);
  finally
    LElencoProviders.Free;
  end;
end;

procedure TMainForm.btnNotificationsClick(Sender: TObject);
var
  LResponse: IeiResponse;
begin
  ei.Connect;
  try
    Memo1.Clear;
    for LResponse in ei.ReceiveInvoiceNotifications(eInvoiceName.Text) do
    begin
      Memo1.Lines.Add(Format('File name: %s; Msg code: %s; Msg text: %s', [LResponse.FileName, LResponse.MsgCode, LResponse.MsgText]));
      Memo1.Lines.Add(Format('ResponseDate: %s; NotificationDate : %s', [FormatDateTime('dd/mm/yy hh:nn:ss', LResponse.ResponseDate),
        FormatDateTime('dd/mm/yy hh:nn:ss', LResponse.NotificationDate)]));

      // Memo1.Lines.Add(LResponse.StatusAsString);

      Memo1.Lines.Add(LResponse.MsgRaw);
    end;
  finally
    ei.Disconnect;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ei.ReceivePurchaseInvoices;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  LInvoice: IeiInvoice;
  LValidationResultCollection: IeiValidationResultCollection;
  LValidationResult: IeiValidationResult;
begin
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  if not LInvoice.Validate then
  begin
    for LValidationResult in LInvoice.ValidationResultCollection do
    begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add(LValidationResult.Info);
      Memo1.Lines.Add(LValidationResult.Code);
    end;
  end;
end;

procedure TMainForm.btnLoadFromFileClick(Sender: TObject);
var
  LInvoice: IeiInvoice;
begin
  Memo1.Lines.Clear;
  LInvoice := ei.NewInvoiceFromFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_FPR01.xml'));
  Memo1.Lines.Text := LInvoice.ToString;
end;

procedure TMainForm.btnLoadFromStreamBase64Click(Sender: TObject);
var
  LInvoice, LInvoice2: IeiInvoice;
  LStream: TStream;
begin
  Memo1.Lines.Clear;
  LStream := TMemoryStream.Create;
  try
    // Crea una fattura, la riempie con dati demo e la salva su una stringa
    LInvoice := ei.NewInvoice;
    LInvoice.FillWithSampleData;
    LInvoice.SaveToStreamBase64(LStream);
    // Crea una seconda fattura dalla string e la mostra sul memo
    LInvoice2 := ei.NewInvoiceFromStreamBase64(LStream);
    Memo1.Lines.Text := LInvoice2.ToString;
  finally
    LStream.Free;
  end;
end;

procedure TMainForm.btnLoadFromStreamClick(Sender: TObject);
var
  LInvoice, LInvoice2: IeiInvoice;
  LStream: TStream;
begin
  Memo1.Lines.Clear;
  LStream := TMemoryStream.Create;
  try
    // Crea una fattura, la riempie con dati demo e la salva su una stringa
    LInvoice := ei.NewInvoice;
    LInvoice.FillWithSampleData;
    LInvoice.SaveToStream(LStream);
    // Crea una seconda fattura dalla string e la mostra sul memo
    LInvoice2 := ei.NewInvoiceFromStream(LStream);
    Memo1.Lines.Text := LInvoice2.ToString;
  finally
    LStream.Free;
  end;
end;

procedure TMainForm.btnLoadFromStringClick(Sender: TObject);
var
  LInvoice, LInvoice2: IeiInvoice;
  LInvoiceXML: string;
begin
  Memo1.Lines.Clear;
  // Crea una fattura, la riempie con dati demo e la salva su una stringa
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  LInvoiceXML := LInvoice.ToString;
  // Crea una seconda fattura dalla string e la mostra sul memo
  LInvoice2 := ei.NewInvoiceFromString(LInvoiceXML);
  Memo1.Lines.Text := LInvoice2.ToString;
end;

procedure TMainForm.brnLoadFromStringBase4Click(Sender: TObject);
var
  LInvoice, LInvoice2: IeiInvoice;
  LInvoiceXML: string;
begin
  Memo1.Lines.Clear;
  // Crea una fattura, la riempie con dati demo e la salva su una stringa
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  LInvoiceXML := LInvoice.ToStringBase64;
  // Crea una seconda fattura dalla string e la mostra sul memo
  LInvoice2 := ei.NewInvoiceFromStringBase64(LInvoiceXML);
  Memo1.Lines.Text := LInvoice2.ToString;
end;

procedure TMainForm.btnGeneraXMLDiProvaClick(Sender: TObject);
var
  LInvoice: IeiInvoice;
begin
  Memo1.Lines.Clear;

  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;

  Memo1.Lines.Text := LInvoice.ToString;

  LInvoice.SaveToFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_FPR01.xml'));
end;

procedure TMainForm.btnInviaFatturaMultiplaClick(Sender: TObject);
var
  LInvoice: IeiInvoice;
  LResponse: IeiResponse;
begin
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  { permette di usare il provider in un unica sessione per più fatture}
  ei.Connect;
  try
    for LResponse in ei.SendInvoice(LInvoice) do
      Memo1.Lines.Add(#13#10 + Format('File name: %s; Msg code: %s; Msg text: %s', [LResponse.FileName, LResponse.MsgCode,
        LResponse.MsgText]));
  finally
    ei.Disconnect;
  end;
end;

procedure TMainForm.btnInviaFatturaSingolaClick(Sender: TObject);
var
  LInvoice: IeiInvoice;
  LResponse: IeiResponse;
begin
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  for LResponse in ei.SendInvoice(LInvoice) do
    Memo1.Lines.Add(#13#10 + Format('File name: %s; Msg code: %s; Msg text: %s', [LResponse.FileName, LResponse.MsgCode,
      LResponse.MsgText]));
end;

procedure TMainForm.btnInviaAProviderSempliceClick(Sender: TObject);
var
  LInvoice: IeiInvoice;
begin
  LInvoice := ei.NewInvoice;
  LInvoice.FillWithSampleData;
  ei.SendInvoice(LInvoice);
end;

procedure TMainForm.lblInfoArubaAPIDblClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'https://fatturazioneelettronica.aruba.it/apidoc/docs.html', nil, nil, SW_SHOWNORMAL);
end;

end.
