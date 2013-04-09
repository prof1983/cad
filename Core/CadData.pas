{**
@Abstract Общие переменные для Cad
@Author Prof1983 <prof1983@ya.ru>
@Created 02.07.2009
@LastMod 09.04.2013

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
  ABase,
  CadCoreBase;

const
  CAD_PRECISION_CHR: array[TCadPrecision] of APascalString = ('D', 'S', 'T');
  CAD_PRECISION_INT: array[TCadPrecision] of AInteger = (0, 1, 2);

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
 