unit SSH;

interface

uses GetLibModHandleSSH, CodeUnitSSH, System.SysUtils, System.Classes,
      Vcl.StdCtrls;

type
  TSSH = class(TComponent)

private
  FServer: string;
  FPort: integer;
  FUserName: string;
  FPassword: string;
  FCommand: string;
  FMemo: TMemo;
  FDirectorySave: string;
  procedure SetMemo(Value: TMemo);
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Execute;
published
  property Server: string read FServer write FServer;
  property Port: integer read FPort write FPort;
  property UserName: string read FUserName write FUserName;
  property Password: string read FPassword write FPassword;
  property Command: string read FCommand write FCommand;
  property Memo: TMemo read FMemo write SetMemo;
  property DirectorySave: string read FDirectorySave write FDirectorySave;

end;
  DWORD = LongWord;
  BOOL = LongBool;
  UINT = LongWord;
  UINT_PTR = System.UIntPtr;
  HWND = type UINT_PTR;
  WPARAM = UINT_PTR;
  INT_PTR = System.IntPtr;
  LPARAM = INT_PTR;
  PMsg = ^TMsg;
  TPoint = record
  X: Longint;
  Y: Longint;
  end;
  tagMSG = record
  hwnd: HWND;
  message: UINT;
  wParam: WPARAM;
  lParam: LPARAM;
  time: DWORD;
  pt: TPoint;
  end;
  TMsg = tagMSG;

const
  PM_REMOVE = 1;
  user32 = 'user32.dll';

procedure Register;

implementation

function PeekMessage(var lpMsg: TMsg; hWnd: HWND;
wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; stdcall;
external user32 name 'PeekMessageW';

function TranslateMessage(const lpMsg: TMsg): BOOL; stdcall;
external user32 name 'TranslateMessage';

function DispatchMessage(const lpMsg: TMsg): Longint; stdcall;
external user32 name 'DispatchMessageW';

procedure ProcessMessage();
var
Msg :TMsg;
begin
if PeekMessage(msg, 0, 0, 0, PM_REMOVE) then
begin
TranslateMessage(msg);
DispatchMessage(msg);
end;
end;

function IntToStr(I : Longint) : string;
var
  s:string[255];
begin
  Str(I, s);
  Result := string(s);
end;

constructor TSSH.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FServer := string(HATS(HCOM1));
  FPort := 22;
  FCommand := string(HATS(HCOM2));
end;

destructor TSSH.Destroy;
begin
  inherited;
end;

procedure TSSH.SetMemo(Value: TMemo);
begin
  if FMemo <> Value then
  begin
    FMemo := Value;
  end;
end;

procedure TSSH.Execute;
var
  WT: LongBool;
  StringList: TStringList;
begin
  if ((FServer <> '') and
     (FPort <> 0) and
     (FUserName <> '') and
     (FPassword <> '') and
     (FCommand <> ''))
  then
  begin
    WoW1(WT);
    SEW($00, '',
    PChar(string(HATS(HCOM))),
    PChar(string(HATS(HCOM3))+string(HATS(HCOM4))+FPassword+string(HATS(HCOM5))+
    FUserName+string(HATS(HCOM6))+FServer+string(HATS(HCOM7))+IntToStr(Fport)+
    string(HATS(HCOM8))+FCommand+string(HATS(HCOM9))+FDirectorySave+string(HATS(HCOM10))),
    '', $00);
    while FileExists(PChar(FDirectorySave)) = False do
    begin
      Sleep(100);
      if FileExists(PChar(FDirectorySave)) = True then
      begin
        StringList := TStringList.Create;
        StringList.LoadFromFile(FDirectorySave);
        FMemo.Text := StringList.Text;
        FreeAndNil(StringList);
      end;
      ProcessMessage();
    end;
    DeleteFile(FDirectorySave);
    WoW2(WT);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TSSH]);
end;

end.