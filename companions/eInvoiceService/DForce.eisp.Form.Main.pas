unit DForce.eisp.Form.Main;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
  CRYPTO_KEY = 61248;
  CRYPTO_K1 = 15238;
  CRYPTO_K2 = 23719;

type
  TMainForm = class(TForm)
    ProviderID: TLabel;
    eUsername: TEdit;
    Label2: TLabel;
    ePassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    chkEnableReceiveSalesNotifications: TCheckBox;
    chkEnableSendSalesInvoices: TCheckBox;
    chkEnableReceivePurchaseInvoices: TCheckBox;
    btnSave: TButton;
    btnClose: TButton;
    cmbProviderID: TComboBox;
    cmbPollingTimeMinutes: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadParams;
    procedure SaveParams;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses IniFiles, DForce.ei, DForce.eis.Crypto;

{$R *.dfm}
{ TMainForm }

procedure TMainForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  SaveParams;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadParams;
end;

procedure TMainForm.LoadParams;
var
  LIniFile: TMemIniFile;
  TmpStr: String;
begin
  LIniFile := TMemIniFile.Create('eisParams.ini');
  try
    // Load param values
    ei.ProvidersAsStrings(cmbProviderID.Items);
    cmbProviderID.Text := LIniFile.ReadString('EIS', 'ProviderID', '');

    TmpStr := LIniFile.ReadString('EIS', 'UserName', '');
    eUsername.Text := TeisCrypto.DecryptStr(TmpStr , CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);

    TmpStr := LIniFile.ReadString('EIS', 'Password', '');
    ePassword.Text := TeisCrypto.DecryptStr(TmpStr, CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);

    cmbPollingTimeMinutes.Text := LIniFile.ReadString('EIS', 'PollingTimeMinutes', '10');
    chkEnableReceiveSalesNotifications.Checked := LIniFile.ReadBool('EIS', 'EnableReceiveSalesNotifications', True);
    chkEnableSendSalesInvoices.Checked := LIniFile.ReadBool('EIS', 'EnableSendSalesInvoices', True);
    chkEnableReceivePurchaseInvoices.Checked := LIniFile.ReadBool('EIS', 'EnableReceivePurchaseInvoices', True);
  finally
    LIniFile.Free;
  end;
end;

procedure TMainForm.SaveParams;
var
  LIniFile: TMemIniFile;
  TmpStr: String;
begin
  LIniFile := TMemIniFile.Create('eisParams.ini');
  try
    LIniFile.WriteString('EIS', 'ProviderID', cmbProviderID.Text);

    TmpStr := TeisCrypto.EncryptStr(eUsername.Text, CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);
    LIniFile.WriteString('EIS', 'UserName', TmpStr);

    TmpStr := TeisCrypto.EncryptStr(ePassword.Text, CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);
    LIniFile.WriteString('EIS', 'Password', TmpStr);

    LIniFile.WriteString('EIS', 'PollingTimeMinutes', cmbPollingTimeMinutes.Text);
    LIniFile.WriteBool('EIS', 'EnableReceiveSalesNotifications', chkEnableReceiveSalesNotifications.Checked);
    LIniFile.WriteBool('EIS', 'EnableSendSalesInvoices', chkEnableSendSalesInvoices.Checked);
    LIniFile.WriteBool('EIS', 'EnableReceivePurchaseInvoices', chkEnableReceivePurchaseInvoices.Checked);
    LIniFile.UpdateFile;
  finally
    LIniFile.Free;
  end;
  ShowMessage('File saved.');
end;

end.
