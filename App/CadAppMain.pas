{**
@Abstract Cad.App.Main
@Author Prof1983 <prof1983@ya.ru>
@Created 07.09.2011
@LastMod 09.04.2013
}
unit CadAppMain;

{$IFNDEF NoVcl}{$DEFINE VCL}{$ENDIF}

interface

uses
  Types,
  ABase,
  AEventsMain,
  ASettingsMain,
  ASystemMain,
  AUiBase,
  AUiDialogsEx2,
  AUiMain,
  AUtilsMain,
  {$IFDEF VCL}CadMainWin,{$ENDIF}
  CadAppBase,
  CadAppData,
  CadAppDataConvert,
  CadAppDataUtils,
  CadAppUtils,
  CadCoreBase,
  CadCoreMain,
  CadData,
  CadDrawBase,
  CadDrawData,
  CadDrawMain,
  CadDrawPrimitive,
  CadDrawScene,
  CadDrawTypes,
  CadStampData,
  fDrawWin, fLegend, fPictureSelect, fPrint;

// --- CadApp ---

function CadApp_AddToLogP(const Text: APascalString): AInt;

// Расчитываем видимые фигуры
function CadApp_CalcVisible(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_CreateNewProject(): AError; {$ifdef AStdCall}stdcall;{$endif}

{** Производит очистку параметров перед загрузкой файла или при создании новой схемы
    @param IsFullClear - очищать полностью }
function CadApp_Clear(IsFullClear: ABool): AError; {$ifdef AStdCall}stdcall;{$endif}

//** Выводит значок ПЛА.
function CadApp_DrawPla(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_Fin(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_FormClose(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_FormKeyDown(Key: AInt): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_FormResize(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_GetIsShowAllFigures(): ABool; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_GetMaxViewPort(): TRect;

function CadApp_GetMouseActiveControl(): AControl; {$ifdef AStdCall}stdcall;{$endif}

// Импортирует данные из файла .dan.
function CadApp_ImportDan(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_ImportDan2(const FileName: string): Boolean;

//** Инициализирует модуль.
function CadApp_Init(): AError; {$ifdef AStdCall}stdcall;{$endif}

{** Выбор катринки для вставки в рисунок }
function CadApp_InputPic(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_PaintBoxMouseDown(Button: AMouseButton; Shift: AShiftState; X, Y: AInt): AError; {$ifdef AStdCall}stdcall;{$endif}

//** Загружает данные из строки StrokaDan.
function CadApp_PreobrDanStrP(const StrokaDan: APascalString; Version: AInt; IsDan: ABool;
    out EdIzm: AInt; out Precision: TCadPrecision; out NameSh, NameVar,
    NodeSurface, Tnar, Tsh, Pnar, Psh: APascalString): AError;

//** Подготавливает перед инициализацией.
function CadApp_Prepare(): AError; {$ifdef AStdCall}stdcall;{$endif}

{** Обновляет размеры области рисования на главной форме }
function CadApp_RefreshPaintBoxSize(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_RefreshTitle(): AError; {$ifdef AStdCall}stdcall;{$endif}

{ Сохраняет схему и данные в файл
  FileName - Имя сохраняемого файла
  StrokaDan - Строка с данными
  StrokaUO - Строка с описанием условных обозначений
  Version - Версия файла для сохранения }
function CadApp_SaveFileExP(const FileName, StrokaDan, StrokaUo: APascalString; Version: AInt): AInt;

{ Сделает указанную ветвь активной, переходит на соответсвующую строку данных в таблице ветвей,
  переводит позицию отображения схемы на нужную ветвь. }
function CadApp_SelectBranch(BranchNum: AInt): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetGrids(BranchGrid, NodeGrid, VenGrid: AStringGrid): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetGrids_Vp(VpGrid: AStringGrid): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetGrids_Way(WayWorkerGrid, WaySaverGrid: AStringGrid): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetIsShowAllFigures(Value: ABool): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnActivated(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnAppMessage(Value: CadApp_OnAppMessage_Proc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCalcFireCurrent(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCalcFireGas(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCalcFirePrev(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCalcFireStability(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCalcTd(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCheckData(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCloseQuery(Value: CadApp_OnCloseQuery_Proc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnCompileExtData(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnDataClear(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnFileOpen(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnFileSave(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnGenData(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnImportDataOk(Value: CadApp_OnImportDataOk_Proc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnImportDataFromXls(Value: CadApp_OnImportDataFromXls_Proc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnNodeFocus(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnPaintBoxMouseDown(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnPlaClick(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnRecover(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnRefreshParams(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnRefreshTitle(Value: AProc): AError;

function CadApp_SetOnSaveConfig(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnSetPosition(Value: ACallbackProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShow2D(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShowData(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShowFire(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShowFireProtectView(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShowRevBranchs(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnShowVenSprav(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnTaskEr(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetOnTaskVentDeviceFail(Value: AProc): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadApp_SetPositionBranch(BranchNum: AInt): AError; {$ifdef AStdCall}stdcall;{$endif}

//** Отображает справку по программе.
function CadApp_ShowHelp(): AError; {$ifdef AStdCall}stdcall;{$endif}

//** Отображает редактор условных обозначений.
function CadApp_ShowLegend(): AError; {$ifdef AStdCall}stdcall;{$endif}

{** Отображает редактор условных обозначений }
function CadApp_ShowLegendWin2(var StrokaUO: APascalString): AError;

{** Отображает диалоговое окно для печати всей схемы }
function CadApp_ShowPrintDialog(): AError; {$ifdef AStdCall}stdcall;{$endif}

{** Отображает окно выбора и настройки печати }
function CadApp_ShowPrinterSetupDialog(): AError; {$ifdef AStdCall}stdcall;{$endif}

//** Отображает окно с настройками.
function CadApp_ShowSettingsWin(): AError; {$ifdef AStdCall}stdcall;{$endif}

// --- Vars ---

{** Главная форма приложения }
var DrawWin: TDrawWin;

implementation

uses
  Controls,
  Grids,
  Windows,
  fSettings;

var
  FInitialized: Boolean;
  FLegendForm: TLegendForm;

// --- Events ---

function DoMainFormCreate(): AError; stdcall;
begin
  Result := CadMainWin_CreateMainForm();
end;

// --- CadApp ---

function CadApp_AddToLogP(const Text: APascalString): AInt;
begin
  {$IFDEF VCL}
  try
    Result := CadMainWin_AddToLogP(Text);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function CadApp_CalcVisible(): AError;
begin
  try
    Scene.Coll.CalcVisible(IsShowAllFigures, Scene.GetCurrentSchemeIndex());
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_CreateNewProject(): AError;
begin
  {$ifdef Vcl}
  try
    Result := CadMainWin_CreateNewProject();
  except
    Result := -1;
  end;
  {$else}
  Result := -1;
  {$endif}
end;

function CadApp_Clear(IsFullClear: ABoolean): AError;
begin
  try
    DrawWin_Escape();

    if IsSxema3D then
    begin
      // Отображаем 2D cхему
      if Assigned(OnShow2D) then
        OnShow2D();
    end;

    if IsFullClear then
    begin
      PL.Clear();
      TV.Clear();
    end;
    
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_DrawPla(): AError;
begin
  try
    CadDraw_DrawPla(CadAppData.PaintBoxCanvas);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_Fin(): AError;
begin
  Result := 0;
end;

function CadApp_FormClose(): AError;
begin
  try
    DrawWin_FormClose();
    if Assigned(OnSaveConfig) then
      OnSaveConfig();
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_FormKeyDown(Key: AInt): AError;
begin
  try
    // Отработка нажатых клавиш
    case Key of
      // Курсор
      VK_LEFT{37}: // Left
        begin
          DrawWin_ScrollA(csLeft,False);
        end;
      VK_RIGHT{39}: // Right
        begin
          DrawWin_ScrollA(csRight,False);
        end;
      VK_UP{38}: // Up
        begin
          DrawWin_ScrollA(csUp,False);
        end;
      VK_DOWN{40}: // Down
        begin
          DrawWin_ScrollA(csDown,False);
        end;
      {VK_ADD:
        begin
          Coll.ZoomIn;
          RefreshDraw;
        end;
      VK_SUBTRACT:
        begin
          Coll.ZoomOut;
          RefreshDraw;
        end;}
      VK_ESCAPE:
        begin
          DrawWin_Escape();
          CadMainWin_SetPeroState(cSSelect);
          DrawWin_RefreshDraw();
        end;
      VK_DELETE:
        begin
          // Удаление текущего объекта или объектов
          DrawWin_Delete();
        end;
    end;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_FormResize(): AError;
begin
  Result := 0;
  if DrawWin_IsClosing1 then Exit;
  try
    // Меняет размеры картинки вслед за изменнением размера формы
    CadApp_RefreshPaintBoxSize();
    if DrawWin.PaintBox1.Enabled then
    begin
      CadMainWin_RefreshWindowSize();
      DrawWin_RefreshDraw();
    end;
  except
    CadMainWin_AddToLogP('Произошла ошибка при изменении размера окна');
  end;
end;

function CadApp_GetIsShowAllFigures(): ABool;
begin
  Result := IsShowAllFigures;
end;

function CadApp_GetMaxViewPort(): TRect;
begin
  try
    Result := Scene.Coll.GetMaxViewPort(DrawWin.Canvas);
  except
    Result.Left := 0;
    Result.Top := 0;
    Result.Right := 0;
    Result.Bottom := 0;
  end;
end;

function CadApp_GetMouseActiveControl(): AControl;
begin
  Result := CadMainWin_MouseActiveControl;
end;

function CadApp_ImportDan(): AError;
var
  FileName: APascalString;
begin
  try
    if AUi_ExecuteOpenFileDialogP(AUtils_ExtractFilePathP(CadData.DrawFileName), '*.dan', 'Выбор файла данных', FileName) then
    begin
      CadApp_ImportDan2(FileName);
      if Assigned(OnRefreshParams) then
        OnRefreshParams();
    end;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_ImportDan2(const FileName: string): Boolean;
var
  s: string;
  s1: string;
  f: TextFile;
begin
  Result := False;
  if AUtils_FileExistsP(FileName) then
  begin
    AssignFile(f, FileName);
    Reset(f);
    s := '';
    while not(Eof(f)) do
    begin
      ReadLn(f, s1);
      s := s + s1 + #13#10;
    end;
    CloseFile(f);

    if Assigned(OnImportDataOk) then
      OnImportDataOk(S);
  end;
end;

function CadApp_Init(): AError;
begin
  if FInitialized then
  begin
    Result := 0;
    Exit;
  end;

  {$IFDEF VCL}
  // Подготавливам перед инициализацией, если еще не было выполнено.
  CadApp_Prepare();
  {$ENDIF VCL}

  DocDirectory := 'Doc\';
  IsShowAllFigures := True;

  // --- Init request modules ---

  try
    if (CadCore_Init() < 0) then
    begin
      Result := -2;
      Exit;
    end;
  except
    ASystem_ShowMessageP('Произошла ошибка при выполнении CadCore_Init');
  end;

  if (CadDraw_Init() < 0) then
  begin
    Result := -3;
    Exit;
  end;

  if (AEvents_Init() < 0) then
  begin
    Result := -7;
    Exit;
  end;

  if (ASettings_Init() < 0) then
  begin
    Result := -2;
    Exit;
  end;

  if (ASystem_Init() < 0) then
  begin
    Result := -4;
    Exit;
  end;

  try
    if (AUi_Init() < 0) then
    begin
      Result := -5;
      Exit;
    end;
  except
    ASystem_ShowMessageP('Произошла ошибка при выполнении UI_Init');
  end;

  try
    if (AUtils_Init() < 0) then
    begin
      Result := -6;
      Exit;
    end;
  except
    ASystem_ShowMessageP('Произошла ошибка при выполнении Utils_Init');
  end;

  // ---

  CompileExtDataEvent := AEvent_NewP(0, 'CompileExtData');

  try
    {$IFDEF VCL}
    DrawWin_Prepare();
    {$ENDIF VCL}
    FInitialized := True;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_InputPic(): AError;
var
  PicName: string;
  Index: Integer;
  IsPic1: Boolean;
begin
  {$ifdef Vcl}
  try
    if not(fPictureSelect.InputPic(Scene.Coll, Index, PicName, IsPic1)) then
    begin
      Result := 1;
      Exit;
    end;
    CadDrawData.IsPic1 := IsPic1;
    CadDrawData.PicName_ := PicName;
    if (Index < 0) then
      PicIndex1 := 0
    else
      PicIndex1 := Index;
    Result := 0;
  except
    Result := -1;
  end;
  {$else}
  Result := -1;
  {$endif}
end;

function CadApp_PaintBoxMouseDown(Button: AMouseButton; Shift: AShiftState; X, Y: AInt): AError;
var
  PeroSostInt: AInt;
begin
  try
    if Assigned(OnPaintBoxMouseDown) then
      OnPaintBoxMouseDown();

    PeroSostInt := AInt(PeroSost);
    DrawWin_PaintBox1MouseDown(AControl(DrawWin.PaintBox1), Button, Shift, X, Y, PeroSostInt);
    CadMainWin.PeroSost := TPeroSost(PeroSostInt);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_PreobrDanStrP(const StrokaDan: APascalString; Version: AInt; IsDan: ABool;
    out EdIzm: AInt; out Precision: TCadPrecision; out NameSh, NameVar,
    NodeSurface, Tnar, Tsh, Pnar, Psh: APascalString): AError;
begin
  try
    NameSh := '';
    NameVar := '';
    NodeSurface := '';
    Tnar := '';
    Tsh := '';
    Pnar := '';
    Psh := '';
    {$ifdef Vcl}
    PreobrDanStr(StrokaDan, Version, TStringGrid(BranchGrid), TStringGrid(NodeGrid), TStringGrid(VenGrid),
        TStringGrid(WayWorkerGrid), TStringGrid(WaySaverGrid), TStringGrid(VpGrid), IsDan,
        EdIzm, Precision, StampData,
        NameSh, NameVar, NodeSurface, Tnar, Tsh, Pnar, Psh);
    {$endif}

    if Assigned(OnRefreshParams) then
      OnRefreshParams();
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_Prepare(): AError;
begin
  try
    DrawWin_IsClosing1 := False;
    {$IFDEF VCL}
    AUi_SetOnMainFormCreate(DoMainFormCreate);
    {$ENDIF VCL}
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_RefreshPaintBoxSize(): AError;
begin
  Result := CadApp_RefreshPaintBoxSize2(AImage(DrawWin.PaintBox1));
end;

function CadApp_RefreshTitle(): AError;
var
  Title: string;
begin
  try
    Title := ASystem_GetTitleP();
    if (DrawFileName <> '') then
      DrawWin.Caption := DrawFileName + ' - ' + Title
    else
      DrawWin.Caption := Title;
    if Assigned(OnRefreshTitle) then
      OnRefreshTitle();
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_SaveFileExP(const FileName, StrokaDan, StrokaUo: APascalString; Version: AInt): AInt;
begin
{$IFDEF VCL}
  try
    DrawWin_SaveGraphFile(FileName, StrokaDan, StrokaUO, Version);
    OrigFileName := DrawFileName;
    Result := 0;
  except
    Result := -1;
  end;
{$ELSE} // VCL
  Result := -1;
{$ENDIF VCL}
end;

function CadApp_SelectBranch(BranchNum: AInt): AError;
begin
  {$ifdef Vcl}
  try
    if (CadDraw_SelectBranch(BranchNum) < 0) then
    begin
      Result := -2;
      Exit;
    end;
    // Обновим картинку и панель свойств
    DrawWin_RefreshDrawAndState();
    Result := 0;
  except
    Result := -1;
  end;
  {$else}
  Result := -1;
  {$endif}
end;

function CadApp_SetGrids(BranchGrid, NodeGrid, VenGrid: AStringGrid): AError;
begin
  CadAppData.BranchGrid := BranchGrid;
  CadAppData.NodeGrid := NodeGrid;
  CadAppData.VenGrid := VenGrid;
  Result := 0;
end;

function CadApp_SetGrids_Vp(VpGrid: AStringGrid): AError;
begin
  CadAppData.VpGrid := VpGrid;
  Result := 0;
end;

function CadApp_SetGrids_Way(WayWorkerGrid, WaySaverGrid: AStringGrid): AError;
begin
  CadAppData.WayWorkerGrid := WayWorkerGrid;
  CadAppData.WaySaverGrid := WaySaverGrid;
  Result := 0;
end;

function CadApp_SetIsShowAllFigures(Value: ABool): AError;
begin
  IsShowAllFigures := Value;
  Result := 0;
end;

function CadApp_SetOnActivated(Value: AProc): AError;
begin
  OnActivated := Value;
  Result := 0;
end;

function CadApp_SetOnAppMessage(Value: CadApp_OnAppMessage_Proc): AError;
begin
  OnAppMessage := Value;
  Result := 0;
end;

function CadApp_SetOnCalcFireCurrent(Value: AProc): AError;
begin
  OnCalcFireCurrent := Value;
  Result := 0;
end;

function CadApp_SetOnCalcFireGas(Value: AProc): AError;
begin
  OnCalcFireGas := Value;
  Result := 0;
end;

function CadApp_SetOnCalcFirePrev(Value: AProc): AError;
begin
  OnCalcFirePrev := Value;
  Result := 0;
end;

function CadApp_SetOnCalcFireStability(Value: AProc): AError;
begin
  OnCalcFireStability := Value;
  Result := 0;
end;

function CadApp_SetOnCalcTd(Value: AProc): AError;
begin
  OnCalcTd := Value;
  Result := 0;
end;

function CadApp_SetOnCheckData(Value: AProc): AError;
begin
  OnCheckData := Value;
  Result := 0;
end;

function CadApp_SetOnCloseQuery(Value: CadApp_OnCloseQuery_Proc): AError;
begin
  OnCloseQuery := Value;
  Result := 0;
end;

function CadApp_SetOnCompileExtData(Value: AProc): AError;
begin
  OnCompileExtData := Value;
  Result := 0;
end;

function CadApp_SetOnDataClear(Value: AProc): AError;
begin
  OnDataClear := Value;
  Result := 0;
end;

function CadApp_SetOnFileOpen(Value: AProc): AError;
begin
  OnFileOpen := Value;
  Result := 0;
end;

function CadApp_SetOnFileSave(Value: AProc): AError;
begin
  OnFileSave := Value;
  Result := 0;
end;

function CadApp_SetOnGenData(Value: AProc): AError;
begin
  OnGenData := Value;
  Result := 0;
end;

function CadApp_SetOnImportDataOk(Value: CadApp_OnImportDataOk_Proc): AError;
begin
  OnImportDataOk := Value;
  Result := 0;
end;

function CadApp_SetOnImportDataFromXls(Value: CadApp_OnImportDataFromXls_Proc): AError;
begin
  OnImportDataFromXls := Value;
  Result := 0;
end;

function CadApp_SetOnNodeFocus(Value: AProc): AError;
begin
  OnNodeFocus := Value;
  Result := 0;
end;

function CadApp_SetOnPaintBoxMouseDown(Value: AProc): AError;
begin
  OnPaintBoxMouseDown := Value;
  Result := 0;
end;

function CadApp_SetOnPlaClick(Value: AProc): AError;
begin
  OnPlaClick := Value;
  Result := 0;
end;

function CadApp_SetOnRecover(Value: AProc): AError;
begin
  OnRecover := Value;
  Result := 0;
end;

function CadApp_SetOnRefreshParams(Value: AProc): AError;
begin
  OnRefreshParams := Value;
  Result := 0;
end;

function CadApp_SetOnRefreshTitle(Value: AProc): AError;
begin
  OnRefreshTitle := Value;
  Result := 0;
end;

function CadApp_SetOnSaveConfig(Value: AProc): AError;
begin
  OnSaveConfig := Value;
  Result := 0;
end;

function CadApp_SetOnSetPosition(Value: ACallbackProc): AError;
begin
  OnSetPosition := Value;
  Result := 0;
end;

function CadApp_SetOnShow2D(Value: AProc): AError;
begin
  OnShow2D := Value;
  Result := 0;
end;

function CadApp_SetOnShowData(Value: AProc): AError;
begin
  OnShowData := Value;
  Result := 0;
end;

function CadApp_SetOnShowFire(Value: AProc): AError;
begin
  OnShowFire := Value;
  Result := 0;
end;

function CadApp_SetOnShowFireProtectView(Value: AProc): AError;
begin
  OnShowFireProtectView := Value;
  Result := 0;
end;

function CadApp_SetOnShowRevBranchs(Value: AProc): AError;
begin
  OnShowRevBranchs := Value;
  Result := 0;
end;

function CadApp_SetOnShowVenSprav(Value: AProc): AError;
begin
  OnShowVenSprav := Value;
  Result := 0;
end;

function CadApp_SetOnTaskEr(Value: AProc): AError;
begin
  OnTaskEr := Value;
  Result := 0;
end;

function CadApp_SetOnTaskVentDeviceFail(Value: AProc): AError;
begin
  OnTaskVentDeviceFail := Value;
  Result := 0;
end;

function CadApp_SetPositionBranch(BranchNum: AInt): AError;
begin
  {$ifdef Vcl}
  try
    Data_Branch_SetPosition(BranchNum);
    Result := 0;
  except
    Result := -1;
  end;
  {$else}
  Result := -1;
  {$endif}
end;

function CadApp_ShowHelp(): AError;
begin
  try

    Result := AUi_ShowHelp2P(ASystem_GetDirectoryPathP() + DocDirectory + ASystem_GetProgramNameP() + '.hlp');
  except
    Result := -1;
  end;
end;

function CadApp_ShowLegend(): AError;
begin
  {$ifdef Vcl}
  try
    if not(Assigned(FLegendForm)) then
      FLegendForm := TLegendForm.Create(nil);
    FLegendForm.Init(StrokaUO);
    FLegendForm.Show();
    Result := 0;
  except
    Result := -1;
  end;
  {$else}
  Result := -1;
  {$endif}
end;

function CadApp_ShowLegendWin2(var StrokaUO: APascalString): AError;
var
  Form: TLegendForm;
begin
  try
    Form := TLegendForm.Create(nil);
    try
      Form.Init(StrokaUO);
      if (Form.ShowModal = mrOk) then
        StrokaUO := Form.EditorUO.Text;
    finally
      Form.Free();
    end;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadApp_ShowPrintDialog(): AError;
begin
  {$IFDEF VCL}
  try
    fPrint.ShowPrintDlg(CadImgPath, DrawFlag);
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function CadApp_ShowPrinterSetupDialog(): AError;
begin
  {$IFDEF VCL}
  Result := AUi_ExecutePrinterSetupDialog();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function CadApp_ShowSettingsWin(): AError;
{$IFDEF VCL}
var
  SettingsForm: TSettingsForm;
  Coll: TGCollFigure;
{$ENDIF VCL}
begin // Вызов диалога  - Опции
  try
    Result := 0;
    {$ifdef Vcl}
    Coll := Scene.Coll;
    SettingsForm := TSettingsForm.Create(nil);
    try
      SettingsForm.SetColSettings(ColSettings);
      SettingsForm.Init();
      if (SettingsForm.ShowModal = mrOK) then
      begin
        SettingsForm.GetColSettings(ColSettings);
        DrawWin_ApplyScheme(Scene.GetCurrentSchemeIndex());
        PhotoPathStr := SettingsForm.GetPhotoPath;
        CadDraw_SetPhotoPathIsDefault(SettingsForm.CheckBoxFoto.Checked);
        PlaPathStr := SettingsForm.PlaPath.Text;

        if (Coll.StepGrid <= 0) then
          Coll.StepGrid := 5;
        ExtheightCons := Coll.Extheight;

        oPrVisibleQ := SettingsForm.PrRash.Checked;
        oPrVisibleS := SettingsForm.PrSechenie.Checked;
        oPrVisibleV := SettingsForm.PrSpeed.Checked;
        oPrVisibleL := SettingsForm.PrLength.Checked;
        Coll.PrRectVisible := SettingsForm.PrRectEnable.Checked;
        // цвет прямоугольника свойств
        Coll.PrColorAll := SettingsForm.ColorPrRect.Color;
        Coll.PrDefaultWidth := SettingsForm.UpDownPr.Position;

        Coll.CalcVisible(DrawWin.MsxAll.Checked, Scene.GetCurrentSchemeIndex());
        DrawWin.cbLayer.Items := SettingsForm.lbLayers.Items;
        DrawWin.cbLayer.ItemIndex := SettingsForm.lbLayers.ItemIndex;
        if (DrawWin.cbLayer.ItemIndex < 0) then
          DrawWin.cbLayer.ItemIndex := 0;
        DrawWin_RefreshDrawAndState;
        CadData.IsModify := True;

        DrawWin_RefreshMenuBranchTypes(AMenuItem(DrawWin.mTipV));
        DrawWin_RefreshMenuPl();

        Check00 := SettingsForm.CheckBox00.Checked;
        Check01 := SettingsForm.CheckBox01.Checked;
        Check02 := SettingsForm.CheckBox02.Checked;
        Check03 := SettingsForm.CheckBox03.Checked;
        Check04 := SettingsForm.CheckBox04.Checked;
        Check05 := SettingsForm.CheckBox05.Checked;
        Check06 := SettingsForm.CheckBox06.Checked;
        Check07 := SettingsForm.CheckBox07.Checked;
        Check08 := SettingsForm.CheckBox08.Checked;
        Check09 := SettingsForm.CheckBox09.Checked;
        Check10 := SettingsForm.CheckBox10.Checked;
        Check11 := SettingsForm.CheckBox11.Checked;
        Check12 := SettingsForm.CheckBox12.Checked;
        Check13 := SettingsForm.CheckBox13.Checked;
        Check14 := SettingsForm.CheckBox14.Checked;
        Check15 := SettingsForm.CheckBox15.Checked;
        Check16 := SettingsForm.CheckBox16.Checked;
        Check17 := SettingsForm.CheckBox17.Checked;
        Check18 := SettingsForm.CheckBox18.Checked;
        Check19 := SettingsForm.CheckBox19.Checked;
        Check20 := SettingsForm.CheckBox20.Checked;
        Check21 := SettingsForm.CheckBox21.Checked;
        Check22 := SettingsForm.CheckBox22.Checked;

        Col00 := SettingsForm.edtCol00.Text;
        Col01 := SettingsForm.edtCol01.Text;
        Col02 := SettingsForm.edtCol02.Text;
        Col03 := SettingsForm.edtCol03.Text;
        Col04 := SettingsForm.edtCol04.Text;
        Col05 := SettingsForm.edtCol05.Text;
        Col06 := SettingsForm.edtCol06.Text;
        Col07 := SettingsForm.edtCol07.Text;
        Col08 := SettingsForm.edtCol08.Text;
        Col09 := SettingsForm.edtCol09.Text;
        Col10 := SettingsForm.edtCol10.Text;
        Col11 := SettingsForm.edtCol11.Text;
        Col12 := SettingsForm.edtCol12.Text;
        Col13 := SettingsForm.edtCol13.Text;
        Col14 := SettingsForm.edtCol14.Text;
        Col15 := SettingsForm.edtCol15.Text;
        Col16 := SettingsForm.edtCol16.Text;
        Col17 := SettingsForm.edtCol17.Text;
        Col18 := SettingsForm.edtCol18.Text;
        Col19 := SettingsForm.edtCol19.Text;
        Col20 := SettingsForm.edtCol20.Text;
        Col21 := SettingsForm.edtCol21.Text;
        Col22 := SettingsForm.edtCol22.Text;

        if Assigned(OnSaveConfig) then
          OnSaveConfig();
      end;
    finally
      SettingsWin_Fin();
      SettingsForm.Free;
    end;
    {$endif Vcl}
  except
    Result := -1;
  end;
end;

end.
