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
unit DForce.ei.Validation.Validator.Rules;

interface

type

  TeiValidationRules = class
  public
    class procedure RegisterMethods;
  end;

implementation

uses DForce.ei.Validation.Engine, DForce.ei.Invoice.Interfaces,
  DForce.ei.Validation.Interfaces, DForce.ei.Invoice.Base, System.SysUtils,
  DForce.ei.Validation.Factory;

{ TeiValidationRules }

class procedure TeiValidationRules.RegisterMethods;
begin

  // invoice rows validators
  TeiValidationEngine.RegisterValidationMethod(
    function(const AInvoice: IeiInvoiceEx): IeiValidationResultCollectionInt
    var
      LDettaglioLinea: IXMLDettaglioLineeType;
      i: Integer;
      LInfo: string;
    begin
      result := TeiValidationFactory.NewValidationResultCollection;
      for i := 0 to AInvoice.FatturaElettronicaBody[0].DatiBeniServizi.DettaglioLinee.Count - 1 do
      begin
        LDettaglioLinea := AInvoice.FatturaElettronicaBody[0].DatiBeniServizi.DettaglioLinee[i];
        LInfo := Format('Line %d', [i + 1]);
        // ---------------------------------------------------------------------------------------
        // Codice 00400  2.2.1.14 <Natura> non presente a fronte di 2.2.1.12 <AliquotaIVA> pari a zero
        if (LDettaglioLinea.AliquotaIVA.Replace('.', '').ToInteger = 0) and LDettaglioLinea.Natura.Trim.IsEmpty then
          result.Add(TeiValidationFactory.NewValidationResult(LInfo, '00400',
            '2.2.1.14 <Natura> non presente a fronte di 2.2.1.12 <AliquotaIVA> pari a zero', TeiSeverityType.stError));
        // ---------------------------------------------------------------------------------------
        // Codice 00401  2.2.1.14 <Natura> presente a fronte di 2.2.1.12 <AliquotaIVA> diversa da zero
        if (not LDettaglioLinea.Natura.Trim.IsEmpty) and (LDettaglioLinea.AliquotaIVA.Replace('.', '').ToInteger <> 0) then
          result.Add(TeiValidationFactory.NewValidationResult(LInfo, '00401',
            '2.2.1.14 <Natura> presente a fronte di 2.2.1.12 <AliquotaIVA> diversa da zero', TeiSeverityType.stError));
      end;
    end);

end;

end.
