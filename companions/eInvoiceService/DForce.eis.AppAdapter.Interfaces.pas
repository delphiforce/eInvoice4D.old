unit DForce.eis.AppAdapter.Interfaces;

interface

uses DForce.ei;

type

  IeiApplicationAdapter = interface
    ['{DEFAA1C4-7C6D-4E03-AB5C-188A4CE6EA56}']
    // Sales invoices to send
    function LoadSalesInvoicesToSend: IeiInvoiceCollection;
    procedure PersistSalesInvoicesResponse(const AResponseCollection: IeiResponseCollection);
    // Sales invoices for notification request
    function LoadSalesInvoicesForNotificationRequest: IeiInvoiceIDCollection;
    procedure PersistSalesNotificationResponse(const AResponseCollection: IeiResponseCollection);
    // Purchase invoices
    procedure PersistPurchaseInvoices(const AInvoiceCollection: IeiInvoiceCollection);
  end;

implementation

end.
