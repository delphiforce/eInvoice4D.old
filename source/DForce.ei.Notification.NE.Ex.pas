unit DForce.ei.Notification.NE.Ex;

interface

uses DForce.ei.Notification.NE.Base, DForce.ei.Notification.Interfaces,
  System.Classes;

type
  TeiNotificationNEEx = class(TXMLNotificaNEType, IeiNotificationNEEx, IeiNotificationCommon)
  private
    FRawXML: string;
  protected
    function ToString: String; reintroduce;
    function ToStringBase64: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
    function InvoiceAccepted: Boolean;
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses System.SysUtils, Xml.XMLDoc, System.NetEncoding, DForce.ei.Exception,
  DForce.ei.Utils;

{ TeiNotificationNEEx }

function TeiNotificationNEEx.GetRawXML: string;
begin
  result := FRawXML;
end;

function TeiNotificationNEEx.InvoiceAccepted: Boolean;
begin
  Result := (Trim(EsitoCommittente.Esito) = 'EC01');
end;

procedure TeiNotificationNEEx.SaveToFile(const AFileName: String);
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

procedure TeiNotificationNEEx.SaveToStream(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNEEx.SaveToStreamBase64(const AStream: TStream);
begin
  TeiUtils.StringToStream(AStream, ToStringBase64);
end;

procedure TeiNotificationNEEx.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNEEx.ToString: String;
begin
  result := self.GetRawXML;
end;

function TeiNotificationNEEx.ToStringBase64: String;
begin
  result := TNetEncoding.Base64.Encode(ToString);
end;

end.
