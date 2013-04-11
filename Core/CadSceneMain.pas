{**
@Author Prof1983 <prof1983@ya.ru>
@Created 12.09.2011
@LastMod 11.04.2013
}
unit CadSceneMain;

interface

uses
  Classes,
  Types,
  ABase,
  CadCoreBase,
  CadData,
  CadDrawBase,
  CadDrawBranchTypeList,
  CadDrawFigureCollection,
  CadDrawPrimitive;

// --- CadDrawScene ---

function CadDrawScene_GetColl(Scene: AGScene): TGCollFigure;

// --- CadScene ---

function CadScene_AddBranchType(Scene: AGScene; const BranchType: APascalString): AError;

function CadScene_AddExBranchData(Scene: AGScene; BranchNum, NodeNum1, NodeNum2, PlaNum: AInt;
    PlaColor: AColor; ArrowIsFresh, LineIsDotted: ABool; const Name: APascalString): AError;

function CadScene_AddExNode(Scene: AGScene; Num, X, Y, Z, Xg, Yg: AInt; IsPov: ABool): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_Clear(Scene: AGScene): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_ClearExData(Scene: AGScene): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_ClearExData2(Scene: AGScene): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_DeleteBranchType(Scene: AGScene; Index: AInt): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_Fin(Scene: AGScene): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_FindBranchType(Scene: AGScene; const BranchType: APascalString): AInt;

function CadScene_FindExNode(Scene: AGScene; NdNum: AInt): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetBranchTypeBalansByIndex(Scene: AGScene; Index: AInt): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetBranchTypeCount(Scene: AGScene): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetBranchTypeNameByIndex(Scene: AGScene; Index: AInt): APascalString;

function CadScene_GetBranchTypes(Scene: AGScene): TGBranchTypeList;

function CadScene_GetBranchTypesLength(Scene: AGScene; Version: AInt): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetCurrentSchemeIndex(Scene: AGScene): TSchemeIndex; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetExBranchData(Scene: AGScene; I: AInt; out BranchNum, NodeNum1, NodeNum2,
    PlaNum: AInt; out PlaColor: AColor; out ArrowIsFresh, LineIsDotted: ABool;
    out Name: APascalString): AError;

function CadScene_GetExBranchDataLen(Scene: AGScene): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetExNodeData(Scene: AGScene; Index: AInt; out ExNodeData: TExDataNodeRec): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetExNodeDataLen(Scene: AGScene): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_GetExNodeNum(Scene: AGScene; Index: AInt): AInt; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_Init(Scene: AGScene; OnAddDataBranch, OnAddDataNode, OnDeleteFig,
    OnDeleteNode: TGProcedureI): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_LoadBranchTypesFromStream(Scene: AGScene; Stream: TFileStream): AError;

function CadScene_New(): AGScene; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_SaveBranchTypesToStream(Scene: AGScene; Stream: TFileStream): AError;

function CadScene_SetCurrentSchemeIndex(Scene: AGScene; Value: TSchemeIndex): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_SetExNodeByIndex(Scene: AGScene; Index, X, Y, Z: AInt; IsPov: ABool): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_SetExNodeByIndex2(Scene: AGScene; Index, X, Y, Z, Xg, Yg: AInt; IsPov: ABool): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadScene_SetOnSelectFig(Scene: AGScene; Value: ACallbackProc): AError; {$ifdef AStdCall}stdcall;{$endif}

implementation

type
  TBranchIrs = record
    {** Номер ветви }
    BranchNum: AInt;
    {** Номер узла начала ветви }
    NodeNum1: AInt;
    {** Номер узла конца ветви }
    NodeNum2: AInt;
    {** Позиция ПЛА }
    PlaNum: AInt;
    {** Цвет позиции ПЛА }
    PlaColor: AInt;
    {** Цвет стрелки (1-true-свежая-clRed, 0-false-исходящая-clBlue) }
    ArrowIsFresh: ABool;
    {** Линия пунктирная }
    LineIsDotted: ABool;
    {** Наименование ветви }
    Name: string;
  end;

type
  AGScene_Type = record
    {** Номер текущей схемы }
    CurrentSchemeIndex: TSchemeIndex;
    {** Коллекция фигур }
    FigureColl: AGFigureCollection;
    // Типы ветвей
    TV: TGBranchTypeList;
    {** Внешние данные ветвей }
    Ex_Data_Branch: array of TBranchIrs;
    {** Полностью соответсвует таблице TablDavl с Row-2 }
    Ex_Data_Uz: array of TExDataNodeRec;
  end;

type
  PGScene = ^AGScene_Type;

function _GetColl(Scene: AGScene): TGCollFigure;
begin
  Result := TGCollFigure(PGScene(Scene)^.FigureColl);
end;

// --- CadDrawScene ---

function CadDrawScene_GetColl(Scene: AGScene): TGCollFigure;
begin
  Result := TGCollFigure(PGScene(Scene)^.FigureColl);
end;

// --- CadScene ---

function CadScene_AddBranchType(Scene: AGScene; const BranchType: APascalString): AError;
begin
  try
    PGScene(Scene)^.TV.Add(BranchType);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_AddExBranchData(Scene: AGScene; BranchNum, NodeNum1, NodeNum2, PlaNum: AInt;
    PlaColor: AColor; ArrowIsFresh, LineIsDotted: ABool; const Name: APascalString): AError;
var
  I: AInt;
begin
  try
    I := Length(PGScene(Scene)^.Ex_Data_Branch);

    SetLength(PGScene(Scene)^.Ex_Data_Branch, I+1);

    PGScene(Scene)^.Ex_Data_Branch[I].BranchNum := BranchNum;
    PGScene(Scene)^.Ex_Data_Branch[I].NodeNum1 := NodeNum1;
    PGScene(Scene)^.Ex_Data_Branch[I].NodeNum2 := NodeNum2;
    PGScene(Scene)^.Ex_Data_Branch[I].ArrowIsFresh := ArrowIsFresh;
    PGScene(Scene)^.Ex_Data_Branch[I].LineIsDotted := LineIsDotted;
    PGScene(Scene)^.Ex_Data_Branch[I].PlaNum := PlaNum;
    PGScene(Scene)^.Ex_Data_Branch[I].PlaColor := PlaColor;
    PGScene(Scene)^.Ex_Data_Branch[I].Name := Name;

    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_AddExNode(Scene: AGScene; Num, X, Y, Z, Xg, Yg: AInt; IsPov: ABool): AError;
var
  I: AInt;
begin
  try
    I := Length(PGScene(Scene)^.Ex_Data_Uz);
    SetLength(PGScene(Scene)^.Ex_Data_Uz, I + 1);
    PGScene(Scene)^.Ex_Data_Uz[I].Num := Num;
    PGScene(Scene)^.Ex_Data_Uz[I].X := X;
    PGScene(Scene)^.Ex_Data_Uz[I].Y := Y;
    PGScene(Scene)^.Ex_Data_Uz[I].Z := Z;
    PGScene(Scene)^.Ex_Data_Uz[I].Xg := Xg;
    PGScene(Scene)^.Ex_Data_Uz[I].Yg := Yg;
    PGScene(Scene)^.Ex_Data_Uz[I].IsPov := IsPov;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_Clear(Scene: AGScene): AError;
var
  Coll: TGCollFigure;
begin
  try
    Coll := TGCollFigure(PGScene(Scene)^.FigureColl);
    Coll.CloseDoc();
    Coll.SetViewPort(Rect(0,0,0,0), True);
    PGScene(Scene)^.CurrentSchemeIndex := 0;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_ClearExData(Scene: AGScene): AError;
begin
  try
    SetLength(PGScene(Scene)^.Ex_Data_Branch, 2);
    SetLength(PGScene(Scene)^.Ex_Data_Uz, 2);
    SetLength(Ex_PolyLine, 10);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_ClearExData2(Scene: AGScene): AError;
begin
  try
    SetLength(PGScene(Scene)^.Ex_Data_Branch, 0);
    SetLength(PGScene(Scene)^.Ex_Data_Uz, 0);
    SetLength(Ex_PolyLine, 0);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_DeleteBranchType(Scene: AGScene; Index: AInt): AError;
begin
  try
    PGScene(Scene)^.TV.Delete(Index);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_Fin(Scene: AGScene): AError;
var
  Coll: TGCollFigure;
  P: Pointer;
begin
  try
    // Уничтожаем коллекцию объектов
    Coll := TGCollFigure(PGScene(Scene)^.FigureColl);
    Coll.Free();
    PGScene(Scene)^.FigureColl := 0;
    P := Pointer(Scene);
    FreeMem(P);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_FindBranchType(Scene: AGScene; const BranchType: APascalString): AInt;
begin
  try
    Result := PGScene(Scene)^.TV.Find(BranchType);
  except
    Result := -1;
  end;
end;

function CadScene_FindExNode(Scene: AGScene; NdNum: AInt): AInt;
var
  I: AInt;
begin
  for I := 0 to High(PGScene(Scene)^.Ex_Data_Uz) do
  begin
    if (PGScene(Scene)^.Ex_Data_Uz[I].Num = NdNum) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;

function CadScene_GetBranchTypeBalansByIndex(Scene: AGScene; Index: AInt): AInt;
begin
  try
    Result := PGScene(Scene)^.TV.GetByIndex(Index).Balans;
  except
    Result := 0;
  end;
end;

function CadScene_GetBranchTypeCount(Scene: AGScene): AInt;
begin
  try
    Result := PGScene(Scene)^.TV.Count;
  except
    Result := 0;
  end;
end;

function CadScene_GetBranchTypeNameByIndex(Scene: AGScene; Index: AInt): APascalString;
begin
  try
    Result := PGScene(Scene)^.TV.GetByIndex(Index).Name;
  except
    Result := '';
  end;
end;

function CadScene_GetBranchTypes(Scene: AGScene): TGBranchTypeList;
begin
  try
    Result := PGScene(Scene)^.TV;
  except
    Result := nil;
  end;
end;

function CadScene_GetBranchTypesLength(Scene: AGScene; Version: AInt): AInt;
begin
  try
    Result := PGScene(Scene)^.TV.GetLength(Version);
  except
    Result := 0;
  end;
end;

function CadScene_GetCurrentSchemeIndex(Scene: AGScene): TSchemeIndex;
begin
  Result := PGScene(Scene)^.CurrentSchemeIndex;
end;

function CadScene_GetExBranchData(Scene: AGScene; I: AInt; out BranchNum, NodeNum1, NodeNum2,
    PlaNum: AInt; out PlaColor: AColor; out ArrowIsFresh, LineIsDotted: ABool;
    out Name: APascalString): AError;
begin
  try
    BranchNum := PGScene(Scene)^.Ex_Data_Branch[I].BranchNum;
    NodeNum1 := PGScene(Scene)^.Ex_Data_Branch[I].NodeNum1;
    NodeNum2 := PGScene(Scene)^.Ex_Data_Branch[I].NodeNum2;
    PlaNum := PGScene(Scene)^.Ex_Data_Branch[I].PlaNum;
    PlaColor := PGScene(Scene)^.Ex_Data_Branch[I].PlaColor;
    ArrowIsFresh := PGScene(Scene)^.Ex_Data_Branch[I].ArrowIsFresh;
    LineIsDotted := PGScene(Scene)^.Ex_Data_Branch[I].LineIsDotted;
    Name := PGScene(Scene)^.Ex_Data_Branch[I].Name;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_GetExBranchDataLen(Scene: AGScene): AInt;
begin
  try
    Result := Length(PGScene(Scene)^.Ex_Data_Branch);
  except
    Result := 0;
  end;
end;

function CadScene_GetExNodeData(Scene: AGScene; Index: AInt; out ExNodeData: TExDataNodeRec): AError;
begin
  try
    ExNodeData := PGScene(Scene)^.Ex_Data_Uz[Index];
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_GetExNodeDataLen(Scene: AGScene): AInt;
begin
  try
    Result := Length(PGScene(Scene)^.Ex_Data_Uz);
  except
    Result := 0;
  end;
end;

function CadScene_GetExNodeNum(Scene: AGScene; Index: AInt): AInt;
begin
  try
    Result := PGScene(Scene)^.Ex_Data_Uz[Index].Num;
  except
    Result := 0;
  end;
end;

function CadScene_Init(Scene: AGScene; OnAddDataBranch, OnAddDataNode, OnDeleteFig,
    OnDeleteNode: TGProcedureI): AError;
var
  Coll: TGCollFigure;
begin
  try
    PGScene(Scene)^.CurrentSchemeIndex := 0;
    PGScene(Scene)^.TV := TGBranchTypeList.Create(Scene);
    // Создаем основной объект графики
    Coll := TGCollFigure.Create(Scene);
    Coll.Init(OnAddDataBranch, OnAddDataNode, OnDeleteFig, OnDeleteNode);
    PGScene(Scene)^.FigureColl := AGFigureCollection(Coll);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_LoadBranchTypesFromStream(Scene: AGScene; Stream: TFileStream): AError;
begin
  try
    PGScene(Scene)^.TV.LoadFromStream2(Stream);
    Result := 0
  except
    Result := -1;
  end;
end;

function CadScene_New(): AGScene;
var
  P: ^AGScene_Type;
begin
  GetMem(P, SizeOf(AGScene_Type));
  FillChar(P^, SizeOf(AGScene_Type), 0);
  Result := AGScene(P);
end;

function CadScene_SaveBranchTypesToStream(Scene: AGScene; Stream: TFileStream): AError;
begin
  try
    PGScene(Scene)^.TV.SaveToStream(Stream);
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_SetCurrentSchemeIndex(Scene: AGScene; Value: TSchemeIndex): AError;
begin
  try
    PGScene(Scene)^.CurrentSchemeIndex := Value;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_SetExNodeByIndex(Scene: AGScene; Index, X, Y, Z: AInt; IsPov: ABool): AError;
begin
  try
    PGScene(Scene)^.Ex_Data_Uz[Index].X := X;
    PGScene(Scene)^.Ex_Data_Uz[Index].Y := Y;
    PGScene(Scene)^.Ex_Data_Uz[Index].Z := Z;
    PGScene(Scene)^.Ex_Data_Uz[Index].IsPov := IsPov;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_SetExNodeByIndex2(Scene: AGScene; Index, X, Y, Z, Xg, Yg: AInt; IsPov: ABool): AError;
begin
  try
    PGScene(Scene)^.Ex_Data_Uz[Index].X := X;
    PGScene(Scene)^.Ex_Data_Uz[Index].Y := Y;
    PGScene(Scene)^.Ex_Data_Uz[Index].Z := Z;
    PGScene(Scene)^.Ex_Data_Uz[Index].Xg := Xg;
    PGScene(Scene)^.Ex_Data_Uz[Index].Yg := Yg;
    PGScene(Scene)^.Ex_Data_Uz[Index].IsPov := IsPov;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadScene_SetOnSelectFig(Scene: AGScene; Value: ACallbackProc): AError;
begin
  try
    _GetColl(Scene).SetOnSelectFig(Value);
    Result := 0;
  except
    Result := -1;
  end;
end;

end.
 