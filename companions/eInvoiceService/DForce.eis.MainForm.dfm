object eInvoiceSrvMainForm: TeInvoiceSrvMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'eInvoice srv GUI version'
  ClientHeight = 267
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnAvvia: TBitBtn
    Left = 40
    Top = 24
    Width = 129
    Height = 65
    Caption = 'Avvia'
    TabOrder = 0
    OnClick = btnAvviaClick
  end
  object btnFerma: TBitBtn
    Left = 175
    Top = 24
    Width = 129
    Height = 65
    Caption = 'Ferma'
    TabOrder = 1
    OnClick = btnFermaClick
  end
  object btnInviaERicevi: TBitBtn
    Left = 40
    Top = 112
    Width = 264
    Height = 113
    Caption = 'Invia e ricevi'
    TabOrder = 2
    OnClick = btnInviaERiceviClick
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 160
    Top = 64
  end
end
