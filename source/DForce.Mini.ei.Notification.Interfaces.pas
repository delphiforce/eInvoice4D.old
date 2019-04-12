unit DForce.Mini.ei.Notification.Interfaces;

interface

uses
  DForce.ei.Notification.NS.Base, DForce.ei.Notification.NE.Base,
  System.Classes;

type

  IeiNotificationCommonMini = interface
    ['{4A0F64ED-D33E-49D3-9A4E-5F7F446AC449}']
    // RawXML
    procedure SetRawXML(const AXml: string);
    function GetRawXML: string;
    property RawXML: String read GetRawXML write SetRawXML;
  end;

  IeiNotificationNSmini = interface(IXMLNotificaNSType)
    ['{BB98D776-9CB7-4EE2-88D0-A61D94B3D3E3}']
    function ToString: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
  end;

  IeiNotificationNEmini = interface(IXMLNotificaNEType)
    ['{DAEA6757-1F6B-4D40-BD46-E0B0E4B10C4D}']
    function ToString: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    function InvoiceAccepted: Boolean;
  end;

implementation

end.
