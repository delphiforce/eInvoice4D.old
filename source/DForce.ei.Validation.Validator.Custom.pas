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
unit DForce.ei.Validation.Validator.Custom;

interface

type

  TeiValidationCustom = class
  public
    class procedure RegisterMethods;
  end;

implementation

uses DForce.ei.Validation.Engine, DForce.ei.Invoice.Interfaces,
  DForce.ei.Validation.Interfaces, DForce.ei.Validation.Factory, System.SysUtils;

{ TeiValidationCustoms }

class procedure TeiValidationCustom.RegisterMethods;
begin

  // invoice rows validators
  TeiValidationEngine.RegisterValidationMethod(
    function(const AInvoice: IeiInvoiceEx): IeiValidationResultCollectionInt
    begin

      result := TeiValidationFactory.NewValidationResultCollection;

      // Example:
      // ---------------------------------------------------------------------------------------
      // Codice 00300  1.1.1.2 <IdCodice> non valido
      // if (AInvoice.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdPaese = 'IT') and
      // (AInvoice.FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente.IdCodice.Length <> 11) then
      // result.Add(TeiValidationFactory.NewValidationResult('FatturaElettronicaHeader.DatiTrasmissione.IdTrasmittente', '00300',
      // '1.1.1.2 <IdCodice> non valido', TeiSeverityType.stError));

    end);

end;

end.
