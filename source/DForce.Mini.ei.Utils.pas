unit DForce.Mini.ei.Utils;

interface

uses
  System.Classes;

type

  TeiUtilsMini = class
  public
    class procedure StringToStream(const ADestStream: TStream; const ASourceString: String);
    class function StreamToString(const ASourceStream: TStream): string;
  end;

implementation

uses
  DForce.ei.Exception;

{ TeiUtilsMini }

class function TeiUtilsMini.StreamToString(const ASourceStream: TStream): string;
var
  LStringStream: TStringStream;
begin
  LStringStream := TStringStream.Create;
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
begin
  // Check the stream
  if not Assigned(ADestStream) then
    raise eiGenericException.Create('"AStream" parameter not assigned');
  // Save invoice into the stream
  LStringStream := TStringStream.Create(ASourceString);
  try
    ADestStream.CopyFrom(LStringStream, 0);
  finally
    LStringStream.Free;
  end;
end;

end.
