unit DForce.ei.Logger.Interfaces;

interface

uses System.SysUtils;

type

  TeiLoggerAbstractRef = class of TeiLoggerAbstract;

  TeiLoggerAbstract = class abstract
  public
    class procedure LogI(const ALogMessage: string); virtual; abstract;
    class procedure LogW(const ALogMessage: string); virtual; abstract;
    class procedure LogE(const ALogMessage: string); virtual; abstract;
  end;

implementation

end.
