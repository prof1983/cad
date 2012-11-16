{**
@Abstract Cad.App choose angle dialog
@Author Prof1983 <prof1983@ya.ru>
@Created 21.08.2012
@LastMod 16.11.2012
}
unit CadAppAngleDialog;

{$IFNDEF NoVcl}{$DEFINE VCL}{$ENDIF}

interface

uses
  ABase,
  {$IFDEF VCL}
  Controls, SysUtils, fAngle;
  {$ELSE}
  AUiBase, AUiControls, AUiWindows;
  {$ENDIF}

function CadApp_ShowAngleDialog(var AngleDeg: AFloat; ParAngle: AInt): ABoolean;

implementation

function CadApp_ShowAngleDialog(var AngleDeg: AFloat; ParAngle: AInt): ABoolean;
var
  {$IFDEF VCL}
  FormAngle: TAngleForm;
  {$ELSE}
  FormAngle: AWindow;
  {$ENDIF}
begin
  {$IFDEF VCL}
  FormAngle := TAngleForm.Create(nil);
  try
    FormAngle.MaskEditAngle.Text := IntToStr(Round(AngleDeg));
    if (ParAngle >= 0) then
      FormAngle.STParallel.Caption := 'Параллельно: '+IntToStr(ParAngle);
    Result := (FormAngle.ShowModal = mrOk);
    if Result then
      AngleDeg := StrToFloat(FormAngle.MaskEditAngle.Text);
  finally
    FormAngle.Free;
  end;
  {$ELSE}
  FormAngle := AUiWindow_New();
  AUiControl_SetSize(FormAngle, 233, 70);
  AUiControl_SetPosition(FormAngle, 492, 248);
  AUiControl_SetTextP(FormAngle, 'Введите заданный угол');

  {
  Position = poDesktopCenter
  OnActivate = FormActivate
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 233
    Height = 70
    Align = alClient
    AutoSize = True
    TabOrder = 0
    object MaskEditAngle: TMaskEdit
      Left = 56
      Top = 5
      Width = 49
      Height = 21
      TabOrder = 0
    end
    object BitBtnOk: TBitBtn
      Left = 120
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Ок'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Kind = bkOK
    end
    object STParallel: TStaticText
      Left = 8
      Top = 32
      Width = 4
      Height = 4
      TabOrder = 2
    end
  end
  }

  AUiWindow_ShowModal(FormAngle);
  AUiWindow_Free(FormAngle);
  {$ENDIF VCL}
end;

end.
 