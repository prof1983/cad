{**
@Abstract Cad.App base consts and types
@Author Prof1983 <prof1983@ya.ru>
@Created 12.07.2011
@LastMod 08.04.2013
}
unit CadAppBase;

interface

uses
  ABase;

const
  CadApp_Name = 'CadApp';
  CadApp_Uid = $11033101;

type
  CadApp_OnAppMessage_Proc = function(var Msg: AUInt; var WParam, LParam: AInt;
      var Handled: ABool): AError; stdcall;
  CadApp_OnImportDataFromXls_Proc = function(const FileName: AString_Type; IsAll: ABoolean): AError; stdcall;
  CadApp_OnImportDataOk_Proc = function(const Data: AWideString): AError; stdcall;

type
  {** Настройки колонок для отчета }
  TColSetting = record
    Enabled: Boolean;    //**< Включено
    Width: Real;         //**< Ширина колонки
  end;
  TColSettings = array of TColSetting;

type
  {** Вид отображения схемы:
      0-Нормальное распределение,
      1-Опрокинутые ветви,
      2-Распространение пожара,
      3-Ветви с отрицательным расходом,
      4-Ветви с заданным R }
  TCadAppViewMode = (
    CadAppViewMode_Normal,
    CadAppViewMode_OpVetvi,
    CadAppViewMode_FireVetvi,
    CadAppViewMode_OtrVetvi,
    CadAppViewMode_RRegVetvi
    );

implementation

end.
 