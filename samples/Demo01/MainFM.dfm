object MainForm: TMainForm
  Left = 235
  Top = 186
  Caption = 'Demo01'
  ClientHeight = 583
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 270
    Top = 8
    Width = 55
    Height = 39
    Shape = bsLeftLine
    Style = bsRaised
  end
  object lblInfoArubaAPI: TLabel
    Left = 524
    Top = 73
    Width = 350
    Height = 13
    Caption = 
      'Leggi qui le API https://fatturazioneelettronica.aruba.it/apidoc' +
      '/docs.html'
    OnDblClick = lblInfoArubaAPIDblClick
  end
  object Label2: TLabel
    Left = 141
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Provider'
  end
  object btnGeneraXMLDiProva: TButton
    Left = 8
    Top = 8
    Width = 127
    Height = 39
    Caption = 'Genera XML di prova'
    TabOrder = 0
    OnClick = btnGeneraXMLDiProvaClick
  end
  object Memo1: TMemo
    Left = 0
    Top = 259
    Width = 900
    Height = 324
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'Per provare invio fattura: '
      'Generare xml di prova, poi inviare ad aruba'
      ''
      'Per provare Notifications:'
      
        'Inviare un xml e salvarsi il filename. Dopo almeno 60 sec. prova' +
        're a richiedere la notifica specificando il '
      'filename.')
    ParentFont = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 8
    Top = 141
    Width = 127
    Height = 39
    Caption = 'Validazione XML'
    TabOrder = 2
    OnClick = Button2Click
  end
  object btnInviaAProviderSemplice: TButton
    Left = 141
    Top = 141
    Width = 116
    Height = 39
    Caption = 'Invia fattura semplice'
    TabOrder = 3
    OnClick = btnInviaAProviderSempliceClick
  end
  object btnNotifications: TButton
    Left = 279
    Top = 8
    Width = 236
    Height = 39
    Caption = 'Notifications (getByInvoiceFilename)'
    TabOrder = 4
    OnClick = btnNotificationsClick
  end
  object cmbProvider: TComboBox
    Left = 141
    Top = 26
    Width = 115
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    Sorted = True
    TabOrder = 5
    Text = 'Aruba'
    Items.Strings = (
      'Aruba'
      'Namirial'
      'Unimatica')
  end
  object btnInviaFatturaSingola: TButton
    Left = 263
    Top = 141
    Width = 116
    Height = 39
    Caption = 'Invia fattura singola'
    TabOrder = 6
    OnClick = btnInviaFatturaSingolaClick
  end
  object btnInviaFatturaMultipla: TButton
    Left = 385
    Top = 141
    Width = 116
    Height = 39
    Caption = 'Invia fattura multipla'
    TabOrder = 7
    OnClick = btnInviaFatturaMultiplaClick
  end
  object eInvoiceName: TEdit
    Left = 279
    Top = 46
    Width = 236
    Height = 21
    TabOrder = 8
  end
  object btnLoadFromString: TButton
    Left = 8
    Top = 96
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Load from string'
    TabOrder = 9
    OnClick = btnLoadFromStringClick
  end
  object brnLoadFromStringBase4: TButton
    Left = 141
    Top = 96
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Load from string base64'
    TabOrder = 10
    OnClick = brnLoadFromStringBase4Click
  end
  object btnLoadFromStream: TButton
    Left = 274
    Top = 96
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Load from stream'
    TabOrder = 11
    OnClick = btnLoadFromStreamClick
  end
  object btnLoadFromStreamBase64: TButton
    Left = 407
    Top = 96
    Width = 154
    Height = 39
    Cancel = True
    Caption = 'Load from stream base 64'
    TabOrder = 12
    OnClick = btnLoadFromStreamBase64Click
  end
  object btnLoadFromFile: TButton
    Left = 567
    Top = 96
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Load from file'
    TabOrder = 13
    OnClick = btnLoadFromFileClick
  end
  object Button1: TButton
    Left = 543
    Top = 8
    Width = 236
    Height = 39
    Caption = 'Ricezione'
    TabOrder = 14
    OnClick = Button1Click
  end
  object btnNotificaNS: TButton
    Left = 8
    Top = 202
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Notifica NS'
    TabOrder = 15
    OnClick = btnNotificaNSClick
  end
  object Button4: TButton
    Left = 727
    Top = 96
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Load from file PROVA'
    TabOrder = 16
    OnClick = Button4Click
  end
  object btnNotificaNE: TButton
    Left = 141
    Top = 202
    Width = 127
    Height = 39
    Cancel = True
    Caption = 'Notifica NE'
    TabOrder = 17
    OnClick = btnNotificaNEClick
  end
end
