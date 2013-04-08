{**
@Abstract Общие переменные для Cad
@Author Prof1983 <prof1983@ya.ru>
@Created 02.07.2009
@LastMod 08.04.2013

     ===========
     | CadData |
     ===========
       |    |
---------  ---------------
| ABase |  | CadCoreBase |
---------  ---------------
}
unit CadData;

interface

uses
  Types,
  ABase,
  CadCoreBase;

const
  CAD_PRECISION_CHR: array[TCadPrecision] of APascalString = ('D', 'S', 'T');
  CAD_PRECISION_INT: array[TCadPrecision] of AInteger = (0, 1, 2);

type
  TBranchIrs = record
    BranchNum: Integer;    // 0 - номер ветви
    NodeNum1: Integer;     // 1 = Ex_Data_Uz[j,0] - номер узла начала ветви
    NodeNum2: Integer;     // 2 = Ex_Data_Uz[j,0] - номер узла конца ветви
    PlaNum: Integer;       // 3 = NomPla = Branch.Brn.ExtData3.Data1 - позиция ПЛА
    PlaColor: Integer;     // 4 = Branch.Brn.ExtData3.Color - цвет Позиции ПЛА
    ArrowIsFresh: Integer; // 6 - Цвет стрелки (свежая, исходящая) (0(False)-clBlue else 1(True)-clRed)
    LineType7: Integer;    // 7 - Тип линии (1,14 - Пунктирная (штриховая)) // тип выработки
    Name: string;          // Наименование ветви
  end;

type
  TExDataNodeRec = record
    Nd0: Integer; // 0 - Items[I].NdNum - номер узла
    Nd1: Integer; // 1 - Items[I].NdPnt.X - координаты узла
    Nd2: Integer; // 2 - Items[I].NdPnt.Y - координаты узла
    Nd3: Integer; // 3 - Items[I].NdPntZ - координаты узла
    Nd4: Integer; // 4 - Items[I].NdType - узел поверхности или нет
  end;

type
  TPolyRec = record
    {** номер индекса в массиве Ex_Data_Branch }
    IndEx: Integer;
    {** число узлов полилинии }
    NumNode: Integer;
    PolyCoord: array of TPoint;
  end;

// --- Vars ---

var DrawFlag: AInt;

{** Имя файла }
var DrawFileName: APascalString;

var IsModify: Boolean;

var CadImgPath: APascalString;

var StrokaUo: APascalString;

{** Имя открываемого файла }
var OrigFileName: string;

var
  {** Передача полилиний }
  Ex_PolyLine: array of TPolyRec;
  {** Полностью соответсвует таблице TablDavl с Row-2 }
  Ex_Data_Uz: array of TExDataNodeRec;
  {** Внешние данные ветвей (Irs) }
  Ex_Data_Branch: array of TBranchIrs;

function CadPrecisionFromChar(const Value: AChar): TCadPrecision;
function CadPrecisionFromInt(Value: AInt): TCadPrecision;

implementation

function CadPrecisionFromChar(const Value: AChar): TCadPrecision;
var
  p: TCadPrecision;
begin
  for p := Low(p) to High(p) do
  begin
    if (CAD_PRECISION_CHR[p] = Value) then
    begin
      Result := p;
      Exit;
    end;
  end;
  Result := Precision0;
end;

function CadPrecisionFromInt(Value: AInt): TCadPrecision;
var
  p: TCadPrecision;
begin
  for p := Low(p) to High(p) do
  begin
    if (CAD_PRECISION_INT[p] = Value) then
    begin
      Result := p;
      Exit;
    end;
  end;
  Result := Precision0;
end;

end.
 