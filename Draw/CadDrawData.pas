{**
@Author Prof1983 <prof1983@ya.ru>
@Created 12.07.2011
@LastMod 22.03.2013
}
unit CadDrawData;

interface

uses
  Types,
  ABase,
  ABaseTypes,
  CadDrawBase;

var
  {** Цвет фона }
  BackColor1: AColor;
  {** True -> Pic; False -> UO }
  IsPic1: Boolean;
  {** Индекс к текущей картинке }
  PicIndex1: Integer;
  {** Имя файла с картинкой (PicName1) - избавиться? }
  PicName_: string;
  {** Временные точки }
  P01: TPoint;
  P02: TPoint;
  PolyPoints: Integer;
  MouseDrag: Boolean;
  {** Старые временные координаты узла }
  OldXY: TPoint;
  PhotoPathDefault: Boolean;
  PhotoPathStr: string;
  PlaPathStr: string;
  IsSxema3D: Boolean;
  UgolXg: Real;
  UgolZg: Real;

  {** Событие срабатывает при неоходимости запуска таймера (для отрисовки ПЛА) }
  FOnEnableTimer: AProc;
  {** Событие для отрисовки штампа }
  FOnStampDraw: TStampDrawProc;

implementation

end.
 