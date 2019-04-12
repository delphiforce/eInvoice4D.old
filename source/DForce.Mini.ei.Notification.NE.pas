unit DForce.Mini.ei.Notification.NE;

interface

uses
  DForce.ei.Notification.NE.Base, DForce.Mini.ei.Notification.Interfaces,
  System.Classes;

type
  TeiNotificationNEmini = class(TXMLNotificaNEType, IeiNotificationNEmini, IeiNotificationCommonMini)
  private
    FRawXML: string;
  protected
    function ToString: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    function InvoiceAccepted: Boolean;
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses
  System.SysUtils, DForce.ei.Exception, DForce.Mini.ei.Utils;

{ TeiNotificationNEmini }

function TeiNotificationNEmini.GetRawXML: string;
begin
  Result := FRawXML;
end;

function TeiNotificationNEmini.InvoiceAccepted: Boolean;
begin
  Result := (Trim(EsitoCommittente.Esito) = 'EC01');
end;

procedure TeiNotificationNEmini.SaveToFile(const AFileName: String);
var
  LFileStream: TFileStream;
begin
  if FileExists(AFileName) then
    raise eiGenericException.Create(Format('File "%s" already exists', [AFileName]));
  LFileStream := TFileStream.Create(AFileName, fmCreate);
  try
    TeiUtilsMini.StringToStream(LFileStream, ToString);
  finally
    LFileStream.Free;
  end;
end;

procedure TeiNotificationNEmini.SaveToStream(const AStream: TStream);
begin
  TeiUtilsMini.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNEmini.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNEmini.ToString: String;
begin
  result := self.GetRawXML;
end;

end.
