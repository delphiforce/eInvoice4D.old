unit DForce.ei.InvoiceDataExtractor.Interfaces;

interface

uses
  System.SysUtils, Xml.XMLIntf;

type

  IeiXMLInvoiceDataExtractor = Interface
    ['{9B76142E-CA9C-4406-80FA-7DD719966FE0}']
    // Getters/Setters
    function GetFormatSettings: TFormatSettings;
    function GetParentNode: IXMLNode;
    procedure SetParentNode(const Value: IXMLNode);
    // Base methods
    function NodeExists(const ANodeName: string): boolean;
    function NodeValue(const ANodeName: string; const ARequired: boolean = false): string;
    function NodeValueAsString(const ANodeName: string; Const AMaxLength: integer = 9999; const ARequired: boolean = false): string;
    function NodeValueAsInteger(const ANodeName: string; const ARequired: boolean = false): integer;
    function NodeValueAsFloat(const ANodeName: string; const ARequired: boolean = false): Extended;
    function NodeValueAsDateTime(const ANodeName: string; const ARequired: boolean = false): TDateTime;
    // Advanced extractors
    procedure ExtractInvoiceNumberAndRegister(out AInvoiceNumber: integer; out AInvoiceRegister: string);
    function ExtractSupplierName: string;
    // Properties
    property ParentNode: IXMLNode read GetParentNode write SetParentNode;
    property FormatSettings: TFormatSettings read GetFormatSettings;
  end;


implementation

end.
