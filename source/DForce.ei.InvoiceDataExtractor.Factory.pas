unit DForce.ei.InvoiceDataExtractor.Factory;

interface

uses
  DForce.ei.Invoice.Base, DForce.ei.InvoiceDataExtractor.Interfaces;

type

  TeiXMLDataExtractorFactory = class
  public
    class function NewInvoiceDataExtractor(const AInvoice: IXMLFatturaElettronicaType): IeiXMLInvoiceDataExtractor;
  end;

implementation

uses
  DForce.ei.InvoiceDataExtractor;

{ TeiInvoiceDataExtractorFactory }

class function TeiXMLDataExtractorFactory.NewInvoiceDataExtractor(
  const AInvoice: IXMLFatturaElettronicaType): IeiXMLInvoiceDataExtractor;
begin
  Result := TeiXMLInvoiceDataExtractor.Create(AInvoice);
end;

end.
