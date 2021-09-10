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
unit DForce.ei.Invoice.Ex;

interface

uses DForce.ei.Invoice.Base, DForce.ei.Invoice.Interfaces, System.Classes,
  DForce.ei.Response.Interfaces, DForce.ei.GenericCollection,
  DForce.ei.Validation.Interfaces, DForce.ei.Invoice.Attachments.Interfaces;

type

  TeiInvoiceEx = class(TXMLFatturaElettronicaType, IeiInvoiceEx)
  private
    FReference: string;
    FValidationResultCollection: IeiValidationResultCollectionInt;
  protected
    function BuildFileName: String;
    function ToString: String; reintroduce;
    function ToStringBase64: String;
    function Validate: boolean;
    function ValidationResultCollection: IeiValidationResultCollectionInt;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
    procedure FillWithSampleData;
    function IsPA: boolean;
    // Reference
    procedure SetReference(const AValue: string);
    function GetReference: string;
    // Attachment
    function Attachments: IeiAttachments;
  end;

  TeiInvoiceCollectionEx = TeiCollection<IeiInvoiceEx>;

  TeiInvoiceIDCollectionEx = TeiCollection<string>;

implementation

uses Xml.XMLDoc, System.NetEncoding, DForce.ei.Exception, System.SysUtils,
  DForce.ei, DForce.ei.Utils, DForce.ei.Validation.Engine, System.StrUtils,
  DForce.ei.Utils.Sanitizer, DForce.ei.Encoding, System.IOUtils,
  DForce.ei.Invoice.Attachments.Factory;

{ TeiInvoiceEx }

function TeiInvoiceEx.BuildFileName: String;
var
  LSiglaNazione: String;
  LIdFiscale: String;
  LProgressivoInvio: String;
begin
  LSiglaNazione := FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdPaese.Trim;
  LIdFiscale := FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdCodice.Trim;
  LProgressivoInvio := FatturaElettronicaHeader.DatiTrasmissione.ProgressivoInvio.Trim;
  // Effettua alcuni controlli
  if LSiglaNazione = '' then
    raise eiGenericException.Create('Property 1.2.1.1.1 <IdPaese> is not valid!');
  if LIdFiscale = '' then
    raise eiGenericException.Create('Property 1.2.1.1.2 <IdCodice> is not valid!');
  if (LProgressivoInvio = '') or (LProgressivoInvio = '-1') then
    raise eiGenericException.Create('Property 1.1.2 <ProgressivoInvio> is not valid!');
  // Compila il nome del file
  Result := Format('%s%s_%s.xml', [LSiglaNazione, LIdFiscale, LProgressivoInvio]);
end;

procedure TeiInvoiceEx.FillWithSampleData;
begin
  TeiUtils.FillInvoiceSample(Self);
end;

function TeiInvoiceEx.Attachments: IeiAttachments;
begin
  result := TeiAttachmentsFactory.NewAttachments(Self);
end;

function TeiInvoiceEx.GetReference: string;
begin
  result := FReference;
end;

function TeiInvoiceEx.IsPA: boolean;
begin
  result := (LeftStr(FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione, 3) = 'FPA');
end;

procedure TeiInvoiceEx.SaveToFile(const AFileName: String);
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    TeiUtils.StringToStream(LFileStream, ToString);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiInvoiceEx.SaveToStream(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToString);
end;

procedure TeiInvoiceEx.SaveToStreamBase64(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToStringBase64);
end;

procedure TeiInvoiceEx.SetReference(const AValue: string);
begin
  FReference := AValue;
end;

function TeiInvoiceEx.ToString: String;
var
  LxmlText: string;
  Lxml: TStringList;
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  // Extract the XML text and sanitize it
  TeiSanitizer.SanitizeInvoice(Self);
  LxmlText := Self.GetXML;
  TeiSanitizer.SanitizeXMLValues(LxmlText);

  Lxml := TStringList.Create;
  try
    Lxml.Text := FormatXMLData(LxmlText);

    // AGGIUNTO V 1.2 - INIZIO
//    Lxml[0] := '<?xml version="1.0" encoding="UTF-8"?>';
//    Lxml.Insert(1, '<p:FatturaElettronica versione="' + Self.FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione + '"');
//    Lxml.Insert(2, 'xmlns:ds="http://www.w3.org/2000/09/xmldsig#"');
//    Lxml.Insert(3, 'xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"');
//    Lxml.Insert(4, 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"');
//    Lxml.Insert(5,
//      'xsi:schemaLocation="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2 http://www.fatturapa.gov.it/export/fatturazione/sdi/fatturapa/v1.2/Schema_del_file_xml_FatturaPA_versione_1.2.xsd">');
    // Se abilitato aggiunge il riferimento al file XSL
    // if AggiungiXSL then
    // Lxml.Insert(1, '<?Lxml-stylesheet type="text/xsl" href="fatturapa_v1.2.xsl"?>');
    // Aggiunge "p:" alla fine nel Tag di chiusura
//    Lxml[Lxml.Count - 1] := '</p:FatturaElettronica>';
    // AGGIUNTO V 1.2 - FINE

    {* VER. 1.6.1
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
      xmlns="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
      targetNamespace="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2"
      version="1.2.1">

      <xs:import namespace="http://www.w3.org/2000/09/xmldsig#" schemaLocation="http://www.w3.org/TR/2002/REC-xmldsig-core-20020212/xmldsig-core-schema.xsd" />
    *}


    // ----- VER. 1.6.1
    // DOCTYPE tag
    Lxml[0] := '<?xml version="1.0" encoding="UTF-8"?>';
    // ROOT tag opening
    Lxml.Insert(1, Format('<p:FatturaElettronica versione="%s" xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2">', [Self.FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione]));
    // ROOT tag closing
    Lxml[Lxml.Count - 1] := '</p:FatturaElettronica>';
    // ----- VER. 1.6.1


    // Salva tutto (UTF8)
    LEncoding := TeiUTFEncodingWithoutBOM.Create;
    LStringStream := TStringStream.Create('', LEncoding);
    try
      Lxml.SaveToStream(LStringStream, LEncoding);
      result := LStringStream.DataString;
    finally
      LStringStream.Free;
    end;

  finally
    Lxml.Free;
  end;
end;

function TeiInvoiceEx.ToStringBase64: String;
begin
  result := TNetEncoding.Base64.Encode(ToString);
end;

function TeiInvoiceEx.Validate: boolean;
begin
  FValidationResultCollection := TeiValidationEngine.Validate(Self);
  result := (FValidationResultCollection.Count = 0);
end;

function TeiInvoiceEx.ValidationResultCollection: IeiValidationResultCollectionInt;
begin
  if not Assigned(FValidationResultCollection) then
    Validate;
  result := FValidationResultCollection;
end;

end.
