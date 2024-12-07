unit EncodeDecodeXEBI;

interface

uses
  System.SysUtils, System.Classes;

type
  TEncodeDecodeXEBI = class(TComponent)
  private
    function StrToHex(const Source: string): string;
    function HexToStr(const Source: string): string;
    function xebiM(const Text, Password: string): string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Encrypt(const Text, Password: string): string;
    function Decrypt(const Text, Password: string): string;
  published
  end;

procedure Register;

implementation

constructor TEncodeDecodeXEBI.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

destructor TEncodeDecodeXEBI.Destroy;
begin
  inherited;
end;

function TEncodeDecodeXEBI.StrToHex(const Source: string): string;
var
  StrAsBytes: TBytes;
  i: cardinal;
begin
  StrAsBytes := TEncoding.UTF8.GetBytes(Source);
  for i := 0 to length(StrAsBytes) - 1 do
    result := result + IntToHex(StrAsBytes[i], 2);
end;

function TEncodeDecodeXEBI.HexToStr(const Source: string): string;
var
  i, idx: integer;
  StrAsBytes: TBytes;
begin
  SetLength(StrAsBytes, length(Source) div 2);
  i := 1;
  idx := 0;
  while i <= length(Source) do
  begin
    StrAsBytes[idx] := StrToInt('$' + Source[i] + Source[i + 1]);
    i := i + 2;
    idx := idx + 1;
  end;
  result := TEncoding.UTF8.GetString(StrAsBytes);
end;

function TEncodeDecodeXEBI.xebiM(const Text, Password: string): string;
const
  szBuffer = SizeOf(LongWord);
  szByteBuffer = SizeOf(Byte);
var
  HashPasswd, buffer, i, byteBuffer: LongWord;
  StreamOut, StreamIn: TStringStream;

  function Murmur2(const S: string; const Seed: LongWord = $9747b28c): LongWord;
  var
    hash, len, k: LongWord;
    StrAsBytes: TBytes;
    data: Integer;
  const
    m = $5bd1e995;
    r = 24;
  begin
    StrAsBytes := TEncoding.UTF8.GetBytes(S);
    len := Length(StrAsBytes);
    hash := Seed xor len;
    data := 0;

    while (len >= 4) do
    begin
      k := PLongWord(@StrAsBytes[data])^;
      k := k * m;
      k := k xor (k shr r);
      k := k * m;
      hash := hash * m;
      hash := hash xor k;
      inc(data, 4);
      dec(len, 4);
    end;

    Assert(len <= 3);
    if len = 3 then
      hash := hash xor (LongWord(StrAsBytes[data + 2]) shl 16);
    if len >= 2 then
      hash := hash xor (LongWord(StrAsBytes[data + 1]) shl 8);
    if len >= 1 then
    begin
      hash := hash xor (LongWord(StrAsBytes[data]));
      hash := hash * m;
    end;
    hash := hash xor (hash shr 13);
    hash := hash * m;
    hash := hash xor (hash shr 15);
    Result := hash;
  end;

begin
  StreamIn := TStringStream.Create(text);
  StreamOut := TStringStream.Create('');
  try
    StreamIn.Position := 0;
    StreamOut.Position := 0;

    HashPasswd := Murmur2(Password);

    while (StreamIn.Position < StreamIn.Size) and ((StreamIn.Size - StreamIn.Position) >= szBuffer) do
    begin
      StreamIn.ReadBuffer(buffer, szBuffer);
      buffer := buffer xor HashPasswd;
      buffer := buffer xor $E0F;
      StreamOut.WriteBuffer(buffer, szBuffer);
    end;

    if (StreamIn.Size - StreamIn.Position) >= 1 then
      for i := StreamIn.Position to StreamIn.Size - 1 do
      begin
        StreamIn.ReadBuffer(byteBuffer, szByteBuffer);
        byteBuffer := byteBuffer xor $F;
        StreamOut.WriteBuffer(byteBuffer, szByteBuffer);
      end;

    StreamOut.Position := 0;
    Result := StreamOut.ReadString(StreamOut.Size);
  finally
    StreamOut.Free;
    StreamIn.Free;
  end;
end;

function TEncodeDecodeXEBI.Encrypt(const Text, Password: string): string;
begin
  if Length(Password) > 0 then
  begin
    Result := StrToHex(xebiM(Text, Password));
  end;

end;

function TEncodeDecodeXEBI.Decrypt(const Text, Password: string): string;
begin
  if Length(Password) > 0 then
  begin
    Result := xebiM(HexToStr(Text), Password);
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TEncodeDecodeXEBI]);
end;

end.

