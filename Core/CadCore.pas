{**
@Abstract Cad.Core
@Author Prof1983 <prof1983@ya.ru>
@Created 25.11.2009
@LastMod 20.03.2013
}
unit CadCore;

interface

uses
  ABase,
  CadCoreBase, CadCoreMain;

function CheckExtP(const Ext: APascalString): AInteger; stdcall;

function CheckFileExtP(const FileName: APascalString): AInteger; stdcall;

function Fin(): AError; stdcall;

function GetDrawFlag(): AInt; stdcall;

function Init(): AError; stdcall;

implementation

// --- Public ---

function CheckExtP(const Ext: APascalString): AInt;
begin
  try
    Result := CadCore_CheckExt(Ext);
  except
    Result := -1;
  end;
end;

function CheckFileExtP(const FileName: APascalString): AInt;
begin
  try
    Result := CadCore_CheckFileExtP(FileName);
  except
    Result := -1;
  end;
end;

function Fin(): AError;
begin
  try
    Result := CadCore_Fin();
  except
    Result := -1;
  end;
end;

function GetDrawFlag(): AInt;
begin
  Result := CadCore_GetDrawFlag();
end;

function Init(): AError;
begin
  try
    Result := CadCore_Init();
  except
    Result := -1;
  end;
end;

end.
