{***************************************************************************}
{                                                                           }
{           eInvoice4D - (Fatturazione Elettronica per Delphi)              }
{                                                                           }
{           Copyright (C) 2018  Delphi Force                                }
{                                                                           }
{           info@delphiforce.it                                             }
{           https://github.com/delphiforce/eInvoice4D.git                   }
{                                                                  	        }
{           Delphi Force Team                                      	        }
{             Antonio Polito                                                }
{             Carlo Narcisi                                                 }
{             Fabio Codebue                                                 }
{             Marco Mottadelli                                              }
{             Maurizio del Magno                                            }
{             Omar Bossoni                                                  }
{             Thomas Ranzetti                                               }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  This file is part of eInvoice4D                                          }
{                                                                           }
{  Licensed under the GNU Lesser General Public License, Version 3;         }
{  you may not use this file except in compliance with the License.         }
{                                                                           }
{  eInvoice4D is free software: you can redistribute it and/or modify       }
{  it under the terms of the GNU Lesser General Public License as published }
{  by the Free Software Foundation, either version 3 of the License, or     }
{  (at your option) any later version.                                      }
{                                                                           }
{  eInvoice4D is distributed in the hope that it will be useful,            }
{  but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            }
{  GNU Lesser General Public License for more details.                      }
{                                                                           }
{  You should have received a copy of the GNU Lesser General Public License }
{  along with eInvoice4D.  If not, see <http://www.gnu.org/licenses/>.      }
{                                                                           }
{***************************************************************************}
unit DForce.ei.Validation.ValidationResult;

interface

uses DForce.ei.Validation.Interfaces;

type
  TeiValidationResult = class(TInterfacedObject, IeiValidationResultInt)
  private
    FInfo: string;
    FCode: string;
    FDescription: string;
    FSeverity: TeiSeverityType;
  protected
    function GetInfo: string;
    function GetCode: string;
    function GetDescription: string;
    function GetSeverity: TeiSeverityType;
    procedure SetInfo(const Value: string);
    procedure SetCode(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetSeverity(const Value: TeiSeverityType);
  public
    constructor Create(const AInfo, ACode, ADescription: string; const ASeverity: TeiSeverityType);
    function ToString: string; reintroduce;
    property Info: string read GetInfo write SetInfo;
    property Code: string read GetCode write SetCode;
    property Description: string read GetDescription write SetDescription;
    property Severity: TeiSeverityType read GetSeverity write SetSeverity;
  end;

implementation

uses System.SysUtils;

{ TeiValidationResult }

constructor TeiValidationResult.Create(const AInfo, ACode, ADescription: string; const ASeverity: TeiSeverityType);
begin
  inherited Create;
  FInfo := AInfo;
  FCode := ACode;
  FDescription := ADescription;
  FSeverity := ASeverity;
end;

function TeiValidationResult.GetCode: string;
begin
  result := FCode;
end;

function TeiValidationResult.GetDescription: string;
begin
  result := FDescription;
end;

function TeiValidationResult.GetInfo: string;
begin
  result := FInfo;
end;

function TeiValidationResult.GetSeverity: TeiSeverityType;
begin
  result := FSeverity;
end;

procedure TeiValidationResult.SetCode(const Value: string);
begin
  FCode := Value;
end;

procedure TeiValidationResult.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

procedure TeiValidationResult.SetInfo(const Value: string);
begin
  FInfo := Value;
end;

procedure TeiValidationResult.SetSeverity(const Value: TeiSeverityType);
begin
  FSeverity := Value;
end;

function TeiValidationResult.ToString: string;
begin
  result := Format('%s %s', [FCode, FDescription]);
end;

end.
