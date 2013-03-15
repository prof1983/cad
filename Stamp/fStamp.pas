{**
@Abstract CadStamp
@Author Prof1983 <prof1983@ya.ru>
@Created 04.09.2009
@LastMod 20.08.2012
}
unit fStamp;

interface

uses
  Buttons, Classes, Controls, Dialogs, Forms, Graphics, Messages, StdCtrls, SysUtils, Variants, Windows,
  CadAppData, CadStampData;

type
  TStampForm = class(TForm)
    Edit1: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    FDMemo2: TFontDialog;
    BitBtnM2: TBitBtn;
    BitBtnM3: TBitBtn;
    BitBtnM4: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure BitBtnM2Click(Sender: TObject);
    procedure BitBtnM3Click(Sender: TObject);
    procedure BitBtnM4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  public
    procedure LoadStamp;
    procedure SaveStamp;
  end;

implementation

uses
  fDrawWin;

{$R *.dfm}

{ TStampForm }

procedure TStampForm.BitBtnM2Click(Sender: TObject);
begin
  FDMemo2.Font := Memo2.Font;
  if FDMemo2.Execute then
    Memo2.Font := FDMemo2.Font;
end;

procedure TStampForm.BitBtnM3Click(Sender: TObject);
begin
  FDMemo2.Font := Memo3.Font;
  if FDMemo2.Execute then
    Memo3.Font := FDMemo2.Font;
end;

procedure TStampForm.BitBtnM4Click(Sender: TObject);
begin
  FDMemo2.Font := Memo4.Font;
  if FDMemo2.Execute then
    Memo4.Font := FDMemo2.Font;
end;

procedure TStampForm.BitBtn1Click(Sender: TObject);
begin
  SaveStamp;
  Close;
end;

procedure TStampForm.BitBtn2Click(Sender: TObject);
begin
  Close;
end;

procedure TStampForm.LoadStamp;
var
  I: Integer;
begin
  Edit1.Text := StampData.ed1;
  Edit6.Text := StampData.ed6;
  Edit7.Text := StampData.ed7;
  Edit8.Text := StampData.ed8;
  Edit9.Text := StampData.ed9;
  Edit10.Text := StampData.ed10;
  Edit11.Text := StampData.ed11;
  Edit12.Text := StampData.ed12;
  Edit13.Text := StampData.ed13;
  Edit14.Text := StampData.ed14;
  Edit15.Text := StampData.ed15;
  Edit16.Text := StampData.ed16;
  Edit17.Text := StampData.ed17;
  Edit18.Text := StampData.ed18;
  Edit19.Text := StampData.ed19;
  Edit20.Text := StampData.ed20;

  Memo2.Lines.Clear;
  Memo3.Lines.Clear;
  Memo4.Lines.Clear;
  Memo5.Lines.Clear;
  for I := 0 to Stamp_Mem2_Count - 1 do
    Memo2.Lines.Add(Stamp_Mem2[i]);
  for I := 0 to Stamp_Mem3_Count - 1 do
    Memo3.Lines.Add(Stamp_Mem3[i]);
  for I := 0 to Stamp_Mem4_Count - 1 do
    Memo4.Lines.Add(Stamp_Mem4[i]);
  for I := 0 to Stamp_Mem5_Count - 1 do
    Memo5.Lines.Add(Stamp_Mem5[i]);
  Memo2.Text := Copy(Memo2.Text,1,Length(Memo2.Text)-2);
  Memo3.Text := Copy(Memo3.Text,1,Length(Memo3.Text)-2);
  Memo4.Text := Copy(Memo4.Text,1,Length(Memo4.Text)-2);
  Memo5.Text := Copy(Memo5.Text,1,Length(Memo5.Text)-2);
  Memo2.Font.Size := StampData.Mem2FontSize;
  Memo3.Font.Size := StampData.Mem3FontSize;
  Memo4.Font.Size := StampData.Mem4FontSize;
  StampData.Mem5FontSize := 14;
  Memo5.Font.Size := StampData.Mem5FontSize;
end;

procedure TStampForm.SaveStamp;
var
  I: Integer;
begin
  StampData.ed1 := Edit1.Text;
  StampData.ed6 := Edit6.Text;
  StampData.ed7 := Edit7.Text;
  StampData.ed8 := Edit8.Text;
  StampData.ed9 := Edit9.Text;
  StampData.ed10 := Edit10.Text;
  StampData.ed11 := Edit11.Text;
  StampData.ed12 := Edit12.Text;
  StampData.ed13 := Edit13.Text;
  StampData.ed14 := Edit14.Text;
  StampData.ed15 := Edit15.Text;
  StampData.ed16 := Edit16.Text;
  StampData.ed17 := Edit17.Text;
  StampData.ed18 := Edit18.Text;
  StampData.ed19 := Edit19.Text;
  StampData.ed20 := Edit20.Text;

  Stamp_Mem2_Count := Memo2.Lines.Count;
  Stamp_Mem3_Count := Memo3.Lines.Count;
  Stamp_Mem4_Count := Memo4.Lines.Count;
  Stamp_Mem5_Count := Memo5.Lines.Count;

  for I := 0 to Memo2.Lines.Count-1 do
    Stamp_Mem2[I] := Memo2.Lines[I];
  for I := 0 to Memo3.Lines.Count-1 do
    Stamp_Mem3[I] := Memo3.Lines[I];
  for I := 0 to Memo4.Lines.Count-1 do
    Stamp_Mem4[I] := Memo4.Lines[I];
  for I := 0 to Memo5.Lines.Count-1 do
    Stamp_Mem5[I] := Memo5.Lines[I];
  StampData.Mem2FontSize := Memo2.Font.Size;
  StampData.Mem3FontSize := Memo3.Font.Size;
  StampData.Mem4FontSize := Memo4.Font.Size;
  StampData.Mem5FontSize := 14; //Memo5.Font.Size;
  StampData.ed1FontSize := Edit1.Font.Size;
end;

end.


