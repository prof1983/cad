{**
@Author Prof1983 <prof1983@ya.ru>
@Created 23.11.2009
@LastMod 09.04.2013
}
unit fNavigator;

interface

uses
  Classes,
  Controls,
  ExtCtrls,
  Forms,
  Graphics,
  Types,
  CadDrawMain,
  CadDrawScene,
  CadMainWin;

type
  TNavigatorForm = class(TForm)
    ImageNavigator: TImage;
    procedure FormActivate(Sender: TObject);
    procedure ImageNavigatorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FDC: TRect;
    procedure ImageNavigatorMouseDownA(X, Y: Integer; var DC, VP: TRect);
  public
    procedure Init;
    procedure RefreshImage(ImageNavigator: TImage; BackColor1: TColor; var DC, VP: TRect);
  end;

implementation

{$R *.DFM}

{ TNavigatorForm }

procedure TNavigatorForm.FormActivate(Sender: TObject);
begin
  RefreshImage(ImageNavigator, CadDraw_GetBackColor(), FDC, CadDraw_GetColl().VP);
end;

procedure TNavigatorForm.ImageNavigatorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ImageNavigatorMouseDownA(X, Y, FDC, CadDraw_GetColl().VP);
end;

procedure TNavigatorForm.ImageNavigatorMouseDownA(X, Y: Integer; var DC, VP: TRect);
begin
  NavigatorForm_ImageNavigatorMouseDownA(Canvas, ClientHeight, Width, X, Y, DC, VP);
end;

procedure TNavigatorForm.Init;
begin
  Top := 5;
  Width := Round(0.2*Screen.Width);
  Height := Round(0.2*Screen.Height);
  Left := Screen.Width-Width;
  ImageNavigator.Width := ClientWidth;
  ImageNavigator.Height := ClientHeight;
end;

procedure TNavigatorForm.RefreshImage(ImageNavigator: TImage; BackColor1: TColor; var DC, VP: TRect);
begin
  NavigatorForm_RefreshImage(ImageNavigator, BackColor1, DC, VP);
end;

end.
