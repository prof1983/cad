{**
@Abstract Cad.App data convert
@Author Prof1983 <prof1983@ya.ru>
@Created 27.07.2010
@LastMod 14.03.2013

        ----------
        | CadApp |
        ----------
             |
      =====================
      | CadAppDataConvert |
      =====================
           |           |
 -------------------  --------------
 | CadAppDataUtils |  | CadAppData |
 -------------------  --------------
      |       |
---------   ------------
| fData |   | fDrawWin |
---------   ------------
}
unit CadAppDataConvert;

{$IFNDEF NoVcl}{$DEFINE VCL}{$ENDIF}

{$IFDEF DEGASAPP} {$DEFINE DEGAS} {$ENDIF}
{$IFDEF DEGASDLL} {$DEFINE DEGAS} {$ENDIF}
{$IFDEF DEGAS} {$DEFINE DEGAS_OR_VENT} {$ENDIF}
{$IFDEF PLAN}  {$DEFINE PLAN_OR_VENT} {$ENDIF}
{$IFDEF VENT}  {$DEFINE DEGAS_OR_VENT} {$ENDIF}
{$IFDEF VENT}  {$DEFINE PLAN_OR_VENT} {$ENDIF}

interface

uses
  {$ifdef Vcl}
  Grids,
  {$endif}
  ABase,
  AStringMain,
  AUiGrids,
  AUtilsMain,
  CadAppDataUtils,
  CadCoreBase,
  CadData,
  CadStampData;

// --- Public ---

procedure PreobrDanStr(const StrokaDan: string; Version: AInt;
    TablData, TablDavl, TablVen, WayWorkerGrid, WaySaverGrid, VpGrid: TStringGrid; IsDan: ABool;
    var EdIzm: AInt; var Precision: TCadPrecision; var Stamp: TStampDataRec;
    var NameSh, NameVar, MUzlovPt, Tnar, Tsh, Pnar, Psh: APascalString);

implementation

// --- Private ---

function ReadString(var Stroka: string): string;
var
  P: Byte;
begin
  P := Pos(';',Stroka);
  if (P > 0) then
  begin
    Result := Copy(Stroka,1,P-1);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end
  else
  begin
    Result := Stroka;
    Stroka := '';
  end;
end;

function ReadChar8(var Stroka: string; Def: Char): Char;
var
  S: string;
begin
  S := AUtils_TrimP(ReadString(Stroka));
  if (S <> '') then
    Result := S[1]
  else
    Result := Def;
end;

function ReadChar(var Stroka: string; Def: AChar): AChar;
var
  S: AnsiString;
begin
  S := AUtils_TrimP(ReadString(Stroka));
  Result := AnsiString_GetChar(S, 1);
  if (Result = #0) then
    Result := Def;
end;

function ReadFloat(var Stroka: string; Def: AFloat): AFloat;
begin
  Result := AUtils_StrToFloatDefP(ReadString(Stroka), Def);
end;

function ReadInteger(var Stroka: string; Def: Integer = 0): Integer;
begin
  Result := AUtils_StrToIntDefP(ReadString(Stroka), Def);
end;

{$IFDEF VCL}
// Зачитывает данные узла (нет в PLAN)
procedure _PreobrDanStrNode(Tabl: TStringGrid; var Stroka: string; Row, Version: Integer);
// Tabl = TablDavl
{$IFDEF DEGAS_OR_VENT}
var
  I: Integer;
  P: Integer;
  S: string;
  {$ENDIF VENT_OR_DEGAS}
begin
  {$IFDEF DEGAS_OR_VENT}
  I := 0;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Inc(I);
    P := Pos(';',Stroka);
    S := Copy(Stroka,1,P-1);
    Tabl.Cells[I-1,Row] := S;
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;
  if (Version < 23) then
  begin
    Stroka := Tabl.Cells[6,Row];
    Tabl.Cells[6,Row] := Tabl.Cells[4,Row];
    Tabl.Cells[4,Row] := Stroka;
    Stroka := Tabl.Cells[5,Row];
    Tabl.Cells[5,Row] := Tabl.Cells[4,Row];
    Tabl.Cells[4,Row] := Stroka;
  end;
  {$ENDIF VENT_OR_DEGAS}
end;
{$ENDIF VCL}

procedure _Read_A(var Stroka: string; out EdIzm: AInt; out Precision: TCadPrecision;
    out NameSh, NameVar, Tnar, Tsh, Pnar, Psh: APascalString);
begin
  NameSh := ReadString(Stroka);
  NameVar := ReadString(Stroka);
  EdIzm := ReadInteger(Stroka, 1);
  if (EdIzm <> 60) then
    EdIzm := 1;
  Precision := CadPrecisionFromChar(ReadChar(Stroka, 'T'));

  ReadString(Stroka);
  ReadChar8(Stroka, 'N');
  ReadChar(Stroka, 'M');
  ReadChar(Stroka, 'O');
  Tnar := ReadString(Stroka);
  Tsh := ReadString(Stroka);
  Pnar := ReadString(Stroka);
  Psh := ReadString(Stroka);
end;

{$IFDEF VCL}
// Чтение ветви/периода
procedure _Read_D(TablData: TStringGrid; var Stroka: string; Row: Integer);
var
  Col: Integer;
  P: Byte;
begin
  Col := 0;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    P := Pos(';',Stroka);
    TablData.Cells[Col,Row] := AUtils_NormalizeStrP(Copy(Stroka,1,P-1));
    Inc(Col);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;
end;
{$ENDIF VCL}

procedure _Read_E_Stamp(var Stroka: string; var Stamp: TStampDataRec);
var
  P: Byte;
begin
  P := Pos(';',Stroka);
  if (P > 0) then
  begin
    Stamp.Ed1FontSize := ReadInteger(Stroka);
    Stamp.Ed1 := ReadString(Stroka);
    Stamp.Ed6 := ReadString(Stroka);
    Stamp.Ed7 := ReadString(Stroka);
    Stamp.Ed8 := ReadString(Stroka);
    Stamp.Ed9 := ReadString(Stroka);
    Stamp.Ed10 := ReadString(Stroka);
    Stamp.Ed11 := ReadString(Stroka);
    Stamp.Ed12 := ReadString(Stroka);
    Stamp.Ed13 := ReadString(Stroka);
    Stamp.Ed14 := ReadString(Stroka);
    Stamp.Ed15 := ReadString(Stroka);
    Stamp.Ed16 := ReadString(Stroka);
    Stamp.Ed17 := ReadString(Stroka);
    Stamp.Ed18 := ReadString(Stroka);
    Stamp.Ed19 := ReadString(Stroka);
    Stamp.Ed20 := ReadString(Stroka);
  end;
end;

{$IFDEF VCL}
procedure _Read_M(WayWorkerGrid: TStringGrid; var Stroka: string; var j1: Integer);
var
  i1: Integer;
  P: Byte;
begin
  i1 := 0;
  inc(j1);
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    inc(i1);
    P := Pos(';',Stroka);
    WayWorkerGrid.Cells[i1-1,j1-1] := Copy(Stroka,1,P-1);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;
end;
{$ENDIF VCL}

{$IFDEF VCL}
// Зачитывает данные узла (нет в PLAN)
procedure _Read_N(TablDavl: TStringGrid; var Stroka: string; Row, Version: Integer);
{$IFDEF DEGAS}
var
  Node: TNodeRec;
{$ENDIF DEGAS}
begin
  _PreobrDanStrNode(TablDavl, Stroka, Row, Version);
  {$IFDEF DEGAS}
  Data_GetNode(Row, Node);
  Nodes_Add1(Node);
  {$ENDIF}
end;
{$ENDIF VCL}

{$IFDEF VCL}
procedure _Read_P(VpGrid: TStringGrid; var Stroka: string; CountSP: Integer);
var
  i1: Integer;
  P: Integer;
begin
  i1 := 0;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Inc(i1);
    P := Pos(';',Stroka);
    VpGrid.Cells[1,i1-1] := Copy(Stroka,1,P-1);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;
end;
{$ENDIF VCL}

procedure _Read_Q_Stamp(var Stroka: string; var Stamp: TStampDataRec);
var
  P: Integer;
begin
  Stamp.Mem5FontSize := ReadInteger(Stroka);
  Stamp_ClearMem5();
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Stamp_AddMem5(ReadString(Stroka));
    P := Pos(';',Stroka);
  end;
end;

{$IFDEF VCL}
procedure _Read_S(WaySaverGrid: TStringGrid; var Stroka: string; var j2: Integer);
var
  i1: Integer;
  P: Byte;
begin
  i1 := 0;
  inc(j2);
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    inc(i1);
    P := Pos(';',Stroka);
    WaySaverGrid.Cells[i1-1,j2-1] := Copy(Stroka,1,P-1);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;
end;
{$ENDIF VCL}

{$IFDEF VCL}
// DEGAS or VENT: Читаем данные вентилятора/вакуум-насоса
procedure _Read_V(TablVen: TStringGrid; var Stroka: string; Row: Integer);
var
  i1: Integer;
  P: Byte;
  {$IFDEF DEGAS}Branch: TBranchRec;{$ENDIF}
begin
  i1 := 0;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Inc(i1);
    P := Pos(';',Stroka);
    TablVen.Cells[i1-1,Row] := Copy(Stroka,1,P-1);
    Stroka := Copy(Stroka,P+1,Length(Stroka)-P+1);
  end;

  {$IFDEF DEGAS}
  Data_GetBranch_(DrawWin.TablData, Row, Branch);
  Branchs_Add3(Branch);
  {$ENDIF DEGAS}
end;
{$ENDIF VCL}

procedure _Read_X_Stamp(var Stroka: string; var Stamp: TStampDataRec);
var
  P: Integer;
begin
  Stamp.Mem2FontSize := ReadInteger(Stroka);
  Stamp_ClearMem2;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Stamp_AddMem2(ReadString(Stroka));
    P := Pos(';',Stroka);
  end;
end;

procedure _Read_Y_Stamp(var Stroka: string; var Stamp: TStampDataRec);
var
  P: Integer;
begin
  Stamp.Mem3FontSize := ReadInteger(Stroka);
  Stamp_ClearMem3;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Stamp_AddMem3(ReadString(Stroka));
    P := Pos(';',Stroka);
  end;
end;

procedure _Read_Z_Stamp(var Stroka: string; var Stamp: TStampDataRec);
var
  P: Integer;
begin
  Stamp.Mem4FontSize := ReadInteger(Stroka);
  Stamp_ClearMem4;
  P := Pos(';',Stroka);
  while (P > 0) do
  begin
    Stamp_AddMem4(ReadString(Stroka));
    P := Pos(';',Stroka);
  end;
end;

{$IFDEF VCL}
procedure PreobrDanStr(const StrokaDan: string; Version: AInt;
    TablData, TablDavl, TablVen, WayWorkerGrid, WaySaverGrid, VpGrid: TStringGrid; IsDan: ABool;
    var EdIzm: AInt; var Precision: TCadPrecision; var Stamp: TStampDataRec;
    var NameSh, NameVar, MUzlovPt, Tnar, Tsh, Pnar, Psh: APascalString);
var
  ii: Integer;
  j1: Integer;
  jj: Integer;
  VidStr: Char;
  Stroka: string;
  CountBranchs: Integer;       // Кол-во ветвей
  CountVen: Integer;           // Кол-во вентиляторов j
  nuz: Integer;
  CountSP: Integer;
  i: Integer;                  // Счетчик для for
  CountNodes: Integer;         // Кол-во узлов
  k_: Integer; // k
begin
  CadAppDataUtils.Data_Clear();
  CountNodes := 0;
  CountBranchs := 0;           // Кол-во ветвей
  CountVen := 0;
  j1 := 0;
  CountSP := 0;
  Stroka := '';
  jj := 0;

  for ii := 1 to Length(StrokaDan)-1 do
  begin
    Inc(jj);
    Stroka := Stroka+StrokaDan[ii];
    if (Stroka[jj] = '#')
    or (IsDan and (Length(Stroka) >= 2) and
         (
            ((Stroka[Length(Stroka)-1] = #13) and (Stroka[Length(Stroka)] = #10)) or (ii = Length(StrokaDan)-1)
         )
       ) then
    begin
      if (Stroka[Length(Stroka)] = '#') then
        Stroka := Copy(Stroka, 1, Length(Stroka)-1);
      if ((Length(Stroka) >= 2) and (Stroka[1] = #13) and (Stroka[2] = #10)) then
        Stroka := Copy(Stroka, 3, Length(Stroka)-2);
      if ((Length(Stroka) >= 2) and (Stroka[Length(Stroka)-1] = #13) and (Stroka[Length(Stroka)] = #10)) then
        Stroka := Copy(Stroka, 1, Length(Stroka)-2);
      if (Length(Stroka) > 0) then
      begin
        VidStr := Stroka[1];

        k_ := Pos(';', Stroka);
        if (k_ > 0) then
          Stroka := Copy(Stroka, k_+1, Length(Stroka)-k_);

        case VidStr of
          'A': _Read_A(Stroka, EdIzm, Precision, NameSh, NameVar, Tnar, Tsh, Pnar, Psh);
          'U': // Узлы поверхности
            begin
              MUzlovPt := Stroka;
            end;
          'D': // Чтение ветви/периода
            begin
              _Read_D(TablData, Stroka, TablData.FixedRows+CountBranchs);
              Inc(CountBranchs);
            end;
          'V': // Вентилятор
            begin
              Inc(CountVen);
              _Read_V(TablVen, Stroka, CountVen+1);
            end;
          'N': // Узел
            begin
              _Read_N(TablDavl, Stroka, TablDavl.FixedRows+CountNodes, Version);
              Inc(CountNodes);
            end;
          'M':
            begin
              if Assigned(WayWorkerGrid) then
                _Read_M(WayWorkerGrid, Stroka, j1);
            end;
          'S':
            begin
              if Assigned(WaySaverGrid) then
                _Read_S(WaySaverGrid, Stroka, CountSP);
            end;
          'P':
            begin
              Inc(CountSP);
              if Assigned(VpGrid) then
                _Read_P(VpGrid, Stroka, CountSP);
            end;
          'E': _Read_E_Stamp(Stroka, Stamp);
          'X': _Read_X_Stamp(Stroka, Stamp);
          'Y': _Read_Y_Stamp(Stroka, Stamp);
          'Z': _Read_Z_Stamp(Stroka, Stamp);
          'Q': _Read_Q_Stamp(Stroka, Stamp);
        end; {case}
      end;
      Stroka := '';
      jj := 0;
    end;
  end;

  StringGrid_SetRowCount(TablData, TablData.FixedRows + CountBranchs);
  StringGrid_SetRowCount(TablVen, TablVen.FixedRows + CountVen);
  StringGrid_SetRowCount(TablDavl, TablDavl.FixedRows + CountNodes);
  StringGrid_SetRowCount(WayWorkerGrid, j1+1);
  StringGrid_SetRowCount(WaySaverGrid, CountSP + 1);
end; { PreobrDanStr }
{$ENDIF VCL} 

end.
