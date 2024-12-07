unit EncodeDecodeXOR;

interface

uses
  System.SysUtils, System.Classes;

type
  TEncodeDecodeXOR = class(TComponent)
  private
    function XorEncode(Source, Key: AnsiString): string;
    function XorDecode(Source, Key: AnsiString): AnsiString;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Encrypt(Text, Password: AnsiString): AnsiString;
    function Decrypt(Text, Password: AnsiString): AnsiString;
  published
  end;

procedure Register;

implementation

constructor TEncodeDecodeXOR.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TEncodeDecodeXOR.Destroy;
begin
  inherited;
end;

function TEncodeDecodeXOR.XorEncode(Source, Key: AnsiString): string;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(Source) do
  begin
    if Length(Key) > 0 then
      C := Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(Source[I])
    else
      C := Byte(Source[I]);
    Result := string(Result) + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function TEncodeDecodeXOR.XorDecode(Source, Key: AnsiString): AnsiString;
var
  I: Integer;
  C: AnsiChar;
begin
  Result := '';
  for I := 0 to Length(Source) div 2 - 1 do
  begin
    C := AnsiChar(StrToIntDef('$' + Copy(string(Source), (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C := AnsiChar(Byte(Key[1 + (I mod Length(Key))]) xor Byte(C));
    Result := Result + C;
  end;
end;

function TEncodeDecodeXOR.Encrypt(Text, Password: AnsiString): AnsiString;
begin
  if Length(Password) > 0 then
  begin
    Result := AnsiString(XorEncode(Text, Password));
  end;

end;

function TEncodeDecodeXOR.Decrypt(Text, Password: AnsiString): AnsiString;
begin
  if Length(Password) > 0 then
  begin
    Result := XorDecode(Text, Password);
  end;

end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TEncodeDecodeXOR]);
end;

end.

