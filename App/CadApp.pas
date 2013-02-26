{**
@Abstract Cad.App
@Author Prof1983 <prof1983@ya.ru>
@Created 30.11.2009
@LastMod 26.02.2013
}
unit CadApp;

{$IFDEF HomeCad}{$DEFINE NoVcl}{$ENDIF}

{$ifndef NoVcl}
  {$define Vcl}
{$endif}

interface

uses
  Types,
  ABase,
  ABaseTypes,
  AUiBase,
  AUiDialogs2,
  CadAppBase,
  CadAppData,
  CadAppDataUtils,
  CadAppLoader,
  CadCoreBase,
  CadDrawBase;

{** Расчитывает видимые фигуры }
function CalcVisible(): AError; stdcall;

function CreateNewProject(): AError; stdcall;

{** Выводит значок ПЛА }
function DrawPla(): AError; stdcall;

{** Финализирует модуль CadApp }
function Fin(): AError; stdcall;

{** Возвращает номер строки по номеру ветви }
function FindBranchByNum(BranchNum: AInt): AInt; stdcall;

{** Возвращает номер строки для узла NodeNum }
function FindNodeByNum(NodeNum: AInt): AInt; stdcall;

{** Возвращает объект-событие обновления данных }
function GetCompileExtDataEvent(): AEvent; stdcall;

{** Возвращает индекс активного слоя }
function GetCurrentLayerIndex(): AInt; stdcall;

function GetMaxViewPort(): TRect; stdcall;

{** Инициализирует модуль CadApp }
function Init(): AError; stdcall;

{** Выбор катринки для вставки в рисунок }
function InputPic(): ABool; stdcall;

{** Импортирует данные из файла данных }
function ImportDan(): AError; stdcall;

{** Загружает файл }
function LoadFileExP(const FileName: APascalString; FileType: AInt; IsAll: ABool): ABool;

{** Загружает файл }
function LoadFileP(const FileName: APascalString): AError;

{** Загружает графический файл
    @param PaintBox1 - (TImage) }
function LoadGraphFile2P(const FileName: APascalString; PaintBox1: AControl): ABool;

{** Загружает графический файл }
function LoadGraphFileP(const FileName: APascalString): AError;

{** Вызывает диалог выбор файла }
function Open2(DefFilterIndex: AInt; IsAll: ABool): ABool; stdcall;

{** Подготавливает перед инициализацией }
function Prepare(): AInt; stdcall;

{** Сохраняет схему и данные в файл
    @param FileName - Имя сохраняемого файла
    @param StrokaDan - Строка с данными
    @param StrokaUO - Строка с описанием условных обозначений
    @param Version - Версия файла для сохранения }
function SaveFileExP(const FileName, StrokaDan, StrokaUO: APascalString; Version: AInt): AError;

{** Делает указанную ветвь активной, переходит на соответсвующую строку данных в таблице ветвей,
    переводит позицию отображения схемы на нужную ветвь }
function SelectBranch(BranchNum: AInt): AInt; stdcall;

{** Устанавливает режим отображения всех фигур }
function SetIsShowAllFigures(Value: ABool): AError; stdcall;

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
function SetPositionBranch(BranchNum: AInt): AError; stdcall;

function SetDataGrid(Value: AStringGrid): AError; stdcall;

{** Отображает 2D cхему }
function Show2D(): ABool; stdcall;

{** Отображает 3D cхему }
function Show3D(PaintBox: AImage; X, Z: AInt): ABool; stdcall;

{** Отображает справку по программе }
function ShowHelp(): AError; stdcall;

{** Отображает редактор условных обозначений }
function ShowLegend(): AError; stdcall;

{** Отображает редактор условных обозначений }
function ShowLegendWin2P(var StrokaUO: APascalString): AError;

{** Отображает диалоговое окно для печати всей схемы }
function ShowPrintDialog(): AError; stdcall;

{** Отображает окно выбора и настройки печати }
function ShowPrinterSetupDialog(): AError; stdcall;

{** Вызов диалога "Опции" }
function ShowSettingsWin(): AInt; stdcall;

implementation

uses
  {$ifdef Vcl}CadMainWin,{$endif}
  CadAppMain;

{ Public }

function CalcVisible(): AError;
begin
  {$IFDEF VCL}
  Result := CadApp_CalcVisible();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function CreateNewProject(): AError;
begin
  Result := CadApp_CreateNewProject();
end;

function DrawPla(): AError;
begin
  {$IFDEF VCL}
  Result := CadApp_DrawPla();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function Fin(): AError;
begin
  Result := CadApp_Fin();
end;

function FindBranchByNum(BranchNum: AInt): AInt;
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

function FindNodeByNum(NodeNum: AInt): AInt;
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

function GetCurrentLayerIndex(): AInt;
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

function InputPic(): ABool;
begin
  {$IFDEF VCL}
  Result := CadApp_InputPic();
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function LoadFileExP(const FileName: APascalString; FileType: AInt; IsAll: ABool): ABool;
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

function LoadGraphFile2P(const FileName: APascalString; PaintBox1: AControl): ABool;
begin
  Result := CadApp_LoadGraphFileA(FileName, PaintBox1);
end;

function LoadGraphFileP(const FileName: APascalString): AError;
begin
  Result := CadApp_LoadGraphFileP(FileName);
end;

(*function Logger_AddP(const Text: APascalString): AInt;
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
end;*)

function Open2(DefFilterIndex: AInt; IsAll: ABool): ABool;
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

function Prepare(): AInt;
begin
  {$IFDEF VCL}
  Result := CadApp_Prepare();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SaveFileExP(const FileName, StrokaDan, StrokaUO: APascalString; Version: AInt): AError;
begin
  {$IFDEF VCL}
  Result := CadApp_SaveFileExP(FileName, StrokaDan, StrokaUO, Version);
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SelectBranch(BranchNum: AInt): AInt;
begin
  {$IFDEF VCL}
  Result := CadApp_SelectBranch(BranchNum);
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SetDocDirectory(const Value: AWideString): AError;
begin
  DocDirectory := Value;
  Result := 0;
end;

function SetIsShowAllFigures(Value: ABool): AError;
begin
  Result := CadApp_SetIsShowAllFigures(Value);
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

function SetPositionBranch(BranchNum: AInt): AError;
begin
  {$IFDEF VCL}
  Result := CadApp_SetPositionBranch(BranchNum);
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function SetDataGrid(Value: AStringGrid): AError;
begin
  CadDataGrid := Value;
  Result := 0;
end;

function Show2D(): ABool;
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

function Show3D(PaintBox: AImage; X, Z: AInt): ABool;
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
  Result := CadApp_ShowLegend();
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
  Result := AUi_ExecutePrinterSetupDialog();
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

function ShowSettingsWin(): AInt;
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
