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
