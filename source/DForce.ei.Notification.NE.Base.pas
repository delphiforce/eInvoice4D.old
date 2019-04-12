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

unit DForce.ei.Notification.NE.Base;

// PER ATTRIBUTI IOrm
{$WARN UNSUPPORTED_CONSTRUCT OFF}

interface

{$RTTI EXPLICIT METHODS([vcProtected, vcPublic, vcPublished]) PROPERTIES([vcProtected, vcPublic, vcPublished])}

uses xmldom, XMLDoc, XMLIntf, Classes;

type

  { Forward Decls }

  IXMLNotificaEsitoCommittenteType = interface;

  IXMLRiferimentoFatturaType = interface;

  IXMLNotificaNEType = interface(IXMLNode)
    ['{C1511487-B852-4CBD-A2BC-0776CD5DF4FD}']
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    function Get_DataOraRicezione: UnicodeString;
    function Get_EsitoCommittente: IXMLNotificaEsitoCommittenteType;
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
    property EsitoCommittente: IXMLNotificaEsitoCommittenteType read Get_EsitoCommittente;
    property PecMessageId: UnicodeString read Get_PecMessageId write Set_PecMessageId;
    property MessageId: UnicodeString read Get_MessageId write Set_MessageId;
    property Note: UnicodeString read Get_Note write Set_Note;
  end;

  IXMLNotificaEsitoCommittenteType = interface(IXMLNode)
    ['{CDF776E7-98AA-46D1-8DCB-4C16D5DE4FA8}']
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_RiferimentoFattura: IXMLRiferimentoFatturaType;
    function Get_Esito: UnicodeString;
    function Get_Descrizione: UnicodeString;
    function Get_MessageIdCommittente: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_Esito(Value: UnicodeString);
    procedure Set_Descrizione(Value: UnicodeString);
    procedure Set_MessageIdCommittente(Value: UnicodeString);
    { Methods & Properties }
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property RiferimentoFattura: IXMLRiferimentoFatturaType read Get_RiferimentoFattura;
    property Esito: UnicodeString read Get_Esito write Set_Esito;
    property Descrizione: UnicodeString read Get_Descrizione write Set_Descrizione;
    property MessageIdCommittente: UnicodeString read Get_MessageIdCommittente write Set_MessageIdCommittente;
  end;

  IXMLRiferimentoFatturaType = interface(IXMLNode)
    ['{662CD6DD-8032-4CB3-A285-611BF58F3C01}']
    { Property Accessors }
    function Get_NumeroFattura: UnicodeString;
    function Get_AnnoFattura: UnicodeString;
    function Get_PosizioneFattura: UnicodeString;
    procedure Set_NumeroFattura(Value: UnicodeString);
    procedure Set_AnnoFattura(Value: UnicodeString);
    procedure Set_PosizioneFattura(Value: UnicodeString);
    { Methods & Properties }
    property NumeroFattura: UnicodeString read Get_NumeroFattura write Set_NumeroFattura;
    property AnnoFattura: UnicodeString read Get_AnnoFattura write Set_AnnoFattura;
    property PosizioneFattura: UnicodeString read Get_PosizioneFattura write Set_PosizioneFattura;
  end;

  { TXMLNotificaNEType }

  TXMLNotificaNEType = class(TXMLNode, IXMLNotificaNEType, IInterface)
  protected
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_NomeFile: UnicodeString;
    function Get_DataOraRicezione: UnicodeString;
    function Get_EsitoCommittente: IXMLNotificaEsitoCommittenteType;
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
    property EsitoCommittente: IXMLNotificaEsitoCommittenteType read Get_EsitoCommittente;
    property PecMessageId: UnicodeString read Get_PecMessageId write Set_PecMessageId;
    property MessageId: UnicodeString read Get_MessageId write Set_MessageId;
    property Note: UnicodeString read Get_Note write Set_Note;
  end;

  { TXMLNotificaEsitoCommittenteType }
  TXMLNotificaEsitoCommittenteType = class(TXMLNode, IXMLNotificaEsitoCommittenteType, IInterface)
  protected
    { Property Accessors }
    function Get_IdentificativoSdI: UnicodeString;
    function Get_RiferimentoFattura: IXMLRiferimentoFatturaType;
    function Get_Esito: UnicodeString;
    function Get_Descrizione: UnicodeString;
    function Get_MessageIdCommittente: UnicodeString;
    procedure Set_IdentificativoSdI(Value: UnicodeString);
    procedure Set_Esito(Value: UnicodeString);
    procedure Set_Descrizione(Value: UnicodeString);
    procedure Set_MessageIdCommittente(Value: UnicodeString);
  public
    { Methods & Properties }
    procedure AfterConstruction; override;
    property IdentificativoSdI: UnicodeString read Get_IdentificativoSdI write Set_IdentificativoSdI;
    property RiferimentoFattura: IXMLRiferimentoFatturaType read Get_RiferimentoFattura;
    property Esito: UnicodeString read Get_Esito write Set_Esito;
    property Descrizione: UnicodeString read Get_Descrizione write Set_Descrizione;
    property MessageIdCommittente: UnicodeString read Get_MessageIdCommittente write Set_MessageIdCommittente;
  end;

  { TXMLRiferimentoFatturaType }
  TXMLRiferimentoFatturaType = class(TXMLNode, IXMLRiferimentoFatturaType, IInterface)
  protected
    { Property Accessors }
    function Get_NumeroFattura: UnicodeString;
    function Get_AnnoFattura: UnicodeString;
    function Get_PosizioneFattura: UnicodeString;
    procedure Set_NumeroFattura(Value: UnicodeString);
    procedure Set_AnnoFattura(Value: UnicodeString);
    procedure Set_PosizioneFattura(Value: UnicodeString);
  public
    { Methods & Properties }
    property NumeroFattura: UnicodeString read Get_NumeroFattura write Set_NumeroFattura;
    property AnnoFattura: UnicodeString read Get_AnnoFattura write Set_AnnoFattura;
    property PosizioneFattura: UnicodeString read Get_PosizioneFattura write Set_PosizioneFattura;
  end;

  { Global Functions }

function GetNotificaNE(Doc: IXMLDocument): IXMLNotificaNEType;

function LoadNotificaNE(const FileName: string): IXMLNotificaNEType;

function NewNotificaNE: IXMLNotificaNEType;

const
  TargetNamespace = '';

implementation

function GetNotificaNE(Doc: IXMLDocument): IXMLNotificaNEType;
begin
  Result := Doc.GetDocBinding('NotificaEsito', TXMLNotificaNEType, TargetNamespace) as IXMLNotificaNEType;
end;

function LoadNotificaNE(const FileName: string): IXMLNotificaNEType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('NotificaEsito', TXMLNotificaNEType, TargetNamespace) as IXMLNotificaNEType;
end;

function NewNotificaNE: IXMLNotificaNEType;
begin
  Result := NewXMLDocument.GetDocBinding('NotificaEsito', TXMLNotificaNEType, TargetNamespace) as IXMLNotificaNEType;
end;

{ TXMLNotificaNEType }

procedure TXMLNotificaNEType.AfterConstruction;
begin
  RegisterChildNode('EsitoCommittente', TXMLNotificaEsitoCommittenteType);
  inherited;
end;

function TXMLNotificaNEType.Get_DataOraRicezione: UnicodeString;
begin
  Result := ChildNodes['DataOraRicezione'].Text;
end;

function TXMLNotificaNEType.Get_EsitoCommittente: IXMLNotificaEsitoCommittenteType;
begin
  Result := ChildNodes['EsitoCommittente'] as IXMLNotificaEsitoCommittenteType;
end;

function TXMLNotificaNEType.Get_IdentificativoSdI: UnicodeString;
begin
  Result := ChildNodes['IdentificativoSdI'].Text;
end;

function TXMLNotificaNEType.Get_MessageId: UnicodeString;
begin
  Result := ChildNodes['MessageId'].Text;
end;

function TXMLNotificaNEType.Get_NomeFile: UnicodeString;
begin
  Result := ChildNodes['NomeFile'].Text;
end;

function TXMLNotificaNEType.Get_Note: UnicodeString;
begin
  Result := ChildNodes['Note'].Text;
end;

function TXMLNotificaNEType.Get_PecMessageId: UnicodeString;
begin
  Result := ChildNodes['PecMessageId'].Text;
end;

procedure TXMLNotificaNEType.Set_DataOraRicezione(Value: UnicodeString);
begin
  ChildNodes['DataOraRicezione'].NodeValue := Value;
end;

procedure TXMLNotificaNEType.Set_IdentificativoSdI(Value: UnicodeString);
begin
  ChildNodes['IdentificativoSdI'].NodeValue := Value;

end;

procedure TXMLNotificaNEType.Set_MessageId(Value: UnicodeString);
begin
  ChildNodes['MessageId'].NodeValue := Value;
end;

procedure TXMLNotificaNEType.Set_NomeFile(Value: UnicodeString);
begin
  ChildNodes['NomeFile'].NodeValue := Value;
end;

procedure TXMLNotificaNEType.Set_Note(Value: UnicodeString);
begin
  ChildNodes['Note'].NodeValue := Value;
end;

procedure TXMLNotificaNEType.Set_PecMessageId(Value: UnicodeString);
begin
  ChildNodes['PecMessageId'].NodeValue := Value;
end;

{ TXMLNotificaEsitoCommittenteType }

procedure TXMLNotificaEsitoCommittenteType.AfterConstruction;
begin
  RegisterChildNode('RiferimentoFattura', TXMLRiferimentoFatturaType);
  inherited;
end;

function TXMLNotificaEsitoCommittenteType.Get_Descrizione: UnicodeString;
begin
  Result := ChildNodes['Descrizione'].Text;
end;

function TXMLNotificaEsitoCommittenteType.Get_Esito: UnicodeString;
begin
  Result := ChildNodes['Esito'].Text;
end;

function TXMLNotificaEsitoCommittenteType.Get_IdentificativoSdI: UnicodeString;
begin
  Result := ChildNodes['IdentificativoSdI'].Text;
end;

function TXMLNotificaEsitoCommittenteType.Get_MessageIdCommittente: UnicodeString;
begin
  Result := ChildNodes['MessageIdCommittente'].Text;
end;

function TXMLNotificaEsitoCommittenteType.Get_RiferimentoFattura: IXMLRiferimentoFatturaType;
begin
  Result := ChildNodes['RiferimentoFattura'] as IXMLRiferimentoFatturaType;
end;

procedure TXMLNotificaEsitoCommittenteType.Set_Descrizione(Value: UnicodeString);
begin
  ChildNodes['Descrizione'].NodeValue := Value;
end;

procedure TXMLNotificaEsitoCommittenteType.Set_Esito(Value: UnicodeString);
begin
  ChildNodes['Esito'].NodeValue := Value;
end;

procedure TXMLNotificaEsitoCommittenteType.Set_IdentificativoSdI(Value: UnicodeString);
begin
  ChildNodes['IdentificativoSdI'].NodeValue := Value;
end;

procedure TXMLNotificaEsitoCommittenteType.Set_MessageIdCommittente(Value: UnicodeString);
begin
  ChildNodes['MessageIdCommittente'].NodeValue := Value;
end;

{ TXMLRiferimentoFatturaType }

function TXMLRiferimentoFatturaType.Get_AnnoFattura: UnicodeString;
begin
  Result := ChildNodes['AnnoFattura'].Text;
end;

function TXMLRiferimentoFatturaType.Get_NumeroFattura: UnicodeString;
begin
  Result := ChildNodes['NumeroFattura'].Text;
end;

function TXMLRiferimentoFatturaType.Get_PosizioneFattura: UnicodeString;
begin
  Result := ChildNodes['PosizioneFattura'].Text;
end;

procedure TXMLRiferimentoFatturaType.Set_AnnoFattura(Value: UnicodeString);
begin
  ChildNodes['AnnoFattura'].NodeValue := Value;
end;

procedure TXMLRiferimentoFatturaType.Set_NumeroFattura(Value: UnicodeString);
begin
  ChildNodes['NumeroFattura'].NodeValue := Value;
end;

procedure TXMLRiferimentoFatturaType.Set_PosizioneFattura(Value: UnicodeString);
begin
  ChildNodes['PosizioneFattura'].NodeValue := Value;
end;

end.
