unit DForce.eis.AppAdapter.Mock;

interface

uses System.SysUtils, System.Classes, DForce.eis.AppAdapter.Base, DForce.ei;

type
  TeiApplicationAdapterMock = class(TeiApplicationAdapterBase)
  protected
    // Sales invoices to send
    function LoadSalesInvoicesToSend: IeiInvoiceCollection; override;
    procedure PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection); override;
    // Sales invoices for notification request
    function LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection; override;
    procedure PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection); override;
    // Purchase invoices
    procedure PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection); override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TApplicationAdapterMock }

function TeiApplicationAdapterMock.LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection;
begin
  inherited;
  result := ei.NewInvoiceIDCollection;

  result.Add('IT070260378832_jtlkl.xml');
  result.Add('IT070260378832_jtlkm.xml');
  result.Add('IT070260378832_jtlkn.xml');
end;

function TeiApplicationAdapterMock.LoadSalesInvoicesToSend: IeiInvoiceCollection;
var
  i: Integer;
  LInvoice: IeiInvoice;
begin
  inherited;
  result := ei.NewInvoiceCollection;

  for i := 1 to 3 do
  begin
    LInvoice := ei.NewInvoice;
    LInvoice.FillWithSampleData;
    result.Add(LInvoice);
  end;
end;

procedure TeiApplicationAdapterMock.PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection);
begin
  inherited;

end;

procedure TeiApplicationAdapterMock.PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection);
begin
  inherited;

end;

procedure TeiApplicationAdapterMock.PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection);
begin
  inherited;

end;

end.
