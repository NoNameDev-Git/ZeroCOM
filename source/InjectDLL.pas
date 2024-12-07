unit InjectDLL;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Tlhelp32;

type
  TInjectDLL = class(TComponent)
  private
    FPathDLL, FProcess: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Inject;
  published
    property PathDLL: string read FPathDLL write FPathDLL;
    property Process: string read FProcess write FProcess;
  end;

procedure Register;

implementation

constructor TInjectDLL.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TInjectDLL.Destroy;
begin
  inherited;
end;

function GetPID(ExeFileName: string): dword;
var
  ContinueLoop: boolean;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  UpEFN: string;
begin
  result := 0;
  UpEFN := UpperCase(ExeFileName);
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpEFN) or
      (UpperCase(FProcessEntry32.szExeFile) = UpEFN)) then
    begin
      result := FProcessEntry32.th32ProcessID;
      break;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function SetSeDebugPrivilege: boolean;
var
  ht: THandle;
  luid: TLargeInteger;
  tkp: TTokenPrivileges;
  rl: Cardinal;
begin
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, ht) then
  begin
    LookupPrivilegeValue(nil, 'SeDebugPrivilege', luid);
    tkp.Privileges[0].luid := luid;
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    if AdjustTokenPrivileges(ht, false, tkp, 0, nil, rl) then
      result := true
    else
      result := false;
  end
  else
    result := false;
end;

function QInjectDLL(dwPID: DWORD; DLLPath: PWideChar): integer;
var
  dwThreadID: Cardinal;
  hProc, hThread, hKernel: THandle;
  BytesToWrite, BytesWritten: SIZE_T;
  pRemoteBuffer, pLoadLibrary: Pointer;
begin
  hProc := OpenProcess(PROCESS_CREATE_THREAD or PROCESS_QUERY_INFORMATION or PROCESS_VM_OPERATION or PROCESS_VM_WRITE or PROCESS_VM_READ, False, dwPID);
  if hProc = 0 then
    exit(0);
  try
    BytesToWrite := SizeOf(WideChar) * (Length(DLLPath) + 1);
    pRemoteBuffer := VirtualAllocEx(hProc, nil, BytesToWrite, MEM_COMMIT, PAGE_READWRITE);
    if pRemoteBuffer = nil then
      exit(0);
    try
      if not WriteProcessMemory(hProc, pRemoteBuffer, DLLPath, BytesToWrite, BytesWritten) then
        exit(0);
      hKernel := GetModuleHandle('kernel32.dll');
      pLoadLibrary := GetProcAddress(hKernel, 'LoadLibraryW');
      hThread := CreateRemoteThread(hProc, nil, 0, pLoadLibrary, pRemoteBuffer, 0, dwThreadID);
      try
        WaitForSingleObject(hThread, INFINITE);
      finally
        CloseHandle(hThread);
      end;
    finally
      VirtualFreeEx(hProc, pRemoteBuffer, 0, MEM_RELEASE);
    end;
  finally
    CloseHandle(hProc);
  end;
  exit(1);
end;

procedure TInjectDLL.Inject;
var
  PID: dword;
begin
  SetSeDebugPrivilege;
  PID := GetPID(FProcess);
  if (PID > 0) then
  begin
    QInjectDLL(PID, PWideChar(FPathDLL));
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TInjectDLL]);
end;

end.

