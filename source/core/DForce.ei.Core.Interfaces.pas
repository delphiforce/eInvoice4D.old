unit DForce.ei.Core.Interfaces;

interface

uses
  System.Generics.Collections, System.Classes;

type

TeiOccurrence = (o01, o0N, o11, o1N);

IeiProperty = interface(IInvokable)
  ['{62E253B1-834E-4DC0-86BD-D582E6FFEF02}']
  procedure _Clear;
  function _PropFullQualifiedName: String;
  function _PropID: String;
  function _PropIsNotNull: Boolean;
  function _PropIsNull: Boolean;
  function _PropName: String;
  function _PropOccurrence: TeiOccurrence;
  function _PropOccurrenceAsString: String;
  function _PropQualifiedName: String;
end;

IeiBlock = interface(IeiProperty)
  ['{883EC805-04A7-403B-96A7-4331854A1F57}']
end;

IeiList<T: IeiProperty> = interface(IeiProperty)
  ['{CEE209E4-5CC5-4429-B831-FA377BF6D67D}']
  function Add: T;
  function Current: T;
  function Count: Integer;
//  function GetEnumerator: TEnumerator<T>;
  // Items property
  function GetItem(Index: Integer): T;
  property Items[Index: Integer]: T read GetItem; default;
end;

IeiProperty<T> = interface(IeiProperty)
  ['{A667DCAE-06FA-46C4-8273-B46A53FEAA96}']
  // Value
  procedure _SetValue(const AValue: T);
  function _GetValue: T;
  property Value: T read _GetValue write _SetValue;
end;

IeiDate = interface(IeiProperty<TDate>)
  ['{2B689F47-754F-46A6-BA77-309280B5E6AB}']
end;

IeiDecimal = interface(IeiProperty<Double>)
  ['{994BFD3A-1232-49C0-9289-DAC0AC72AD00}']
end;

IeiInteger = interface(IeiProperty<Integer>)
  ['{E4AB24FC-CD6E-4274-9800-C89537049B10}']
end;

IeiString = interface(IeiProperty<String>)
  ['{E82B7999-8360-4F65-8EA8-28BDC2D6FFC4}']
end;

IeiBase64 = interface(ieiProperty<string>)
  ['{D4A6CEE9-76AA-4BCD-A6A7-3BBCF3782441}']
  procedure LoadFromStream(const AStream: TStream);
  procedure LoadFromFile(const AFileName: string);
  procedure SaveToStream(const AStream: TStream);
  procedure SaveToFile(const AFileName: string);
end;

implementation

end.
