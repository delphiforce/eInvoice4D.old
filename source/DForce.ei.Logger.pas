{ *************************************************************************** }
{ }
{ eInvoice4D - (Fatturazione Elettronica per Delphi) }
{ }
{ Copyright (C) 2018  Delphi Force }
{ }
{ info@delphiforce.it }
{ https://github.com/delphiforce/eInvoice4D.git }
{ }
{ Delphi Force Team }
{ Antonio Polito }
{ Carlo Narcisi }
{ Fabio Codebue }
{ Marco Mottadelli }
{ Maurizio del Magno }
{ Omar Bossoni }
{ Thomas Ranzetti }
{ }
{ *************************************************************************** }
{ }
{ This file is part of eInvoice4D }
{ }
{ Licensed under the GNU Lesser General Public License, Version 3; }
{ you may not use this file except in compliance with the License. }
{ }
{ eInvoice4D is free software: you can redistribute it and/or modify }
{ it under the terms of the GNU Lesser General Public License as published }
{ by the Free Software Foundation, either version 3 of the License, or }
{ (at your option) any later version. }
{ }
{ eInvoice4D is distributed in the hope that it will be useful, }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the }
{ GNU Lesser General Public License for more details. }
{ }
{ You should have received a copy of the GNU Lesser General Public License }
{ along with eInvoice4D.  If not, see <http://www.gnu.org/licenses/>. }
{ }
{ *************************************************************************** }
unit DForce.ei.Logger;

interface

uses System.SysUtils, DForce.ei.Logger.Interfaces;

type

  TeiLogType = (ltInformation, ltWarning, ltError);

  TeiLogger = class
  protected
    class function GetLogger: TeiLoggerAbstractRef;
  public
    class procedure LogI(const ALogMessage: string);
    class procedure LogW(const ALogMessage: string);
    class procedure LogE(const ALogMessage: string); overload; // Error
    class procedure LogE(const E: Exception); overload; // Exception
    class procedure LogBlank;
    class procedure LogSeparator;
  end;

implementation

uses Winapi.Windows, DForce.ei.Logger.pfLogger.Adapter;

{ TeiLogger }

class procedure TeiLogger.LogE(const ALogMessage: string);
begin
  GetLogger.LogE(ALogMessage);
end;

class function TeiLogger.GetLogger: TeiLoggerAbstractRef;
begin
  result := TeiPfLoggerAdapter;
end;

class procedure TeiLogger.LogBlank;
begin
  GetLogger.LogI('');
end;

class procedure TeiLogger.LogE(const E: Exception);
begin
  GetLogger.LogE(E.Message);
end;

class procedure TeiLogger.LogI(const ALogMessage: string);
begin
  GetLogger.LogI(ALogMessage);
end;

class procedure TeiLogger.LogSeparator;
begin
  GetLogger.LogI('--------------------------------------------------');
end;

class procedure TeiLogger.LogW(const ALogMessage: string);
begin
  GetLogger.LogW(ALogMessage);
end;

end.
