unit DForce.ei.Core.Prop;

interface

uses
  DForce.ei.Core.Interfaces, DForce.ei.Core.Prop.Base, System.Classes;

type

  TeiProperty<T> = class(TeiProperty, IeiProperty<T>)
  strict private
    FValue: T;
  public
    // Begin: Leave this methods public to ensure RTTI informations on them
    function _GetValue: T;
    procedure _SetValue(const AValue: T);
    property Value: T read _GetValue write _SetValue;
    // End: Leave this methods public to ensure RTTI informations on them
  end;

  TeiDateProperty = class(TeiProperty<TDate>, IeiDate)
  end;

  TeiDecimalProperty = class(TeiProperty<double>, IeiDecimal)
  end;

  TeiIntegerProperty = class(TeiProperty<integer>, IeiInteger)
  end;

  TeiStringProperty = class(TeiProperty<string>, IeiString)
  end;

  TeiBase64Property = class(TeiProperty<string>, IeiBase64)
  public
    // Begin: Leave this methods public to ensure RTTI informations on them
    procedure LoadFromStream(const AStream: TStream);
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToFile(const AFileName: string);
    // End: Leave this methods public to ensure RTTI informations on them
  end;

implementation

uses
  System.NetEncoding, System.SysUtils;

{ TeiProperty<T> }

function TeiProperty<T>._GetValue: T;
begin
  if _PropIsNull then
    _RaiseException('Cannot read a NULL property.');
  Result := FValue;
end;

procedure TeiProperty<T>._SetValue(const AValue: T);
begin
  FValue := AValue;
  _SetProcIsNull(False);
end;

{ TeiPropertyBase64 }

procedure TeiBase64Property.LoadFromFile(const AFileName: string);
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

procedure TeiBase64Property.LoadFromStream(const AStream: TStream);
var
  LStringStream: TStringStream;
begin
  LStringStream := TStringStream.Create;
  try
    TNetEncoding.Base64.Encode(AStream, LStringStream);
    Value := LStringStream.DataString;
  finally
    LStringStream.Free;
  end;
end;

procedure TeiBase64Property.SaveToFile(const AFileName: string);
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

procedure TeiBase64Property.SaveToStream(const AStream: TStream);
var
  LBytesStream: TBytesStream;
begin
  LBytesStream := TBytesStream.Create(TNetEncoding.Base64.DecodeStringToBytes(Value));
  try
    AStream.CopyFrom(LBytesStream, 0);
  finally
    LBytesStream.Free;
  end;
end;

end.
