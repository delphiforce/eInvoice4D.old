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
