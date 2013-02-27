{**
@Author Prof1983 <prof1983@ya.ru>
@Created 19.12.2009
@LastMod 27.02.2013
}
unit CadDrawTypes;

interface

uses
  ABase;

type
  {** Тип фигуры }
  TCadFigureType = (
    ftUncnown = 0,
    ftLine = 1,            // Ветвь-линия
    ftPic = 2,             //cTPic = 0,
    ftUo = 3,              //cTUO1 = 0,
    ft4 = 4,
    ftRectangle = 5,       // Прямоугольник
    ftPolygon = 6,         // Полигон
    ftArc = 7,             // Дуга
    ftElipse = 8           // Круг
    );

type
  {** Режимы состояния курсора }
  TPeroSost = (
    cSNone,            // выбор и рисоване
    cSSelect,
    cSLine_Branch,
    cSPolyline,
    cSArc,
    cSText,
    cSPicture,
    cSMove,            // Перемещение
    cSMovePaint,       // Перемещение схемы рукой
    cSMovePaintW,      // Перемещение схемы рукой
    cSPolygon,
    cSPlus,
    cSMinus,
    cSPlusRect,        // Масштабирование
    cSGetPoint,
    cSRectangle,       // Прямоугольник
    cSPrintRect,       // Печать
    cSEditWay,
    cSMoveGroup,
    cSMoveGroupGo,
    cSForwardPlan,
    cSPropGroup,
    cSvybOb,           // PLAN
    cSVvodOb,          // PLAN
    cSRectangleVP_Del,
    cSLine,
    cSElipse,
    cSVStolb,          // PLAN
    cSPodRabL,         // PLAN
    cSPodRabPl,        // PLAN
    cSPodRab           // PLAN
    );

type
  {** Тип линии }
  TCadLineType = (
    cLineTypeDef = 0,     // По умолчанию
    cLineType1 = 1,       // Одинарная
    cLineType2 = 2,       // Двойная
    cLineType2b = 3,      // Двойная с заливкой
    cLineType3 = 4        // Пунктирная (штриховая)
    );                        

type
  {** Типы столбцов }
  TCadPropType = type AInt;
const
  cINone = 0;
  cIType = 1;
  cIName = 2;                   // Наименование ветви. Переименовать в cIBranchName.
  cIBr = 3;
  cINd1 = 4;
  cINd2 = 5;
  cIWidth = 6;
  cIColor = 7;
  cICoord = 8;
  cIPla = 9;
  cINZS = 11;
  cIFact_Degas = 12;  // Degassing,Planning
  cIFact_VentCad = 8;
  cIText = 13;
  cIFont = 14;
  cIPic = 15;
  cIPicName = 16;
  cIUOName = 17;
  cIUOAngl = 18;
  cINameUO = 19;
  cINdType = 20; //cIuoBr=20;
  cINdVin = 22;
  cIArrow = 23;  // стрелка
  cIPicNum = 24;
  cIPicAngle = 25;
  cIPicSize = 27;
  cIPicType = 28;
  cIUONum = 29;
  cIUOSize = 30;
  cIUOType = 31;
  cIPrType = 32;
  cIImage = 33; // для фото
  cIVisible = 34;
  cILajer = 35;
  cINomBr = 36;
  cINdNum = 37;
  cINdVid = 38;
  cINdDavl = 39;
  CINDx = 40;
  cINdY = 41;
  cINdZ = 42;
  cINdZ0 = 43;
  cITipV = 44;   // (VentCad)
  cIPl = 45;     // (VentCad)
  cIOstZap = 46;
  cIDataBegin = 47;
  cIDataEnd = 48;
  cITypOb = 49;
  cINameVS = 50;                // Наименование фигуры
  cINomVS = 51;

type
  {** Тип перемещаемой фигуры }
  TMoveCode = (
    cMNone,
    cMBranch, // Не используется
    cMNode,
    cMText,
    cMBrName,
    cMBrNum,
    cMPicture,
    cMNdNum,
    cMUO,
    cMPolyNode,
    cMExtData,
    cMRectangle,
    cMPolygon,
    cMPrRect,
    cMStolb,
    cMLine,
    cMElipse,
    cMArc);

type
  RTipVyr = record
    Name: string;
    TipL: AInt;
    Balans: AInt;
    Color: AInt;
    Checked: ABool;
  end;

type
  {** Направление скроллинга }
  TCadScroll = (
    csLeft,
    csRight,
    csUp,
    csDown
    );

type
  {** Вид фигуры }
  TGFigureType = type AInt;
const
  cNone = 0;
  cLine_Branch = 1001;
  cPolyline = 1002;
  cArc = 1003;
  cText = 1004;
  cPicture = 1005;
  cUO = 1006;
  cNode = 1007;                 // Узел
  cRectangle = 1008;
  cALine = 1011;
  cElipse = 1009;
  cPie = 1012;
  cPolygon = 1010;
  cPodRabL = 1015; // PLAN
  cPodRabPl = 1016; // PLAN
  cVstolb = 1017;
  cBrF = 2001;
  cNdF = 2002;
  cBrNF = 2003;
  cExtF = 2004;
  cTextF = 2005;
  cUOSize = 3001;

implementation

end.
