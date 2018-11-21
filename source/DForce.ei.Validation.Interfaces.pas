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
unit DForce.ei.Validation.Interfaces;

interface

uses DForce.ei.GenericCollection.Interfaces,
  DForce.ei.GenericCollection;

type

  TeiSeverityType = (stHint, stWarning, stError);

  IeiValidationResultInt = interface
    ['{1122D41C-97BE-4572-9A8A-1527170294E3}']
    function ToString: string;
    function GetInfo: string;
    function GetCode: string;
    function GetDescription: string;
    function GetSeverity: TeiSeverityType;
    procedure SetInfo(const Value: string);
    procedure SetCode(const Value: string);
    procedure SetDescription(const Value: string);
    procedure SetSeverity(const Value: TeiSeverityType);
    property Info: string read GetInfo write SetInfo;
    property Code: string read GetCode write SetCode;
    property Description: string read GetDescription write SetDescription;
    property Severity: TeiSeverityType read GetSeverity write SetSeverity;
  end;

  IeiValidationResultCollectionInt = IeiCollection<IeiValidationResultInt>;
  TeiValidationResultCollection = TeiCollection<IeiValidationResultInt>;

implementation

initialization

end.
