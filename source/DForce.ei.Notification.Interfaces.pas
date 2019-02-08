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
unit DForce.ei.Notification.Interfaces;

interface

uses System.Classes, DForce.ei.Notification.NS.Base, DForce.ei.Notification.NE.Base;

type

  IeiNotificationCommon = interface
    ['{4A0F64ED-D33E-49D3-9A4E-5F7F446AC449}']
    // RawXML
    procedure SetRawXML(const AXml: string);
    function GetRawXML: string;
    property RawXML: String read GetRawXML write SetRawXML;
  end;

  IeiNotificationNSEx = interface(IXMLNotificaNSType)
    ['{BB98D776-9CB7-4EE2-88D0-A61D94B3D3E3}']
    function ToString: String;
    function ToStringBase64: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
  end;

  IeiNotificationNEEx = interface(IXMLNotificaNEType)
    ['{DAEA6757-1F6B-4D40-BD46-E0B0E4B10C4D}']
    function ToString: String;
    function ToStringBase64: String;
    procedure SaveToFile(const AFileName: String);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToStreamBase64(const AStream: TStream);
    function InvoiceAccepted: Boolean;
  end;

implementation

end.
