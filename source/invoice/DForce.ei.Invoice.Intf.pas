unit DForce.ei.Invoice.Intf;

interface

uses
  DForce.ei.Core.Attributes, DForce.ei.Core.Interfaces;

type

  IIdFiscaleType = interface(IeiBlock)
    ['{19E8DD8A-DC6C-4A6D-92F8-972C9F25319E}']
    [eiProperty(1, o11)] function IdPaese: IeiString;
    [eiProperty(2, o11)] function IdCodice: IeiString;
  end;

  IDatiTrasmissioneType = interface(IeiBlock)
    ['{0C1398C5-3955-4D87-AB55-86A8D0C7A41D}']
    [eiProperty(1, o11)] function IdTrasmittente: IIdFiscaleType;
    [eiProperty(2, o11)] function ProgressivoInvio: IeiString;
  end;

  IFatturaElettronicaHeaderType = interface(IeiBlock)
    ['{B569FA15-2FC8-4896-B457-FE23B17B164C}']
    [eiProperty(1, o11)] function DatiTrasmissione: IDatiTrasmissioneType;
  end;

  IDatiGenerali = interface(IeiBlock)
    ['{CEAFBFC2-3A11-4E70-87E8-136208F9FFC7}']
    [eiProperty(1, o11)] function TestProperty: IeiString;
  end;

  IAllegati = interface(IeiBlock)
    ['{140ACCBC-8495-4C4E-BE66-74707421DB31}']
    [eiProperty(1, o11)] function NomeAttachment: IeiString;
    [eiProperty(1, o01)] function AlgoritmoCompressione: IeiString;
    [eiProperty(1, o01)] function FormatoAttachment: IeiString;
    [eiProperty(1, o01)] function DescrizioneAttachment: IeiString;
    [eiProperty(1, o11)] function Attachment: IeiBase64;
  end;

  IFatturaElettronicaBody = interface(IeiBlock)
    ['{2690076D-A79B-47CB-B56D-86F9434D67C6}']
    [eiProperty(1, o11)] function DatiGenerali: IDatiGenerali;
    [eiProperty(1, o0N)] function Allegati: IeiList<IAllegati>;
  end;

  IFatturaElettronicaType = interface(IeiBlock)
    ['{C1B2B781-0F6C-4E0C-981A-8DC6155699F6}']
    [eiProperty(1, o11)]
    function FatturaElettronicaHeader: IFatturaElettronicaHeaderType;
    [eiProperty(2, o1N)]
    function FatturaElettronicaBody: IeiList<IFatturaElettronicaBody>;
  end;

implementation

end.
