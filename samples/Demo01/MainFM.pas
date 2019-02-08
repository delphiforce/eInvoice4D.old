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
unit MainFM;

interface

uses Winapi.Windows,
  Winapi.Messages,
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
    btnListaFatture: TButton;
    btnNotificaNS: TButton;
    Button4: TButton;
    btnNotificaNE: TButton;
    Button3: TButton;
    eInvoiceNameToDownload: TEdit;
    btnScaricaFattura: TButton;
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
    procedure btnListaFattureClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnNotificaNSClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnNotificaNEClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnScaricaFatturaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  System.UITypes,
  DForce.ei.Notification.Interfaces,
  DForce.ei.Notification.Factory,
  System.SysUtils, DForce.ei.Utils;

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

procedure TMainForm.btnScaricaFatturaClick(Sender: TObject);
var
  LXML: IeiResponse;
  LInvoice: IeiInvoice;
begin
  ei.Connect;
  try
    Memo1.Clear;
    LXML := ei.ReceivePurchaseInvoiceAsXML(eInvoiceNameToDownload.Text);
    Memo1.Lines.Add(LXML.MsgRaw);

    // TEST conversione XML
    // Memo1.Lines.Add('');
    // Memo1.Lines.Add('-----------------------------------------------------------------------------');
    // Memo1.Lines.Add('               CONVERTITA DA LINVOICE ');
    // Memo1.Lines.Add('-----------------------------------------------------------------------------');
    // Memo1.Lines.Add('');
    // LInvoice := ei.NewInvoiceFromString(LResponse.MsgRaw);
    // Memo1.Lines.Add(LInvoice.ToString);
  finally
    ei.Disconnect;
  end;
end;

procedure TMainForm.btnListaFattureClick(Sender: TObject);
var
  LIDCollection: IeiInvoiceIDCollection;
  LID: string;
begin
  Memo1.Lines.Clear;
  // LIDCollection := ei.ReceivePurchaseInvoiceFileNameCollection(EncodeDate(2019, 1, 1));
  for LID in LIDCollection do
  begin
    Memo1.Lines.Add(LID);
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  LResponse: IeiResponse;
begin
  ei.Connect;
  try
    Memo1.Clear;
    for LResponse in ei.ReceivePurchaseInvoiceNotifications('IT02242550982_00B21.xml.p7m') do
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

procedure TMainForm.Button2Click(Sender: TObject);
var
  LInvoice: IeiInvoice;
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

procedure TMainForm.Button3Click(Sender: TObject);
var
  LXML: TStringList;
  LStr: string;
begin
  LXML := TStringList.Create;
  LXML.LoadFromFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_11111_NE_001.xml'));
  LStr := LXML.Text;
  TeiUtils.PurgeXML(LStr, 'NotificaEsito');
  LXML.Text := LStr;
  LXML.SaveToFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_11111_NE_001_PURGED.xml'));
end;

procedure TMainForm.btnNotificaNEClick(Sender: TObject);
var
  LNotificaNE: IeiNotificationNEEx;
  LXmlNotificaNE: string;
  LFileXML: TFileStream;
  LStringXML: TStringStream;
begin
  LFileXML := TFileStream.Create(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_11111_NE_001.xml'), fmOpenRead);
  try
    LStringXML := TStringStream.Create;
    try
      LStringXML.CopyFrom(LFileXML, 0);
      LXmlNotificaNE := LStringXML.DataString;
      LNotificaNE := TeiNotificationFactory.NewNotificationNEFromString(LXmlNotificaNE);
      Memo1.Lines.Clear;
      Memo1.Lines.Add(LNotificaNE.IdentificativoSDI);
      Memo1.Lines.Add(LNotificaNE.NomeFile);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.IdentificativoSDI);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.RiferimentoFattura.NumeroFattura);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.RiferimentoFattura.AnnoFattura);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.RiferimentoFattura.PosizioneFattura);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.Esito);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.Descrizione);
      Memo1.Lines.Add(LNotificaNE.EsitoCommittente.MessageIdCommittente);
      Memo1.Lines.Add(LNotificaNE.MessageId);
      Memo1.Lines.Add(LNotificaNE.PecMessageId);
      Memo1.Lines.Add(LNotificaNE.Note);
    finally
      LStringXML.Free;
    end;

    Memo1.Lines.Add('-------------------------------------');
    Memo1.Lines.Add('RAW XML:');
    Memo1.Lines.Add('-------------------------------------');
    Memo1.Lines.Add(LNotificaNE.ToString);
  finally
    LFileXML.Free;
  end;
end;

procedure TMainForm.btnNotificaNSClick(Sender: TObject);
var
  LNotificaNS: IeiNotificationNSEx;
  LXmlNotificaNS: string;
  LFileXML: TFileStream;
  LStringXML: TStringStream;
  i: Integer;
begin
  LFileXML := TFileStream.Create(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_11111_NS_001.xml'), fmOpenRead);
  try
    LStringXML := TStringStream.Create;
    try
      LStringXML.CopyFrom(LFileXML, 0);
      LXmlNotificaNS := LStringXML.DataString;
      LNotificaNS := TeiNotificationFactory.NewNotificationNSFromString(LXmlNotificaNS);
      Memo1.Lines.Clear;
      Memo1.Lines.Add(LNotificaNS.IdentificativoSDI);
      Memo1.Lines.Add(LNotificaNS.NomeFile);
      Memo1.Lines.Add(LNotificaNS.DataOraRicezione);
      Memo1.Lines.Add(LNotificaNS.RiferimentoArchivio.IdentificativoSDI);
      Memo1.Lines.Add(LNotificaNS.RiferimentoArchivio.NomeFile);
      Memo1.Lines.Add(LNotificaNS.MessageId);
      Memo1.Lines.Add(LNotificaNS.Note);
      for i := 0 to LNotificaNS.ListaErrori.Errore.Count - 1 do
      begin
        Memo1.Lines.Add('');
        Memo1.Lines.Add(LNotificaNS.ListaErrori.Errore[i].Codice);
        Memo1.Lines.Add(LNotificaNS.ListaErrori.Errore[i].Descrizione);
      end;

      Memo1.Lines.Add('-------------------------------------');
      Memo1.Lines.Add('RAW XML:');
      Memo1.Lines.Add('-------------------------------------');
      Memo1.Lines.Add(LNotificaNS.ToString);
    finally
      LStringXML.Free;
    end;
  finally
    LFileXML.Free;
  end;
end;

procedure TMainForm.Button4Click(Sender: TObject);
var
  LInvoice: IeiInvoice;
begin
  Memo1.Lines.Clear;
  LInvoice := ei.NewInvoiceFromFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_FPR02.xml'));
  Memo1.Lines.Text := LInvoice.ToString;
  LInvoice.SaveToFile(TPath.Combine(TPath.GetDocumentsPath, 'IT01234567890_FPR03.xml'));
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
  { permette di usare il provider in un unica sessione per più fatture }
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
