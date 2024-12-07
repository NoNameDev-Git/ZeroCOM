unit BSSIDLocation;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Winapi.TlHelp32;

type
  TServerEx = ( Google, Yandex, Apple );
  TBSSIDLocation = class(TComponent)
  private
    FServer: TServerEx;
    FBssid: string;
    function GetServer: TServerEx;
    procedure SetServer(Value: TServerEx);
    function StrOemToAnsi(const S: AnsiString): AnsiString;
    procedure ExtractRes(ResType, ResName, ResNewName: string);
    function DelWord(word, srtl: string): string;
    function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
    procedure TaskKill(FileName: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetLocation: string;
  published
    property Server: TServerEx read GetServer write SetServer;
    property Bssid: string read FBssid write FBssid;
  end;

procedure Register;

implementation

{$R geomac.RES}
{$R libcrypto.RES}
{$R libssl.RES}

constructor TBSSIDLocation.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TBSSIDLocation.Destroy;
begin
  inherited;
end;

function TBSSIDLocation.GetServer: TServerEx;
begin
  Result := FServer;
end;

procedure TBSSIDLocation.SetServer(Value: TServerEx);
begin
  FServer := Value;
end;

function TBSSIDLocation.StrOemToAnsi(const S: AnsiString): AnsiString;
begin
  SetLength(Result, Length(S));
  OemToAnsiBuff(@S[1], @Result[1], Length(S));
end;

procedure TBSSIDLocation.ExtractRes(ResType, ResName, ResNewName: string);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, ResName, Pchar(ResType));
  Res.SavetoFile(ResNewName);
  Res.Free;
end;

function TBSSIDLocation.DelWord(word, srtl: string): string;
var
  s, s1: string;
  p: integer;
begin
  s := srtl;
  s1 := word;
  p := pos(s1, s);
  if p <> 0 then
  begin
    delete(s, p, length(s1));
  end;
  Result := s
end;

function TBSSIDLocation.GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE);
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine), nil, nil, True, 0, nil, PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
    try
      repeat
        WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
        if BytesRead > 0 then
        begin
          Buffer[BytesRead] := #0;
          Result := Result + string(StrOemToAnsi(Buffer));
        end;

      until not WasOK or (BytesRead = 0);
      WaitForSingleObject(PI.hProcess, INFINITE);
    finally
      CloseHandle(PI.hThread);
      CloseHandle(PI.hProcess);
    end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

procedure TBSSIDLocation.TaskKill(FileName: string);
var
  wh: Bool;
  sp, sm, th: THandle;
  pe: TProcessEntry32;
  me: TModuleEntry32;
  seid: Int64;
  tp: TOKEN_PRIVILEGES;
  rl: Cardinal;
begin
//получаем debug-привелегию
  OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, th);
  LookupPrivilegeValue(nil, 'SeDebugPrivilege', seid);
  with tp do
  begin
    PrivilegeCount := 1;
    Privileges[0].Luid := seid;
    Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
  end;
  AdjustTokenPrivileges(th, False, tp, SizeOf(tp), tp, rl);
  //создаем снапшот
  sp := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  pe.dwSize := SizeOf(pe);
  wh := Process32First(sp, pe);
  //пробегаемся циклом по всем процессам и убиваем FileName при совпадении
  while wh <> False do
  begin
    sm := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, pe.th32ProcessID);
    me.dwSize := SizeOf(me);
    Module32First(sm, me);
    if LowerCase(me.szExePath) = LowerCase(FileName) then
      TerminateProcess(OpenProcess($0001, False, pe.th32ProcessID), 0);
    CloseHandle(sm);
    wh := Process32Next(sp, pe);
  end;
  CloseHandle(sp);
  tp.Privileges[0].Attributes := 0;
  AdjustTokenPrivileges(th, False, tp, SizeOf(tp), tp, rl);
end;

function TBSSIDLocation.GetLocation: string;
var
  StringList:TStringList;
  i:Integer;
  RGoogle, RYandex, RApple, Map, Err: string;
begin
  Map := 'http://www.google.ru/maps/place/';
  Err := '[Error] Wi-Fi hotspot is not registered in the database.';
  if FileExists(ExtractFilePath(ParamStr(0))+'geomac.exe') = False then
    ExtractRes('EXEFILE', 'geomac', ExtractFilePath(ParamStr(0))+'geomac.exe');
  if FileExists(ExtractFilePath(ParamStr(0))+'libssl-1_1-x64.dll') = False then
    ExtractRes('DLLFILE', 'libssl', ExtractFilePath(ParamStr(0))+'libssl-1_1-x64.dll');
  if FileExists(ExtractFilePath(ParamStr(0))+'libcrypto-1_1-x64.dll') = False then
    ExtractRes('DLLFILE', 'libcrypto', ExtractFilePath(ParamStr(0))+'libcrypto-1_1-x64.dll');
  StringList:=TStringList.Create;
  Sleep(200);
  StringList.Text := GetDosOutput('"'+ExtractFilePath(ParamStr(0))+'geomac.exe" ' + Bssid, 'C:');
  for i := 0 to StringList.Count-1 do
  begin
     if Pos('Yandex Locator  | ',StringList[i]) <> 0 then
     begin
        RYandex := DelWord('Yandex Locator  | ',StringList[i])
     end;
     if Pos('Google          | ',StringList[i]) <> 0 then
     begin
        RGoogle := DelWord('Google          | ',StringList[i])
     end;
     if Pos('Apple           | ',StringList[i]) <> 0 then
     begin
        RApple := DelWord('Apple           | ',StringList[i])
     end;
  end;
  StringList.Free;
  TaskKill(ExtractFilePath(ParamStr(0))+'geomac.exe');
  if FileExists(ExtractFilePath(ParamStr(0))+'geomac.exe') = True then
    DeleteFile(ExtractFilePath(ParamStr(0))+'geomac.exe');
  if FileExists(ExtractFilePath(ParamStr(0))+'libssl-1_1-x64.dll') = True then
    DeleteFile(ExtractFilePath(ParamStr(0))+'libssl-1_1-x64.dll');
  if FileExists(ExtractFilePath(ParamStr(0))+'libcrypto-1_1-x64.dll') = True then
    DeleteFile(ExtractFilePath(ParamStr(0))+'libcrypto-1_1-x64.dll');
  if FServer = Google then
    if RGoogle <> '' then Result := Map + RGoogle else Result := Err;
  if FServer = Yandex then
    if RYandex <> '' then Result := Map + RYandex else Result := Err;
  if FServer = Apple then
    if RApple <> '' then Result := Map + RApple else Result := Err;
end;


procedure Register;
begin
  RegisterComponents('ZERO COM', [TBSSIDLocation]);
end;

end.

