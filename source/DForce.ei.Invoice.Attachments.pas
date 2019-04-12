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
{ *************************************************************************** }
unit DForce.ei.Invoice.Attachments;

interface

uses
  System.Classes, DForce.ei.Invoice.Interfaces,
  DForce.ei.Invoice.Attachments.Interfaces, DForce.ei.Invoice.Base;

type
  TeiAttachment = class(TInterfacedObject, IeiAttachment)
  private
    FXMLAttachment: IXMLAllegatiType;
  protected
    procedure LoadFromStream(const AStream: TStream);
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToFile(const APath: string);
    procedure SaveToFileAs(const AFileName: string);
    // NomeAttachments
    function GetNomeAttachment: string;
    // AlgoritmoCompressione
    function GetAlgoritmoCompressione: string;
    // FormatoAttachment
    function GetFormatoAttachment: string;
    // DescrizioneAttachment
    function GetDescrizioneAttachment: string;
  public
    constructor Create(const AXMLAttachment: IXMLAllegatiType; const ANomeAttachment, AFormatoAttachment, AAlgoritmoCompressione, ADescrizioneAttachment: string); reintroduce;
  end;

  TeiAttachments = class(TInterfacedObject, IeiAttachments)
  private
    FInvoice: IeiInvoiceEx;
  protected
    function Add(const ANomeAttachment: string; const AFormatoAttachment: string = ''; const AAlgoritmoCompressione: string = ''; const ADescrizioneAttachment: string = '')
      : IeiAttachment;
    function GetList: TStringList;
    procedure FillList(const AStringList: TStringList);
    function IndexOf(const AName: string): integer;
    function Count: integer;
    function GetItems(const AIndex: integer): IeiAttachment;
    function GetValues(const AAttachmentName: string): IeiAttachment;
  public
    constructor Create(const AInvoice: IeiInvoiceEx); reintroduce;
  end;

implementation

uses
  System.NetEncoding, System.SysUtils, System.IOUtils,
  DForce.ei.Invoice.Attachments.Factory, DForce.ei.Exception;

{ TeiAttachments }

function TeiAttachments.Count: integer;
begin
  result := FInvoice.FatturaElettronicaBody[0].Allegati.Count;
end;

constructor TeiAttachments.Create(const AInvoice: IeiInvoiceEx);
begin
  FInvoice := AInvoice;
end;

function TeiAttachments.Add(const ANomeAttachment: string; const AFormatoAttachment: string = ''; const AAlgoritmoCompressione: string = '';
  const ADescrizioneAttachment: string = ''): IeiAttachment;
begin
  result := TeiAttachmentsFactory.NewAttachment(FInvoice.FatturaElettronicaBody[0].Allegati.Add, ANomeAttachment, AFormatoAttachment, AAlgoritmoCompressione,
    ADescrizioneAttachment);
end;

procedure TeiAttachments.FillList(const AStringList: TStringList);
var
  i: integer;
begin
  for i := 0 to FInvoice.FatturaElettronicaBody[0].Allegati.Count - 1 do
    AStringList.Add(FInvoice.FatturaElettronicaBody[0].Allegati[i].NomeAttachment);
end;

function TeiAttachments.GetItems(const AIndex: integer): IeiAttachment;
begin
  result := TeiAttachmentsFactory.NewAttachment(FInvoice.FatturaElettronicaBody[0].Allegati[AIndex]);
end;

function TeiAttachments.GetList: TStringList;
begin
  result := TStringList.Create;
  Self.FillList(result);
end;

function TeiAttachments.GetValues(const AAttachmentName: string): IeiAttachment;
var
  LIndex: integer;
begin
  LIndex := Self.IndexOf(AAttachmentName);
  if LIndex < 0 then
    raise eiGenericException.Create('Attachment non found.');
  result := Self.GetItems(LIndex);
end;

function TeiAttachments.IndexOf(const AName: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to FInvoice.FatturaElettronicaBody[0].Allegati.Count - 1 do
    if SameText(FInvoice.FatturaElettronicaBody[0].Allegati[i].NomeAttachment, AName) then
      Exit(i);
end;

{ TeiAttachment }

constructor TeiAttachment.Create(const AXMLAttachment: IXMLAllegatiType; const ANomeAttachment, AFormatoAttachment, AAlgoritmoCompressione, ADescrizioneAttachment: string);
begin
  FXMLAttachment := AXMLAttachment;
  if Trim(ANomeAttachment) <> '' then
    FXMLAttachment.NomeAttachment := ANomeAttachment;
  if Trim(AAlgoritmoCompressione) <> '' then
    FXMLAttachment.AlgoritmoCompressione := Trim(AAlgoritmoCompressione);
  if Trim(AFormatoAttachment) <> '' then
    FXMLAttachment.FormatoAttachment := Trim(AFormatoAttachment);
  if Trim(ADescrizioneAttachment) <> '' then
    FXMLAttachment.DescrizioneAttachment := Trim(ADescrizioneAttachment);
end;

function TeiAttachment.GetAlgoritmoCompressione: string;
begin
  if FXMLAttachment.ChildNodes.IndexOf('AlgoritmoCompressione') >= 0 then
    result := FXMLAttachment.AlgoritmoCompressione
  else
    result := '';
end;

function TeiAttachment.GetDescrizioneAttachment: string;
begin
  if FXMLAttachment.ChildNodes.IndexOf('DescrizioneAttachment') >= 0 then
    result := FXMLAttachment.DescrizioneAttachment
  else
    result := '';
end;

function TeiAttachment.GetFormatoAttachment: string;
begin
  if FXMLAttachment.ChildNodes.IndexOf('FormatoAttachment') >= 0 then
    result := FXMLAttachment.FormatoAttachment
  else
    result := '';
end;

function TeiAttachment.GetNomeAttachment: string;
begin
  result := FXMLAttachment.NomeAttachment;
end;

procedure TeiAttachment.LoadFromFile(const AFileName: string);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    Self.LoadFromStream(LFileStream);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiAttachment.LoadFromStream(const AStream: TStream);
var
  LStringStream: TStringStream;
begin
  LStringStream := TStringStream.Create;
  try
    TNetEncoding.Base64.Encode(AStream, LStringStream);
    FXMLAttachment.Attachment := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

procedure TeiAttachment.SaveToFile(const APath: string);
var
  LFileName: string;
  LFormato: string;
  LIndex: integer;
begin
  LFileName := FXMLAttachment.NomeAttachment;
  // aggiunta dell'estensione in caso non fosse già presente
  if ExtractFileExt(LFileName) = '' then
  begin
    LIndex := FXMLAttachment.ChildNodes.IndexOf('FormatoAttachment');
    if LIndex >= 0 then
    begin
      LFormato := Trim(FXMLAttachment.FormatoAttachment);
      LFormato := StringReplace(LFormato, '.', '', [rfReplaceAll]);
      LFileName := LFileName + '.' + LFormato;
    end;
  end;
  LFileName := IncludeTrailingPathDelimiter(APath) + LFileName;
  Self.SaveToFileAs(LFileName);
end;

procedure TeiAttachment.SaveToFileAs(const AFileName: string);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    Self.SaveToStream(LFileStream);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiAttachment.SaveToStream(const AStream: TStream);
var
  LBytesStream: TBytesStream;
begin
  LBytesStream := TBytesStream.Create(TNetEncoding.Base64.DecodeStringToBytes(FXMLAttachment.Attachment));
  try
    AStream.CopyFrom(LBytesStream, 0);
  finally
    LBytesStream.Free;
  end;
end;

end.
