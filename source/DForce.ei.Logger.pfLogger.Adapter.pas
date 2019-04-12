unit DForce.ei.Logger.pfLogger.Adapter;

interface

uses DForce.ei.Logger.Interfaces, System.SysUtils, DForce.ei.Logger.pfLogger;

type
  TeiPfLoggerAdapter = class(TeiLoggerAbstract)
  private
    class var FPfLogger: IPfLogger;
  public
    class constructor Create;
    class procedure LogI(const ALogMessage: string); override;
    class procedure LogW(const ALogMessage: string); override;
    class procedure LogE(const ALogMessage: string); override;
  end;

implementation

{ TeiPfLoggerAdapter }

uses System.IOUtils;

class constructor TeiPfLoggerAdapter.Create;
var
  LLogDir: string;
begin
  LLogDir := TPath.Combine(GetEnvironmentVariable('APPDATA'), 'LogFatturaElettronica');
  TDirectory.CreateDirectory(LLogDir);
  FPfLogger := GetPFLogger(TPath.Combine(LLogDir, 'LogFatturaElettronica'));
  FPfLogger.SetLogLevel(llDebug);
end;

class procedure TeiPfLoggerAdapter.LogE(const ALogMessage: string);
begin
  FPfLogger.Error(ALogMessage);
end;

class procedure TeiPfLoggerAdapter.LogI(const ALogMessage: string);
begin
  inherited;
  FPfLogger.Info(ALogMessage);
end;

class procedure TeiPfLoggerAdapter.LogW(const ALogMessage: string);
begin
  inherited;
  FPfLogger.Warning(ALogMessage);
end;

end.
