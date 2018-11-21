object eInvoiceSrvService: TeInvoiceSrvService
  OldCreateOrder = False
  DisplayName = 'eInvocice Service'
  AfterInstall = ServiceAfterInstall
  OnContinue = ServiceContinue
  OnExecute = ServiceExecute
  OnPause = ServicePause
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 429
  Width = 581
end
