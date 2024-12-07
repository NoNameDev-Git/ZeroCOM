unit PowershellBase64Encode;

interface

uses System.Classes;

type
  TPowershellBase64Encode = class(TComponent)
private
  FCommand: string;
  FEncryptCommand: string;
protected
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  function Encode: string;
published
  property Command: string read FCommand write FCommand;
end;

procedure Register;

implementation

function Base64Encode(S:string):string;
const
  Cod='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
var
  i,a,b,x: Integer;
begin
  a:=0;
  b:=0;
  for i:=1 to length(s) do
  begin
    x:=Ord(s[i]);
    b:= b*256+x;
    inc(a,8);
    while a>=6 do
    begin
      dec(a,6);
      x:=b div (1 shl a);
      b:=b mod (1 shl a);
      Result:=Result+Cod[x+1];
    end;
  end;
  if a>0 then
  begin
    x:=b shl (6-a);
    Result:=Result+Cod[x+1]+'==';
  end;
end;

constructor TPowershellBase64Encode.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TPowershellBase64Encode.Destroy;
begin
  inherited;
end;

function TPowershellBase64Encode.Encode(): string;
begin
  Result := '';
  if FCommand <> '' then
  begin
    FEncryptCommand := 'Powershell -C $ABCX = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String(''' + Base64Encode(FCommand);
    FEncryptCommand := FEncryptCommand + ''')); $XCBA = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($ABCX)); powershell -E $XCBA;';
    Result := FEncryptCommand;
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TPowershellBase64Encode]);
end;

end.