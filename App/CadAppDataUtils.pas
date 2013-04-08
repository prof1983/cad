{**
@Abstract Cad.App - DataUtils
@Author Prof1983 <prof1983@ya.ru>
@Created 13.08.2009
@LastMod 08.04.2013

                       ----------
                       | CadApp |
                       ----------
                           |
                  ---------------------
                  | CadAppDataConvert |
                  ---------------------
                           |
                  =======================
                  |   CadAppDataUtils   |
                  =======================
           /       |             |           \
-----------  -----------  --------------  ----------
| CadCore |  | CadDraw |  | CadAppData |  | AUtils |
-----------  -----------  --------------  ----------
}
unit CadAppDataUtils;

{$ifndef NoVcl}
  {$define Vcl}
{$endif}

interface

uses
  ABase,
  ABaseTypes,
  AUiBase,
  AUiGrids,
  AUtilsMain,
  CadAppData,
  CadCoreBase,
  CadDrawBase,
  CadDrawPrimitive,
  CadDrawScene;

const
  DataPage0 = 0; // Общие
  DataPage1 = 1; // Ветви
  DataPage2 = 2; // Вентиляторы
  DataPage4 = 4;
  DataPage6 = 6;
  DataPage7 = 7;

// --- Data ---

function Data_Clear(): AError;

function Data_Branch_IsVentilator_ByRow(TablData: AStringGrid; BranchRow: AInt): ABool;

function Data_Branch_SetPosition(BranchNum: AInt): AError;

function Data_Branch_SetPositionA(DataGrid: AStringGrid; BranchNum: AInt): AError;

{** Компилирует внешние данные. Заполнение массива PrData -> массив свойств (заполнение массива свойств). }
function Data_CompileExtData(DataGrid1, NodesGrid1: AStringGrid; VCell, CCell: AInt;
    Status_Regim: AChar): AError;

{** Возвращает номер строки по номеру ветви }
function Data_FindBranch(BranchNum: AInt): AInt;

{** Возвращает номер строки для узла n }
function Data_FindNode(NodeNum: AInt): AInt;

function Data_FindVenA(TablVen1: AStringGrid; NomVetvi: AInt): AInt;

function Data_FindStolb(Num: AInt): AInt;

function Data_Node_Delete(TablDavl: AStringGrid; NodeNum: AInt): AError;

function Data_Node_SetPosition(NodeNum: AInt): AError;

{** Проверяет отсутствующие на схеме ветви }
function Data_Prepare_CheckBranchs2(GenericTable1: AStringGrid; LogProc: TCadLogProc): Boolean;

function Data_QuickSort(Grid: AStringGrid): AError;

function Data_SetBranchNameP(TablData1: AStringGrid; BranchNum, NameCol: AInt;
    const Value: APascalString): AError;

function Data_Stolb_SetPosition(StolbNum: AInt): AError;

implementation

{$ifdef Vcl}
uses
  ComCtrls,
  Grids,
  SysUtils;
{$endif}

// --- Private ---

{ Grid - Таблица узлов. В колонке 0 в этой таблице должны быть указаны номера узлов.
  NomUzel - Номер узла }
procedure _SetNodePosition(Grid1: AStringGrid; NomUzel: AInt);
{$IFDEF VCL}
var
  TR: Integer;
  ns: Integer; // Row
  SRect: TGridRect;
  Grid: TStringGrid;
{$ENDIF VCL}
begin
{$IFDEF VCL}
  Grid := TStringGrid(Grid1);
  if not(Assigned(Grid)) then Exit;

  TR := Grid.TopRow;
  ns := AUiGrid_FindInt(Grid1, 0, NomUzel);
  if (ns > 0) then
  begin
    SRect.Top := ns;
    SRect.Left := 0;
    SRect.Bottom := ns;
    SRect.Right := 0;
    Grid.LeftCol := 0;
    if ((ns < Grid.TopRow) or (ns > Grid.TopRow + Grid.VisibleRowCount)) then
      TR := ns-2;
    if (TR > 2) then
      Grid.TopRow := TR
    else
      Grid.TopRow := 2;
    Grid.Selection := SRect;
  end;
{$ENDIF VCL}
  if Assigned(OnNodeFocus) then
    OnNodeFocus();
end;

// --- Data ---

function Data_Branch_IsVentilator_ByRow(TablData: AStringGrid; BranchRow: AInteger): ABoolean;
begin
{$IFDEF VCL}
  Result := (AUtils_TrimP(TStringGrid(TablData).Cells[3,BranchRow]) = 'В');
{$ELSE}
  Result := False;
{$ENDIF VCL}
end;

function Data_Branch_SetPosition(BranchNum: AInt): AError;
begin
  try
    CadAppDataUtils.Data_Branch_SetPositionA(BranchGrid, BranchNum);
    if Assigned(OnSetPosition) then
      Result := OnSetPosition(0, BranchNum)
    else
      Result := 0;
  except
    Result := -1;
  end;
end;

function Data_Branch_SetPositionA(DataGrid: AStringGrid; BranchNum: AInt): AError;
{$IFDEF VCL}
var
  TR: Integer;
  SRect: TGridRect;
  Row: Integer;
  PrevCol: Integer; // Колонка на которой находился курсор до перехода
  TablData: TStringGrid;
{$ENDIF VCL}
begin
  Result := 0;
{$IFDEF VCL}
  TablData := TStringGrid(DataGrid);
  PrevCol := TablData.Col;
  Row := AUiGrid_FindInt(AControl(TablData), 0, BranchNum);
  if (Row > 0) then
    TablData.Row := Row;
  TR := TablData.TopRow;
  Row := AUiGrid_FindInt(AControl(TablData), 0, BranchNum);
  if (Row > 0) then
  begin
    SRect.Top := Row;
    SRect.Left := 0;
    SRect.Bottom := Row;
    SRect.Right := 0;
    TablData.LeftCol := 0;
    if ((Row < TablData.TopRow) or (Row > TablData.TopRow + TablData.VisibleRowCount)) then
      TR := Row - TablData.FixedRows;
    if (TR > TablData.FixedRows) then
      TablData.TopRow := TR
    else
      TablData.TopRow := TablData.FixedRows;
    TablData.Selection := SRect;
    TablData.Col := PrevCol;
  end;
{$ENDIF VCL}
end;

function Data_Clear(): AError;
begin
  try
    AUiGrid_Clear(BranchGrid);
    AUiGrid_Clear(NodeGrid);
    AUiGrid_Clear(VenGrid);
    if Assigned(OnDataClear) then
      Result := OnDataClear()
    else
      Result := 0;
  except
    Result := -1;
  end;
end;

function Data_CompileExtData(DataGrid1, NodesGrid1: AStringGrid; VCell, CCell: AInt;
    Status_Regim: AChar): AError;
{$IFDEF VCL}
var
  I: Integer;
  y: Integer;
  nv: Integer; // Номер ветви
  s: string;
  NodeNum: Integer;
  Branch: TGBranch;
  BranchRow: Integer; // AInd
  Coll: TGCollFigure;
  DataGrid: TStringGrid;
  NodesGrid: TStringGrid;
{$ENDIF VCL}
begin
  Result := 0;
  {$IFDEF VCL}
  DataGrid := TStringGrid(DataGrid1);
  NodesGrid := TStringGrid(NodesGrid1);
  try
    Coll := Scene.Coll;
    nv := 0;
    if (DataGrid1 <> 0) then
    begin
      // Разбираем все строки
      for I := DataGrid.FixedRows to DataGrid.RowCount - 1 do
      begin
        s := AUtils_TrimP(DataGrid.Cells[0,I]);
        if (s <> '') and (s <> 'ветви') and AUtils_TryStrToIntP(s, nv) then
        begin
          for y := 0 to Coll.FigCount - 1 do
          begin
            if (Coll.Data[y] is TGBranch) then
            begin
              Branch := TGBranch(Coll.Data[y]);
              Branch.Brn.ExtData3_NomPla := Branch.Brn.ExtData3.Data1;
            end;
          end;
        end;
      end;

      // Заполнение массива PrData -> массив свойств (заполнение массива свойств)
      for I := 0 to Coll.FigCount-1 do
      begin
        if (Coll.Data[I] is TGBranch) then
        begin
          Branch := TGBranch(Coll.Data[I]);
          BranchRow := Data_FindBranch(Branch.Brn.BrNum);
          if (BranchRow >= 0) then
          begin
            // Указываем значение расхода
            if (Status_Regim = 'D') then
            begin
              Branch.SetPropValue(PrData_Q, DataGrid.Cells[10,BranchRow]);
            end
            else if (Status_Regim = 'N') then
            begin
              Branch.SetPropValue(PrData_Q, DataGrid.Cells[11,BranchRow]);
              Branch.Brn.ExtDataQ_Value := AUtils_StrToFloatP(DataGrid.Cells[11,BranchRow]);
            end
            else if (Status_Regim = 'A') then
            begin
              Branch.SetPropValue(PrData_Q, DataGrid.Cells[12,BranchRow]);
              Branch.Brn.ExtDataQ_Value := AUtils_StrToFloatP(DataGrid.Cells[12,BranchRow]);
            end
            else
            begin
              Branch.SetPropValue(PrData_Q, '0');
              Branch.Brn.ExtDataQ_Value := 0;
            end;

            // Указываем сечение
            Branch.SetPropValue(PrData_S, DataGrid.Cells[6,BranchRow]);
            Branch.SetPropValue(PrData_V, DataGrid.Cells[VCell,BranchRow]);
            // Указываем длину ветви
            Branch.SetPropValue(PrData_L, DataGrid.Cells[5,BranchRow]);
            // Указываем концентрацию метана
            Branch.SetPropValue(PrData_C, DataGrid.Cells[CCell,BranchRow]);
          end;
        end;
      end;
    end;

    if Assigned(NodesGrid) then
    begin
      begin
        // Строчка за строчкой разбираем
        for I := NodesGrid.FixedRows to NodesGrid.RowCount do
        begin
          NodeNum := 0;
          s := AUtils_TrimP(NodesGrid.Cells[0,I]);
          if (s <> '') and (s <> '№') and (s <> 'узла') and (AUtils_TryStrToIntP(s, NodeNum)) and (NodeNum > 0) then
          begin
            Coll.NodeList.Node_SetData(NodeNum,
                AUtils_StrToFloatP(NodesGrid.Cells[4,I]),
                AUtils_StrToFloatP(NodesGrid.Cells[5,I]),
                AUtils_StrToFloatP(NodesGrid.Cells[6,I]),
                AUtils_FloatToStr2P(AUtils_StrToFloatP(NodesGrid.Cells[1,I]), 2, False, False));
          end;
        end;
      end;
    end;
  except
    Result := -1;
  end;
  {$ENDIF VCL}
end;

function Data_FindBranch(BranchNum: AInt): AInt;
begin
  Result := AUiGrid_FindInt(BranchGrid, 0, BranchNum);
end;

function Data_FindNode(NodeNum: AInt): AInt;
begin
  Result := AUiGrid_FindInt(NodeGrid, 0, NodeNum);
end;

function Data_FindStolb(Num: AInt): AInt;
begin
  Result := AUiGrid_FindInt(BlockGrid, 0, Num);
end;

function Data_FindVenA(TablVen1: AStringGrid; NomVetvi: Integer): Integer;
{$IFDEF VCL}
var
  I: Integer;
  TablVen: TStringGrid;
{$ENDIF VCL}
begin
  {$IFDEF VCL}
  TablVen := TStringGrid(TablVen1);
  for I := TablVen.FixedRows to TablVen.RowCount - 1 do
  begin
    if (AUtils_StrToIntP(TablVen.Cells[0,I]) = NomVetvi) then
    begin
      Result := I;
      Exit;
    end;
  end;
  {$ENDIF VCL}
  Result := -1;
end;

function Data_Node_Delete(TablDavl: AStringGrid; NodeNum: AInt): AError;
var
  Row: Integer;
begin
  Row := Data_FindNode(NodeNum);
  if (Row > 0) then
    AUiGrid_DeleteRow2(TablDavl, Row);
  Result := 0;
end;

function Data_Node_SetPosition(NodeNum: AInt): AError;
begin
  try
    _SetNodePosition(NodeGrid, NodeNum);
    Result := 0;
  except
    Result := -1;
  end;
end;

function Data_Prepare_CheckBranchs2(GenericTable1: AStringGrid; LogProc: TCadLogProc): Boolean;

  function _IsPrit(const BranchType: string): Boolean;
  begin
    Result := (Length(BranchType) > 0) and (BranchType = 'П');
  end;

{$IFDEF VCL}
var
  BranchNum: Integer;
  BranchRow: Integer;
  GenericTable: TStringGrid;
  S: APascalString;
{$ENDIF VCL}
begin
{$IFDEF VCL}
  GenericTable := TStringGrid(GenericTable1);
  Result := True;
  for BranchRow := GenericTable.FixedRows to GenericTable.RowCount-1 do
  begin
    if (GenericTable.Cells[0,BranchRow] <> '') then

    if not(_IsPrit(GenericTable.Cells[3,BranchRow])) then
    begin
      BranchNum := AUtils_StrToIntDefP(GenericTable.Cells[0,BranchRow],0);
      if (Scene.Coll.FindBranch(BranchNum) < 0) then
      begin
        Result := False;
        if Assigned(LogProc) then
        begin
          S := 'Ветви '+GenericTable.Cells[0,BranchRow]+' нет на схеме';
          LogProc(AStr(AnsiString(S)), ALogIconError+LogFlagBranch, BranchNum);
        end
        else
          Exit;
      end;
    end;
  end;
{$ELSE}
  Result := False;
{$ENDIF VCL}
end;

function Data_QuickSort(Grid: AStringGrid): AError;
{$IFDEF VCL}
var
  A: TStringGrid;
{$ENDIF VCL}
begin
{$IFDEF VCL}
  A := TStringGrid(Grid);
  A.Visible := False;
  if (A.Col = 0) or (A.Col = 1) or (A.Col = 2) then
    StringGrid_Sort_Int(A)
  else
    StringGrid_Sort_Float(A);
  A.Visible := True;
{$ENDIF VCL}
  Result := 0;
end;

function Data_SetBranchNameP(TablData1: AStringGrid; BranchNum, NameCol: AInt;
    const Value: APascalString): AError;
{$IFDEF VCL}
var
  Row: Integer;
  TablData: TStringGrid;
{$ENDIF VCL}
begin
{$IFDEF VCL}
  TablData := TStringGrid(TablData1);
  Row := AUiGrid_FindInt(AControl(TablData), 0, BranchNum);
  if (Row > 0) then
    TablData.Cells[NameCol,Row] := Value;
  Result := 0;
{$ENDIF VCL}
end;

function Data_Stolb_SetPosition(StolbNum: AInt): AError;
begin
  _SetNodePosition(BlockGrid, StolbNum);
  Result := 0;
end;

end.

