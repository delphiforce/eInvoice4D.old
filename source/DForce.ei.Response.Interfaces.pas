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
unit DForce.ei.Response.Interfaces;

interface

uses
  System.Generics.Collections, DForce.ei.GenericCollection.Interfaces,
  DForce.ei.Invoice.Interfaces;

type

  TeiResponseTypeInt = (rtUnknown, rtException, rtAcceptedByProvider, rtRejectedByProvider, rtSDIMessageRC, rtSDIMessageNS,
    rtSDIMessageMC, rtSDIMessageNEAccepted, rtSDIMessageNERejected, rtSDIMessageMT, rtSDIMessageEC, rtSDIMessageSE, rtSDIMessageDT,
    rtSDIMessageAT, rtReceivedFromProvider);

  IeiResponseBase = interface
    ['{7614F698-78A6-4A29-A189-00E798DC4C26}']
    // da implementare se rilevati comportamenti comuni
  end;

  IeiResponseEx = interface(IeiResponseBase)
    ['{7FC9F98A-881D-4499-A85F-95EAD982AFF1}']
    // FileName
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    property FileName: string read GetFileName write SetFileName;
    // ResponseDate
    // TODO: responseDate to identificate excatly
    function GetResponseDate: TDateTime;
    procedure SetResponseDate(const AValue: TDateTime);
    property ResponseDate: TDateTime read GetResponseDate write SetResponseDate;
    // Status: stato dell'azione sulla fattura
    function GetResponseType: TeiResponseTypeInt;
    procedure SetResponseType(const AValue: TeiResponseTypeInt);
    property ResponseType: TeiResponseTypeInt read GetResponseType write SetResponseType;
    // NotificationDate
    function GetNotificationDate: TDateTime;
    procedure SetNotificationDate(const AValue: TDateTime);
    property NotificationDate: TDateTime read GetNotificationDate write SetNotificationDate;
    // MsgCode
    function GetMsgCode: string;
    procedure SetMsgCode(const AValue: string);
    property MsgCode: string read GetMsgCode write SetMsgCode;
    // MsgText
    function GetMsgText: string;
    procedure SetMsgText(const AValue: string);
    property MsgText: string read GetMsgText write SetMsgText;
    // RawResponse
    function GetMsgRaw: string;
    procedure SetMsgRaw(const AValue: string);
    property MsgRaw: string read GetMsgRaw write SetMsgRaw;
    // Invoice
    function GetInvoice: IeiInvoiceEx;
    procedure SetInvoice(const AInvoice: IeiInvoiceEx);
    property Invoice: IeiInvoiceEx read GetInvoice write SetInvoice;
  end;

  IeiResponseCollectionEx = IeiCollection<IeiResponseEx>;

implementation

end.
