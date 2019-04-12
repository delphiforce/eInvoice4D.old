unit DForce.eis.Crypto;

interface

type

  TeisCrypto = class
    class function EncryptStr(const S: WideString; Key: Word; const k1, k2: Word): String;
    class function DecryptStr(const S: String; Key: Word; const k1, k2: Word): String;
  end;

implementation

uses
  System.SysUtils;

class function TeisCrypto.EncryptStr(const S: WideString; Key: Word; const k1, k2: Word): String;
var
  i: Integer;
  RStr: RawByteString;
  RStrB: TBytes Absolute RStr;
begin
  Result := '';
  RStr := UTF8Encode(S);
  for i := 0 to Length(RStr) - 1 do
  begin
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (RStrB[i] + Key) * k1 + k2;
  end;
  for i := 0 to Length(RStr) - 1 do
  begin
    Result := Result + IntToHex(RStrB[i], 2);
  end;
end;

class function TeisCrypto.DecryptStr(const S: String; Key: Word; const k1, k2: Word): String;
var
  i, tmpKey: Integer;
  RStr: RawByteString;
  RStrB: TBytes Absolute RStr;
  tmpStr: string;
begin
  tmpStr := UpperCase(S);
  SetLength(RStr, Length(tmpStr) div 2);
  i := 1;
  try
    while (i < Length(tmpStr)) do
    begin
      RStrB[i div 2] := StrToInt('$' + tmpStr[i] + tmpStr[i + 1]);
      Inc(i, 2);
    end;
  except
    Result := '';
    Exit;
  end;
  for i := 0 to Length(RStr) - 1 do
  begin
    tmpKey := RStrB[i];
    RStrB[i] := RStrB[i] xor (Key shr 8);
    Key := (tmpKey + Key) * k1 + k2;
  end;
  Result := UTF8ToString(RStr);
end;

end.
