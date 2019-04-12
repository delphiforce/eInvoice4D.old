{ *************************************************************************** }
{ }
{ eInvoice4D - (Fatturazione Elettronica per Delphi) }
{ }
{ Copyright (C) 2018  Delphi Force }
{ }
{ info@delphiforce.it }
{ https://github.com/delphiforce/eInvoice4D.git }
{ }
{ Delphi Force Team }
{ Antonio Polito }
{ Carlo Narcisi }
{ Fabio Codebue }
{ Marco Mottadelli }
{ Maurizio del Magno }
{ Omar Bossoni }
{ Thomas Ranzetti }
{ }
{ *************************************************************************** }
{ }
{ This file is part of eInvoice4D }
{ }
{ Licensed under the GNU Lesser General Public License, Version 3; }
{ you may not use this file except in compliance with the License. }
{ }
{ eInvoice4D is free software: you can redistribute it and/or modify }
{ it under the terms of the GNU Lesser General Public License as published }
{ by the Free Software Foundation, either version 3 of the License, or }
{ (at your option) any later version. }
{ }
{ eInvoice4D is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the }
{ GNU Lesser General Public License for more details. }
{ }
{ You should have received a copy of the GNU Lesser General Public License }
{ along with eInvoice4D.  If not, see <http://www.gnu.org/licenses/>. }
{ }
{ ------------------------------------------------------------------------- }
{ Generated on: 05/05/2015 18:58:34 }
{ Generated from: fatturapa_v1.1.xsd }
{ versione 1.2.1 }
{ DA AGGIUNGERE A MANO: }
{ - Tutte le proprietà nelle classi (copiarle dalle interfacce) }
{ - Attributo [ioEntity] in ogni classe }
{ - Attributo [ioBelongsTo(...)] nelle proprietà oggetto di una relazione }
{ con un'altra classe figlia }
{ - Direttiva {$RTTI EXPLICIT METHODS([vcProtected, vcPublic, vcPublished]) }
{ PROPERTIES([vcProtected, vcPublic, vcPublished]) }
{ prima dello uses di questa Unit. }
{ *************************************************************************** }
unit DForce.ei.Notification.NS.Base;
// PER ATTRIBUTI IOrm
{$WARN UNSUPPORTED_CONSTRUCT OFF}

interface

{$RTTI EXPLICIT METHODS([vcProtected, vcPublic, vcPublished]) PROPERTIES([vcProtected, vcPublic, vcPublished])}

uses xmldom, XMLDoc, XMLIntf, Classes;

type

  { Forward Decls }

  IXMLRiferimentoArchivioType = interface;

  IXMLListaErroriType = interface;

  IXMLErroreTypeList = interface;

  IXMLErroreType = interface;

  IXMLNotificaNSType = interface(IXMLNode)
    ['{7F517387-C7D7-4331-BE16-F23C0BCBA925}']
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    function Get_DataOraRicezione: UnicodeString;
    function Get_RiferimentoArchivio: IXMLRiferimentoArchivioType;
    function Get_ListaErrori: IXMLListaErroriType;
    function Get_MessageId: UnicodeString;
    function Get_PecMessageId: UnicodeString;
    function Get_Note: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_NomeFile(Value: UnicodeString);
    procedure Set_DataOraRicezione(Value: UnicodeString);
    procedure Set_MessageId(Value: UnicodeString);
    procedure Set_PecMessageId(Value: UnicodeString);
    procedure Set_Note(Value: UnicodeString);
    { Methods & Properties }
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property NomeFile: UnicodeString read Get_NomeFile write Set_NomeFile;
    property DataOraRicezione: UnicodeString read Get_DataOraRicezione write Set_DataOraRicezione;
    property RiferimentoArchivio: IXMLRiferimentoArchivioType read Get_RiferimentoArchivio;
    property ListaErrori: IXMLListaErroriType read Get_ListaErrori;
    property PecMessageId: UnicodeString read Get_PecMessageId write Set_PecMessageId;
    property MessageId: UnicodeString read Get_MessageId write Set_MessageId;
    property Note: UnicodeString read Get_Note write Set_Note;
  end;

  IXMLRiferimentoArchivioType = interface(IXMLNode)
    ['{005C8BC9-D220-46EC-B761-7F8D3AAA94D3}']
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_NomeFile(Value: UnicodeString);
    { Methods & Properties }
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property NomeFile: UnicodeString read Get_NomeFile write Set_NomeFile;
  end;

  IXMLListaErroriType = interface(IXMLNode)
    ['{F7FAB2D3-5455-4AD8-B37B-82FCC7BA49D4}']
    { Property Accessors }
    function Get_Errore: IXMLErroreTypeList;
    { Methods & Properties }
    property Errore: IXMLErroreTypeList read Get_Errore;
  end;

  IXMLErroreTypeList = interface(IXMLNodeCollection)
    ['{7D1D01D5-356A-4321-9D80-5AA22B509F57}']
    function Add: IXMLErroreType;
    function Insert(const Index: Integer): IXMLErroreType;
    function Get_Item(Index: Integer): IXMLErroreType;
    property Items[Index: Integer]: IXMLErroreType read Get_Item; default;
  end;

  IXMLErroreType = interface(IXMLNode)
    ['{C4E4533D-7F1D-42A2-A04F-3F22D497F740}']
    function Get_Codice: UnicodeString;
    function Get_Descrizione: UnicodeString;
    function Get_Suggerimento: UnicodeString;
    procedure Set_Codice(Value: UnicodeString);
    procedure Set_Descrizione(Value: UnicodeString);
    procedure Set_Suggerimento(Value: UnicodeString);
    { Methods & Properties }
    property Codice: UnicodeString read Get_Codice write Set_Codice;
    property Descrizione: UnicodeString read Get_Descrizione write Set_Descrizione;
    property Suggerimento: UnicodeString read Get_Suggerimento write Set_Suggerimento;
  end;

  { TXMLNotificaNSType }

  TXMLNotificaNSType = class(TXMLNode, IXMLNotificaNSType, IInterface)
  protected
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    function Get_DataOraRicezione: UnicodeString;
    function Get_RiferimentoArchivio: IXMLRiferimentoArchivioType;
    function Get_ListaErrori: IXMLListaErroriType;
    function Get_MessageId: UnicodeString;
    function Get_PecMessageId: UnicodeString;
    function Get_Note: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_NomeFile(Value: UnicodeString);
    procedure Set_DataOraRicezione(Value: UnicodeString);
    procedure Set_MessageId(Value: UnicodeString);
    procedure Set_PecMessageId(Value: UnicodeString);
    procedure Set_Note(Value: UnicodeString);
  public
    { Methods & Properties }
    procedure AfterConstruction; override;
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property NomeFile: UnicodeString read Get_NomeFile write Set_NomeFile;
    property DataOraRicezione: UnicodeString read Get_DataOraRicezione write Set_DataOraRicezione;
    property RiferimentoArchivio: IXMLRiferimentoArchivioType read Get_RiferimentoArchivio;
    property ListaErrori: IXMLListaErroriType read Get_ListaErrori;
    property MessageId: UnicodeString read Get_MessageId write Set_MessageId;
    property Note: UnicodeString read Get_Note write Set_Note;
  end;

  { TXMLRiferimentoArchivioType }

  TXMLRiferimentoArchivioType = class(TXMLNode, IXMLRiferimentoArchivioType)
  protected
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_NomeFile(Value: UnicodeString);
  public
    { Methods & Properties }
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property NomeFile: UnicodeString read Get_NomeFile write Set_NomeFile;
  end;

  { TXMLListaErroriType }

  TXMLListaErroriType = class(TXMLNode, IXMLListaErroriType)
  private
    FErroreList: IXMLErroreTypeList;
  protected
    { Property Accessors }
    function Get_Errore: IXMLErroreTypeList;
    { Methods & Properties }
    property Errore: IXMLErroreTypeList read Get_Errore;
  public
    procedure AfterConstruction; override;
  end;

  TXMLErroreTypeList = class(TXMLNodeCollection, IXMLErroreTypeList)
  protected
    { Methods & Properties }
    function Add: IXMLErroreType;
    function Insert(const Index: Integer): IXMLErroreType;
    function Get_Item(Index: Integer): IXMLErroreType;
    property Items[Index: Integer]: IXMLErroreType read Get_Item; default;
  end;

  { TXMLErroreType }

  TXMLErroreType = class(TXMLNode, IXMLErroreType)
  protected
    function Get_Codice: UnicodeString;
    function Get_Descrizione: UnicodeString;
    function Get_Suggerimento: UnicodeString;
    procedure Set_Codice(Value: UnicodeString);
    procedure Set_Descrizione(Value: UnicodeString);
    procedure Set_Suggerimento(Value: UnicodeString);
  public
    { Methods & Properties }
    property Codice: UnicodeString read Get_Codice write Set_Codice;
    property Descrizione: UnicodeString read Get_Descrizione write Set_Descrizione;
    property Suggerimento: UnicodeString read Get_Suggerimento write Set_Suggerimento;
  end;

  { Global Functions }

function GetNotificaNS(Doc: IXMLDocument): IXMLNotificaNSType;

function LoadNotificaNS(const FileName: string): IXMLNotificaNSType;

function NewNotificaNS: IXMLNotificaNSType;

const
  TargetNamespace = '';

implementation

function GetNotificaNS(Doc: IXMLDocument): IXMLNotificaNSType;
begin
  Result := Doc.GetDocBinding('NotificaScarto', TXMLNotificaNSType, TargetNamespace) as IXMLNotificaNSType;
end;

function LoadNotificaNS(const FileName: string): IXMLNotificaNSType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('NotificaScarto', TXMLNotificaNSType, TargetNamespace) as IXMLNotificaNSType;
end;

function NewNotificaNS: IXMLNotificaNSType;
begin
  Result := NewXMLDocument.GetDocBinding('NotificaScarto', TXMLNotificaNSType, TargetNamespace) as IXMLNotificaNSType;
end;

{ TXMLNotificaNSType }

procedure TXMLNotificaNSType.AfterConstruction;
begin
  RegisterChildNode('RiferimentoArchivio', TXMLRiferimentoArchivioType);
  RegisterChildNode('ListaErrori', TXMLListaErroriType);
  inherited;
end;

function TXMLNotificaNSType.Get_DataOraRicezione: UnicodeString;
begin
  Result := ChildNodes['DataOraRicezione'].Text;
end;

function TXMLNotificaNSType.Get_IdentificativoSdI: UnicodeString;
begin
  Result := ChildNodes['IdentificativoSdI'].Text;
end;

function TXMLNotificaNSType.Get_ListaErrori: IXMLListaErroriType;
begin
  Result := ChildNodes['ListaErrori'] as IXMLListaErroriType;
end;

function TXMLNotificaNSType.Get_MessageId: UnicodeString;
begin
  Result := ChildNodes['MessageId'].Text;
end;

function TXMLNotificaNSType.Get_NomeFile: UnicodeString;
begin
  Result := ChildNodes['NomeFile'].Text;
end;

function TXMLNotificaNSType.Get_Note: UnicodeString;
begin
  Result := ChildNodes['Note'].Text;
end;

function TXMLNotificaNSType.Get_PecMessageId: UnicodeString;
begin
  Result := ChildNodes['PecMessageId'].Text;
end;

function TXMLNotificaNSType.Get_RiferimentoArchivio: IXMLRiferimentoArchivioType;
begin
  Result := ChildNodes['RiferimentoArchivio'] as IXMLRiferimentoArchivioType;
end;

procedure TXMLNotificaNSType.Set_DataOraRicezione(Value: UnicodeString);
begin
  ChildNodes['DataOraRicezione'].NodeValue := Value;
end;

procedure TXMLNotificaNSType.Set_IdentificativoSdI(Value: UnicodeString);
begin
  ChildNodes['IdentificativoSdI'].NodeValue := Value;
end;

procedure TXMLNotificaNSType.Set_MessageId(Value: UnicodeString);
begin
  ChildNodes['MessageId'].NodeValue := Value;
end;

procedure TXMLNotificaNSType.Set_NomeFile(Value: UnicodeString);
begin
  ChildNodes['NomeFile'].NodeValue := Value;
end;

procedure TXMLNotificaNSType.Set_Note(Value: UnicodeString);
begin
  ChildNodes['Note'].NodeValue := Value;
end;

procedure TXMLNotificaNSType.Set_PecMessageId(Value: UnicodeString);
begin
  ChildNodes['PecMessageId'].NodeValue := Value;
end;

{ TXMLRiferimentoArchivioType }

function TXMLRiferimentoArchivioType.Get_IdentificativoSdI: UnicodeString;
begin
  Result := ChildNodes['IdentificativoSdI'].Text;
end;

function TXMLRiferimentoArchivioType.Get_NomeFile: UnicodeString;
begin
  Result := ChildNodes['NomeFile'].Text;
end;

procedure TXMLRiferimentoArchivioType.Set_IdentificativoSdI(Value: UnicodeString);
begin
  ChildNodes['IdentificativoSdI'].NodeValue := Value;
end;

procedure TXMLRiferimentoArchivioType.Set_NomeFile(Value: UnicodeString);
begin
  ChildNodes['NomeFile'].NodeValue := Value;
end;

{ TXMLErroreTypeList }

function TXMLErroreTypeList.Add: IXMLErroreType;
begin
  Result := AddItem(-1) as IXMLErroreType;
end;

function TXMLErroreTypeList.Get_Item(Index: Integer): IXMLErroreType;
begin
  Result := List[Index] as IXMLErroreType;
end;

function TXMLErroreTypeList.Insert(const Index: Integer): IXMLErroreType;
begin
  Result := AddItem(Index) as IXMLErroreType;
end;

{ TXMLErroreType }

function TXMLErroreType.Get_Codice: UnicodeString;
begin
  Result := ChildNodes['Codice'].Text;
end;

function TXMLErroreType.Get_Descrizione: UnicodeString;
begin
  Result := ChildNodes['Descrizione'].Text;
end;

function TXMLErroreType.Get_Suggerimento: UnicodeString;
begin
  Result := ChildNodes['Suggerimento'].Text;
end;

procedure TXMLErroreType.Set_Codice(Value: UnicodeString);
begin
  ChildNodes['Codice'].NodeValue := Value;
end;

procedure TXMLErroreType.Set_Descrizione(Value: UnicodeString);
begin
  ChildNodes['Descrizione'].NodeValue := Value;
end;

procedure TXMLErroreType.Set_Suggerimento(Value: UnicodeString);
begin
  ChildNodes['Suggerimento'].NodeValue := Value;
end;

{ TXMLListaErroriType }

procedure TXMLListaErroriType.AfterConstruction;
begin
  RegisterChildNode('Errore', TXMLErroreType);
  FErroreList := CreateCollection(TXMLErroreTypeList, IXMLErroreType, 'Errore') as IXMLErroreTypeList;
  inherited;
end;

function TXMLListaErroriType.Get_Errore: IXMLErroreTypeList;
begin
  Result := FErroreList;
end;

end.
