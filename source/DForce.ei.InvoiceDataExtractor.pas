unit DForce.ei.InvoiceDataExtractor;

interface

uses
  DForce.ei.Invoice.Base, Xml.XMLIntf, System.SysUtils,
  DForce.ei.InvoiceDataExtractor.Interfaces;

type

  TeiXMLInvoiceDataExtractor = class(TInterfacedObject, IeiXMLInvoiceDataExtractor)
  private
    FInvoice: IXMLFatturaElettronicaType;
    FParentNode: IXMLNode;
    FFormatSettings: TFormatSettings;
    function GetFormatSettings: TFormatSettings;
    function GetParentNode: IXMLNode;
    procedure SetParentNode(const Value: IXMLNode);
  public
    constructor Create(const AInvoice: IXMLFatturaElettronicaType);
    // Base methods
    function NodeExists(const ANodeName: string): boolean;
    function NodeValue(const ANodeName: string; const ARequired: boolean = false): string;
    function NodeValueAsString(const ANodeName: string; Const AMaxLength: integer = 9999; const ARequired: boolean = false): string;
    function NodeValueAsInteger(const ANodeName: string; const ARequired: boolean = false): integer;
    function NodeValueAsFloat(const ANodeName: string; const ARequired: boolean = false): Extended;
    function NodeValueAsDateTime(const ANodeName: string; const ARequired: boolean = false): TDateTime;
    // Advanced extractors
    procedure ExtractInvoiceNumberAndRegister(out AInvoiceNumber: integer; out AInvoiceRegister: string);
    function ExtractSupplierName: string;
    // Properties
    property ParentNode: IXMLNode read GetParentNode write SetParentNode;
    property FormatSettings: TFormatSettings read GetFormatSettings;
  end;

implementation

uses
  System.StrUtils, System.Character;

{ TeiInvoiceDataExtractor }

constructor TeiXMLInvoiceDataExtractor.Create(const AInvoice: IXMLFatturaElettronicaType);
begin
  FInvoice := AInvoice;
end;

function TeiXMLInvoiceDataExtractor.ExtractSupplierName: string;
var
  LDenominazione: string;
begin
  ParentNode := FInvoice.FatturaElettronicaHeader.CedentePrestatore.DatiAnagrafici.Anagrafica;
  LDenominazione := NodeValueAsString('Denominazione', 60);
  if Ldenominazione <> '' then
    Result := LDenominazione
  else
    Result := Trim(NodeValueAsString('Cognome', 60) + ' ' + NodeValueAsString('Nome', 60));
  Result := LeftStr(Result, 60);
end;

procedure TeiXMLInvoiceDataExtractor.ExtractInvoiceNumberAndRegister(out AInvoiceNumber: integer; out AInvoiceRegister: string);
var
  LNumDocFE: string;
  I, LStep, LStartIndex, LStopIndex: integer;
  LEstraendoNumDoc: Boolean;
  LChar: Char;
  LNumStr: string;
begin
  LNumStr := '';
  AInvoiceRegister := '';
  // Estrae il numero fattura dall'XML
  ParentNode := FInvoice.FatturaElettronicaBody.Items[0].DatiGenerali.DatiGeneraliDocumento;
  LNumDocFE := NodeValue('Numero', True);
  if LNumDocFE = '' then
    raise Exception.Create('Numero documento non valido');
  // Se comincia con una cifra (a sx) allora si suppone che l'eventuale registro sia a dx altrimenti a sx
  if LNumDocFE[1].IsDigit then
  begin
    LStartIndex := 1;
    LStopIndex := Length(LNumDocFE) + 1;
    LStep := 1;
  end
  else
  begin
    LStartIndex := Length(LNumDocFE);
    LStopIndex := 0;
    LStep := -1;
  end;
  // Loop
  LEstraendoNumDoc := True;
  I := LStartIndex;
  while I <> LStopIndex do
  begin
    LChar := LNumDocFE[I];
    LEstraendoNumDoc := LEstraendoNumDoc and LChar.IsDigit;
    if LEstraendoNumDoc then
      LNumStr := LNumStr + LChar
    else
      AInvoiceRegister := AInvoiceRegister + LChar;
    Inc(I, LStep);
  end;
  if LStopIndex = 0 then
  begin
    LNumStr := ReverseString(LNumStr);
    AInvoiceRegister := ReverseString(AInvoiceRegister);
  end;
  if Length(LNumStr) > 9 then
    LNumStr := RightStr(LNumStr, 9);
  AInvoiceRegister := RightStr(AInvoiceRegister, 5);
  AInvoiceNumber := StrToInt(LNumStr);
end;

function TeiXMLInvoiceDataExtractor.GetFormatSettings: TFormatSettings;
begin
  FFormatSettings.Create;
  // Float
  FFormatSettings.DecimalSeparator := '.';
  FFormatSettings.ThousandSeparator := ',';
  // DateTime
  FFormatSettings.DateSeparator := '-';
  FFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
  // Return the result
  Result := FFormatSettings;
end;

function TeiXMLInvoiceDataExtractor.GetParentNode: IXMLNode;
begin
  Result := FParentNode;
end;

function TeiXMLInvoiceDataExtractor.NodeValue(const ANodeName: string; const ARequired: boolean): string;
begin
  Result := '';
  if NodeExists(ANodeName) then
//    Result := Trim(ParentNode.ChildNodes[ANodeName].NodeValue) //NB: Questa riga dava un errore di conversione OLEVAriant toString se il valore era una stringa vuota
    Result := Trim(ParentNode.ChildNodes[ANodeName].Text)
  else
  if ARequired then
    raise Exception.Create('Informazione mancante:'#13#13'Sezione: "' +
      ParentNode.NodeName + '"'#13'Campo: "' + ANodeName + '"');
end;

function TeiXMLInvoiceDataExtractor.NodeValueAsDateTime(const ANodeName: string; const ARequired: boolean): TDateTime;
begin
  Result := StrToDateTime(  NodeValue(ANodeName, ARequired), GetFormatSettings  );
end;

function TeiXMLInvoiceDataExtractor.NodeValueAsFloat(const ANodeName: string; const ARequired: boolean): Extended;
var
  LStrValue: String;
begin
  LStrValue := NodeValue(ANodeName, ARequired);
  if LStrValue <> '' then
    Result := StrToFloat(LStrValue, GetFormatSettings)
  else
    Result := 0;
end;

function TeiXMLInvoiceDataExtractor.NodeValueAsInteger(const ANodeName: string; const ARequired: boolean): integer;
var
  LStrValue: String;
begin
  LStrValue := NodeValue(ANodeName, ARequired);
  if LStrValue <> '' then
    Result := StrToInt(LStrValue)
  else
    Result := 0;
end;

function TeiXMLInvoiceDataExtractor.NodeValueAsString(const ANodeName: string; const AMaxLength: integer;
  const ARequired: boolean): string;
begin
  Result := NodeValue(ANodeName, ARequired);
  Result := LeftStr(Result, AMaxLength);
end;

procedure TeiXMLInvoiceDataExtractor.SetParentNode(const Value: IXMLNode);
begin
  FParentNode := Value;
end;

function TeiXMLInvoiceDataExtractor.NodeExists(const ANodeName: string): boolean;
begin
  Result := (ParentNode.ChildNodes.IndexOf(ANodeName) > -1);
end;

end.
