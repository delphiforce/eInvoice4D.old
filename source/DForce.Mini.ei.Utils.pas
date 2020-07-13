unit DForce.Mini.ei.Utils;

interface

uses
  System.Classes, DForce.Mini.ei.Invoice.Interfaces;

type

  TeiUtilsMini = class
  public
    class procedure StringToStream(const ADestStream: TStream; const ASourceString: String);
    class function StreamToString(const ASourceStream: TStream): string;
    class function ExtractRootTagName(XMLText:string): string;
  end;

implementation

uses
  DForce.ei.Exception, System.SysUtils, DForce.ei.Encoding;

{ TeiUtilsMini }

class function TeiUtilsMini.ExtractRootTagName(XMLText: string): string;
var
  LEndXmlVersionPos: integer;
  LStartRootTagPos, LDoublePointPos, LEndRootTagPos, LFirstSpacePos: integer;
begin
  LEndXmlVersionPos := Pos('?>', XMLText);
  // Remove the XML version line
  if LEndXmlVersionPos > 0 then
    XMLText := Copy(XMLText, LEndXmlVersionPos+2, Length(XMLText));
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
  if (LFirstSpacePos <> 0) and (LFirstSpacePos < LEndRootTagPos) and (LFirstSpacePos > LStartRootTagPos) then
    LEndRootTagPos := LFirstSpacePos;
  // Detect the ":" between the NameSpace and the root tag (if exists)
  LDoublePointPos := Pos(':', XMLText);
  if (LDoublePointPos <> 0) and (LDoublePointPos < LEndRootTagPos) then
    LStartRootTagPos := LDoublePointPos;
  // Extract the root tag name
  Result := Copy(XMLText, LStartRootTagPos+1, (LEndRootTagPos - LStartRootTagPos -1));
end;

class function TeiUtilsMini.StreamToString(const ASourceStream: TStream): string;
var
  LStringStream: TStringStream;
  LEncoding: TEncoding;
begin
  LEncoding := TeiUTFEncodingWithoutBOM.Create;
  LStringStream := TStringStream.Create('', LEncoding);
  try
    LStringStream.CopyFrom(ASourceStream, 0);
    Result := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

class procedure TeiUtilsMini.StringToStream(const ADestStream: TStream; const ASourceString: String);
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

end.
