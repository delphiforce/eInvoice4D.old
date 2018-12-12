unit DForce.Mini.ei.Notification.NS;

interface

uses
  DForce.ei.Notification.NS.Base, DForce.Mini.ei.Notification.Interfaces,
  System.Classes;

type

  TeiNotificationNSmini = class(TXMLNotificaNSType, IeiNotificationNSmini, IeiNotificationCommonMini)
  private
    FRawXML: string;
  protected
    function ToString: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    // RawXML
    procedure SetRawXML(const AValue: string);
    function GetRawXML: string;
  end;

implementation

uses
  System.SysUtils, DForce.ei.Exception, DForce.Mini.ei.Utils;

{ TeiNotificationNSmini }

function TeiNotificationNSmini.GetRawXML: string;
begin
  Result := FRawXML;
end;

procedure TeiNotificationNSmini.SaveToFile(const AFileName: String);
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

procedure TeiNotificationNSmini.SaveToStream(const AStream: TStream);
begin
  TeiUtilsMini.StringToStream(AStream, ToString);
end;

procedure TeiNotificationNSmini.SetRawXML(const AValue: string);
begin
  FRawXML := AValue;
end;

function TeiNotificationNSmini.ToString: String;
begin
  result := self.GetRawXML;
end;

end.
