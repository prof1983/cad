{**
@Abstract CadStamp
@Author Prof1983 <prof9183@ya.ru>
@Created 19.08.2010
@LastMod 15.03.2013
}
unit CadStampMain;

{define AStdCall}

interface

uses
  ABase,
  AUiMainWindow2,
  AUtilsMain,
  CadAppData,
  CadCoreBase,
  CadDraw,
  CadStampData;

// --- CadStamp ---

function CadStamp_Fin(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadStamp_Init(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadStamp_SaveDanP(): APascalString;

function CadStamp_Show(): AError; {$ifdef AStdCall}stdcall;{$endif}

implementation

uses
  Graphics, Types, Windows,
  fStamp;

// --- Forward ---

procedure _Stamp_Draw(Canvas: TCanvas; P0, P1: TPoint; ScaleX, ScaleY: Real; IsPrint: Boolean); forward;

// --- Events ---

procedure DoStampDraw(Canvas: AInt{TCanvas}; P0X, P0Y, P1X, P1Y: AInt; Scale1, Scale2: AFloat32; IsPrint: ABool); stdcall;
begin
  _Stamp_Draw(TCanvas(Canvas), Point(P0X,P0Y), Point(P1X,P1Y), Scale1, Scale2, IsPrint);
end;

function DoStampSettings(Obj, Data: AInt): AError; stdcall;
begin
  try
    Result := CadStamp_Show();
  except
    Result := -1;
  end;
end;

// --- Private ---

procedure _SaveDanStamp(const Stamp: TStampDataRec; var StrokaDan: string);
var
  j: Integer;
begin
  StrokaDan := StrokaDan+'E;'+AUtils_IntToStrP(StampData.Ed1FontSize)+';';;
  StrokaDan := StrokaDan +
      StampData.Ed1 + ';' +
      StampData.Ed6 + ';' +
      StampData.Ed7 + ';' +
      StampData.Ed8 + ';' +
      StampData.Ed9 + ';' +
      StampData.Ed10 + ';' +
      StampData.Ed11 + ';' +
      StampData.Ed12 + ';' +
      StampData.Ed13 + ';' +
      StampData.Ed14 + ';' +
      StampData.Ed15 + ';' +
      StampData.Ed16 + ';' +
      StampData.Ed17 + ';' +
      StampData.Ed18 + ';' +
      StampData.Ed19 + ';' +
      StampData.Ed20 + ';#';

  StrokaDan := StrokaDan+'X;'+AUtils_IntToStrP(Stamp.Mem2FontSize)+';';
  for j := 0 to Stamp_Mem2_Count - 1 do
    StrokaDan := StrokaDan+Stamp_Mem2[j]+';';
  StrokaDan := StrokaDan+'#';

  StrokaDan := StrokaDan+'Y;'+AUtils_IntToStrP(Stamp.Mem3FontSize)+';';
  for j := 0 to Stamp_Mem3_Count - 1 do
    StrokaDan := StrokaDan+Stamp_Mem3[j]+';';
  StrokaDan := StrokaDan+'#';

  StrokaDan := StrokaDan+'Z;'+AUtils_IntToStrP(Stamp.Mem4FontSize)+';';
  for j := 0 to Stamp_Mem4_Count - 1 do
    StrokaDan := StrokaDan+Stamp_Mem4[j]+';';
  StrokaDan := StrokaDan+'#';

  StrokaDan := StrokaDan+'Q;'+AUtils_IntToStrP(Stamp.Mem5FontSize)+';';
  for j := 0 to Stamp_Mem5_Count - 1 do
    StrokaDan := StrokaDan+Stamp_Mem5[j]+';';
  StrokaDan := StrokaDan+'#';

  StrokaDan := StrokaDan+ '#';
end;

procedure _Stamp_Draw(Canvas: TCanvas; P0, P1: TPoint; ScaleX, ScaleY: Real; IsPrint: Boolean);

  procedure Line1(P1, P2: TPoint);
  begin
    Canvas.MoveTo(P1.X, P1.Y);
    Canvas.LineTo(P2.X, P2.Y);
  end;

  procedure TextOut1(P: TPoint; const Text: string);
  begin
    Canvas.TextOut(P.X + 10, P.Y, Text);
  end;

  function sx(x: Integer): Integer;
  begin
    Result := Round(x*ScaleX);
  end;

  function sy(x: Integer): Integer;
  begin
    Result := Round(x*ScaleY);
  end;

var
  P: array[1..11,1..12] of TPoint;

  procedure TextOutMem2(G: Integer);
  var
    ns: Integer;
  begin
    ns := Stamp_Mem2_Count;
    case ns of
      1: Canvas.TextOut(g,p[7,5].y,Stamp_Mem2[0]);
      2:
        begin
          Canvas.TextOut(g,p[7,4].y+sy(2),Stamp_Mem2[0]);
          Canvas.TextOut(g,p[7,5].y+sy(2),Stamp_Mem2[1]);
        end;
      3:
        begin
          Canvas.TextOut(g,p[7,4].y,Stamp_Mem2[0]);
          Canvas.TextOut(g,p[7,5].y,Stamp_Mem2[1]);
          Canvas.TextOut(g,p[7,6].y,Stamp_Mem2[2]);
        end;
    end;
  end;

  procedure TextOutMem3(G: Integer);
  var
    ns: Integer;
  begin
    ns := Stamp_Mem3_Count; //Length(Stamp_Mem3);
    case ns of
      1: Canvas.TextOut(g,p[7,8].y,Stamp_Mem3[0]);
      2:
        begin
          Canvas.TextOut(g,p[7,8].y-sy(2),Stamp_Mem3[0]);
          Canvas.TextOut(g,p[7,9].y-sy(2),Stamp_Mem3[1]);
        end;
      3:
        begin
          Canvas.TextOut(g,p[7,7].y,Stamp_Mem3[0]);
          Canvas.TextOut(g,p[7,8].y,Stamp_Mem3[1]);
          Canvas.TextOut(g,p[7,9].y,Stamp_Mem3[2]);
        end;
    end;
  end;

  procedure TextOutMem4(G: Integer);
  var
    ns: Integer;
  begin
    ns := Stamp_Mem4_Count; //Length(Stamp_Mem4);
    case ns of
      1: Canvas.TextOut(g,p[7,11].y,Stamp_Mem4[0]);
      2:
        begin
          Canvas.TextOut(g,p[7,10].y,Stamp_Mem4[0]);
          Canvas.TextOut(g,p[7,11].y,Stamp_Mem4[1]);
        end;
      3:
        begin
          Canvas.TextOut(g,p[7,10].y,Stamp_Mem4[0]);
          Canvas.TextOut(g,p[7,11].y,Stamp_Mem4[1]);
          Canvas.TextOut(g,p[7,12].y,Stamp_Mem4[2]);
        end;
      4:
        begin
          Canvas.TextOut(g,p[7,10].y-sy(1),Stamp_Mem4[0]);
          Canvas.TextOut(g,p[7,11].y-sy(2),Stamp_Mem4[1]);
          Canvas.TextOut(g,p[7,12].y-sy(3),Stamp_Mem4[2]);
          Canvas.TextOut(g,p[7,12].y,Stamp_Mem4[3]);
        end;
    end;
  end;

  procedure TextOutMem5(G: Integer);
  var
    ns: Integer;
  begin
    ns := Stamp_Mem5_Count; //Length(Stamp_Mem5);
    case ns of
      1: Canvas.TextOut(g,p[8,11].y,Stamp_Mem5[0]);
      2:
        begin
          Canvas.TextOut(g,p[8,10].y+sy(3),Stamp_Mem5[0]);
          Canvas.TextOut(g,p[8,11].y+sy(3),Stamp_Mem5[1]);
        end;
      3:
        begin
          Canvas.TextOut(g,p[8,10].y,Stamp_Mem5[0]);
          Canvas.TextOut(g,p[8,11].y,Stamp_Mem5[1]);
          Canvas.TextOut(g,p[8,12].y,Stamp_Mem5[2]);
        end;
    end;
  end;

var
  i: Integer;
  g: Integer;
  Rect: TRect;
  StampForm: TStampForm;
begin
  StampForm := TStampForm.Create(nil);
  StampForm.LoadStamp();

  p0.X := p0.X - sx(5);
  p0.Y := p0.Y - sy(5);
  Rect.Left := p1.X+sx(20);
  Rect.Top := p1.Y+sy(5);
  Rect.Right := p0.X;
  Rect.Bottom := p0.Y;

  for i := 1 to 12 do p[1,i].X := P0.X-sx(185);
  for i := 1 to 12 do p[2,i].X := P0.X-sx(175);
  for i := 1 to 12 do p[3,i].X := P0.X-sx(165);
  for i := 1 to 12 do p[4,i].X := P0.X-sx(155);
  for i := 1 to 12 do p[5,i].X := P0.X-sx(145);
  for i := 1 to 12 do p[6,i].X := P0.X-sx(130);
  for i := 1 to 12 do p[7,i].X := P0.X-sx(120);
  for i := 1 to 12 do p[8,i].X := P0.X-sx(50);
  for i := 1 to 12 do p[9,i].X := P0.X-sx(35);
  for i := 1 to 12 do p[10,i].X := P0.X-sx(20);
  for i := 1 to 12 do p[11,i].X := P0.X;

  for i := 1 to 11 do p[i,1].Y := P0.Y-sy(55);
  for i := 1 to 11 do p[i,2].Y := P0.Y-sy(50);
  for i := 1 to 11 do p[i,3].Y := P0.Y-sy(45);
  for i := 1 to 11 do p[i,4].Y := P0.Y-sy(40);
  for i := 1 to 11 do p[i,5].Y := P0.Y-sy(35);
  for i := 1 to 11 do p[i,6].Y := P0.Y-sy(30);
  for i := 1 to 11 do p[i,7].Y := P0.Y-sy(25);
  for i := 1 to 11 do p[i,8].Y := P0.Y-sy(20);
  for i := 1 to 11 do p[i,9].Y := P0.Y-sy(15);
  for i := 1 to 11 do p[i,10].Y := P0.Y-sy(10);
  for i := 1 to 11 do p[i,11].Y := P0.Y-sy(5);
  for i := 1 to 11 do p[i,12].Y := P0.Y;

  Canvas.Pen.Width := 10;

  Line1(P[1,1], P[11,1]);
  Line1(P[7,3], P[11,3]);
  Line1(P[1,5], P[7,5]);
  Line1(P[1,6], P[11,6]);
  Line1(P[8,7], P[11,7]);
  Line1(P[7,9], P[11,9]);

  Line1(P[1,1], P[1,12]);
  Line1(P[2,1], P[2,6]);
  Line1(P[3,1], P[3,12]);
  Line1(P[4,1], P[4,6]);
  Line1(P[5,1], P[5,12]);
  Line1(P[6,1], P[6,12]);
  Line1(P[7,1], P[7,12]);
  Line1(P[8,6], P[8,12]);
  Line1(P[9,6], P[9,9]);
  Line1(P[10,6], P[10,9]);

  Canvas.Pen.Width := 1;

  Line1(P[1,2], P[7,2]);
  Line1(P[1,3], P[7,3]);
  Line1(P[1,4], P[7,4]);
  Line1(P[1,7], P[7,7]);
  Line1(P[1,8], P[7,8]);
  Line1(P[1,9], P[7,9]);
  Line1(P[1,10], P[7,10]);
  Line1(P[1,11], P[7,11]);

  SetTextAlign(Canvas.Handle,TA_Center or TA_Bottom);

  Canvas.Font.Assign(StampForm.Edit1.Font);

  g := P[7,2].X + Round((P[11,2].X - P[7,2].X)/2);
  Canvas.TextOut(g,p[7,2].y+sy(3),StampData.Ed1);

  Canvas.Font.Assign(StampForm.Edit15.Font);

  SetTextAlign(Canvas.Handle,TA_Left or TA_Bottom);

  TextOut1(P[1,7], StampData.ed15);
  TextOut1(P[1,8], StampData.ed16);
  TextOut1(P[1,9], StampData.ed17);
  TextOut1(P[1,10], StampData.ed18);
  TextOut1(P[1,11], StampData.ed19);
  TextOut1(P[1,12], StampData.ed20);
  TextOut1(P[3,7], StampData.ed9);
  TextOut1(P[3,8], StampData.ed10);
  TextOut1(P[3,9], StampData.ed11);
  TextOut1(P[3,10], StampData.ed12);
  TextOut1(P[3,11], StampData.ed13);
  TextOut1(P[3,12], StampData.ed14);

  TextOut1(P[1,6], ' Изм.');
  TextOut1(P[2,6], 'Кол.уч.');
  TextOut1(P[3,6], ' Лист');
  TextOut1(P[4,6], ' №док');
  TextOut1(P[5,6], ' Подп.');
  TextOut1(P[6,6], ' Дата');

  SetTextAlign(Canvas.Handle,TA_Center or TA_Bottom);

  Canvas.TextOut(P[8,7].X + sx(8), P[8,7].Y, 'Стадия');
  Canvas.TextOut(P[9,7].X + sx(8), P[9,7].Y, 'Лист');
  Canvas.TextOut(P[10,7].X + sx(8), P[10,7].Y, 'Листов');

  Canvas.Font.Assign(StampForm.Edit6.Font);

  Canvas.TextOut(p[8,9].x+sx(8),p[8,9].y-sy(2),StampData.ed6);
  Canvas.TextOut(p[9,9].x+sx(8),p[9,9].y-sy(2),StampData.ed7);
  Canvas.TextOut(p[10,9].x+sx(8),p[10,9].y-sy(2),StampData.ed8);

  Canvas.Font.Assign(StampForm.Memo2.Font);
  TextOutMem2(G);

  Canvas.Font.Assign(StampForm.Memo3.Font);
  G := P[7,2].X + Round((P[8,2].X - P[7,2].X)/2);
  TextOutMem3(G);

  Canvas.Font.Assign(StampForm.Memo4.Font);
  TextOutMem4(G);

  Canvas.Font.Assign(StampForm.Memo5.Font);
  G := P[8,2].X + Round((P[11,2].X - P[8,2].X)/2);
  TextOutMem5(G);

  StampForm.Free();
end;

// --- CadStamp ---

function CadStamp_Fin(): AError;
begin
  Result := 0;
end;

function CadStamp_Init(): AError;
begin
  if (CadDraw.Init() < 0) then
  begin
    Result := -2;
    Exit;
  end;

  CadDraw.SetOnStampDraw(DoStampDraw);
  AUiMainWindow_AddMenuItemP('Tools', 'Stamp', 'Штамп...', DoStampSettings, 0, 180);
  Result := 0;
end;

function CadStamp_SaveDanP(): APascalString;
var
  Value: string;
begin
  Value := '';
  _SaveDanStamp(StampData, Value);
  Result := Value;
end;

function CadStamp_Show(): AError;
var
  StampForm: TStampForm;
begin
  StampForm := TStampForm.Create(nil);
  try
    StampForm.LoadStamp();
    StampForm.ShowModal();
  finally
    StampForm.Free();
  end;
  Result := 0;
end;

end.
 