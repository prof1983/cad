{**
@Author Prof1983 <prof1983@ya.ru>
@Created 19.12.2009
@LastMod 11.04.2013
}
unit CadDrawTypes;

interface

uses
  Graphics,
  Types,
  ABase,
  CadConsts;

// --- Simple types ---

type
  // Значение по умолчанию = 'z'
  // 'r' - ветвь в работе
  TGBrCost = Char;              // r,z,o,s,p

// --- Simple struct ---

type
  TPointCoord = record
    X: Real;
    Y: Real;
    Z: Real;
    Z0: Real;
  end;

type
  TPointReal = record
    X: Real;
    Y: Real;
  end;

// --- Struct ---

type
  { запись для подключения внешних данных,
    данные никак себя не проявляют
    задаются и обрабатываются во внешних классах. От базового класа
    требуется только сохранять и загружать данные + добавлять запись }
  TGExtData = record
    Data1: Integer;    // Сами данные
    Coord: TPoint;     // координаты вывода
    CoordS_: TPoint;   // координаты вывода экранные
    CoordZ: TSize;     // размеры строки вывода в пикселах
    Enable: Boolean;   // а стоить ли выводить?
    Color: TColor;     // цвет стрелки или внутреннего круга ПЛА
    TypePla: Byte;     // тип аварии для ПЛА
    Angle: Real;       // угол вывода для внешних данных
    MoveFlag: Boolean; // двигали ли позицию?
  end;

type
  {** Набор данных для позиции ПЛА  }
  TCadPlaRec = record
    FlagPLA: ABool;             // выодить не выводить ПЛА
    Coord: TPoint;              // координаты вывода
    Color: TColor;              // цвет стрелки или внутреннего круга ПЛА
  end;
  TGPlaRecord = TCadPlaRec;

type
  {** Парметры ветви }
  TCadBranch = record
    BrNum: Integer;            // Номер ветви
    BrBNode: Integer;          // Номер начального узла
    BrENode: Integer;          // Номер конечного узла
    BrBNodeI: Integer;         // Индекс начального узла
    BrENodeI: Integer;         // Индекс конечного узла
    BrName: string;            // Название ветви

    BrCName: TPoint;           // Координаты названия ветви
    BrCoord: TPoint;           // Координаты номера ветви
    BrCNameZ: TSize;
    BrCoordZ: TSize;
    BrNEnable: Boolean;        // Разрешено ли выводить наименование ветви
    BrCEnable: Boolean;        // Разрешено ли выводить атрибуты ветви
    ExtCount: Integer;         // Число внешних данных
    //ANyAngle: Integer;       // 0-угол,2-вертикаль,1-горизонталь;

    ArrowData: TGExtData;      // Внешние данные - стрелка (версия < 5) / расход "стрелка"
    // Удалить
    ExtData2: TGExtData;       // Внешние данные - фактические расходы?
    ExtData3: TGExtData;       // Внешние данные - ПЛА
    ExtDataQ_Value: Real;      // ExtDataQ.Data2; 
    ExtData3_NomPla: Integer;  // Номер ПЛА.
    ExtData4: TGExtData;       // Внешние данные - давление в узлах
    ExtData6: TGExtData;       // Внешние данные - пожары / Угол расположения внешних данных
    ExtData7: TGExtData;       // Внешние данные
    ExtData8_: TGExtData;      // Внешние данные
    ExtDataQ: TGExtData;       // Внешние данные - фактические расходы(Data1) и расчетные расходы (Data2)

    // вывод нескольких позиций ПЛА массив записи
    PlaData: array[1..MaxPlaCount+1] of TCadPlaRec; // массив для ПЛА
    ArrowDefault: Boolean;     // стрелка: координаты по умолчанию - 1 или заданные - 0
    BrBranch: Boolean;         // для задач определяет какие вевтви закрашивать: опрокинутые ветви, пожары
    BrMoveCName: Boolean;      // Двигали или нет название ветви
    BrMoveCoord: Boolean;      // Двигали или нет номер ветви
    BrSost: TGBrCost;          // Состояние выработки.
    BrDataBegin: Integer;
    BRDataEnd: Integer;
    BrGotovo: Real;
    BrPl: Integer;             // Пласт
    BrTipV: Integer;           // Тип выработки
  end;
  TGCustomBranch = TCadBranch;

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
  {** Вид фигуры }
  TCadFigureTypeInt = type AInt;
  TGFigureType = TCadFigureTypeInt;
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
  cPodRabL = 1015;
  cPodRabPl = 1016; 
  cVstolb = 1017;
  cBrF = 2001;
  cNdF = 2002;
  cBrNF = 2003;
  cExtF = 2004;
  cTextF = 2005;
  cUOSize = 3001;

type
  // структура для картинок
  TCadImage = record
    Name: APascalString;        // Имя Файла
    Image: Graphics.TBitMap;    // Кокретное изображение
  end;
  TGCustomImage = TCadImage;

type
  TCadLayerRec = record
    Nom: AInt;
    Name: APascalString;
    LineType: AInt;             // Тип линии
    LajerLineColor: AColor;
    Width: AInt;                // Ширина линии
    LajerPenWidth: AInt;
  end;
  TGLayerRec = TCadLayerRec;

type
  {** Тип линии }
  TCadLineType = (
    cLineTypeDef = 0,     // По умолчанию
    cLineType1 = 1,       // Одинарная
    cLineType2 = 2,       // Двойная
    cLineType2b = 3,      // Двойная с заливкой
    cLineType3 = 4        // Пунктирная (штриховая)
    );                        

type // структура определения узлов
  TCadNode = record
    NdNum: Integer;                 // Номер узла
    NdPnt_X: AInt;                  // Координаты узла
    NdPnt_Y: AInt;                  // Координаты узла
    NdPnt_Z: AInt;                  // Координата Z
    NdPnt2D_X: AInt;                // Координаты узла
    NdPnt2D_Y: AInt;                // Координаты узла
    NdPntS: TPoint;                 // Координаты узла для отрисовки 2D (в пикселях)
    NdPnt3D: TPointCoord;           // Координаты узла для отрисовки 3D
    NdCoord: TPoint;                // Координаты вывода номера узла в единицах чертежа
    NdCoordS: TPoint;               // Координаты вывода номера узла в пикселях
    NdNSize: TSize;                 // Размер (ширина) номера в пикселах
    NdVis: Boolean;                 // Признак видимости узла
    NdEntry: Integer;               // Число ветвей которым принадлежит узел
    NdEnable: Boolean;              // Разрешено выводить узел или нет
    FGBRect: TRect;                 // Ограничивающий прямоугольник
    NdType: Integer;                // Тип узла
    NdVin: Boolean;                 // Выноска
    Davl: string;                   // Давление
    NVx: Integer;                   // Входящие ветви (кол-во) ?
    NIsx: Integer;                  // Исходящие ветви (кол-во) ?
    Vx: array[0..100] of Integer;   // Входящие ветви
    Isx: array[0..100] of Integer;  // Исходящие ветви
    IncBR: array[0..100] of Integer;// Массив индексов всех присоединенных ветвей
    NdSoprag: Boolean;              // Отрисовывать сопряжения или нет
    NPnt1: TPoint;                  // Координаты для соединения двойной линии при отсутсвии сопряжения
    NPnt2: TPoint;                  // Координаты для соединения двойной линии при отсутсвии сопряжения
  end;
  TGCustomNode = TCadNode;

type
  {** Режимы состояния курсора }
  TCadPenStyle = (
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
    cSvybOb,
    cSVvodOb,
    cSRectangleVP_Del,
    cSLine,
    cSElipse,
    cSVStolb,
    cSPodRabL,
    cSPodRabPl,
    cSPodRab
    );
  TPeroSost = TCadPenStyle;

type
  {** ПЛА }
  TCadPla = record
    Point: TPoint;              //**< Точка вывода активного ПЛА
    Typ: Byte;                  //**< Тип активного ПЛА
    Data: Integer;              //**< Данные активного ПЛА
    Color: TColor;              //**< Цвет круга активного ПЛА
  end;
  TGPla = TCadPla;

type
  TCadPlastRec = record
    Name: APascalString;
    Color: AInt;
    m: AFloat;
    Checked: ABool;
  end;
  TGPlastRec = TCadPlastRec;

type
  {** Внутренний тип для рисования стрелок - полигонами }
  TCadPoly = record
    IsLong: ABool;
    Count: AInt;
    // Конкретное изображение
    ppt: array [1..11] of TPoint;
  end;
  TGCustomPoly = TCadPoly;

type
  TCadProp = record
    FGType: TCadLineType;      // Тип линии
    FGPen: TPenData;           // свойство пера
    FGBrush: TBrushData;       // Свойство заливки
    Width: Integer;            // Ширина примитива - записываемая
    WidthDefault: Boolean;     // ширина: по умолчанию -  true - da
    PenBrushDefault: Boolean;  // цвет: цвет по умолчанию -
  end;
  TGProp = TCadProp;

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
  cIFact = 8;
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
  cITipV = 44;
  cIPl = 45;
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

// --- File format ---

type
  // Заголовок
  GFHeader = record
    Signature: array[0..3] of char;//4b
    Version: Integer;              //4b
    NameDraft: string[80];         //80 или 84?
    Count: Integer;                //4b
    Metrix: Integer;               //4b
    Reserv: array[0..100] of byte; //100b
  end;

type
  // Блок данных
  GFHeaderobject = record
    GFType: Integer;     // Типа обекта
    GFOffset: Integer;   // Смещение до следующего объекта
  end;

type
  // Структура шрифта для сохранения в файл
  TGFontLocal = record
    CharSet: TFontCharset;
    Color: TColor;
    Name: TFontDataName;
    Pitch: TFontPitch;
    Size: Integer;
    Style: TFontStyles;
  end;
  // Тип для записи в Stream
  TGFontRec = TGFontLocal;
  //GFont = TGFontLocal;

implementation

end.
