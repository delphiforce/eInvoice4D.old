unit DForce.ei.Core.Prop.Base;

interface

uses
  DForce.ei.Core.Interfaces;

type

  TeiProperty = class(TInterfacedObject, IeiProperty)
  private
    FID: String;
    FIsNull: Boolean;
    FName: String;
    FOccurrence: TeiOccurrence;
  protected
    Procedure _SetProcIsNull(const AIsNull: Boolean);
  public
    constructor Create(const AID, AName: String; const AOccurrence: TeiOccurrence); virtual;
    // Begin: Leave this methods public to ensure RTTI informations on them
    procedure _Clear; virtual;
    procedure _RaiseException(const AMsg: String); virtual;
    function _PropFullQualifiedName: String; virtual;
    function _PropID: String; virtual;
    function _PropIsNotNull: Boolean; virtual;
    function _PropIsNull: Boolean; virtual;
    function _PropName: String; virtual;
    function _PropOccurrence: TeiOccurrence; virtual;
    function _PropOccurrenceAsString: String; virtual;
    function _PropQualifiedName: String; virtual;
    // End: Leave this methods public to ensure RTTI informations on them
  end;

implementation

uses
  DForce.ei.Exception, System.SysUtils;

{ TeiBaseProperty<T> }

procedure TeiProperty._RaiseException(const AMsg: String);
begin
  raise eiPropertyException.Create(Format('%s <%s>: %s', [FID, FName, AMsg]));
end;

procedure TeiProperty._SetProcIsNull(const AIsNull: Boolean);
begin
  FIsNull := AIsNull;
end;

procedure TeiProperty._Clear;
begin
  FIsNull := True;
end;

constructor TeiProperty.Create(const AID, AName: String; const AOccurrence: TeiOccurrence);
begin
  inherited Create;
  FID := AID;
  FIsNull := True;
  FName := AName;
  FOccurrence := AOccurrence;
end;

function TeiProperty._PropFullQualifiedName: String;
begin
  Result := Format('%s %s (%s)', [FID, FName, _PropOccurrenceAsString])
end;

function TeiProperty._PropID: String;
begin
  Result := FID;
end;

function TeiProperty._PropIsNotNull: Boolean;
begin
  Result := not FIsNull;
end;

function TeiProperty._PropIsNull: Boolean;
begin
  Result := FIsNull;
end;

function TeiProperty._PropName: String;
begin
  Result := FName;
end;

function TeiProperty._PropOccurrence: TeiOccurrence;
begin
  Result := FOccurrence;
end;

function TeiProperty._PropOccurrenceAsString: String;
begin
  case FOccurrence of
    o01:
      Result := ('0.1');
    o0N:
      Result := ('0.N');
    o11:
      Result := ('1.1');
    o1N:
      Result := ('1.N');
  end;
end;

function TeiProperty._PropQualifiedName: String;
begin
  Result := Format('%s %s', [FID, FName])
end;

end.
