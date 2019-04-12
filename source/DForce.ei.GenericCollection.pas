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
unit DForce.ei.GenericCollection;

interface

uses
  DForce.ei.GenericCollection.Interfaces, System.Generics.Collections;

type

  TeiCollection<T> = class(TInterfacedObject, IeiCollection<T>)
  private
    FContainer: TList<T>;
  protected
    procedure Clear;
    function Add(const AItem: T): Integer;
    function GetEnumerator: TEnumerator<T>;
    procedure AddRange(const Collection: IeiCollection<T>);
    procedure Delete(const AIndex: Integer);
    // Count
    function GetCount: Integer;
    // Items
    procedure SetItem(Index: Integer; const AItem: T);
    function GetItem(Index: Integer): T;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

implementation

{ TeiCollection<T> }

function TeiCollection<T>.Add(const AItem: T): Integer;
begin
  FContainer.Add(AItem);
end;

procedure TeiCollection<T>.AddRange(const Collection: IeiCollection<T>);
var
  LItem: T;
begin
  for LItem in Collection do
    FContainer.Add(LItem);
end;

procedure TeiCollection<T>.Clear;
begin
  FContainer.Clear;
end;

constructor TeiCollection<T>.Create;
begin
  inherited;
  FContainer := TList<T>.Create;
end;

procedure TeiCollection<T>.Delete(const AIndex: Integer);
begin
  FContainer.Delete(AIndex);
end;

destructor TeiCollection<T>.Destroy;
begin
  FContainer.Free;
  inherited;
end;

function TeiCollection<T>.GetCount: Integer;
begin
  Result := FContainer.Count;
end;

function TeiCollection<T>.GetEnumerator: TEnumerator<T>;
begin
  Result := FContainer.GetEnumerator;
end;

function TeiCollection<T>.GetItem(Index: Integer): T;
begin
  Result := FContainer.Items[Index];
end;

procedure TeiCollection<T>.SetItem(Index: Integer; const AItem: T);
begin
  FContainer.Items[Index] := AItem;
end;

end.
