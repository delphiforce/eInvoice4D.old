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
unit DForce.ei.Utils;

interface

uses DForce.ei.Response.Interfaces, System.Classes,
  DForce.ei.Invoice.Interfaces;

type
  TeiRoundMode = (rmRaise, rmRound, rmTrunc);

  TeiConfig = class
  class var
    FRoundMode: TeiRoundMode;
  end;

  TeiUtils = class
  public
    class function DateToString(const Value: TDateTime): string;
    class function DateTimeToString(const Value: TDateTime): string;
    class function DateTimeToUrlParam(const Value: TDateTime): string;
    class function NumberToString(const Value: extended; const Decimals: integer = 2): string;
    class function DateTimeLocalFromIso8601(const Value: string): TDateTime;
    class function DateTimeUTCFromIso8601(const Value: string): TDateTime;
    class function ResponseTypeToEnum(const AResponseType: string; const ANotificationXML: String = ''): TeiResponseTypeInt;
    class function ResponseTypeForHumans(const AResponseType: TeiResponseTypeInt): string;
    class function ResponseTypeToString(const AResponseType: TeiResponseTypeInt): string;
    class function StringToResponseType(const AResponseType: String): TeiResponseTypeInt;
    class procedure FillInvoiceSample(const AInvoice: IeiInvoiceEx);
    class procedure CopyObjectState(const ASource, ADestination: TObject); overload;
    class procedure CopyObjectState(const ASource, ADestination: IInterface); overload;
    class procedure StringToStream(const ADestStream: TStream; const ASourceString: String);
    class function StreamToString(const ASourceStream: TStream): string;
    class function ExtractInvoiceIDFromNotification(const ANotificationXML: string): string; deprecated; // Deprecated??? // To test???
    class function ExtractRootTagName(XMLText: string): string;
  end;

implementation

uses System.SysUtils,
  System.Math,
  DForce.ei.Exception,
  IdGlobalProtocols,
  XSBuiltIns, DForce.ei.Invoice.Base, System.DateUtils, System.TypInfo, System.Rtti,
  DForce.ei.Notification.Interfaces, DForce.ei.Notification.Factory,
  DForce.ei.Encoding,
  System.NetEncoding;

{ TeiUtils }

class procedure TeiUtils.StringToStream(const ADestStream: TStream; const ASourceString: String);
var
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  // Check the stream
  if not Assigned(ADestStream) then
    raise eiGenericException.Create('"AStream" parameter not assigned');
  // Save invoice into the stream
  LEncoding := TeiUTFEncodingWithoutBOM.Create;
  LStringStream := TStringStream.Create(ASourceString, LEncoding);
  try
    ADestStream.CopyFrom(LStringStream, 0);
  finally
    LStringStream.Free;
  end;
end;

class function TeiUtils.DateToString(const Value: TDateTime): string;
var
  _fs: TFormatSettings;
begin
  // ho utilizzato la versione con il FormatSettings perchè quella senza non è ThreadSafe
  _fs := TFormatSettings.Create;
  // https://it.wikipedia.org/wiki/ISO_8601#Data_completa
  // YYYY-MM-DD
  result := FormatDateTime('yyyy-mm-dd', Value, _fs);
end;

class function TeiUtils.ExtractInvoiceIDFromNotification(const ANotificationXML: string): string;
var
  LStartPos, LEndPos, LCount: integer;
begin
  LCount := 0;
  // get the start pos
  LStartPos := Pos('<NomeFile>', ANotificationXML);
  if LStartPos > 0 then
    LStartPos := LStartPos + Length('<NomeFile>')
  else
    eiGenericException.Create('TeiUtils.ExtractInvoiceIDFromNotification: Tag "<NomeFile>" not found');
  // get the end pos
  LEndPos := Pos('/<NomeFile>', ANotificationXML);
  if LEndPos = 0 then
    LCount := LEndPos - LStartPos
  else
    eiGenericException.Create('TeiUtils.ExtractInvoiceIDFromNotification: Tag "/<NomeFile>" not found');
  // Return the FileName
  result := Copy(ANotificationXML, LStartPos, LCount);
end;

class function TeiUtils.ExtractRootTagName(XMLText: string): string;
var
  LEndXmlVersionPos: integer;
  LStartRootTagPos, LDoublePointPos, LEndRootTagPos, LFirstSpacePos: integer;
begin
  LEndXmlVersionPos := Pos('?>', XMLText);
  // Remove the XML version line
  if LEndXmlVersionPos > 0 then
    XMLText := Copy(XMLText, LEndXmlVersionPos + 2, Length(XMLText));
  // Detect the "<" for the root  tag
  LStartRootTagPos := Pos('<', XMLText);
  if LStartRootTagPos = 0 then
    raise eiGenericException.Create('StartRootTagPos not found');
  // Detect the ">" for the root  tag
  LEndRootTagPos := Pos('>', XMLText);
  if LEndRootTagPos = 0 then
    raise eiGenericException.Create('EndRootTagPos not found');
  // Detect the first space char after the root name
  LFirstSpacePos := Pos(' ', XMLText);
  if (LFirstSpacePos <> 0) and (LFirstSpacePos < LEndRootTagPos) then
    LEndRootTagPos := LFirstSpacePos;
  // Detect the ":" between the NameSpace and the root tag (if exists)
  LDoublePointPos := Pos(':', XMLText);
  if (LDoublePointPos <> 0) and (LDoublePointPos < LEndRootTagPos) then
    LStartRootTagPos := LDoublePointPos;
  // Extract the root tag name
  result := Copy(XMLText, LStartRootTagPos + 1, (LEndRootTagPos - LStartRootTagPos - 1));
end;

class function TeiUtils.ResponseTypeForHumans(const AResponseType: TeiResponseTypeInt): string;
begin
  case AResponseType of
    rtSDIMessageRC:
      result := 'Ricevuta di consegna';
    rtSDIMessageNS:
      result := 'Notifica di scarto';
    rtSDIMessageMC:
      result := 'Notifica di mancata consegna';
    rtSDIMessageNEAccepted:
      result := 'Notifica esito fattura accettata';
    rtSDIMessageNERejected:
      result := 'Notifica esito fattura rifiutata';
    rtSDIMessageMT:
      result := 'Notifica di metadati del file fattura';
    rtSDIMessageEC:
      result := 'Notifica di esito cessionario/committente';
    rtSDIMessageSE:
      result := 'Notifica di scarto esito cessionario/committente';
    rtSDIMessageDT:
      result := 'Notifica decorrenza termini';
    rtSDIMessageAT:
      result := 'Attestazione di avvenuta trasmissione della fattura con impossibilità di recapito';
  else
    result := 'Tipo sconosciuto';
  end;
end;

class function TeiUtils.ResponseTypeToEnum(const AResponseType: string; const ANotificationXML: String): TeiResponseTypeInt;
var
  LNotificationNE: IeiNotificationNEEx;
begin
  if AResponseType = 'RC' then
    result := rtSDIMessageRC
  else if AResponseType = 'NS' then
    result := rtSDIMessageNS
  else if AResponseType = 'MC' then
    result := rtSDIMessageMC
  else if AResponseType = 'MT' then
    result := rtSDIMessageMT
  else if AResponseType = 'EC' then
    result := rtSDIMessageEC
  else if AResponseType = 'SE' then
    result := rtSDIMessageSE
  else if AResponseType = 'DT' then
    result := rtSDIMessageDT
  else if AResponseType = 'AT' then
    result := rtSDIMessageAT
  else if AResponseType = 'NE' then
  begin
    LNotificationNE := TeiNotificationFactory.NewNotificationNEFromString(ANotificationXML);
    if LNotificationNE.InvoiceAccepted then
      result := rtSDIMessageNEAccepted
    else
      result := rtSDIMessageNERejected
  end
  else
    result := rtUnknown;
end;

class function TeiUtils.ResponseTypeToString(const AResponseType: TeiResponseTypeInt): string;
begin
  result := GetEnumName(TypeInfo(TeiResponseTypeInt), Ord(AResponseType));
end;

class function TeiUtils.StreamToString(const ASourceStream: TStream): string;
var
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  LEncoding := TeiUTFEncodingWithoutBOM.Create;
  LStringStream := TStringStream.Create('', LEncoding);
  try
    LStringStream.CopyFrom(ASourceStream, 0);
    result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

class function TeiUtils.StringToResponseType(const AResponseType: String): TeiResponseTypeInt;
begin
  result := TeiResponseTypeInt(GetEnumValue(TypeInfo(TeiResponseTypeInt), AResponseType));
end;

class procedure TeiUtils.FillInvoiceSample(const AInvoice: IeiInvoiceEx);
var
  LXMLFatturaElettronicaBody: IXMLFatturaElettronicaBodyType;
  LXMLDatiDocumentiCorrelatiOrdineAcquisto: IXMLDatiDocumentiCorrelatiType;
  LXMLDatiDocumentiCorrelatiDatiContratto: IXMLDatiDocumentiCorrelatiType;
  LXMLDatiDocumentiCorrelatiDatiConvenzione: IXMLDatiDocumentiCorrelatiType;
  LXMLDatiDocumentiCorrelatiDatiRicezione: IXMLDatiDocumentiCorrelatiType;
  LXMLDettaglioLinee: IXMLDettaglioLineeType;
  LXMLDatiRiepilogo: IXMLDatiRiepilogoType;
  LXMLDatiPagamento: IXMLDatiPagamentoType;
  LXMLDettaglioPagamento: IXMLDettaglioPagamentoType;
begin
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdPaese := 'IT';
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdCodice := '01234567890';
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.ProgressivoInvio := '00001';
  // FXMLFatturaElettronica.FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione := 'FPA12';
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.FormatoTrasmissione := 'FPR12';

  // FXMLFatturaElettronica.FatturaElettronicaHeader.DatiTrasmissione.CodiceDestinatario := 'AAAAAA';
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.CodiceDestinatario := '0000000';
  // AGGIUNTO V 1.2 - INIZIO
  AInvoice.FatturaElettronicaHeader.DatiTrasmissione.PECDestinatario := 'betagamma@pec.it';
  // AGGIUNTO V 1.2 - FINE

  AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdPaese := 'IT';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.IdFiscaleIVA.IdCodice := '01234567890';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica.Denominazione := 'ALPHA SRL';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.RegimeFiscale := 'RF19';

  AInvoice.FatturaElettronicaHeader.CedentePrestatore.Sede.Indirizzo := 'VIALE ROMA 543';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.Sede.CAP := '07100';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.Sede.Comune := 'SASSARI';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.Sede.Provincia := 'SS';
  AInvoice.FatturaElettronicaHeader.CedentePrestatore.Sede.Nazione := 'IT';

  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.CodiceFiscale := '09876543210';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.DatiAnagrafici.Anagrafica.Denominazione := 'AMMINISTRAZIONE BETA';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.Sede.Indirizzo := 'VIA TORINO 38-B';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.Sede.CAP := '00145';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.Sede.Comune := 'ROMA';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.Sede.Provincia := 'RM';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.Sede.Nazione := 'IT';
  // AGGIUNTO V 1.2 - INIZIO
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.Indirizzo := 'VIA CASELLE';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.NumeroCivico := '4/D';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.CAP := '25027';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.Comune := 'QUINZANO D''OGLIO';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.Provincia := 'BS';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.StabileOrganizzazione.Nazione := 'IT';
  // AGGIUNTO V 1.2 - FINE
  // AGGIUNTO V 1.2 - INIZIO
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.RappresentanteFiscale.IdFiscaleIVA.IdPaese := 'DE';
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.RappresentanteFiscale.IdFiscaleIVA.IdCodice := 'DE12345';
  // in alternativa: DENOMINAZIONE o NOME E COGNOME
  AInvoice.FatturaElettronicaHeader.CessionarioCommittente.RappresentanteFiscale.Denominazione := 'RFCC - DENOMINAZIONE';
  // FXMLFatturaElettronica.FatturaElettronicaHeader.CessionarioCommittente.RappresentanteFiscale.Nome := 'RFCC - NOME';
  // FXMLFatturaElettronica.FatturaElettronicaHeader.CessionarioCommittente.RappresentanteFiscale.Cognome := 'RFCC - COGNOME';
  // AGGIUNTO V 1.2 - FINE

  // riga di body
  LXMLFatturaElettronicaBody := AInvoice.FatturaElettronicaBody.Add;
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.TipoDocumento := 'TD01';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.Divisa := 'EUR';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.Data := TeiUtils.DateToString(now);
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.Numero := '123';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.Causale.Add
    ('LA FATTURA FA RIFERIMENTO AD UNA OPERAZIONE AAAA BBBBBBBBBBBBBBBBBB CCC DDDDDDDDDDDDDDD E FFFFFFFFFFFFFFFFFFFF GGGGGGGGGG HHHHHHH II LLLLLLLLLLLLLLLLL MMM NNNNN OO PPPPPPPPPPP QQQQ RRRR SSSSSSSSSSSSSS');
  LXMLFatturaElettronicaBody.DatiGenerali.DatiGeneraliDocumento.Causale.Add
    ('SEGUE DESCRIZIONE CAUSALE NEL CASO IN CUI NON SIANO STATI SUFFICIENTI 200 CARATTERI AAAAAAAAAAA BBBBBBBBBBBBBBBBB');

  // LXMLFatturaElettronicaBody.DatiGenerali.DatiOrdineAcquisto
  LXMLDatiDocumentiCorrelatiOrdineAcquisto := LXMLFatturaElettronicaBody.DatiGenerali.DatiOrdineAcquisto.Add;
  LXMLDatiDocumentiCorrelatiOrdineAcquisto.RiferimentoNumeroLinea.Add(1);;
  LXMLDatiDocumentiCorrelatiOrdineAcquisto.IdDocumento := '66685';
  LXMLDatiDocumentiCorrelatiOrdineAcquisto.NumItem := '1';
  LXMLDatiDocumentiCorrelatiOrdineAcquisto.CodiceCUP := '123abc';
  LXMLDatiDocumentiCorrelatiOrdineAcquisto.CodiceCIG := '456def';

  // LXMLFatturaElettronicaBody.DatiGenerali.DatiContratto

  LXMLDatiDocumentiCorrelatiDatiContratto := LXMLFatturaElettronicaBody.DatiGenerali.DatiContratto.Add;
  LXMLDatiDocumentiCorrelatiDatiContratto.RiferimentoNumeroLinea.Add(1);
  LXMLDatiDocumentiCorrelatiDatiContratto.IdDocumento := '123';
  LXMLDatiDocumentiCorrelatiDatiContratto.Data := TeiUtils.DateToString(StartOfTheYear(now));
  LXMLDatiDocumentiCorrelatiDatiContratto.NumItem := '5';
  LXMLDatiDocumentiCorrelatiDatiContratto.CodiceCUP := '123abc';
  LXMLDatiDocumentiCorrelatiDatiContratto.CodiceCIG := '456def';

  // LXMLDatiDocumentiCorrelatiDatiConvenzione

  LXMLDatiDocumentiCorrelatiDatiConvenzione := LXMLFatturaElettronicaBody.DatiGenerali.DatiConvenzione.Add;

  LXMLDatiDocumentiCorrelatiDatiConvenzione.RiferimentoNumeroLinea.Add(1);
  LXMLDatiDocumentiCorrelatiDatiConvenzione.IdDocumento := '456';
  // LXMLDatiDocumentiCorrelatiDatiConvenzione.Data:='2016-09-01';
  LXMLDatiDocumentiCorrelatiDatiConvenzione.NumItem := '5';
  LXMLDatiDocumentiCorrelatiDatiConvenzione.CodiceCUP := '123abc';
  LXMLDatiDocumentiCorrelatiDatiConvenzione.CodiceCIG := '456def';

  LXMLDatiDocumentiCorrelatiDatiRicezione := LXMLFatturaElettronicaBody.DatiGenerali.DatiRicezione.Add;
  // LXMLDatiDocumentiCorrelatiDatiRicezione
  LXMLDatiDocumentiCorrelatiDatiRicezione.RiferimentoNumeroLinea.Add(1);
  LXMLDatiDocumentiCorrelatiDatiRicezione.IdDocumento := '789';
  // LXMLDatiDocumentiCorrelatiDatiConvenzione.Data:='2016-09-01';
  LXMLDatiDocumentiCorrelatiDatiRicezione.NumItem := '5';
  LXMLDatiDocumentiCorrelatiDatiRicezione.CodiceCUP := '123abc';
  LXMLDatiDocumentiCorrelatiDatiRicezione.CodiceCIG := '456def';

  LXMLFatturaElettronicaBody.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdPaese := 'IT';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.IdFiscaleIVA.IdCodice := '24681012141';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiTrasporto.DatiAnagraficiVettore.Anagrafica.Denominazione := 'Trasporto spa';
  LXMLFatturaElettronicaBody.DatiGenerali.DatiTrasporto.DataOraConsegna := TeiUtils.DateTimeToString(now - 2);

  LXMLDettaglioLinee := LXMLFatturaElettronicaBody.DatiBeniServizi.DettaglioLinee.Add;
  LXMLDettaglioLinee.NumeroLinea := 1;
  LXMLDettaglioLinee.Descrizione := 'DESCRIZIONE DELLA FORNITURA';
  LXMLDettaglioLinee.Quantita := TeiUtils.NumberToString(5.005, 3);
  LXMLDettaglioLinee.PrezzoUnitario := TeiUtils.NumberToString(1);
  LXMLDettaglioLinee.PrezzoTotale := TeiUtils.NumberToString(5);
  LXMLDettaglioLinee.AliquotaIVA := TeiUtils.NumberToString(22);
  // LXMLDettaglioLinee.AliquotaIVA := '0';

  LXMLDatiRiepilogo := LXMLFatturaElettronicaBody.DatiBeniServizi.DatiRiepilogo.Add;
  LXMLDatiRiepilogo.AliquotaIVA := '22.00';
  LXMLDatiRiepilogo.ImponibileImporto := '5.00';
  LXMLDatiRiepilogo.Imposta := '1.10';
  LXMLDatiRiepilogo.EsigibilitaIVA := 'I';

  LXMLDatiPagamento := LXMLFatturaElettronicaBody.DatiPagamento.Add;
  LXMLDatiPagamento.CondizioniPagamento := 'TP01';
  LXMLDettaglioPagamento := LXMLDatiPagamento.DettaglioPagamento.Add;
  LXMLDettaglioPagamento.ModalitaPagamento := 'MP01';
  LXMLDettaglioPagamento.DataScadenzaPagamento := '2017-02-18';
  LXMLDettaglioPagamento.ImportoPagamento := '6.10';
end;

class function TeiUtils.DateTimeToString(const Value: TDateTime): string;
var
  _fs: TFormatSettings;
begin
  // ho utilizzato la versione con il FormatSettings perchè quella senza non è ThreadSafe
  _fs := TFormatSettings.Create;
  // https://it.wikipedia.org/wiki/ISO_8601#Data_completa
  // YYYY-MM-DDTHH:NN:SS
  // non è richiesta la localizzazione in quanto presupposto fuso orario italiano
  result := FormatDateTime('yyyy-mm-ddhh:nn:ss', Value, _fs);
  result := result.Insert(10, 'T');
end;

class function TeiUtils.DateTimeToUrlParam(const Value: TDateTime): string;
begin
  result := FormatDateTime('yyyy-mm-dd"T"hh%3Ann%3Ass', Value);
end;

class function TeiUtils.NumberToString(const Value: extended; const Decimals: integer = 2): string;
var
  _fs: TFormatSettings;
  LLocalValue: extended;
  LParteIntera, LParteDecimale: string;
begin
  // ho utilizzato la versione con il FormatSettings perchè quella senza non è ThreadSafe
  if not InRange(Decimals, 2, 8) then
    raise eiDecimalsException.Create('TeiUtils.NumberToString: il numero di decimali deve essere compreso tra 2 e 8.');

  LLocalValue := Value;
  case TeiConfig.FRoundMode of
    rmRaise:
      begin
        LParteDecimale := FloatToStr(Frac(LLocalValue));
        if (Length(FloatToStr(Frac(LLocalValue))) - 2) > Decimals then
          raise eiDecimalsException.Create
            ('TeiUtils.NumberToString: il numero di decimali specificati è diverso al numero di decimali del valore da convertire.');
        _fs := TFormatSettings.Create;
        _fs.DecimalSeparator := '.';
        result := FormatFloat('#0.' + StringOfChar('0', Decimals), LLocalValue, _fs);
      end;
    rmRound:
      begin
        SetRoundMode(rmUp);
        LLocalValue := SimpleRoundTo(LLocalValue, -Decimals);
        SetRoundMode(rmNearest);
        _fs := TFormatSettings.Create;
        _fs.DecimalSeparator := '.';
        result := FormatFloat('#0.' + StringOfChar('0', Decimals), LLocalValue, _fs);
      end;
    rmTrunc:
      begin
        LParteIntera := Trunc(LLocalValue).ToString;
        LParteDecimale := Frac(LLocalValue).ToString;
        result := LParteIntera + '.' + LParteDecimale.Substring(2, Decimals);
      end
  else
    raise eiDecimalsException.Create('TeiUtils.NumberToString: Metodo di arrotondamento in conversione non valido.');
  end;
end;

class procedure TeiUtils.CopyObjectState(const ASource, ADestination: TObject);
var
  LTyp: TRttiType;
  LProp: TRttiProperty;
begin
  if ASource.ClassType <> ADestination.ClassType then
    eiGenericException.Create('Source and destination objects must be of the same type.');
  LTyp := TRttiContext.Create.GetType(ASource.ClassInfo);
  for LProp in LTyp.GetProperties do
    if LProp.IsReadable and LProp.IsWritable then
      LProp.SetValue(ADestination, LProp.GetValue(ASource));
end;

class procedure TeiUtils.CopyObjectState(const ASource, ADestination: IInterface);
begin
  CopyObjectState(ASource as TObject, ADestination as TObject);
end;

class function TeiUtils.DateTimeLocalFromIso8601(const Value: string): TDateTime;
begin
  with TXSDateTime.Create() do
    try
      XSToNative(Value);
      result := AsDateTime;
    finally
      Free();
    end;
end;

class function TeiUtils.DateTimeUTCFromIso8601(const Value: string): TDateTime;
begin
  with TXSDateTime.Create() do
    try
      XSToNative(Value);
      result := AsDateTime + TimeZoneBias;
    finally
      Free();
    end;
end;

initialization

TeiConfig.FRoundMode := rmRaise;

end.
