{**
@Author Prof1983 <prof1983@ya.ru>
@Created 08.08.2011
@LastMod 22.03.2013

    -----------
    | CadDraw |
    -----------
         |
  ---------------
  | CadDrawMain |
  ---------------
         |
  ================
  | CadDrawPrint |
  ================
         |
--------------------
| CadDrawPrimitive |
--------------------
}
unit CadDrawPrint;

interface

uses
  Types,
  ABase,
  CadDrawBase;

{** Выводит изображение на печать.
    @param IsShowAllFigures = CadAppData.IsShowAllFigures
    @param DrawWay - Отрисовывать маршрут вывода людей }
function CadDraw_Print(const ImgPath: APascalString; FieldRect, MMRect, DocRect: TRect;
    AirFlag: AInt; IsShowAllFigures, IsPortret, IsBwPrint, PrintStamp, PrintBord: ABool;
    const Format: APascalString; CopiesCount: AInt): AError;

implementation

uses
  Graphics,
  Math,
  Printers,
  Windows,
  CadDrawData,
  CadDrawMain,
  CadDrawPrimitive,
  CadDrawScene;

// --- Forward ---

procedure _SetPrinterOrientation(Xf, Yf, ScaleXm, ScaleYm: Integer; IsPortret: Boolean; out Xn, Ym: Integer); forward;

// --- Private ---

procedure _Print(const ImgPath: string; FieldRect, MMRect, DocRect: TRect; AirFlag: AInteger;
    IsShowAllFigures, IsDrawWay, IsPortret, IsBWPrint, PrintStamp, PrintBord: Boolean;
    const Format: string; CopiesCount: Integer);
var
  Scale: Real;
  Scale1: Real;
  Scale2: Real;
  ScaleX: Integer;
  ScaleY: Integer;
  ScaleXm: Integer;
  ScaleYm: Integer;
  POffY: Integer;
  POffX: Integer;
  Select: Integer;
  Rc2: TRect;
  Rc3: TRect;
  Rc4: TRect;
  Col1: TColor;
  Col2: TColor;
  Col3: TColor;
  Col4: TColor;
  i: Integer;
  j: Integer;
  Xn: Integer;             // Кол-во страниц по X
  Ym: Integer;             // Кол-во страниц по Y
  xp,yp: Integer;
  drx,dry: Integer;
  PrevMetafile: TMetafile;
  MetaCanvas: TMetafileCanvas;
  Pages: array of array of TRect;
  PagesMM: array [0..1] of array of TPoint;
  t1: Integer;
  t2: Integer;
  ttLeft: Integer;
  ttBottom: Integer;
  ttRight: Integer;
  ttTop: Integer;
  OldS: Real;
  DocScale: Real;
  OldVP: TRect;
  rgn: HRGN;
  rrr: TRect;
  rrr1: TRect;
  R: TRect;
  Xf: Integer; // Ширина в миллиметрах
  Yf: Integer; // Высота в миллиметрах
  Coll: TGCollFigure;
begin
  Coll := Scene.Coll;
  // Расчитываем окно для печати
  // масштабные коэффициенты
  ScaleX := GetDeviceCaps(Printer.Handle,HORZRES); // Пикселы
  ScaleY := GetDeviceCaps(Printer.Handle,VERTRES);
  ScaleXm := GetDeviceCaps(Printer.Handle,HORZSIZE); // Миллиметры
  ScaleYm := GetDeviceCaps(Printer.Handle,VERTSIZE);
  POffY := GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY); // Смещения полей
  POffX := GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX);

  Scale1 := ScaleX/ScaleXm;
  Scale2 := ScaleY/ScaleYm;

  // Вычисляем ширину в миллиметрах
  Xf := MMRect.Right - MMRect.Left;
  // Вычисляем высоту в миллиметрах
  Yf := MMRect.Bottom - MMRect.Top;
  // Устанавливаем положение бумаги
  _SetPrinterOrientation(Xf, Yf, ScaleXm, ScaleYm, IsPortret, Xn, Ym);

  // число страниц на которые следует разбить
  Printer.Copies := CopiesCount;
  SetLength(Pages,xn);
  for i := 0 to xn-1 do
    SetLength(Pages[i],ym);
  SetLength(PagesMM[0],xn);
  SetLength(PagesMM[1],ym);

  if PrintStamp then
  begin
    ttLeft := 30+5;
    ttBottom := 65+5;
    ttRight := 15+5;
    ttTop := 15+5;
  end
  else
  begin
    ttLeft := 10+5;
    ttBottom := 10+5;
    ttRight := 10+5;
    ttTop := 10+5;
  end;

  // Расчитываем прямоугольники страниц в пикселях
  for i := 0 to xn-1 do
  begin
    for j := 0 to ym-1 do
    begin
      if (i = 0) then
        rrr.Left := Round((FieldRect.Left+ttLeft)*Scale1 - POffX)
      else
        rrr.Left := 0;
      if (i = xn-1) then
        rrr.Right := Round(ScaleX-(FieldRect.Right+ttRight)*Scale1 + POffX)
      else
        rrr.Right := ScaleX;
      if (j = 0) then
        rrr.Top := Round((FieldRect.Top+ttTop)*Scale2 - POffX)
      else
        rrr.Top := 0;
      if (j = ym-1) then
        rrr.Bottom := Round(ScaleY-(FieldRect.Bottom+ttBottom)*Scale2 + POffY)
      else
        rrr.Bottom := ScaleY;
      if (rrr.Top < 0) then rrr.Top := 0;
      if (rrr.Left < 0) then rrr.Left := 0;
      if (rrr.Right < 0) then rrr.Right := 0;
      if (rrr.Bottom < 0) then rrr.Bottom := 0;
      Pages[i,j] := rrr;
    end;
  end;

  // Высчитываем масштаб изображения
  t1 := 0;
  t2 := 0;
  for i := 0 to (xn-1) do
    t1 := t1 + Pages[i,0].Right - Pages[i,0].Left;
  for j := 0 to (ym-1) do
    t2 := t2 + Pages[0,j].Bottom - Pages[0,j].Top;
  DocScale := Min((t1/Abs(DocRect.Left - DocRect.Right)),
                  (t2/Abs(DocRect.Bottom - DocRect.Top)));

  t1 := 0;
  t2 := 0;
  // Расчитываем прямоугольники страниц в мм
  for I := 0 to (xn-1) do
  begin
    PagesMM[0,i].X := DocRect.Left + Round(t1/DocScale);
    t1 := t1 + Pages[I,0].Right - Pages[I,0].Left;
    PagesMM[0,i].Y := DocRect.Left + Round(t1/DocScale);
  end;
  for j := 0 to (ym-1) do
  begin
    PagesMM[1,j].X := DocRect.Top - Round(t2/DocScale);
    t2 := t2 + Pages[0,j].Bottom - Pages[0,j].Top;
    PagesMM[1,j].Y := DocRect.Top - Round(t2/DocScale);
  end;

  if (PagesMM[0,xn-1].Y < DocRect.Right) then
    PagesMM[0,xn-1].Y := DocRect.Right;
  if (PagesMM[1,ym-1].Y < DocRect.Bottom) then
    PagesMM[1,ym-1].Y := DocRect.Bottom;
  // размер отдельной страниицы в миллиметрах
  OldS := Coll.Scale;
  OldVP := Coll.VP;
  Coll.Scale := DocScale;
  // начинаем печатать
  PrevMetafile := nil; // создаем метафайл -
  MetaCanvas := nil; // его можно использовать для просмотря

  try
    PrevMetaFile := TMetaFile.Create;
    PrevMetaFile.Enhanced := True;
    try
      Printer.BeginDoc;
      for i := 0 to (xn-1) do
      for j := 0 to (ym-1) do
      begin
        try
          MetaCanvas := TMetafileCanvas.Create(PrevMetafile, 0);
          PrevMetafile.Width := Pages[i,j].Right - Pages[i,j].Left;
          PrevMetafile.Height := Pages[i,j].Bottom - Pages[i,j].Top;

          // рисуем
          MetaCanvas.Brush.Style := bsSolid;    //Очищаем сначала
          MetaCanvas.Brush.Color := clWhite;
          MetaCanvas.FillRect(MetaCanvas.ClipRect);
          MetaCanvas.Brush.Style := bsclear;
          MetaCanvas.Pen.Color := clBlack;
          Coll.VP := Rect(PagesMM[0,i].X, PagesMM[1,j].X, PagesMM[0,i].Y, PagesMM[1,j].Y);
          // Расчитываем видимые фигуры
          CadDraw_CalcVisible(IsShowAllFigures);
          // Рисуем страницу в метафайл
          CadDraw_Draw1(ACanvas(MetaCanvas), ImgPath, CadDrawData.BackColor1, AirFlag, True, IsBWPrint, False, False, IsDrawWay, False);
        finally
          MetaCanvas.Free;
        end;

        try
          // Печатаем метафайл на принтер
          Printer.Canvas.Lock;

          rgn := CreateRectRgn(0,0,(ScaleX-POffX),(ScaleY-POffY));

          // Задаем поля на принтере
          SelectClipRgn(Printer.Canvas.Handle,rgn);
          SetViewPortOrgEx(Printer.Canvas.Handle,Pages[i,j].Left,Pages[i,j].Top,nil);
          Printer.Canvas.Brush.Style := bsClear;
          if (PrintStamp) or (PrintBord) then
            Printer.Canvas.Rectangle(Printer.Canvas.ClipRect);

          rrr1 := Printer.Canvas.ClipRect;
          if (PrintStamp) then
          begin
            rrr1.Left := rrr1.Left+Round((FieldRect.Left+ttLeft-15)*Scale1);
            rrr1.Top := rrr1.Top+Round((FieldRect.Top+ttTop-15)*Scale2);
            rrr1.Right := rrr1.Right-Round((FieldRect.Right+ttRight-15)*Scale1);
            rrr1.Bottom := rrr1.Bottom-Round((FieldRect.Bottom+ttTop-15)*Scale2);

            Printer.Canvas.Pen.Width := 10;

            if (j = 0) then
            begin
              Printer.Canvas.MoveTo(rrr1.Left,rrr1.Top);
              Printer.Canvas.LineTo(rrr1.Right,rrr1.Top);
            end;
            if (i = 0) then
            begin
              Printer.Canvas.MoveTo(rrr1.Left,rrr1.Top);
              Printer.Canvas.LineTo(rrr1.Left,rrr1.Bottom);
            end;
            if (j = ym-1) then
            begin
              Printer.Canvas.MoveTo(rrr1.Left,rrr1.Bottom);
              Printer.Canvas.LineTo(rrr1.Right,rrr1.Bottom);
            end;
            if (i = xn-1) then
            begin
              Printer.Canvas.MoveTo(rrr1.Right,rrr1.Bottom);
              Printer.Canvas.LineTo(rrr1.Right,rrr1.Top);
            end;

            if (i = xn-1) and (j = ym-1) then
            begin
              if Assigned(FOnStampDraw) then
              begin
                R := Printer.Canvas.ClipRect;
                FOnStampDraw(AInteger(Printer.Canvas), R.Right, R.Bottom, R.Left, R.Top, Scale1, Scale2, True);
              end;
            end;
          end;

          // Проигрываем метафайл на принтере
          Printer.Canvas.Draw(1,1,PrevMetafile);
          Printer.Canvas.UnLock;
          DeleteObject(rgn);
        except
          Printer.Abort;
        end;

        if not((j = ym-1) and (i = xn-1)) then
          Printer.NewPage; // Начинаем новую страницу
      end;
    finally
      Printer.EndDoc;       // Заканчиваем печать
    end;
  finally
    PrevMetafile.Free;     // Освобождаем метафайл
  end;
  // удаляем массивы
  Pages := nil;
  PagesMM[0] := nil;
  PagesMM[1] := nil;
  Coll.Scale := OldS;
  Coll.VP := OldVP;
end;

{ Устанавливает положение бумаги
  Xf, Yf - Ширина и высота в миллиметрах }
procedure _SetPrinterOrientation(Xf, Yf, ScaleXm, ScaleYm: Integer; IsPortret: Boolean; out Xn, Ym: Integer);
var
  Ori: TPrinterOrientation;
  rr1: Real;
  rr2: Real;
  Xn1: Integer;
  Ym1: Integer;
  r1: Real;
  r2: Real;
begin
  Xn := Xf div ScaleXm;
  Ym := Yf div ScaleYm;
  if (Xn = 0) then Xn := 1;
  if (Ym = 0) then Ym := 1;

  // Коэффициенты
  rr1 := Xf / ScaleXm;
  rr2 := Yf / ScaleYm;
  // Тут одна страница
  if (rr1 < 1.1) and (rr2 < 1.1) then
  begin
    if IsPortret then
      Printer.Orientation := poPortrait
    else
      Printer.Orientation := poLandscape;
  end
  else
  begin // тут разбиение
    // Ориентация принтера
    Ori := Printer.Orientation;

    Xn1 := Xf div ScaleYm;
    Ym1 := Yf div ScaleXm; // обратная
    r1 := Xn*Ym;
    r2 := Xn1*Ym1;
    if (r2 > r1) then   // Положение бумаги
    begin
      if (Ori = poPortrait) then
        Printer.Orientation := poLandscape
      else
        Printer.Orientation := poPortrait;
    end;
  end;
end;

// --- CadDraw ---

function CadDraw_Print(const ImgPath: APascalString; FieldRect, MMRect, DocRect: TRect;
    AirFlag: AInt; IsShowAllFigures, IsPortret, IsBwPrint, PrintStamp, PrintBord: ABool;
    const Format: APascalString; CopiesCount: AInt): AError;
begin
  try
    _Print(ImgPath, FieldRect, MMRect, DocRect, AirFlag,
        IsShowAllFigures, DrawWay, IsPortret, IsBWPrint, PrintStamp, PrintBord,
        Format, CopiesCount);
    Result := 0;
  except
    Result := -1;
  end;
end;

end.
 