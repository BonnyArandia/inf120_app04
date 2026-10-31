unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnCortes: TButton;
    btnEntreCortes: TButton;
    btnParImpar: TButton;
    btnIntercalar: TButton;
    btnPurgar: TButton;

    edtA: TEdit;
    edtB: TEdit;

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;

    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    Memo1: TMemo;

    procedure btnCortesClick(Sender: TObject);
    procedure btnEntreCortesClick(Sender: TObject);
    procedure btnParImparClick(Sender: TObject);
    procedure btnIntercalarClick(Sender: TObject);
    procedure btnPurgarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    va, vb, vc, vd : VectorPlus;
    procedure titulos(t1, t2, t3: string);
    procedure limpiar();
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  va := VectorPlus.crear();
  vb := VectorPlus.crear();
  vc := VectorPlus.crear();
  vd := VectorPlus.crear();
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  va.Free;
  vb.Free;
  vc.Free;
  vd.Free;
end;


procedure TForm1.titulos(t1, t2, t3: string);
begin
  Label3.Caption := t1;
  Label4.Caption := t2;
  Label5.Caption := t3;
end;

procedure TForm1.limpiar();
begin
  vb.vaciar();
  vc.vaciar();
  vb.descargar(StringGrid2);
  vc.descargar(StringGrid3);
end;

procedure TForm1.btnCortesClick(Sender: TObject);
begin
  va.cargarDeTexto(edtA.Text);
  limpiar();
  titulos('A', '', '');
  va.descargar(StringGrid1);
  Memo1.Lines.Add('A = ' + va.comoString());
  Memo1.Lines.Add('Cantidad de cortes de control: ' + IntToStr(va.cantCortes()));
end;

procedure TForm1.btnEntreCortesClick(Sender: TObject);
var
  i: integer;
begin
  va.cargarDeTexto(edtA.Text);
  va.cantEntreCortes(vb, vc);
  titulos('A', 'Valor del grupo', 'Cantidad');
  va.descargar(StringGrid1);
  vb.descargar(StringGrid2);
  vc.descargar(StringGrid3);
  Memo1.Lines.Add('A = ' + va.comoString());
  for i := 1 to vb.getDim() do
    Memo1.Lines.Add('  Corte ' + IntToStr(i) + ': valor ' + IntToStr(vb.getElem(i)) +
                    ' -> ' + IntToStr(vc.getElem(i)) + ' elemento(s)');
end;

procedure TForm1.btnParImparClick(Sender: TObject);
begin
  va.cargarDeTexto(edtA.Text);
  va.dividirParImpar(vb, vc);
  titulos('A', 'Pares', 'Impares');
  va.descargar(StringGrid1);
  vb.descargar(StringGrid2);
  vc.descargar(StringGrid3);
  Memo1.Lines.Add('A = ' + va.comoString());
  Memo1.Lines.Add('Pares   = ' + vb.comoString());
  Memo1.Lines.Add('Impares = ' + vc.comoString());
end;

procedure TForm1.btnIntercalarClick(Sender: TObject);
begin
  va.cargarDeTexto(edtA.Text);
  vb.cargarDeTexto(edtB.Text);
  vd.intercalar(va, vb);
  titulos('A', 'B', 'Intercalado');
  va.descargar(StringGrid1);
  vb.descargar(StringGrid2);
  vd.descargar(StringGrid3);
  Memo1.Lines.Add('A = ' + va.comoString());
  Memo1.Lines.Add('B = ' + vb.comoString());
  Memo1.Lines.Add('Intercalado = ' + vd.comoString());
end;

procedure TForm1.btnPurgarClick(Sender: TObject);
begin
  va.cargarDeTexto(edtA.Text);
  va.descargar(StringGrid1);
  Memo1.Lines.Add('Antes   : ' + va.comoString());
  va.purgarCortes();
  limpiar();
  titulos('Antes', 'Purgado', '');
  va.descargar(StringGrid2);
  Memo1.Lines.Add('Purgado : ' + va.comoString());
end;

end.
