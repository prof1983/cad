{**
@Abstract Cad.Core base consts and types
@Author Prof1983 <prof1983@ya.ru>
@Created 25.11.2009
@LastMod 11.04.2013
}
unit CadCoreBase;

interface

uses
  ABase, ABaseTypes;

const
  CadCore_Name = 'CadCore';
  CadCore_Uid  = $09112501;

type
  AStringGrid = Integer; // TStringGrid

type
  TStampDataRec = record
    Ed1: string;
    Ed6: string;
    Ed7: string;
    Ed8: string;
    Ed9: string;
    Ed10: string;
    Ed11: string;
    Ed12: string;
    Ed13: string;
    Ed14: string;
    Ed15: string;
    Ed16: string;
    Ed17: string;
    Ed18: string;
    Ed19: string;
    Ed20: string;
    Ed1FontSize: Integer;
    Ed6FontSize: Integer;
    Ed15FontSize: Integer;
    Mem2FontSize: Integer;
    Mem3FontSize: Integer;
    Mem4FontSize: Integer;
    Mem5FontSize: Integer;
  end;

type
  {** Точность расчетов }
  TCadPrecision = (
    Precision0 = 0, // D 0.1
    Precision1 = 1, // S 0.01
    Precision2 = 2  // T 0.000001
    );

type
  TCadLogFlags = type ALogFlags;
const
  LogFlagBranch    = $00010000;
  LogFlagNode      = $00020000;
  LogFlagShowMsg   = $01000000;
  LogFlagDebugMsg  = $02000000;

type
  TCadLogProc = ABaseTypes.AAddToLogA_Proc;

type 
  TExDataNodeRec = packed record
    {** Номер узла }
    Num: AInt;
    {** Kоордината узла }
    X: AInt;
    {** Координата узла }
    Y: AInt;
    {** Координата узла }
    Z: AInt;
    Xg: AInt;
    Yg: AInt;
    {** Узел поверхности или нет }
    IsPov: ABool;
  end;

type
  // APoint = TPoint.Type
  APoint = packed record
    X: Longint;
    Y: Longint;
  end;

type
  TPolyRec = record
    {** Номер индекса в массиве Ex_Data_Branch }
    IndEx: AInt;
    {** Число узлов полилинии }
    NumNode: AInt;
    PolyCoord: array of APoint;
  end;

type
  TGProcedureI = procedure(Code: Integer); stdcall;

implementation

end.
 