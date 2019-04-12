unit DForce.ei.Encoding;

interface

uses
  System.SysUtils;

type

  TeiUTFEncodingWithoutBOM = class(TUTF8Encoding)
  public
    function GetPreamble: TBytes; override;
  end;

implementation

{ TeiUTFEncodingWithoutBOM }

function TeiUTFEncodingWithoutBOM.GetPreamble: TBytes;
begin
//  Result := TBytes.Create($EF, $BB, $BF);
  Result := TBytes.Create(); // WIthout BOM
end;

end.
