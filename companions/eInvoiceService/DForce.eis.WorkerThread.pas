unit DForce.eis.WorkerThread;

interface

uses System.Classes, DForce.eis.AppAdapter.Interfaces, System.SysUtils,
  DForce.ei, DForce.eis.Params;

type
  TeInvoiceWorkerThread = class(TThread)
  private
    FPaused: Boolean;
    FForceSendReceive: Boolean;
    FApplicationAdapter: IeiApplicationAdapter;
    procedure OnErrorMethodCommon(AResponseCollection: IeiResponseCollection; const AException: Exception);
  protected
    procedure Execute; override;
    procedure ReceiveSalesInvoiceNotifications;
    procedure ReceivePurchaseInvoices;
    procedure SendSalesInvoices;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Pause;
    procedure Continue;
    function IsPaused: Boolean;
    procedure OnTerminateEventHandler(Sender: TObject);
    procedure ForceSendReceive;
  end;

implementation

{ TWorkerThread }

uses System.IOUtils, DForce.ei.Logger,
  DForce.eis.AppAdapter.Factory, Winapi.ActiveX;

procedure TeInvoiceWorkerThread.Continue;
begin
  FPaused := False;
  ei.LogI('EIS: Worker thread continued');
end;

constructor TeInvoiceWorkerThread.Create;
begin
  // creo il tread con suspended = true (non parte subito)
  inherited Create(True);
  self.OnTerminate := OnTerminateEventHandler;
  FForceSendReceive := False;
  ei.LogI('EIS: Worker thread created');
end;

destructor TeInvoiceWorkerThread.Destroy;
begin
  ei.LogI('EIS: Worker thread destroyed');
  inherited;
end;

procedure TeInvoiceWorkerThread.Execute;
var
  LSecondsCounter: integer;
begin
  inherited;
  LSecondsCounter := 0;
  CoInitialize(nil); // Necessary for use XML Microsoft
  try
    ei.LogI('EIS: Worker thread started');
    FApplicationAdapter := TeiApplicationAdapterFactory.NewApplicationAdapter; // First loop execution
    while not Terminated do
    begin
      if (LSecondsCounter <= 0) or FForceSendReceive then
      begin
        LSecondsCounter := TeisParams.PollingTimeMinutes;
        FForceSendReceive := False;
        // Questo try-except protegge dal blocco al sollevarsi di qualunque eccezione in modo
        // che comunque il flusso del programma vada avanti qualsiasi cosa succeda (loggando tutto ovviamente)
        try
          ei.Connect;
          try
            if not Terminated then // Only for optimization on terminating
              ReceiveSalesInvoiceNotifications;
            if not Terminated then // Only for optimization on terminating
              ReceivePurchaseInvoices;
            if not Terminated then // Only for optimization on terminating
              SendSalesInvoices;
          finally
            ei.Disconnect;
          end;
        except
          // Do not re-raise the exception here
          on E: Exception do
            ei.LogE('EIS: ' + E.Message);
        end;
      end;
      if not FPaused then
        Dec(LSecondsCounter);
      TThread.Sleep(1000);
    end;
  finally
    CoUninitialize;
  end;
  ei.LogI('EIS: Worker thread terminated');
end;

procedure TeInvoiceWorkerThread.ForceSendReceive;
begin
  FForceSendReceive := True;
end;

function TeInvoiceWorkerThread.IsPaused: Boolean;
begin
  result := FPaused;
end;

procedure TeInvoiceWorkerThread.Pause;
begin
  FPaused := True;
  ei.LogI('EIS: Worker thread paused');
end;

procedure TeInvoiceWorkerThread.ReceiveSalesInvoiceNotifications;
var
  LInvoiceIDCollection: IeiInvoiceIDCollection;
begin
  if not TeisParams.EnableReceiveSalesNotifications then
    Exit;
  // Load invoice ID collection to ask for receive notifications
  LInvoiceIDCollection := FApplicationAdapter.LoadSalesInvoicesForNotificationRequest;
  // Receive notifications
  ei.ReceiveInvoiceCollectionNotifications(LInvoiceIDCollection,
    procedure(AResponseCollection: IeiResponseCollection; AInvoiceID: String)
    begin
      FApplicationAdapter.PersistSalesNotificationResponse(AResponseCollection);
    end,
    procedure(AResponseCollection: IeiResponseCollection; AException: Exception; AInvoiceID: String)
    begin
      OnErrorMethodCommon(AResponseCollection, AException);
      FApplicationAdapter.PersistSalesNotificationResponse(AResponseCollection);
    end);
end;

procedure TeInvoiceWorkerThread.ReceivePurchaseInvoices;
begin
  if not TeisParams.EnableReceivePurchaseInvoices then
    Exit;
  // To be implemented
end;

procedure TeInvoiceWorkerThread.SendSalesInvoices;
var
  LInvoiceCollection: IeiInvoiceCollection;
begin
  if not TeisParams.EnableSendSalesInvoices then
    Exit;
  try
    // Load invoice collection to send from the application adapter
    LInvoiceCollection := FApplicationAdapter.LoadSalesInvoicesToSend;
    // Send invoice collection
    ei.SendInvoiceCollection(LInvoiceCollection,
      procedure(AResponseCollection: IeiResponseCollection)
      begin
        FApplicationAdapter.PersistSalesInvoicesResponse(AResponseCollection);
      end,
      procedure(AResponseCollection: IeiResponseCollection; AException: Exception)
      begin
        OnErrorMethodCommon(AResponseCollection, AException);
        FApplicationAdapter.PersistSalesInvoicesResponse(AResponseCollection);
      end);
  except
    // Do not re-raise the exception here
    on E: Exception do
      ei.LogE(E);
  end;
end;

procedure TeInvoiceWorkerThread.OnErrorMethodCommon(AResponseCollection: IeiResponseCollection; const AException: Exception);
var
  LExceptionResponse: IeiResponse;
begin
  // The response collection could be nil
  if not Assigned(AResponseCollection) then
    AResponseCollection := ei.NewResponseCollection;
  // Create a new response for the received exception
  LExceptionResponse := ei.NewResponse;
  LExceptionResponse.ResponseType := TeiResponseType.rtException;
  LExceptionResponse.ResponseDate := Now;
  LExceptionResponse.NotificationDate := LExceptionResponse.ResponseDate;
  LExceptionResponse.MsgCode := 'Exception';
  LExceptionResponse.MsgText := AException.Message;
  AResponseCollection.Add(LExceptionResponse);
end;

procedure TeInvoiceWorkerThread.OnTerminateEventHandler(Sender: TObject);
begin
  // rilascio le eventuali risorse attive
end;

end.
