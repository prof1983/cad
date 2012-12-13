{**
@Abstract Cad.App
@Author Prof1983 <prof1983@ya.ru>
@Created 30.11.2009
@LastMod 13.12.2012
}
unit CadApp;

{$IFDEF HomeCad}{$DEFINE NoVcl}{$ENDIF}

{$IFNDEF NoVcl}
  {$DEFINE VCL}
{$ENDIF}

interface

uses
  Types,
  ABase, ABaseTypes, {AEvents,}
  AUi, AUiBase, AUtils,
  CadAppBase, CadAppData, CadAppDataUtils, CadAppLoader,
  {CadCore,} CadCoreBase,
  {CadDraw,} CadDrawBase;

{** Расчитывает видимые фигуры }
function CalcVisible(): AError; stdcall;

{** Финализирует модуль CadApp }
function Done(): AError; stdcall; deprecated; // Use Fin()

{** Выводит значок ПЛА }
function DrawPla(): AError; stdcall;

{** Возвращает номер строки по номеру ветви }
function FindBranchByNum(BranchNum: AInteger): AInteger; stdcall;

{** Возвращает номер строки для узла NodeNum }
function FindNodeByNum(NodeNum: AInteger): AInteger; stdcall;

{** Возвращает объект-событие обновления данных }
function GetCompileExtDataEvent(): AEvent; stdcall;

{** Возвращает индекс активного слоя }
function GetCurrentLayerIndex(): AInteger; stdcall;

function GetMaxViewPort(): TRect; stdcall;

{** Инициализирует модуль CadApp }
function Init(): AError; stdcall;

{** Выбор катринки для вставки в рисунок }
function InputPic: ABoolean; stdcall;

{** Импортирует данные из файла данных }
function ImportDan(): AError; stdcall;

{** Загружает файл }
function LoadFile02(const FileName: AWideString): ABoolean; stdcall;

{** Загружает файл }
function LoadFileExP(const FileName: APascalString; FileType: AInteger; IsAll: ABoolean): ABoolean; stdcall;

{** Загружает файл }
function LoadFileP(const FileName: APascalString): AError; stdcall;

{** Загружает файл }
function LoadFileWS(const FileName: AWideString): AError; stdcall;

{** Загружает графический файл
    @param PaintBox1 - (TImage) }
function LoadGraphFileA(const FileName: string; PaintBox1: AControl): Boolean;

{** Загружает графический файл }
function LoadGraphFileP(const FileName: APascalString): AError; stdcall;

function Logger_AddP(const Text: APascalString): AInteger; stdcall; deprecated; // Use AddToLogP()

{** Вызывает диалог выбор файла }
function Open2(DefFilterIndex: AInteger; IsAll: ABoolean): ABoolean; stdcall;

{** Подготавливает перед инициализацией }
function Prepare(): AInteger; stdcall;

{** Создает новый проект }
function Project_New(): AError; stdcall; deprecated; // Use CreateNewProject()

{** Сохраняет схему и данные в файл
    @param FileName - Имя сохраняемого файла
    @param StrokaDan - Строка с данными
    @param StrokaUO - Строка с описанием условных обозначений
    @param Version - Версия файла для сохранения }
function SaveFileA(const FileName, StrokaDan, StrokaUO: APascalString; Version: AInteger): AError; stdcall; deprecated; // Use SaveFileExP()

{** Сохраняет схему и данные в файл
    @param FileName - Имя сохраняемого файла
    @param StrokaDan - Строка с данными
    @param StrokaUO - Строка с описанием условных обозначений
    @param Version - Версия файла для сохранения }
function SaveFileExWS(const FileName, StrokaDan, StrokaUO: AWideString; Version: AInteger): AInteger; stdcall;

{** Делает указанную ветвь активной, переходит на соответсвующую строку данных в таблице ветвей,
    переводит позицию отображения схемы на нужную ветвь }
function SelectBranch(BranchNum: AInteger): AInteger; stdcall;

{** Устанавливает режим отображения всех фигур }
function SetIsShowAllFigures(Value: ABoolean): AError; stdcall;

{** Задает реакцию на событие OnCompileExtData }
function SetOnCompileExtData(Value: AProc): AError; stdcall;

{** Задает реакцию на событие OnImportDataFromXls }
function SetOnImportDataFromXls(Value: CadApp_OnImportDataFromXls_Proc): AError; stdcall;

{** Задает реакцию на событие OnImportDataOk }
function SetOnImportDataOk(Value: CadApp_OnImportDataOk_Proc): AError; stdcall;

{** Задает реакцию на событие OnDrawWinInit }
function SetOnDrawWinInit(Value: AProc): AError; stdcall;

{** Задает реакцию на событие OnSaveFile }
function SetOnSaveFile(Value: CadApp_OnSaveFile_Proc): AError; stdcall;

{** Устанавливает курсор на указанную ветвь }
function SetPositionBranch(BranchNum: AInteger): AError; stdcall;

function SetDataGrid(Value: AStringGrid): AError; stdcall;

{** Отображает 2D cхему }
function Show2D(): ABoolean; stdcall;

{** Отображает 3D cхему }
function Show3D(PaintBox: AImage; X, Z: AInteger): ABoolean; stdcall;

{** Отображает справку по программе }
function ShowHelp(): AError; stdcall;

{** Отображает редактор условных обозначений }
function ShowLegend(): AError; stdcall;

{** Отображает редактор условных обозначений }
function ShowLegendWin2P(var StrokaUO: APascalString): AError; stdcall;

{** Отображает диалоговое окно для печати всей схемы }
function ShowPrintDialog(): AError; stdcall;

{** Отображает окно выбора и настройки печати }
function ShowPrinterSetupDialog(): AError; stdcall;

{** Вызов диалога "Опции" }
function ShowSettingsWin(): AInteger; stdcall;

implementation

uses
  CadAppMain,
  CadMainWin;

{ Public }

function CalcVisible(): AError;
begin
  {$IFDEF VCL}
  try
    CadApp_CalcVisible();
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function Done(): AError;
begin
  Result := 0;
end;

function DrawPla(): AError;
begin
  {$IFDEF VCL}
  try
    CadApp_DrawPla();
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function FindBranchByNum(BranchNum: AInteger): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadAppDataUtils.Data_FindBranch(BranchNum);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function FindNodeByNum(NodeNum: AInteger): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadAppDataUtils.Data_FindNode(NodeNum);
  except
    Result := 0;
  end;
  {$ELSE}
  Result := 0;
  {$ENDIF VCL}
end;

function GetCompileExtDataEvent(): AEvent;
begin
  Result := FCompileExtDataEvent;
end;

function GetCurrentLayerIndex(): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadMainWin_GetCurrentLayerIndex();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function GetMaxViewPort(): TRect;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_GetMaxViewPort();
  except
  end;
  {$ENDIF VCL}
end;

function ImportDan(): AError;
begin
  {$IFDEF VCL}
  try
    CadApp_ImportDan();
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function Init(): AError;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_Init();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function InputPic(): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_InputPic();
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function LoadFileExP(const FileName: APascalString; FileType: AInteger; IsAll: ABoolean): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_LoadFileA(FileName, FileType, IsAll);
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function LoadFile02(const FileName: AWideString): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_LoadFile(FileName);
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function LoadFileP(const FileName: APascalString): AError;
begin
  {$IFDEF VCL}
  try
    if CadApp_LoadFile(FileName) then
      Result := 0
    else
      Result := -2;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function LoadFileWS(const FileName: AWideString): AError;
begin
  {$IFDEF VCL}
  try
    if CadApp_LoadFile(FileName) then
      Result := 0
    else
      Result := -2;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function LoadGraphFileP(const FileName: APascalString): AError;
begin
  Result := CadApp_LoadGraphFileP(FileName);
end;

function LoadGraphFileA(const FileName: string; PaintBox1: AControl): Boolean;
begin
  Result := CadApp_LoadGraphFileA(FileName, PaintBox1);
end;

function Logger_AddP(const Text: APascalString): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadMainWin_Logger_Add(Text);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function Open2(DefFilterIndex: AInteger; IsAll: ABoolean): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := CadMainWin_Open2(DefFilterIndex, IsAll);
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function Prepare(): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_Prepare();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function Project_New(): AError;
begin
  {$IFDEF VCL}
  try
    Result := CadMainWin_CreateNewProject();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SaveFileA(const FileName, StrokaDan, StrokaUO: APascalString; Version: AInteger): AError;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_SaveFileA(FileName, StrokaDan, StrokaUO, Version);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SaveFileExWS(const FileName, StrokaDan, StrokaUO: AWideString; Version: AInteger): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_SaveFileA(FileName, StrokaDan, StrokaUO, Version);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SelectBranch(BranchNum: AInteger): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_SelectBranch(BranchNum);
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SetDocDirectory(const Value: AWideString): AError;
begin
  DocDirectory := Value;
  Result := 0;
end;

function SetIsShowAllFigures(Value: ABoolean): AError;
begin
  FIsShowAllFigures := Value;
  Result := 0;
end;

function SetOnCompileExtData(Value: AProc): AError;
begin
  FOnCompileExtData := Value;
  Result := 0;
end;

function SetOnDrawWinInit(Value: AProc): AError;
begin
  {$IFDEF VCL}
  try
    DrawWin_SetOnDrawWinInit(Value);
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SetOnImportDataFromXls(Value: CadApp_OnImportDataFromXls_Proc): AError;
begin
  FOnImportDataFromXls := Value;
  Result := 0;
end;

function SetOnImportDataOk(Value: CadApp_OnImportDataOk_Proc): AError;
begin
  FOnImportDataOk := Value;
  Result := 0;
end;

function SetOnSaveFile(Value: CadApp_OnSaveFile_Proc): AError;
begin
  FOnSaveFile := Value;
  Result := 0;
end;

function SetPositionBranch(BranchNum: AInteger): AError;
begin
  {$IFDEF VCL}
  try
    Data_Branch_SetPosition(BranchNum);
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SetDataGrid(Value: AStringGrid): AError;
begin
  CadDataGrid := Value;
  Result := 0;
end;

function Show2D(): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := DrawWin_2D();
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function Show3D(PaintBox: AImage; X, Z: AInteger): ABoolean;
begin
  {$IFDEF VCL}
  try
    Result := DrawWin_3D(PaintBox, X, Z);
  except
    Result := False;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function ShowHelp(): AError;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_ShowHelp();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function ShowLegend(): AError;
begin
  {$IFDEF VCL}
  try
    CadApp_ShowLegend();
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function ShowLegendWin2P(var StrokaUO: APascalString): AError;
begin
  {$IFDEF VCL}
  try
    CadApp_ShowLegendWin2(StrokaUO);
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function ShowPrintDialog(): AError;
begin
  Result := CadApp_ShowPrintDialog();
end;

function ShowPrinterSetupDialog(): AError;
begin
  {$IFDEF VCL}
  Result := AUI.Dialog_PrinterSetup();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function ShowSettingsWin(): AInteger;
begin
  {$IFDEF VCL}
  try
    Result := CadApp_ShowSettingsWin();
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

end.
