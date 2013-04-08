{**
@Author Prof1983 <prof1983@ya.ru>
@Created 25.12.2012
@LastMod 08.04.2013
}
unit CadAppNavigator;

{define AStdCall}

interface

uses
  ABase,
  fNavigator;

// --- CadAppNavigator ---

function CadAppNavigator_Fin(): AError; {$ifdef AStdCall}stdcall;{$endif}

function CadAppNavigator_Show(): AError; {$ifdef AStdCall}stdcall;{$endif}

implementation

var
  _NavigatorForm: TNavigatorForm;

// --- CadAppNavigator ---

function CadAppNavigator_Fin(): AError;
begin
  if not(Assigned(_NavigatorForm)) then
  begin
    Result := 0;
    Exit;
  end;
  try
    _NavigatorForm.Free();
    _NavigatorForm := nil;
    Result := 0;
  except
    Result := -1;
  end;
end;

function CadAppNavigator_Show(): AError;
begin
  try
    if not(Assigned(_NavigatorForm)) then
      _NavigatorForm := TNavigatorForm.Create(nil);
    _NavigatorForm.Show();
    Result := 0;
  except
    Result := -1;
  end;
end;

end.
