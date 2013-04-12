{**
@Abstract Cad.App util functions
@Author Prof1983 <prof1983@yandex.ru>
@Created 27.06.2009
@LastMod 12.04.2013
}
unit CadAppUtils;

{$IFNDEF NoVcl}{$DEFINE VCL}{$ENDIF}

interface

uses
  {$ifdef Vcl}
  Graphics,
  {$endif}
  ABase,
  AUiDialogsEx2,
  CadAppAngleDialog,
  CadDrawBase,
  CadDrawPrimitive,
  CadDrawTypes;

// --- CadApp ---

{** Обновляет размеры области рисования на указанном элементе }
function CadApp_RefreshPaintBoxSize2(Image: AImage): AError;

// --- Public ---

function ChooseAngle1(Figure: TGCustomFigure): Boolean;
function ChooseAngleBranch(Branch: TGBranch; var IsModify: Boolean): Boolean;
function ChooseAngleBrnExtData5(Branch: TGBranch): Boolean;
{$IFDEF VCL}
function ChooseColor(var Color: TColor): Boolean;
{$ENDIF}
function ChooseFileOpen(var FileName: string): Boolean;
function ChooseFileSave(var FileName: string): Boolean;
function ChooseFont(var Font: TGFontLocal): Boolean;

{$IFDEF VCL}
function ChooseFontF(Font: TFont): Boolean;
{$ENDIF}

implementation

{$ifdef Vcl}
uses
  Dialogs,
  ExtCtrls,
  Math,
  Types,
  fAngle;
{$endif}

// --- Private ---

// Высчитывает угол между двумя точками. Возвращает угол в градусах.
function _ReturnParAngle(X1, Y1, X2, Y2: AInt): AInt;
var
  ShX: AInt;
  ShY: AInt;
  Angle: AFloat;
begin
  ShX := X1 - X2;
  ShY := Y1 - Y2;
  if (ShX <> 0) then
    Angle := ArcTan2(-ShY,-ShX)
  else if (ShY > 0) then
    Angle := -Pi/2
  else
    Angle:= Pi/2;
  Result := Round(RadToDeg(Angle));
end;

{$IFDEF VCL}
function _ReturnParAnglePolyline(Polyline: TGBranchPolyline): Integer;
var
  PntB: TPoint;
  PntE: TPoint;
begin
  if not(Assigned(Polyline)) then
  begin
    Result := 0;
    Exit;
  end;

  PntB := Polyline.GetNodeBPnt();
  PntE := Polyline.GetNodeEPnt();

  if (Polyline.PCount >= 1) then
    Result := _ReturnParAngle(Polyline.Pl[Polyline.PCount-1].X, Polyline.Pl[Polyline.PCount-1].Y, PntE.X, PntE.Y)
  else
    Result := _ReturnParAngle(PntB.X, PntB.Y, PntE.X, PntE.Y);
end;
{$ENDIF}

// --- CadApp ---

function CadApp_RefreshPaintBoxSize2(Image: AImage): AError;
begin
  {$IFDEF VCL}
  try
    TImage(Image).Picture.Bitmap.Height := TImage(Image).Height;
    TImage(Image).Picture.Bitmap.Width := TImage(Image).Width;
    Result := 0;
  except
    Result := -1;
  end;
  {$ELSE}
  Result := -1;
  {$ENDIF VCL}
end;

{ Public }

function ChooseAngle1(Figure: TGCustomFigure): Boolean;
var
  Angle: AFloat;
begin
  Angle := Round(Figure.Angle);
  Result := CadApp_ShowAngleDialog(Angle, -1);
  if Result then
  begin
    if (Angle < -90) then Angle := -90;
    if (Angle > 90) then Angle := 90;
    Figure.Angle := Angle;
  end;
end;

function ChooseAngleBranch(Branch: TGBranch; var IsModify: Boolean): Boolean;
var
  Angle: AFloat;
  ParAngle: Integer;
begin
  {$IFDEF VCL}
  ParAngle := 0;
  Angle := (Round(RadToDeg((Branch as TGBranchLine).NameAngle)) mod 360);

  // относится к линии
  if (Branch is TGBranchLine) then
  begin
    with (Branch as TGBranchLine) do
      ParAngle := _ReturnParAngle(
          NdList.Items[Brn.BrBNodeI].NdPnt_X,
          NdList.Items[Brn.BrBNodeI].NdPnt_Y,
          NdList.Items[Brn.BrENodeI].NdPnt_X,
          NdList.Items[Brn.BrENodeI].NdPnt_Y);
  end;

  // Относится к полилинии
  if (Branch.FGid = cPolyLine) then
    ParAngle := _ReturnParAnglePolyline(Branch as TGBranchPolyline);

  Result := CadApp_ShowAngleDialog(Angle, ParAngle);
  if Result then
  begin
    Branch.NameAngle := DegToRad(Angle);
    IsModify := True;
    Branch.Brn.BrMoveCName := True;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function ChooseAngleBrnExtData5(Branch: TGBranch): Boolean;
var
  Angle: AFloat;
  AngleInd: Integer;
  ParAngle: Integer;
begin
  {$IFDEF VCL}
  ParAngle := 0;
  // записанный угол
  AngleInd := (Round(RadToDeg(Branch.Brn.ArrowData.Angle)) mod 360);
  // если отрицательный преобразуем в положительный
  if (AngleInd < 0) then AngleInd := AngleInd + 360;

  // его вставляем как текущий
  Angle := AngleInd;

  // Для полилиний
  if (Branch.FGid = cPolyLine) then
    ParAngle := _ReturnParAnglePolyline(Branch as TGBranchPolyline);

  // если отрицательный преобразуем в положительный
  if (ParAngle < 0) then
    ParAngle := ParAngle + 360;

  Result := CadApp_ShowAngleDialog(Angle, ParAngle);
  if Result then
    Branch.SetAngle(Angle);
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

{$IFDEF VCL}
function ChooseColor(var Color: TColor): Boolean;
begin
  Result := AUi_ExecuteColorDialog(AColor(Color));
end;
{$ENDIF VCL}

function ChooseFileOpen(var FileName: string): Boolean;
{$IFDEF VCL}
var
  Dialog: TOpenDialog;
{$ENDIF VCL}
begin
  {$IFDEF VCL}
  Dialog := TOpenDialog.Create(nil);
  try
    Result := Dialog.Execute;
    if Result then
      FileName := Dialog.FileName;
  finally
    Dialog.Free;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function ChooseFileSave(var FileName: string): Boolean;
{$IFDEF VCL}
var
  Dialog: TSaveDialog;
{$ENDIF VCL}
begin
  {$IFDEF VCL}
  Dialog := TSaveDialog.Create(nil);
  try
    Result := Dialog.Execute;
    if Result then
      FileName := Dialog.FileName;
  finally
    Dialog.Free;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

function ChooseFont(var Font: TGFontLocal): Boolean;
{$IFDEF VCL}
var
  FontDialog1: TFontDialog;
{$ENDIF VCL}
begin
  {$IFDEF VCL}
  FontDialog1 := TFontDialog.Create(nil);
  try
    FontDialog1.Font.Charset := Font.CharSet;
    FontDialog1.Font.Color := Font.Color;
    FontDialog1.Font.Name := Font.Name;
    FontDialog1.Font.Pitch := Font.Pitch;
    FontDialog1.Font.Size := Font.Size;
    FontDialog1.Font.Style := Font.Style;
    Result := FontDialog1.Execute;
    if Result then
    begin
      Font.CharSet := FontDialog1.Font.Charset;
      Font.Color := FontDialog1.Font.Color;
      Font.Name := FontDialog1.Font.Name;
      Font.Pitch := FontDialog1.Font.Pitch;
      Font.Size := FontDialog1.Font.Size;
      Font.Style := FontDialog1.Font.Style;
    end;
  finally
    FontDialog1.Free;
  end;
  {$ELSE}
  Result := False;
  {$ENDIF VCL}
end;

{$IFDEF VCL}
function ChooseFontF(Font: TFont): Boolean;
var
  FontName: APascalString;
  FontSize: AInteger;
  FontColor: AColor;
begin
  // Выбор шрифта
  FontName := Font.Name;
  FontSize := Font.Size;
  FontColor := Font.Color;
  if AUi_ExecuteFontDialogP(FontName, FontSize, FontColor) then
  begin
    Font.Name := FontName;
    Font.Size := FontSize;
    Font.Color := FontColor;
    Result := True;
  end
  else
    Result := False;
end;
{$ENDIF VCL}

end.
 