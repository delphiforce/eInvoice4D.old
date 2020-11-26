unit DForce.ei.Core.Prop.Block;

interface

uses
  System.Rtti, System.Generics.Collections, DForce.ei.Core.Interfaces,
  System.TypInfo;

type

  TeiPropCollection = TDictionary<String, IeiProperty>;

  TeiBlockProperty = class(TVirtualInterface, IeiProperty)
  private
    FPropInfo: IeiProperty;
    FProps: TeiPropCollection;
    procedure DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
    procedure FillProps(PIID: PTypeInfo);
  protected
  public
    constructor Create(const PIID: PTypeInfo; const AID, AName: String; const AOccurrence: TeiOccurrence); overload;
    destructor Destroy; override;
    // Begin: Leave this methods public to ensure RTTI informations on them
    procedure _Clear;
    function _PropFullQualifiedName: String;
    function _PropID: String;
    function _PropIsNotNull: Boolean;
    function _PropIsNull: Boolean;
    function _PropName: String;
    function _PropOccurrence: TeiOccurrence;
    function _PropOccurrenceAsString: String;
    function _PropQualifiedName: String;
    // End: Leave this methods public to ensure RTTI informations on them
  end;

implementation

uses
  DForce.ei.Core.Factory, System.SysUtils, DForce.ei.Core.Attributes;

{ TeiInsaneVirtualProp }

constructor TeiBlockProperty.Create(const PIID: PTypeInfo; const AID, AName: String; const AOccurrence: TeiOccurrence);
begin
  inherited Create(PIID);
  FPropInfo := TeiPropFactory.NewBaseProp(AID, AName, AOccurrence);
  FProps := TeiPropCollection.Create;
  FillProps(PIID);
  OnInvoke := DoInvoke;
end;

destructor TeiBlockProperty.Destroy;
begin
  FProps.Free;
  inherited;
end;

procedure TeiBlockProperty.DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LConcreteMethod: TRttiMethod;
  LArgs: TArray<TValue>;
  LPropPtr: Pointer;
begin
  // If the method is a VirtualProperty then return it...
  if FProps.ContainsKey(Method.Name) then
  begin
    Supports(FProps[Method.Name], (Method.ReturnType as TRttiInterfaceType).GUID, LPropPtr);
    TValue.Make(@LPropPtr, Method.ReturnType.Handle, Result);
  end
  // ...else invoke as self concrete method
  else
  begin
    LContext := TRttiContext.Create;
    try
      // Get the destination RttiMethod
      LType := LContext.GetType(Self.ClassInfo);
      LConcreteMethod := LType.GetMethod(Method.Name);
      // Do not consider the first element of Args
      LArgs := Copy(Args, 1, Length(Args));
      // Invoke the method
      Result := LConcreteMethod.Invoke(Self, LArgs);
    finally
      LContext.Free;
    end;
  end;
end;

procedure TeiBlockProperty.FillProps(PIID: PTypeInfo);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LMethod: TRttiMethod;
  LAttribute: TCustomAttribute;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(PIID);
    for LMethod in LType.GetMethods do
      for LAttribute in LMethod.GetAttributes do
        if LAttribute is eiPropertyAttribute then
          with LAttribute as eiPropertyAttribute do
            FProps.Add(LMethod.Name, TeiPropFactory.NewProperty(LMethod.ReturnType.Handle, ID(_PropID), LMethod.Name, Occurrence));
  finally
    LContext.Free;
  end;
end;

procedure TeiBlockProperty._Clear;
begin
  FPropInfo._Clear;
end;

function TeiBlockProperty._PropFullQualifiedName: String;
begin
  Result := FPropInfo._PropFullQualifiedName;
end;

function TeiBlockProperty._PropID: String;
begin
  Result := FPropInfo._PropID;
end;

function TeiBlockProperty._PropIsNotNull: Boolean;
begin
  Result := not _PropIsNull;
end;

function TeiBlockProperty._PropIsNull: Boolean;
var
  LProperty: IeiProperty;
begin
  inherited;
  Result := False;
  for LProperty in FProps.Values do
    if LProperty._PropIsNull then
      Exit(True);
end;

function TeiBlockProperty._PropName: String;
begin
  Result := FPropInfo._PropName;
end;

function TeiBlockProperty._PropOccurrence: TeiOccurrence;
begin
  Result := FPropInfo._PropOccurrence;
end;

function TeiBlockProperty._PropOccurrenceAsString: String;
begin
  Result := FPropInfo._PropOccurrenceAsString;
end;

function TeiBlockProperty._PropQualifiedName: String;
begin
  Result := FPropInfo._PropQualifiedName;
end;

end.
