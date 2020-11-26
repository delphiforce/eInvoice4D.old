unit DForce.ei.Core.Attributes;

interface

uses
  DForce.ei.Core.Interfaces;

type

eiPropertyAttribute = class(TCustomAttribute)
private
  FID: Byte;
  FOccurrence: TeiOccurrence;
public
  constructor Create(const AID: Byte; const AOccurrence: TeiOccurrence);
  function ID(const AParentID: String): String;
  property Occurrence: TeiOccurrence read FOccurrence;
end;

implementation

uses
  System.SysUtils;

{ eiPropertyAttribute }

constructor eiPropertyAttribute.Create(const AID: Byte; const AOccurrence: TeiOccurrence);
begin
  inherited Create;
  FID := AID;
  FOccurrence := AOccurrence;
end;

function eiPropertyAttribute.ID(const AParentID: String): String;
begin
  Result := Format('%s.%d', [AParentID, FID]);
end;

end.
