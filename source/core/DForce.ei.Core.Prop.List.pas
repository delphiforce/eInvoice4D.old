unit DForce.ei.Core.Prop.List;

interface

uses
  System.Rtti, System.Generics.Collections, DForce.ei.Core.Interfaces,
  System.TypInfo;

type

  TeiListProperty = class(TVirtualInterface, IeiProperty)
  private
    FItemTypeInfo: PTypeInfo;
    FList: TList<IeiProperty>;
    FPropInfo: IeiProperty;
    procedure DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
    procedure ExtractItemTypeInfo(const PIID: PTypeInfo);
    procedure RaiseException(const AMsg: String);
    function TryInvokeMethod(const AInstance: TObject; const AMethod: TRttiMethod; const Args: TArray<TValue>;
      var AResultValue: TValue): Boolean;
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

    function Add: IeiProperty;
    function Count: Integer;
    function Current: IeiProperty;
    // End: Leave this methods public to ensure RTTI informations on them
  end;

implementation

uses
  DForce.ei.Core.Factory, System.SysUtils, DForce.ei.Exception;

{ TeiListProperty }

function TeiListProperty.Add: IeiProperty;
begin
  Result := TeiPropFactory.NewProperty(FItemTypeInfo, _PropID, _PropName, o01); // o01 perchè altrimenti considera la item come lista
  FList.Add(Result);
end;

function TeiListProperty.Current: IeiProperty;
begin
  if FList.Count = 0 then
    Result := Add
  else
    Result := FList[FList.Count - 1];
end;

destructor TeiListProperty.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TeiListProperty.DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>; out Result: TValue);
begin
  // First try to execute method in the self class (if exists)
  if not TryInvokeMethod(Self, Method, Args, Result) then
    // Second try to execute method in the FList class (if exists)
    if not TryInvokeMethod(FList, Method, Args, Result) then
      // Else raise an exception
      RaiseException(Format('"%s" method not found.', [Method.Name]));
end;

function TeiListProperty.TryInvokeMethod(const AInstance: TObject; const AMethod: TRttiMethod; const Args: TArray<TValue>;
  var AResultValue: TValue): Boolean;
var
  LContext: TRttiContext;
  LType: TRttiType;
  LConcreteMethod: TRttiMethod;
  LArgs: TArray<TValue>;
  LPropPtr: Pointer;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(AInstance.ClassInfo);
    LConcreteMethod := LType.GetMethod(AMethod.Name);
    Result := Assigned(LConcreteMethod);
    if Result then
    begin
      // Do not consider the first element of Args
      LArgs := Copy(Args, 1, Length(Args));
      AResultValue := LConcreteMethod.Invoke(AInstance, LArgs);
      // If the ReturnType of the method is an IieProperty descendant the cast it properly
      if AResultValue.TypeInfo.TypeData.GUID = IeiProperty then
      begin
        Supports(AResultValue.AsType<IeiProperty>, (AMethod.ReturnType as TRttiInterfaceType).GUID, LPropPtr);
        TValue.Make(@LPropPtr, AMethod.ReturnType.Handle, AResultValue);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

procedure TeiListProperty.ExtractItemTypeInfo(const PIID: PTypeInfo);
var
  LContext: TRttiContext;
  LListType: TRttiInterfaceType;
begin
  LContext := TRttiContext.Create;
  try
    LListType := LContext.GetType(PIID) as TRttiInterfaceType;
    FItemTypeInfo := (LListType.GetMethod('GetItem').ReturnType as TRttiInterfaceType).Handle;
  finally
    LContext.Free;
  end;
end;

procedure TeiListProperty.RaiseException(const AMsg: String);
begin
  raise eiPropertyException.Create(Format('%s <%s>: %s', [_PropID, _PropName, AMsg]));
end;

procedure TeiListProperty._Clear;
begin
  FList.Clear;
end;

function TeiListProperty.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TeiListProperty.Create(const PIID: PTypeInfo; const AID, AName: String; const AOccurrence: TeiOccurrence);
begin
  inherited Create(PIID);
  FList := TList<IeiProperty>.Create;
  FPropInfo := TeiPropFactory.NewBaseProp(AID, AName, AOccurrence);
  ExtractItemTypeInfo(PIID);
  OnInvoke := DoInvoke;
end;

function TeiListProperty._PropFullQualifiedName: String;
begin
  Result := FPropInfo._PropFullQualifiedName;
end;

function TeiListProperty._PropID: String;
begin
  Result := FPropInfo._PropID;
end;

function TeiListProperty._PropIsNotNull: Boolean;
begin
  Result := not _PropIsNull;
end;

function TeiListProperty._PropIsNull: Boolean;
begin
  Result := FList.Count = 0;
end;

function TeiListProperty._PropName: String;
begin
  Result := FPropInfo._PropName;
end;

function TeiListProperty._PropOccurrence: TeiOccurrence;
begin
  Result := FPropInfo._PropOccurrence;
end;

function TeiListProperty._PropOccurrenceAsString: String;
begin
  Result := FPropInfo._PropOccurrenceAsString;
end;

function TeiListProperty._PropQualifiedName: String;
begin
  Result := FPropInfo._PropQualifiedName;
end;

end.
