{**
@Abstract Cad.App data
@Author Prof1983 <prof1983@ya.ru>
@Created 02.07.2009
@LastMod 21.08.2012
}
unit CadAppData;

interface

uses
  ABase, AUiBase, CadAppBase, CadCoreBase, CadDrawBase;

var
  CadDataGrid: AStringGrid;

  {** Событие обновления данных }
  FCompileExtDataEvent: AEvent;

  FIsShowAllFigures: Boolean;

  NameSh_Text: APascalString;

  NameVar_Text: APascalString;

  FOnCompileExtData: AProc;

  {** Срабатывает при импорте данных из Xls файла }
  FOnImportDataFromXls: CadApp_OnImportDataFromXls_Proc;

  FOnImportDataOk: CadApp_OnImportDataOk_Proc;

  FOnSaveFile: CadApp_OnSaveFile_Proc;

  {** Событие срабатывает при необходимости в талице с данными установить указатель на требуемый элемент
      Obj - таблица - номер таблицы (0-Branchs, 1-Nodes)
      Data - номер элемента (ветви/узла) }
  FOnSetPosition: ACallbackProc;

  DocDirectory: APascalString;

  {** Окно отрисовки находится в режиме закрытия }
  DrawWin_IsClosing1: Boolean;

  {** Главное меню }
  MainToolMenu: AToolMenu;

  {** Вид отображения схемы:
      0-Нормальное распределение,
      1-Опрокинутые ветви,
      2-Распространение пожара,
      3-Ветви с отрицательным расходом,
      4-Ветви с заданным R }
  ViewMode: TCadAppViewMode;

  {** Основной элемент отрисовки графики }
  PaintBoxCanvas: ACanvas;

  {** Интерфейс к внешним данным }
  TablData_IsModyfid: Boolean;

implementation

end.
