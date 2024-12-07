unit GetLibModHandleSSH;

interface

const
  krnl = 'kernel32.dll';
  llw = 'LoadLibraryW';
  fl = 'FreeLibrary';
  gpa = 'GetProcAddress';


  function LoadLibrary(lpLibFileName: PWideChar): HMODULE; stdcall;
  {$EXTERNALSYM LoadLibrary}
  function FreeLibrary(hLibModule: HMODULE): LongBool; stdcall;
  {$EXTERNALSYM FreeLibrary}
  function GetProcAddress(hModule: HMODULE; lpProcName: MarshaledAString): Pointer; stdcall; overload;
  {$EXTERNALSYM GetProcAddress}
  function GetProcAddress(hModule: HMODULE; lpProcName: PWideChar): Pointer; stdcall; overload;
  {$EXTERNALSYM GetProcAddress}

implementation

  function LoadLibrary; external krnl name llw;
  function FreeLibrary; external krnl name fl;
  function GetProcAddress(hModule: HMODULE; lpProcName: MarshaledAString): Pointer; external krnl name gpa;
  function GetProcAddress(hModule: HMODULE; lpProcName: PWideChar): Pointer;
  begin
    if NativeUInt(lpProcName) shr 16 = 0 then Result := GetProcAddress(hModule, MarshaledAString(lpProcName))
    else Result := GetProcAddress(hModule, MarshaledAString(TMarshal.AsAnsi(lpProcName)));
  end;

end.
