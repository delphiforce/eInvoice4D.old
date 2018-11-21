unit DForce.eis.AppAdapter.Factory;

interface

uses
  System.Classes, DForce.eis.AppAdapter.Interfaces;

type

  TeiApplicationAdapterFactory = class
  public
    class function NewApplicationAdapter: IeiApplicationAdapter;
  end;

implementation

uses
  DForce.eis.AppAdapter.Mock, DForce.ei, System.SysUtils;

{ TApplicationAdapterFactory }

class function TeiApplicationAdapterFactory.NewApplicationAdapter: IeiApplicationAdapter;
begin
  ei.LogI('EIS: Creating application adapter instance');
  try
    Result := TeiApplicationAdapterMock.Create(nil);
    ei.LogI('EIS: Application adapter is alive');
  except
    on E: Exception do
    begin
      ei.LogE(E);
      raise;
    end;
  end;
end;

end.
