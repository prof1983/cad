{**
@Author Prof1983 <prof1983@ya.ru>
@Created 27.02.2013
@LastMod 27.02.2013
}
unit CadDrawBaseUtils;

interface

uses
  ABase,
  CadDrawConsts,
  CadDrawTypes;

// --- Public ---

function CadLineTypeFromByte(Value: Byte): TCadLineType;

function CadLineTypeFromInt(Value: AInt): TCadLineType;

function CadLineTypeFromStr(const Value: string): TCadLineType;

implementation

// --- Public ---

function CadLineTypeFromByte(Value: Byte): TCadLineType;
begin
  Result := TCadLineType(Value);
end;

function CadLineTypeFromInt(Value: AInt): TCadLineType;
begin
  Result := TCadLineType(Value);
end;

function CadLineTypeFromStr(const Value: string): TCadLineType;
var
  I: TCadLineType;
begin
  for I := Low(I) to High(I) do
  begin
    if (CadLineType_Str[I] = Value) then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := cLineTypeDef;
end;

end.
 