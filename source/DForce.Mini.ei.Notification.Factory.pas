unit DForce.Mini.ei.Notification.Factory;

interface

uses
  DForce.Mini.ei.Notification.Interfaces, System.Classes;

type
  TeiNotificationMiniFactory = class
  private
    class function Epurate(const AStringXML: String): string;
  public
    // NS notification
    class function NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSmini;
    class function NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSmini;
    class function NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSmini;
    // NE notification
    class function NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEmini;
    class function NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEmini;
    class function NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEmini;
  end;

const
  TargetNamespace = '';

implementation

uses
  Xml.XMLDoc, System.SysUtils, DForce.Mini.ei.Notification.NS,
  DForce.Mini.ei.Notification.NE, DForce.Mini.ei.Utils;

{ TeiNotificationMiniFactory }

class function TeiNotificationMiniFactory.Epurate(const AStringXML: String): string;
begin
  result := StringReplace(AStringXML, 'types:', '', [rfReplaceAll, rfIgnoreCase]);
end;

class function TeiNotificationMiniFactory.NewNotificationNEFromFile(const AFileName: String): IeiNotificationNEmini;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNEFromString(TeiUtilsMini.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationMiniFactory.NewNotificationNEFromStream(const AStream: TStream): IeiNotificationNEmini;
begin
  Result := NewNotificationNEFromString(TeiUtilsMini.StreamToString(AStream));
end;

class function TeiNotificationMiniFactory.NewNotificationNEFromString(const AStringXML: String): IeiNotificationNEmini;
var
  LNotificationCommon: IeiNotificationCommonMini;
begin
  result := LoadXMLData(Epurate(AStringXML)).GetDocBinding('NotificaEsito', TeiNotificationNEmini, TargetNamespace) as IeiNotificationNEmini;
  if Supports(result, IeiNotificationCommonMini, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromFile(const AFileName: String): IeiNotificationNSmini;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFileName, fmOpenRead);
  try
    Result := NewNotificationNSFromString(TeiUtilsMini.StreamToString(LFileStream));
  finally
    LFileStream.Free;
  end;
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromStream(const AStream: TStream): IeiNotificationNSmini;
begin
  Result := NewNotificationNSFromString(TeiUtilsMini.StreamToString(AStream));
end;

class function TeiNotificationMiniFactory.NewNotificationNSFromString(const AStringXML: String): IeiNotificationNSmini;
var
  LNotificationCommon: IeiNotificationCommonMini;
begin
  result := LoadXMLData(Epurate(AStringXML)).GetDocBinding('NotificaScarto', TeiNotificationNSmini, TargetNamespace) as IeiNotificationNSmini;
  if Supports(result, IeiNotificationCommonMini, LNotificationCommon) then
    LNotificationCommon.RawXML := AStringXML;
end;

end.
