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
unit DForce.ei.Invoice.Attachments.Interfaces;

interface

uses
  System.Classes;

type

  IeiAttachment = Interface
    ['{1064C797-396E-464E-A373-AA57239486FA}']
    procedure LoadFromStream(const AStream: TStream);
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToStream(const AStream: TStream);
    procedure SaveToFile(const APath: string);
    procedure SaveToFileAs(const AFileName: string);
    // NomeAttachments
    function GetNomeAttachment: string;
    property NomeAttachment: string read GetNomeAttachment;
    // AlgoritmoCompressione
    function GetAlgoritmoCompressione: string;
    property AlgoritmoCompressione: string read GetAlgoritmoCompressione;
    // FormatoAttachment
    function GetFormatoAttachment: string;
    property FormatoAttachment: string read GetFormatoAttachment;
    // DescrizioneAttachment
    function GetDescrizioneAttachment: string;
    property DescrizioneAttachment: string read GetDescrizioneAttachment;
  end;

  IeiAttachments = Interface
    ['{29D329CC-EDCD-4E98-ABAD-027A4A79F348}']
    function Add(const ANomeAttachment: string; const AFormatoAttachment: string = ''; const AAlgoritmoCompressione: string = ''; const ADescrizioneAttachment: string = '')
      : IeiAttachment;
    function GetList: TStringList;
    procedure FillList(const AStringList: TStringList);
    function IndexOf(const AName: string): integer;
    function Count: integer;
    // Items
    function GetItems(const AIndex: integer): IeiAttachment;
    property Items[const AIndex: integer]: IeiAttachment read GetItems;
    // Values
    function GetValues(const AAttachmentName: string): IeiAttachment;
    property Values[const AAttachmentName: string]: IeiAttachment read GetValues; default;
  end;

implementation

end.
