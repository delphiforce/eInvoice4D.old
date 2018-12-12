unit DForce.ei.Notification.Factory;

interface

uses DForce.ei.Notification.Interfaces, DForce.ei.Notification.NS.Ex,
  DForce.ei.Notification.NE.Ex, System.Classes;

type
  TeiNotificationFactory = class
  private
    class function Epurate(const AStringXML: String): string;
  public
    // NS notification
    class function NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSEx;
    class function NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNSEx;
    class function NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSEx;
    class function NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSEx;
    class function NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNSEx;
    // NE notification
    class function NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEEx;
    class function NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNEEx;
    class function NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEEx;
    class function NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEEx;
    class function NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNEEx;
  end;

const
  TargetNamespace = '';

implementation

uses System.SysUtils, Xml.XMLDoc, System.NetEncoding, DForce.ei.Utils;

{ TeiNotificationFactory }

class function TeiNotificationFactory.Epurate(const AStringXML: String): string;
begin
  result := StringReplace(AStringXML, 'types:', '', [rfReplaceAll, rfIgnoreCase]);
end;

class function TeiNotificationFactory.NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSEx;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNSFromString(TeiUtils.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationFactory.NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromStreamBase64(const AStream: TStream): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSEx;
var
  LNotificationCommon: IeiNotificationCommon;
begin
  result := LoadXMLData(Epurate(AStringXML)).GetDocBinding('NotificaScarto', TeiNotificationNSEx, TargetNamespace) as IeiNotificationNSEx;
  if Supports(result, IeiNotificationCommon, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationFactory.NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEEx;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNEFromString(TeiUtils.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationFactory.NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNEFromStreamBase64(const AStream: TStream): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TeiUtils.StreamToString(AStream));
end;

class function TeiNotificationFactory.NewNotificationNSFromStringBase64(const ABase64StringXML: String): IeiNotificationNSEx;
begin
  Result := NewNotificationNSFromString(TNetEncoding.Base64.Decode(ABase64StringXML));
end;

class function TeiNotificationFactory.NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEEx;
var
  LNotificationCommon: IeiNotificationCommon;
begin
  result := LoadXMLData(Epurate(AStringXML)).GetDocBinding('NotificaEsito', TeiNotificationNEEx, TargetNamespace) as IeiNotificationNEEx;
  if Supports(result, IeiNotificationCommon, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationFactory.NewNotificationNEFromStringBase64(const ABase64StringXML: String): IeiNotificationNEEx;
begin
  Result := NewNotificationNEFromString(TNetEncoding.Base64.Decode(ABase64StringXML));
end;

end.
