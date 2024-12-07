unit EncodeDecodeSymmetric;

interface

uses
  System.Classes;

type
  TEncodeDecodeSymmetric = class(TComponent)
  private
    function CodeE(Text: string; Password: string): string;
    function CodeD(Text: string; Password: string): string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Encrypt(Text, Password: string): string;
    function Decrypt(Text, Password: string): string;
  published
  end;

procedure Register;

implementation

constructor TEncodeDecodeSymmetric.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TEncodeDecodeSymmetric.Destroy;
begin
  inherited;
end;

function TEncodeDecodeSymmetric.CodeE(Text: string; Password: string): string;
var
  i, PasswordLength: integer;
  sign: shortint;
begin
  PasswordLength := length(Password);
  if PasswordLength = 0 then
    Exit;
  sign := 1;
  for i := 1 to Length(Text) do
    Text[i] := chr(ord(Text[i]) + sign * ord(Password[i mod PasswordLength + 1]));
  Result := Text;
end;

function TEncodeDecodeSymmetric.CodeD(Text: string; Password: string): string;
var
  i, PasswordLength: integer;
  sign: shortint;
begin
  PasswordLength := length(Password);
  if PasswordLength = 0 then
    Exit;
  sign := -1;
  for i := 1 to Length(Text) do
    Text[i] := chr(ord(Text[i]) + sign * ord(Password[i mod PasswordLength + 1]));
  Result := Text;
end;

function TEncodeDecodeSymmetric.Encrypt(Text, Password: string): string;
begin
  if Length(Password) > 0 then
  begin
    Result := CodeE(Text, Password);
  end;
end;

function TEncodeDecodeSymmetric.Decrypt(Text, Password: string): string;
begin
  if Length(Password) > 0 then
  begin
    Result := CodeD(Text, Password);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TEncodeDecodeSymmetric]);
end;

end.

