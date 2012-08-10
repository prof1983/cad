{**
@Abstract CadStamp data
@Author Prof1983 <prof1983@ya.ru>
@Created 10.08.2012
@LastMod 10.08.2012
}
unit CadStampData;

interface

uses
  CadCoreBase;

var
  StampData: TStampDataRec;
  Stamp_Mem2: array[0..7] of string;
  Stamp_Mem3: array[0..7] of string;
  Stamp_Mem4: array[0..7] of string;
  Stamp_Mem5: array[0..7] of string;
  Stamp_Mem2_Count: Integer;
  Stamp_Mem3_Count: Integer;
  Stamp_Mem4_Count: Integer;
  Stamp_Mem5_Count: Integer;

function Stamp_AddMem2(const Value: string): Integer;
function Stamp_AddMem3(const Value: string): Integer;
function Stamp_AddMem4(const Value: string): Integer;
function Stamp_AddMem5(const Value: string): Integer;

procedure Stamp_ClearMem2();
procedure Stamp_ClearMem3();
procedure Stamp_ClearMem4();
procedure Stamp_ClearMem5();

implementation

// --- Stamp ---

function Stamp_AddMem2(const Value: string): Integer;
begin
  if (Stamp_Mem2_Count >= Length(Stamp_Mem2)) then
  begin
    Result := -1;
    Exit;
  end;
  if (Stamp_Mem2_Count < 0) then
    Stamp_Mem2_Count := 0;
  Stamp_Mem2[Stamp_Mem2_Count] := Value;
  Inc(Stamp_Mem2_Count);
  Result := 0;
end;

function Stamp_AddMem3(const Value: string): Integer;
begin
  if (Stamp_Mem3_Count >= Length(Stamp_Mem3)) then
  begin
    Result := -1;
    Exit;
  end;
  if (Stamp_Mem3_Count < 0) then
    Stamp_Mem3_Count := 0;
  Stamp_Mem3[Stamp_Mem3_Count] := Value;
  Inc(Stamp_Mem3_Count);
  Result := 0;
end;

function Stamp_AddMem4(const Value: string): Integer;
begin
  if (Stamp_Mem4_Count >= Length(Stamp_Mem4)) then
  begin
    Result := -1;
    Exit;
  end;
  if (Stamp_Mem4_Count < 0) then
    Stamp_Mem4_Count := 0;
  Stamp_Mem4[Stamp_Mem4_Count] := Value;
  Inc(Stamp_Mem4_Count);
  Result := 0;
end;

function Stamp_AddMem5(const Value: string): Integer;
begin
  if (Stamp_Mem5_Count >= Length(Stamp_Mem5)) then
  begin
    Result := -1;
    Exit;
  end;
  if (Stamp_Mem5_Count < 0) then
    Stamp_Mem5_Count := 0;
  Stamp_Mem5[Stamp_Mem5_Count] := Value;
  Inc(Stamp_Mem5_Count);
  Result := 0;
end;

procedure Stamp_ClearMem2();
begin
  Stamp_Mem2_Count := 0;
end;

procedure Stamp_ClearMem3();
begin
  Stamp_Mem3_Count := 0;
end;

procedure Stamp_ClearMem4();
begin
  Stamp_Mem4_Count := 0;
end;

procedure Stamp_ClearMem5();
begin
  Stamp_Mem5_Count := 0;
end;

end.
