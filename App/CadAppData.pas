{**
@Abstract Cad.App data
@Author Prof1983 <prof1983@ya.ru>
@Created 02.07.2009
@LastMod 08.04.2013
}
unit CadAppData;

interface

uses
  ABase, AUiBase, CadAppBase, CadCoreBase, CadDrawBase;

var
  {** Data update event }
  FCompileExtDataEvent: AEvent;

  FIsShowAllFigures: Boolean;

  NameSh_Text: APascalString;

  NameVar_Text: APascalString;

  OnAppMessage: CadApp_OnAppMessage_Proc;

  {** Event fires when needed clean data }
  FOnDataClear: AProc;

  FOnCompileExtData: AProc;

  OnFileOpen: AProc;

  OnFileSave: AProc;

  {** Event fires when importing data from Xls file }
  FOnImportDataFromXls: CadApp_OnImportDataFromXls_Proc;

  FOnImportDataOk: CadApp_OnImportDataOk_Proc;

  FOnNodeFocus: AProc;

  OnPaintBoxMouseDown: AProc;

  OnPlaClick: AProc;

  OnRefreshParams: AProc;

  OnSaveConfig: AProc;

  {** Event fires when required in the table with data set pointer to the desired item
      Obj - Table num (0-Branchs, 1-Nodes)
      Data - Element (branch/node) num }
  FOnSetPosition: ACallbackProc;

  FOnShow2D: AProc;

  OnShowData: AProc;

  DocDirectory: APascalString;

  {** True if the window rendering is in the closing }
  DrawWin_IsClosing1: Boolean;

  MainMenu: AMenu;
  MainFileMenu: AMenuItem;
  MainTaskMenu: AMenuItem;
  MainViewMenu: AMenuItem;

  {** View the display circuitry }
  ViewMode: TCadAppViewMode;

  {** The main element of rendering graphics }
  PaintBoxCanvas: ACanvas;

  {** Interface to external data }
  TablData_IsModyfid: Boolean;

  {** Branchs }
  FBranchGrid: AStringGrid;

  {** Nodes }
  FNodeGrid: AStringGrid;

  {** Ventilators }
  FVenGrid: AStringGrid;

  {** Stolb }
  FBlockGrid: AStringGrid;

  {** Worker ways }
  FWayWorkerGrid: AStringGrid;

  {** Saver ways }
  FWaySaverGrid: AStringGrid;

  {** The developed space }
  FVpGrid: AStringGrid;

// Settings - Table - Columns for print

var Check00: ABool;
var Check01: ABool;
var Check02: ABool;
var Check03: ABool;
var Check04: ABool;
var Check05: ABool;
var Check06: ABool;
var Check07: ABool;
var Check08: ABool;
var Check09: ABool;
var Check10: ABool;
var Check11: ABool;
var Check12: ABool;
var Check13: ABool;
var Check14: ABool;
var Check15: ABool;
var Check16: ABool;
var Check17: ABool;
var Check18: ABool;
var Check19: ABool;
var Check20: ABool;
var Check21: ABool;
var Check22: ABool;

var Col00: APascalString;
var Col01: APascalString;
var Col02: APascalString;
var Col03: APascalString;
var Col04: APascalString;
var Col05: APascalString;
var Col06: APascalString;
var Col07: APascalString;
var Col08: APascalString;
var Col09: APascalString;
var Col10: APascalString;
var Col11: APascalString;
var Col12: APascalString;
var Col13: APascalString;
var Col14: APascalString;
var Col15: APascalString;
var Col16: APascalString;
var Col17: APascalString;
var Col18: APascalString;
var Col19: APascalString;
var Col20: APascalString;
var Col21: APascalString;
var Col22: APascalString;

implementation

end.
