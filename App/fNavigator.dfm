object NavigatorForm: TNavigatorForm
  Left = 770
  Top = 104
  Width = 245
  Height = 174
  Caption = #1054#1073#1079#1086#1088
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object ImageNavigator: TImage
    Left = 0
    Top = 0
    Width = 237
    Height = 147
    Align = alClient
    OnMouseDown = ImageNavigatorMouseDown
  end
end
