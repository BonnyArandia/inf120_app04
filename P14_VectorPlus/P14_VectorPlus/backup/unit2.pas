unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Grids;

const
  max_elem  = 200;   // capacidad del vector (el resultado de intercalar puede duplicar)
  max_carga = 100;   // maximo de elementos al cargar desde el cuadro de texto

type
  VectorPlus = class
  private
    elem : array[1..max_elem] of integer;
    dim  : integer;
  public
    constructor crear();

    // --- Basicos ---
    procedure cargarDeTexto(s: string);      // "3,3,5,5,5,7"
    procedure descargar(grid: TStringGrid);  // dibuja el vector en un grid
    function comoString(): string;
    function getDim(): integer;
    function getElem(pos: integer): integer;
    procedure vaciar();
    procedure adicionar(ele: integer);

    // --- Operaciones con cortes de control ---
    // Un CORTE DE CONTROL es el cambio de valor entre un elemento y el siguiente.
    // Cada grupo de elementos consecutivos iguales termina en un corte.
    function cantCortes(): integer;
    procedure cantEntreCortes(valores, cantidades: VectorPlus);
    procedure purgarCortes();

    // --- Otras operaciones ---
    procedure dividirParImpar(pares, impares: VectorPlus);
    procedure intercalar(a, b: VectorPlus);
  end;

implementation

constructor VectorPlus.crear();
var
  i: integer;
begin
  for i := 1 to max_elem do
    elem[i] := 0;
  dim := 0;
end;

procedure VectorPlus.cargarDeTexto(s: string);
var
  lista: TStringList;
  i, v: integer;
begin
  dim := 0;
  lista := TStringList.Create;
  try
    ExtractStrings([',', ';', ' ', '[', ']'], [], PChar(s), lista);
    for i := 0 to lista.Count - 1 do
      if (dim < max_carga) and TryStrToInt(lista[i], v) then
      begin
        dim := dim + 1;
        elem[dim] := v;
      end;
  finally
    lista.Free;
  end;
end;

procedure VectorPlus.descargar(grid: TStringGrid);
var
  i: integer;
begin
  grid.FixedRows := 0;
  grid.FixedCols := 0;
  grid.RowCount := 1;
  if dim < 1 then
  begin
    grid.ColCount := 1;
    grid.Cells[0, 0] := '';
    exit;
  end;
  grid.ColCount := dim;
  for i := 1 to dim do
    grid.Cells[i - 1, 0] := IntToStr(elem[i]);
end;

function VectorPlus.comoString(): string;
var
  i: integer;
begin
  Result := '[';
  for i := 1 to dim do
  begin
    Result := Result + IntToStr(elem[i]);
    if i < dim then
      Result := Result + ', ';
  end;
  Result := Result + ']';
end;

function VectorPlus.getDim(): integer;
begin
  Result := dim;
end;

function VectorPlus.getElem(pos: integer): integer;
begin
  if (pos >= 1) and (pos <= dim) then
    Result := elem[pos]
  else
    Result := -1;
end;

procedure VectorPlus.vaciar();
begin
  dim := 0;
end;

procedure VectorPlus.adicionar(ele: integer);
begin
  if dim < max_elem then
  begin
    dim := dim + 1;
    elem[dim] := ele;
  end;
end;

{ ===================== CORTES DE CONTROL ===================== }

// Cantidad de cortes de control = cantidad de grupos de elementos iguales consecutivos
// A=[3,3,5,5,5,7] => 3 cortes (grupos: 3,3 | 5,5,5 | 7)
function VectorPlus.cantCortes(): integer;
var
  i: integer;
begin
  if dim = 0 then
  begin
    Result := 0;
    exit;
  end;
  Result := 1;
  for i := 2 to dim do
    if elem[i] <> elem[i - 1] then
      Result := Result + 1;
end;

// Cantidad de elementos de cada grupo.
// A=[3,3,5,5,5,7] => valores=[3,5,7]  cantidades=[2,3,1]
procedure VectorPlus.cantEntreCortes(valores, cantidades: VectorPlus);
var
  i, cant: integer;
begin
  valores.vaciar();
  cantidades.vaciar();
  if dim = 0 then
    exit;
  cant := 1;
  for i := 2 to dim do
    if elem[i] = elem[i - 1] then
      cant := cant + 1
    else
    begin
      valores.adicionar(elem[i - 1]);
      cantidades.adicionar(cant);
      cant := 1;
    end;
  valores.adicionar(elem[dim]);     // el ultimo grupo
  cantidades.adicionar(cant);
end;

// Purga: deja un solo elemento por grupo (modifica este vector)
// A=[3,3,5,5,5,7] => A=[3,5,7]
procedure VectorPlus.purgarCortes();
var
  i, k: integer;
begin
  if dim < 2 then
    exit;
  k := 1;
  for i := 2 to dim do
    if elem[i] <> elem[k] then
    begin
      k := k + 1;
      elem[k] := elem[i];
    end;
  dim := k;
end;

{ ===================== OTRAS OPERACIONES ===================== }

// Los elementos de valor par van a "pares" y los de valor impar a "impares"
procedure VectorPlus.dividirParImpar(pares, impares: VectorPlus);
var
  i: integer;
begin
  pares.vaciar();
  impares.vaciar();
  for i := 1 to dim do
    if elem[i] mod 2 = 0 then
      pares.adicionar(elem[i])
    else
      impares.adicionar(elem[i]);
end;

// Este vector queda con: A1, B1, A2, B2, ...  (si uno es mas largo, sus
// elementos sobrantes se agregan al final)
procedure VectorPlus.intercalar(a, b: VectorPlus);
var
  i, n: integer;
begin
  vaciar();
  if a.getDim() > b.getDim() then
    n := a.getDim()
  else
    n := b.getDim();
  for i := 1 to n do
  begin
    if i <= a.getDim() then
      adicionar(a.getElem(i));
    if i <= b.getDim() then
      adicionar(b.getElem(i));
  end;
end;

end.
