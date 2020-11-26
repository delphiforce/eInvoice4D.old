unit DForce.ei.Core.Factory;

interface

uses
  DForce.ei.Core.Interfaces, system.Rtti, DForce.ei.Invoice.Intf,
  System.TypInfo;

type

  TeiPropFactory = class
  public
    class function NewBaseProp(const AID, AName: String; const AOccurrence: TeiOccurrence): IeiProperty;
    class function NewInvoice: IFatturaElettronicaType;
    class function NewProperty(const ATypeInfo: PTypeInfo; const AID, AName: String; const AOccurrence: TeiOccurrence): IeiProperty;
  end;

implementation

uses
  DForce.ei.Core.Prop.Base, DForce.ei.Core.Prop, DForce.ei.Core.Prop.Block,
  System.SysUtils, DForce.ei.Core.Prop.List;

{ TeiPropFactory }

class function TeiPropFactory.NewBaseProp(const AID, AName: String; const AOccurrence: TeiOccurrence): IeiProperty;
begin
  Result := TeiProperty.Create(AID, AName, AOccurrence);  // Params value are not important
end;

class function TeiPropFactory.NewInvoice: IFatturaElettronicaType;
begin
  Result := TeiBlockProperty.Create(TypeInfo(IFatturaElettronicaType), '', '', o11) as IFatturaElettronicaType;
end;

class function TeiPropFactory.NewProperty(const ATypeInfo: PTypeInfo; const AID, AName: String;
  const AOccurrence: TeiOccurrence): IeiProperty;
var
  LGUID: TGUID;
begin
  LGUID := ATypeInfo.TypeData.GUID;
  if LGUID = IeiDate then
    Result := TeiProperty<TDate>.Create(AID, AName, AOccurrence)
  else if LGUID = IeiDecimal then
    Result := TeiProperty<Double>.Create(AID, AName, AOccurrence)
  else if LGUID = IeiInteger then
    Result := TeiProperty<Integer>.Create(AID, AName, AOccurrence)
  else if LGUID = IeiString then
    Result := TeiStringProperty.Create(AID, AName, AOccurrence)
  else if LGUID = IeiBase64 then
    Result := TeiBase64Property.Create(AID, AName, AOccurrence)
  else if (AOccurrence = o0N) or (AOccurrence = o1N) then
    Result := TeiListProperty.Create(ATypeInfo, AID, AName, AOccurrence)
  else
    Result := TeiBlockProperty.Create(ATypeInfo, AID, AName, AOccurrence);
end;

end.
