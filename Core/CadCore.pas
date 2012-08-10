{**
@Abstract Cad.Core
@Author Prof1983 <prof1983@ya.ru>
@Created 25.11.2009
@LastMod 10.08.2012
}
unit CadCore;

interface

uses
  ABase,
  CadCoreBase, CadCoreMain;

function CheckExtP(const Ext: APascalString): AInteger; stdcall;

function CheckFileExtP(const FileName: APascalString): AInteger; stdcall;

function CheckFileExtWS(const FileName: AWideString): AInteger; stdcall;

function Done(): AError; stdcall; deprecated; // Use Fin()

function GetProjectFileNameWS(): AWideString; stdcall;

function GetProjectFilePathWS(): AWideString; stdcall;

function Init(): AError; stdcall;

implementation

{ Public }

function CheckExtP(const Ext: APascalString): AInteger; stdcall;
begin
  try
    Result := CadCore_CheckExt(Ext);
  except
    Result := -1;
  end;
end;

function CheckFileExtP(const FileName: APascalString): AInteger; stdcall;
begin
  try
    Result := CadCore_CheckFileExt(FileName);
  except
    Result := -1;
  end;
end;

function CheckFileExtWS(const FileName: AWideString): AInteger; stdcall;
begin
  try
    Result := CadCore_CheckFileExt(FileName);
  except
    Result := -1;
  end;
end;

function Done(): AError;
begin
  try
    Result := CadCore_Fin();
  except
    Result := -1;
  end;
end;

function GetProjectFileNameWS(): AWideString; stdcall;
begin
  try
    Result := CadCore_GetProjectFileName();
  except
    Result := '';
  end;
end;

function GetProjectFilePathWS(): AWideString; stdcall;
begin
  try
    Result := CadCore_GetProjectFilePath();
  except
    Result := '';
  end;
end;

function Init(): AError; stdcall;
begin
  try
    Result := CadCore_Init();
  except
    Result := -1;
  end;
end;

end.
