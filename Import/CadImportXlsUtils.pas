{**
@Author Prof1983 <prof1983@ya.ru>
@Created 01.02.2010
@LastMod 12.04.2013
}
unit CadImportXlsUtils;

{$ifndef NoVcl}
  {$define Vcl}
{$endif}

interface

uses
  {$ifdef Vcl}
  ActiveX, ComObj, Grids, SysUtils, Variants, Windows,
  {$endif}
  ExcelXP,
  ABase,
  ASystemMain,
  AUiGrids,
  AUtilsMain,
  CadAppDataUtils,
  CadCoreBase,
  CadDrawBase,
  CadDrawFigureCollection,
  CadDrawPrimitive,
  CadSceneMain;

type
  IExcelApplication = ExcelXP._Application;
  IExcelWorkbook = ExcelXp.ExcelWorkbook;
  IExcelWorksheet = ExcelXP._Worksheet;
  IExcelRange = ExcelXp.IRange;

type
  TNodeColRec = record
    N: AInt;   // 'Узел '
    Kx: AInt;  // 'Х м'
    Kxg: AInt; // 'X граф.'
    Ky: AInt;  // 'Y м'
    Kyg: AInt; // 'Y граф.'
    Kz: AInt;  // 'Z м'
    P: AInt;   // 'Поверхностный'
    V: AInt;   // 'Выход'
  end;

type
  TBranchColRec = record
    N: AInt;   // 'Ветвь '
    cnu: AInt;
    cku: AInt;
    cname: AInt;
    cl: AInt;
    cu: AInt;
    cs: AInt;
    cr: AInt;
    csr: AInt;
    cd: AInt;
    ch: AInt;
    cg: AInt;
    cpla: AInt;
    cpl: AInt;
    ctv: AInt;
  end;

// --- CadImportXls ---

function CadImportXls_GetRowCount(Sheet: IExcelWorksheet): AInt;

function CadImportXls_GetSheet(const SheetName: string): IExcelWorksheet;

function CadImportXls_Prepare(Scene: AGScene; const FileName: APascalString): AError;

procedure CadImportXls_PrepareBranchs(Sheet: IExcelWorksheet; BranchsTitleRow: Integer;
    IsAll: Boolean; out BranchCol: TBranchColRec);

procedure CadImportXls_PrepareNodes(Sheet: IExcelWorksheet; TablDavl: TStringGrid;
    NodesTitleRow: AInt; IsAll: ABool; out Ver: AInt; out NodeCol: TNodeColRec);

procedure CadImportXls_Quit();

procedure CadImportXls_ReadBranchs(Scene: AGScene; Sheet: IExcelWorksheet;
    TablData, TablVen: TStringGrid; BranchsTitleRow: AInt; const BranchCol: TBranchColRec;
    IsAll: ABool; Callback: AProc);

procedure CadImportXls_ReadNodes(Scene: AGScene; Sheet: IExcelWorksheet; TablDavl: TStringGrid;
    Ver, TitleRow: AInt; const NodeCol: TNodeColRec; IsAll: ABool; Callback: AProc);

implementation

var
  FLCID: LCID;
  XLApp: IExcelApplication;

// --- Private ---

function _AddExBranchData(Scene: AGScene; TablData: TStringGrid; Row: AInt): AError;
var
  {** Номер ветви }
  BranchNum: AInt;
  {** Номер узла начала ветви }
  NodeNum1: AInt;
  {** Номер узла конца ветви }
  NodeNum2: AInt;
  {** Позиция ПЛА }
  PlaNum: AInt;
  {** Цвет позиции ПЛА }
  PlaColor: AInt;
  {** Цвет стрелки (свежая, исходящая) (0(False)-clBlue else 1(True)-clRed) }
  ArrowIsFresh: ABool;
  ArrowIsFreshInt: AInt;
  {** Тип линии (1,14 - Пунктирная (штриховая)) // тип выработки }
  LineType7: AInt;
  LineIsDotted: ABool;
  {** Наименование ветви }
  Name: APascalString;
begin
  try
    // номер ветви
    BranchNum := AUtils_StrToIntP(TablData.Cells[0,Row]);
    // номер начала ветви
    NodeNum1 := AUtils_StrToIntP(TablData.Cells[1,Row]);
    // номер конца ветви
    NodeNum2 := AUtils_StrToIntP(TablData.Cells[2,Row]);

    // свежая исходящая
    if (TablData.Cells[19,Row] <> '') then
      ArrowIsFreshInt := AUtils_StrToIntP(TablData.Cells[19,Row])
    else
      ArrowIsFreshInt := 0;
    if (ArrowIsFreshInt = 0) then
      ArrowIsFresh := False
    else
      ArrowIsFresh := True;

    // тип выработки
    if (TablData.Cells[17,Row] <> '') then
      LineType7 := AUtils_StrToIntP(TablData.Cells[17,Row])
    else
      LineType7 := 0;

    if (LineType7 = 1) or (LineType7 = 14) then
      LineIsDotted := True
    else
      LineIsDotted := False;

    // ПЛА
    if (TablData.Cells[TablData.ColCount,Row] <> '') then
    begin
      // позиция ПЛА
      PlaNum := AUtils_StrToIntP(TablData.Cells[TablData.ColCount,Row]);
      // цвет Позиции ПЛА
      if (TablData.Cells[16,Row] <> '') then
        PlaColor := AUtils_StrToIntP(TablData.Cells[16,Row])
      else
        PlaColor := 0;
    end
    else
    begin
      PlaNum := 0;
      PlaColor := 0;
    end;
    // наименование ветви
    Name := TablData.Cells[15,Row];

    Result := CadScene_AddExBranchData(Scene, BranchNum, NodeNum1, NodeNum2, PlaNum,
        PlaColor, ArrowIsFresh, LineIsDotted, Name);
  except
    Result := -1;
  end;
end;

{** Проверяет координаты узлов на совпадение
    Если координаты совпадают, то сдвигает их на 1 по оси X }
procedure _CheckCoord(Scene: AGScene; Ver: AInt);
var
  I: AInt;
  Iter: AInt;
  J: AInt;
  K: AInt;
  Len: AInt;
  X1: AInt;
  X2: AInt;
  Y1: AInt;
  Y2: AInt;
begin
  Len := CadScene_GetExNodeDataLen(Scene);
  Iter := 0;
  repeat
    K := 0;
    Inc(Iter);
    for J := 0 to Len - 1 do
    begin
      if (Ver = 2) then
      begin
        if (CadScene_GetExNodeXYg(Scene, J, X1, Y1) >= 0) then
        begin
          for I := J+1 to Len - 1 do
          begin
            if (CadScene_GetExNodeXYg(Scene, I, X2, Y2) >= 0) then
            begin
              if (X1 = X2) and (Y1 = Y2) then
              begin
                CadScene_SetExNodeXYg(Scene, I, X2 + 1, Y2);
                Inc(K);
              end;
            end;
          end;
        end;
      end
      else
      begin
        if (CadScene_GetExNodeXY(Scene, J, X1, Y1) >= 0) then
        begin
          for I := J+1 to Len - 1 do
          begin
            if (CadScene_GetExNodeXY(Scene, I, X2, Y2) >= 0) then
            begin
              if (X1 = X2) and (Y1 = Y2) then
              begin
                CadScene_SetExNodeXY(Scene, I, X2 + 1, Y2);
                Inc(K);
              end;
            end;
          end;
        end;
      end;
    end;
  until (K = 0) or (Iter = 10);
end;

function _FindBranch(Coll: TGCollFigure; nv: AInt): AInt;
var
  I: Integer;
begin
  for I := 0 to Coll.FigCount-1 do
  begin
    if (Coll.Data[I] is TGBranch) then
    if (TGBranch(Coll.Data[I]).Brn.BrNum = -nv) or
       (TGBranch(Coll.Data[I]).Brn.BrNum = nv) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

{** Импортирует ветви
    @param BranchsTitleRow - Номер строки с наименованием колонок в импортируемой таблице ветвей }
procedure _ReadBranchsTable(Scene: AGScene; Sheet: IExcelWorksheet; TablData, TablVen: TStringGrid;
    BranchsTitleRow: AInt; const BranchCol: TBranchColRec;
    IsAll: ABool; Callback: AProc);
var
  BranchNum: AInt;
  iv: Integer;
  kx: Real;
  kxs: Real;
  kx_: Real;
  BranchRow: Integer;
  kk: Integer;
  Coll: TGCollFigure;
  RowsCount: AInt;
begin
  RowsCount := Sheet.UsedRange[FLCID].Rows.Count;
  Coll := CadDrawScene_GetColl(Scene);
  kk := TablData.FixedRows;
  if not(IsAll) then
    kk := TablData.RowCount;

  iv := 0;
  BranchRow := BranchsTitleRow;
  Inc(BranchRow);
  repeat
    BranchNum := Sheet.Cells.Item[BranchRow,BranchCol.N]; // номер ветви
    kxs := 0;
    kx := 0;
    if (BranchNum > 0) and (IsAll or (_FindBranch(Coll, BranchNum) < 0)) then
    begin
      StringGrid_RowClearA(TablData, kk);

      TablData.Cells[0,kk] := Sheet.Cells.Item[BranchRow,BranchCol.N]; // номер ветви
      TablData.Cells[1,kk] := Sheet.Cells.Item[BranchRow,BranchCol.cnu]; // начальный узел
      TablData.Cells[2,kk] := Sheet.Cells.Item[BranchRow,BranchCol.cku]; // конечный узел
      if (BranchCol.cname > 0) then
      begin
        TablData.Cells[15,kk] := AUtils_NormalizeStrSpaceP(Sheet.Cells.Item[BranchRow, BranchCol.cname]); // наименование
      end;
      if (BranchCol.cl > 0) then
        TablData.Cells[5,kk] := FormatFloat('#0.00',Sheet.Cells.Item[BranchRow,BranchCol.cl]); // Длина
      if (BranchCol.cu > 0) then
        TablData.Cells[22,kk] := FormatFloat('#0.00',Sheet.Cells.Item[BranchRow,BranchCol.cu]); // Угол
      if (BranchCol.cs > 0) then
        TablData.Cells[6,kk] := FormatFloat('#0.00',Sheet.Cells.Item[BranchRow,BranchCol.cs]); // Сечение
      if (BranchCol.cr > 0) then
        TablData.Cells[4,kk] := FormatFloat('#0.00000',Sheet.Cells.Item[BranchRow,BranchCol.cr]); // Сопротивление
      if (BranchCol.csr > 0) then // 'R сумм. km'
        kxs := Sheet.Cells.Item[BranchRow,BranchCol.csr];
      if (BranchCol.cr > 0) then
      begin
        kx_ := Sheet.Cells.Item[BranchRow,BranchCol.cr];
        kx := kxs-kx_; // = 'R сумм. km' - Сопротивление
      end;
      if (kx > 0.0000001) then
        TablData.Cells[8,kk] := FormatFloat('#0.00',kx) //Сопротивление
      else
        TablData.Cells[8,kk] := ''; //Сопротивление
      if (BranchCol.cd > 0) then
        TablData.Cells[14,kk] := FormatFloat('#0.00',Sheet.Cells.Item[BranchRow,BranchCol.cd]); // Доп депрессия
      if (BranchCol.ch > 0) then
        TablData.Cells[20,kk] := FormatFloat('#0.00',Sheet.Cells.Item[BranchRow,BranchCol.ch]); // Высота

      if (BranchCol.cpl > 0) then
        TablData.Cells[27,kk] := Sheet.Cells.Item[BranchRow,BranchCol.cpl]; // Пласт
      if (BranchCol.ctv > 0) then
        TablData.Cells[28,kk] := Sheet.Cells.Item[BranchRow,BranchCol.ctv]; // Тип выработки
      TablData.Cells[19,kk] := '0'; // свежая исходящая
      TablData.Cells[17,kk] := '0'; // тип выработки
      if (BranchCol.cd > 0) then
        TablData.Cells[3,kk] := FormatFloat('#0.0',Sheet.Cells.Item[BranchRow,BranchCol.cd]);  // Доп депр коэф С
      if (AUtils_StrToFloatDefP(TablData.Cells[3,kk],0) <> 0.0) then
      begin
        Inc(iv);
        TablVen.Cells[0,iv+1] := TablData.Cells[0,kk];
        TablVen.Cells[3,iv+1] := '-'+ FormatFloat('#0.00000',kxs);
        TablVen.Cells[5,iv+1] := TablData.Cells[3,kk];
        TablVen.Cells[1,iv+1] := TablData.Cells[15,kk];
        TablData.Cells[3,kk] := 'В';
        TablData.Cells[4,kk] := '';
      end
      else
        TablData.Cells[3,kk] := '';

      if (TablData.Cells[0,kk] <> '') then
      begin
        _AddExBranchData(Scene, TablData, kk);
        TablData.Cells[16,kk] := '';
        TablData.Cells[17,kk] := '';
        TablData.Cells[19,kk] := '';
        TablData.Cells[TablData.ColCount,kk] := '';
      end;
      Inc(kk);
    end;
    Inc(BranchRow);

    if (iv = 0) then
      TablVen.RowCount := 4
    else
      TablVen.RowCount := iv+2;

    if Assigned(Callback) then
      Callback();
  until BranchRow > RowsCount;

  // Unassign the Delphi Variant Matrix
  TablData.RowCount := kk;
end;

{** Импортирует узлы
    ScaleX = 5
    ScaleY = -5 }
procedure _ReadNodesTable(Scene: AGScene; Sheet: IExcelWorksheet;
    Ver, TitleRow: AInt; const NodeCol: TNodeColRec; ScaleX, ScaleY: AFloat;
    IsAll: ABool; Callback: AProc);

  { Добавляет существующие узлы в список }
  procedure AddExistingNodes(Scene: AGScene);
  var
    I: Integer;
    NodeList: TGCollNode;
  begin
    NodeList := CadDrawScene_GetColl(Scene).GetNodeList();
    for I := 0 to NodeList.GetCount-1 do
    begin
      CadScene_AddExNode(
          Scene,
          NodeList.Items[I].NdNum,
          NodeList.Items[I].NdPnt_X,
          NodeList.Items[I].NdPnt_Y,
          NodeList.Items[I].NdPnt_Z,
          NodeList.Items[I].NdPnt_X,
          NodeList.Items[I].NdPnt_Y,
          NodeList.Items[I].NdType = 1);
    end;
  end;

  function ReadCellsFloat(Row, Col: Integer): Real;
  begin
    if (Col <= 0) then
    begin
      Result := 0;
      Exit;
    end;
    Result := Sheet.Cells.Item[Row, Col];
  end;

const
  SYes = 'Да';
var
  RowK: AInt;     // Номер текущей строки в импортируемой таблице
  S1: string;
  S2: string;
  RowsCount: AInt;
  J: AInt;
var
  NdNum: AInt; // Номер текущего узла
  NdX: AFloat;
  NdY: AFloat;
  NdZ: AFloat;
  NdXg: AFloat;
  NdYg: AFloat;
  NdIsPov: ABool;
begin
  RowsCount := Sheet.UsedRange[FLCID].Rows.Count;

  if not(IsAll) then
    AddExistingNodes(Scene);

  for RowK := TitleRow+1 to RowsCount+1 do
  begin
    NdNum := Sheet.Cells.Item[RowK, NodeCol.N]; // номер узла
    NdX := ReadCellsFloat(RowK,NodeCol.Kx); // координата x
    NdY := ReadCellsFloat(RowK,NodeCol.Ky); // координата y
    NdZ := ReadCellsFloat(RowK,NodeCol.Kz); // координата z
    NdXg := ReadCellsFloat(RowK,NodeCol.Kxg) * ScaleX; // координата x
    NdYg := ReadCellsFloat(RowK,NodeCol.Kyg) * ScaleY; // координата y
    S1 := Sheet.Cells.Item[RowK,NodeCol.P]; // 'Поверхностный'
    S2 := Sheet.Cells.Item[RowK,NodeCol.V]; // 'Выход'
    // Если узел 'Поверхностный' или 'Выход', значит это узел поверхности
    if (S1 = SYes) or (S2 = SYes) then
      NdIsPov := True
    else
      NdIsPov := False;

    J := CadScene_FindExNode(Scene, NdNum);
    if (J >= 0) then
    begin
      if IsAll then
        CadScene_SetExNodeByIndex2(Scene, J, Round(NdX), Round(NdY), Round(NdZ), Round(NdXg), Round(NdYg), NdIsPov)
      else
        CadScene_SetExNodeByIndex(Scene, J, Round(NdX), Round(NdY), Round(NdZ), NdIsPov)
    end
    else
    begin
      CadScene_AddExNode(Scene, NdNum, Round(NdX), Round(NdY), Round(NdZ), Round(NdXg), Round(NdYg), NdIsPov);
    end;

    if Assigned(Callback) then
      Callback();
  end;
end;

procedure _RefreshNodeTable(Scene: AGScene; TablDavl: TStringGrid);
var
  I: AInt;
  Len: AInt;
  NodeRow: AInt;  // Счетчик для заполнения таблицы узлов
  FixedRows: AInt;
  NodeData: TExDataNodeRec;
begin
  FixedRows := TablDavl.FixedRows;
  Len := CadScene_GetExNodeDataLen(Scene);
  for I := 0 to Len - 1 do
  begin
    if (CadScene_GetExNodeData(Scene, I, NodeData) >= 0) then
    begin
      NodeRow := I + FixedRows;
      StringGrid_SetRowCount(TablDavl, NodeRow + 1);
      StringGrid_RowClearA(TablDavl, NodeRow);
      TablDavl.Cells[0,NodeRow] := IntToStr(NodeData.Num); // номер узла
      if NodeData.IsPov then
        TablDavl.Cells[1,NodeRow] := '1'
      else
        TablDavl.Cells[1,NodeRow] := '0';
      TablDavl.Cells[4,NodeRow] := IntToStr(NodeData.X); // координата x
      TablDavl.Cells[5,NodeRow] := IntToStr(NodeData.Y); // координата y
      TablDavl.Cells[6,NodeRow] := IntToStr(NodeData.Z); // координата z
      //TablDavl.Cells[8,NodeRow] := FormatFloat('#0.00', NodeData.Xg); // координата x граф
      //TablDavl.Cells[9,NodeRow] := FormatFloat('#0.00', NodeData.Yg); // координата y граф
    end;
  end;
end;

// --- CadImportXls ---

function CadImportXls_GetRowCount(Sheet: IExcelWorksheet): AInt;
begin
  Result := Sheet.UsedRange[FLCID].Rows.Count;
end;

function CadImportXls_GetSheet(const SheetName: string): IExcelWorksheet;
begin
  Result := XLApp.Worksheets.Item[SheetName] as ExcelXP._Worksheet;
end;

function CadImportXls_Prepare(Scene: AGScene; const FileName: APascalString): AError;
begin
  CadScene_ClearExData(Scene);

  // Create Excel-OLE Object
  FLCID := LOCALE_USER_DEFAULT;
  XLApp := CreateComObject(ExcelXP.CLASS_ExcelApplication) as ExcelXP.ExcelApplication;

  try
    // Hide Excel
    XLApp.Visible[FLCID] := False;
    // Open the Workbook
    XLApp.Workbooks.Open(FileName, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, FLCID);
    Result := 0;
  except
    CadImportXls_Quit();
    Result := -1;
  end;
end;

procedure CadImportXls_PrepareBranchs(Sheet: IExcelWorksheet; BranchsTitleRow: AInt;
    IsAll: ABool; out BranchCol: TBranchColRec);
var
  I: Integer;
  ColCount: Integer;
  ss: string;
begin
  ColCount := Sheet.UsedRange[FLCID].Columns.Count;
  // Set Stringgrid's row &col dimensions.
  // Assign the Variant associated with the WorkSheet to the Delphi Variant
  // Define the loop for filling in the TStringGrid
  BranchCol.N := 0;
  BranchCol.cnu := 0;
  BranchCol.cku := 0;
  BranchCol.cname := 0;
  BranchCol.cl := 0;
  BranchCol.cu := 0;
  BranchCol.cs := 0;
  BranchCol.cr := 0;
  BranchCol.csr := 0;
  BranchCol.cd := 0;
  BranchCol.ch := 0;
  BranchCol.cg := 0;
  BranchCol.cpla := 0;
  BranchCol.cpl := 0;
  BranchCol.ctv := 0;

  // Узнаем номера нужных колонок
  for I := 1 to ColCount do
  begin
    ss := Sheet.Cells.Item[BranchsTitleRow,I];
    if (ss = 'Ветвь ') then
      BranchCol.N := I
    else if (ss = 'Нач. узел') then
      BranchCol.cnu := I
    else if (ss = 'Кон. узел') then
      BranchCol.cku := I
    else if (ss = 'Название ') then
      BranchCol.cname := I
    else if (ss = 'Длина м') then
      BranchCol.cl := I
    else if (ss = 'Угол град') then
      BranchCol.cu := I
    else if (ss = 'Сечение м2') then
      BranchCol.cs := I
    else if (ss = 'R km') then
      BranchCol.cr := I
    else if (ss = 'R сумм. km') then
      BranchCol.csr := I
    else if (Copy(ss,1,10) = 'Доп. депр.') then
      BranchCol.cd := I
    else if (ss = 'Высота м') then
      BranchCol.ch := I
    else if (ss = 'Газовыд. м3/мин') then
      BranchCol.cg := I
    else if (ss = 'Позиция ПЛА ') then
      BranchCol.cpla := I
    else if (ss = 'Пласт ') then
      BranchCol.cpl := I
    else if (ss = 'Тип ветви ') then
      BranchCol.ctv := I;
  end;

  // Проверяем наличие всех необходимых колонок
  if (BranchCol.N = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Ветвь ');
  if (BranchCol.cnu = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Нач. узел ');
  if (BranchCol.cku = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Кон. узел ');
  if (BranchCol.cl = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Длина м');
  if (BranchCol.cs = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Сечение м2');
  if (BranchCol.cr = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец R km');
  if (BranchCol.csr = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец R сумм. km');
  if (BranchCol.cd = 0) then
    ASystem_ShowMessageP(' Отсутствует столбец Доп. депр. даПа');
end;

procedure CadImportXls_PrepareNodes(Sheet: IExcelWorksheet; TablDavl: TStringGrid;
    NodesTitleRow: AInt; IsAll: ABool; out Ver: AInt; out NodeCol: TNodeColRec);
var
  I: Integer;
  ColCount: Integer;
  ss: string;
begin
  // Define the loop for filling in the TStringGrid
  NodeCol.N := 0;
  NodeCol.Kx := 0;
  NodeCol.Ky := 0;
  NodeCol.Kz := 0;
  NodeCol.Kxg := 0;
  NodeCol.Kyg := 0;
  NodeCol.P := 0;
  NodeCol.V := 0;

  ColCount := Sheet.UsedRange[FLCID].Columns.Count;

  // Узнаем номера нужных колонок
  for I := 1 to ColCount do
  begin
    ss := Sheet.Cells.Item[NodesTitleRow,i];
    if (ss = 'Узел ') then
      NodeCol.N := I
    else if (ss = 'Х м') then
      NodeCol.Kx := I
    else if (ss = 'Y м') then
      NodeCol.Ky := I
    else if (ss = 'Z м') then
      NodeCol.Kz := I
    else if (ss = 'X граф.') then
      NodeCol.Kxg := I
    else if (ss = 'Y граф.') then
      NodeCol.Kyg := I
    else if (ss = 'Поверхностный') then
      NodeCol.P := I
    else if (ss = 'Выход') then
      NodeCol.V := I;
  end;

  // Проверяем наличие всех необходимых колонок
  if (NodeCol.N = 0) then
    ASystem_ShowMessageP('Отсутствует столбец Узел');
  if (NodeCol.Kx = 0) then
    ASystem_ShowMessageP('Отсутствует столбец Х м');
  if (NodeCol.Ky = 0) then
    ASystem_ShowMessageP('Отсутствует столбец У м');
  if (NodeCol.Kxg = 0) then
  begin
    Ver := 1;
    ASystem_ShowMessageP('Отсутствует столбец Х граф. Имеется новая версия программы Cooling, поддерживающая экспорт экранных координат.')
  end
  else
    Ver := 2;
  if (NodeCol.Kyg = 0) then
    ASystem_ShowMessageP('Отсутствует столбец У граф');
  if (NodeCol.Kz = 0) then
    ASystem_ShowMessageP('Отсутствует столбец Z м');
  if (NodeCol.P = 0) then
    ASystem_ShowMessageP('Отсутствует столбец Поверхностный');
end;

procedure CadImportXls_Quit();
begin
  if not(VarIsEmpty(XLApp)) then
  begin
    XLApp.Quit();
    XLAPP := nil;
  end;
end;

procedure CadImportXls_ReadBranchs(Scene: AGScene; Sheet: IExcelWorksheet;
    TablData, TablVen: TStringGrid; BranchsTitleRow: AInt; const BranchCol: TBranchColRec;
    IsAll: ABool; Callback: AProc);
begin
  _ReadBranchsTable(Scene, Sheet, TablData, TablVen, BranchsTitleRow, BranchCol, IsAll, Callback);
end;

procedure CadImportXls_ReadNodes(Scene: AGScene; Sheet: IExcelWorksheet; TablDavl: TStringGrid;
    Ver, TitleRow: AInt; const NodeCol: TNodeColRec; IsAll: ABool; Callback: AProc);
begin
  _ReadNodesTable(Scene, Sheet, Ver, TitleRow, NodeCol, 5, -5, IsAll, Callback);
  _CheckCoord(Scene, Ver);
  _RefreshNodeTable(Scene, TablDavl);
end;

end.
