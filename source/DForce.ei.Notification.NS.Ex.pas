unit DForce.ei.Notification.NS.Ex;

interface

uses DForce.ei.Notification.NS.Base, DForce.ei.Notification.Interfaces,
  System.Classes;

type
  TeiNotificationNSEx = class(TXMLNotificaNSType, IeiNotificationNSEx, IeiNotificationCommon)
  private
    FRawXML: string;
  protected
    function ToString: String;
    function ToStringBase64: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses System.SysUtils, Xml.XMLDoc, System.NetEncoding, DForce.ei.Exception,
  DForce.ei.Utils;

{ TeiNotificationNSEx }

function TeiNotificationNSEx.GetRawXML: string;
begin
  result := FRawXML;
end;

procedure TeiNotificationNSEx.SaveToFile(const AFileName: String);
var
  LFileStream: TFileStream;
begin
  if FileExists(AFileName) then
    raise eiGenericException.Create(Format('File "%s" already exists', [AFileName]));
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    TeiUtils.StringToStream(LFileStream, ToString);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiNotificationNSEx.SaveToStream(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNSEx.SaveToStreamBase64(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToStringBase64);
end;

procedure TeiNotificationNSEx.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNSEx.ToString: String;
begin
  result := self.GetRawXML;
end;

function TeiNotificationNSEx.ToStringBase64: String;
begin
  result := TNetEncoding.Base64.Encode(ToString);
end;

end.
