{**
@Author Prof1983 <prof1983@ya.ru>
@Created 10.04.2013
@LastMod 11.04.2013
}
unit CadSceneLoadEx;

interface

uses
  Graphics,
  Grids,
  ABase,
  AUtilsMain,
  CadCoreBase,
  CadDrawBase,
  CadDrawFigureCollection,
  CadDrawPrimitive,
  CadDrawTypes,
  CadSceneMain;

// --- CadDrawFigureColl ---

{** Загружает из вне }
function CadDrawFigureColl_LoadObjectsIrs(Scene: AGScene; Layer: AInt; TablDavl: TStringGrid;
    var NomSxema: TSchemeIndex): AError;

implementation

// --- Private ---

{** Возвращает индекс ветви с заданным начальным узлом }
function _ExDataNodes_FindByNum(Scene: AGScene; NdNum: AInt): AInt;
var
  J: AInt;
begin
  for J := 0 to CadScene_GetExNodeDataLen(Scene) - 1 do
  begin
    if (CadScene_GetExNodeNum(Scene, J) = NdNum) then
    begin
      Result := J;
      Exit;
    end;
  end;
  Result := -1;
end;

// --- CadDrawFigureColl ---

function CadDrawFigureColl_LoadObjectsIrs(Scene: AGScene; Layer: AInt; TablDavl: TStringGrid;
    var NomSxema: TSchemeIndex): AError;

  function AddFigureBranchB(Scene: AGScene; Layer, X1, Y1, Z1, X2, Y2, Z2, IsLoad: AInt;
      LineColor: TColor; NodeNum1, NodeNum2, BranchNum, NodeType1, NodeType2: AInt;
      const BranchName: APascalString): TGBranchLine;
  var
    I: AInt;
    Coll: TGCollFigure;
  begin
    Result := TGBranchLine.Create(Scene, Layer);
    if Assigned(Result) then
    begin
      Coll := CadDrawScene_GetColl(Scene);
      Result.SetLineA(X1, Y1, Z1, X2, Y2, Z2, IsLoad, LineColor, NodeNum1, NodeNum2, BranchNum, NodeType1, NodeType2, BranchName);
      I := Coll.AddFigure(Result);
      Coll.SelectFigByIndex(I);
      Coll.AddDataBranch1(Result.Brn.BrNum);
    end;
  end;

  function AddFigureBranchC(Scene: AGScene; Layer, BranchNum: AInt; BranchName: APascalString;
      const P1, P2: TExDataNodeRec): TGBranchLine;
  begin
    Result := AddFigureBranchB(Scene, Layer, P1.Nd1, P1.Nd2, P1.Nd3,
        P2.Nd1, P2.Nd2, P2.Nd3, 0, 0,
        P1.Nd0, P2.Nd0, BranchNum,
        P1.Nd4, P2.Nd4, BranchName);
  end;

var
  I: AInt;
  K: AInt;
  P1: AInt;
  P2: AInt;
  NomPla: AInt;
  Ip: AInt;
  Kp: AInt;
  MasPosPla: array of AInt;
  Branch: TGBranch;
  Coll: TGCollFigure;
  BranchDataLen: AInt;
    {** Номер ветви }
  BranchNum: AInt;
    {** Номер узла начала ветви }
  NodeNum1: AInt;
    {** Номер узла конца ветви }
  NodeNum2: AInt;
    {** Позиция ПЛА }
  PlaNum: AInt;
    {** Цвет позиции ПЛА }
  PlaColor: AColor;
    {** Цвет стрелки (1-true-свежая-clRed, 0-false-исходящая-clBlue) }
  ArrowIsFresh: ABool;
    {** Линия пунктирная }
  LineIsDotted: ABool;
    {** Наименование ветви }
  Name: APascalString;
  Sel: TGCustomFigure;
  ExNodeData1: TExDataNodeRec;
  ExNodeData2: TExDataNodeRec;
begin
  try
    Coll := CadDrawScene_GetColl(Scene);
    Coll.defWidth := 2;
    Coll.defLineType := 1;

    kp := 1;
    BranchDataLen := CadScene_GetExBranchDataLen(Scene);
    SetLength(MasPosPla, BranchDataLen-1);
    for I := 0 to BranchDataLen - 2 do
    begin
      CadScene_GetExBranchData(Scene, I, BranchNum, NodeNum1, NodeNum2, PlaNum,
          PlaColor, ArrowIsFresh, LineIsDotted, Name);

      // Проверяем наличие ветви с указанным узлом
      p1 := _ExDataNodes_FindByNum(Scene, NodeNum1);
      p2 := _ExDataNodes_FindByNum(Scene, NodeNum2);
      if (p1 = -1) or (p2 = -1) then
        Continue;

      CadScene_GetExNodeData(Scene, P1, ExNodeData1);
      CadScene_GetExNodeData(Scene, P2, ExNodeData2);
      Branch := AddFigureBranchC(Scene, Layer, BranchNum, Name, ExNodeData1, ExNodeData2);

      Branch.Brn.BrMoveCName := False;
      Branch.Brn.BrMoveCoord := False;
      Branch.Brn.ArrowDefault := True;

      Branch.Brn.ExtDataQ.MoveFlag := False;
      Branch.Brn.ExtData3.MoveFlag := False;
      Branch.Brn.ArrowData.MoveFlag := False;
      Branch.Brn.ExtData8_.MoveFlag := False;

      Branch.Brn.ExtData3.Data1 := PlaNum;
      if (Branch.Brn.ExtData3.Data1 = 0) then
        Branch.Brn.ExtData3.Data1 := -1;
      Branch.Brn.ExtData3.Color := PlaColor;
      Branch.Brn.ExtData3.Enable := True;
      NomPla := PlaNum;
      for ip := 0 to kp-1 do
      begin
        if (MasPosPla[ip] = NomPla) then
        begin
          Branch.Brn.ExtData3.Enable := False;
          Break;
        end;
      end;
      if (Branch.Brn.ExtData3.Enable = True) then
      begin
        MasPosPla[kp] := NomPla;
        Inc(kp);
      end;

      if (ArrowIsFresh) then
        Branch.Brn.ArrowData.Color := clRed
      else
        Branch.Brn.ArrowData.Color := clBlue;
      if (LineIsDotted) then
      begin
        Sel := Coll.Selected;
        Sel.FGLineType := cLineType3;
        Sel.Width := 1;
        Sel.WidthDefault := False;
        Sel.PenBrushDefault := False;
      end;
    end;

    for k := TablDavl.FixedRows to TablDavl.RowCount-1 do
    begin
      Coll.NodeList.Node_SetPoint3D(
          AUtils_StrToIntP(TablDavl.Cells[0,k]),
          AUtils_StrToFloatP(TablDavl.Cells[4,k]),
          AUtils_StrToFloatP(TablDavl.Cells[5,k]),
          AUtils_StrToFloatP(TablDavl.Cells[6,k]));
    end;

    NomSxema := 0;
    with Schemes[NomSxema] do
    begin
      sxLineType := Byte(cLineType2);
      sxLineColor := clBlue;
      sxWidth := 2;
      sxPenWidth := 1;
      sxBrNom := False;
      sxNodeNom := True;
      sxBrName := False;
      sxBrQ := False;
      sxAr := False;
      sxDavl := False;
      sxRaschD := False;
      sxPla := False;
      sxLajerVis[0] := True;
    end;

    CadScene_ClearExData2(Scene);

    Result := 0;
  except
    Result := -1;
  end;
end;

end.
 