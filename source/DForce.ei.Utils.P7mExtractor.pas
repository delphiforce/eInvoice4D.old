unit DForce.ei.Utils.P7mExtractor;

interface

uses System.SysUtils;

type

  TeiExtractP7mMethod = TFunc<string, string>;

  TExtractP7m = class
  private
    class var FCustomExtractP7mMethod: TeiExtractP7mMethod;
  protected
    class constructor Create;
  public
    class procedure SetCustomExtractP7mMethod(const AMethod: TeiExtractP7mMethod);
    class function Extract(const ABase64String: string): string;
  end;

implementation

uses DForce.ei.Exception;

class constructor TExtractP7m.Create;
begin
  FCustomExtractP7mMethod := nil;
end;

class function TExtractP7m.Extract(const ABase64String: string): string;
begin
  if not Assigned(FCustomExtractP7mMethod) then
    raise eiGenericException.Create('TCustomExtractP7m.ExtractP7m NOT assigned.');
  result := FCustomExtractP7mMethod(ABase64String);
end;

class procedure TExtractP7m.SetCustomExtractP7mMethod(const AMethod: TeiExtractP7mMethod);
begin
  FCustomExtractP7mMethod := AMethod;
end;

end.
