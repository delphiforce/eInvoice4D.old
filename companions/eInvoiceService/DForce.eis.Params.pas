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
unit DForce.eis.Params;

interface

const
  CRYPTO_KEY = 61248;
  CRYPTO_K1 = 15238;
  CRYPTO_K2 = 23719;

type
  TeisParams = class
  private
    class var FProviderID: string;
    class var FUserName: string;
    class var FPassword: string;
    class var FBaseUrlWS: string;
    class var FBaseUrlAuth: string;
    class var FPollingTimeMinutes: integer;
    class var FLoopWaitingMillisec: integer;
    class var FEnableReceiveSalesNotifications: boolean;
    class var FEnableSendSalesInvoices: boolean;
    class var FEnableReceivePurchaseInvoices: boolean;
    class procedure Load;
  public
    class property ProviderID: string read FProviderID;
    class property UserName: string read FUserName;
    class property Password: string read FPassword;
    class property BaseUrlWS: string read FBaseUrlWS;
    class property BaseUrlAuth: string read FBaseUrlAuth;
    class property PollingTimeMinutes: integer read FPollingTimeMinutes;
    class property LoopWaitingMillisec: integer read FLoopWaitingMillisec;
    class property EnableSendSalesInvoices: boolean read FEnableSendSalesInvoices;
    class property EnableReceiveSalesNotifications: boolean read FEnableReceiveSalesNotifications;
    class property EnableReceivePurchaseInvoices: boolean read FEnableReceivePurchaseInvoices;
  end;

implementation

uses IniFiles, DForce.ei, DForce.eis.Crypto;

{ TeisParams }

class procedure TeisParams.Load;
var
  LIniFile: TMemIniFile;
  TmpStr: String;
begin
  LIniFile := TMemIniFile.Create('eisParams.ini');
  try
    // Load param values
    FProviderID := LIniFile.ReadString('EIS', 'ProviderID', 'ARUBA_WS');

    TmpStr := LIniFile.ReadString('EIS', 'UserName', '');
    FUserName := TeisCrypto.DecryptStr(TmpStr , CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);

    TmpStr := LIniFile.ReadString('EIS', 'Password', '');
    FPassword := TeisCrypto.DecryptStr(TmpStr, CRYPTO_KEY, CRYPTO_K1, CRYPTO_K2);

    FBaseUrlWS := LIniFile.ReadString('EIS', 'BaseUrl', '');
    FBaseUrlAuth := LIniFile.ReadString('EIS', 'BaseUrlAuth', '');
    FLoopWaitingMillisec := LIniFile.ReadInteger('EIS', 'LoopWaitingMillisec', 1000);
    FPollingTimeMinutes := (60 * LIniFile.ReadInteger('EIS', 'PollingTimeMinutes', 10));
    FEnableReceiveSalesNotifications := LIniFile.ReadBool('EIS', 'EnableReceiveSalesNotifications', True);
    FEnableSendSalesInvoices := LIniFile.ReadBool('EIS', 'EnableSendSalesInvoices', True);
    FEnableReceivePurchaseInvoices := LIniFile.ReadBool('EIS', 'EnableReceivePurchaseInvoices', True);

    ei.SelectProvider(FProviderID, FUserName, FPassword);
  finally
    LIniFile.Free;
  end;
end;

initialization

TeisParams.Load;

end.
