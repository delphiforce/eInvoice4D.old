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
unit DForce.ei.Validation.Engine;

interface

uses DForce.ei.Validation.Interfaces,
  System.Generics.Collections,
  DForce.ei.Invoice.Interfaces,
  System.SysUtils;

type

  TeiValidationMethod = reference to function(const AInvoice: IeiInvoiceEx): IeiValidationResultCollectionInt;

  TeiValidationEngine = class
  private
    class var FContainer: TList<TeiValidationMethod>;
    class procedure Build;
    class procedure CleanUp;
  public
    class procedure RegisterValidationMethod(const AValidationMethod: TeiValidationMethod);
    class function Validate(const AInvoice: IeiInvoiceEx): IeiValidationResultCollectionInt;
  end;

implementation

uses DForce.ei.Validation.Factory,
  DForce.ei.Validation.Validator.Rules,
  DForce.ei.Validation.Validator.Values,
  DForce.ei.Validation.Validator.Custom;

{ TeiValidationEngine }

class procedure TeiValidationEngine.Build;
begin
  FContainer := TList<TeiValidationMethod>.Create;
  TeiValidationRules.RegisterMethods;
  TeiValidationValues.RegisterMethods;
  TeiValidationCustom.RegisterMethods;
end;

class procedure TeiValidationEngine.CleanUp;
begin
  FContainer.Free;
end;

class procedure TeiValidationEngine.RegisterValidationMethod(const AValidationMethod: TeiValidationMethod);
begin
  FContainer.Add(AValidationMethod);
end;

class function TeiValidationEngine.Validate(const AInvoice: IeiInvoiceEx): IeiValidationResultCollectionInt;
var
  LValidator: TeiValidationMethod;
begin
  result := TeiValidationFactory.NewValidationResultCollection;
  for LValidator in FContainer do
    result.AddRange(LValidator(AInvoice));
end;

initialization

TeiValidationEngine.Build;

finalization

TeiValidationEngine.CleanUp;

end.
