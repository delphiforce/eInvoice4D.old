object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'DForce service params'
  ClientHeight = 384
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProviderID: TLabel
    Left = 24
    Top = 37
    Width = 51
    Height = 13
    Caption = 'ProviderID'
  end
  object Label2: TLabel
    Left = 24
    Top = 85
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object Label3: TLabel
    Left = 24
    Top = 133
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label4: TLabel
    Left = 24
    Top = 181
    Width = 93
    Height = 13
    Caption = 'Polling time minutes'
  end
  object eUsername: TEdit
    Left = 88
    Top = 82
    Width = 169
    Height = 21
    TabOrder = 0
  end
  object ePassword: TEdit
    Left = 88
    Top = 130
    Width = 169
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object chkEnableReceiveSalesNotifications: TCheckBox
    Left = 24
    Top = 244
    Width = 233
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Enable Receive Sales Notifications'
    TabOrder = 2
  end
  object chkEnableSendSalesInvoices: TCheckBox
    Left = 24
    Top = 221
    Width = 233
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Enable send sales invoices'
    TabOrder = 3
  end
  object chkEnableReceivePurchaseInvoices: TCheckBox
    Left = 24
    Top = 288
    Width = 233
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Enable receive purchase invoices'
    TabOrder = 4
  end
  object btnSave: TButton
    Left = 182
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 5
    OnClick = btnSaveClick
  end
  object btnClose: TButton
    Left = 24
    Top = 340
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 6
    OnClick = btnCloseClick
  end
  object cmbProviderID: TComboBox
    Left = 88
    Top = 34
    Width = 169
    Height = 21
    TabOrder = 7
  end
  object cmbPollingTimeMinutes: TComboBox
    Left = 136
    Top = 178
    Width = 121
    Height = 21
    TabOrder = 8
    Items.Strings = (
      '1'
      '2'
      '3'
      '5'
      '10'
      '15'
      '30'
      '60')
  end
end
