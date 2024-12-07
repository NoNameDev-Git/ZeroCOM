unit WebCam;

interface

uses Winapi.Windows, System.Classes, System.Variants, Vcl.StdCtrls,
     Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Graphics, ActiveX, directshow9;

var
  FileName: string;
  RecMode: boolean = False;
  DeviceName: OleVariant;
  PropertyName: IPropertyBag;
  pDevEnum: ICreateDEvEnum;
  pEnum: IEnumMoniker;
  pMoniker: IMoniker;
  MArray1: array of IMoniker;
  FGraphBuilder: IGraphBuilder;
  FCaptureGraphBuilder: ICaptureGraphBuilder2;
  FMux: IBaseFilter;
  FSink: IFileSinkFilter;
  FMediaControl: IMediaControl;
  FVideoWindow: IVideoWindow;
  FVideoCaptureFilter: IBaseFilter;
  FAudioCaptureFilter: IBaseFilter;
  FVideoRect: TRect;
  FBaseFilter: IBaseFilter;
  FSampleGrabber: ISampleGrabber;
  MediaType: AM_MEDIA_TYPE;

type
  TWebCam = class(TComponent)

private
  FDevice: TComboBox;
  FPanel: TPanel;
  procedure SetDevice(Value: TComboBox);
  procedure SetPanel(Value: TPanel);
  function CameraInitialization: HResult;
  function CreateGraph: HResult;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetDevice: HResult;
    procedure CamDestroy;
    procedure CamCreate;
    function CamScreen(FPath: string): HResult;
  published
    property ComboBox: TComboBox read FDevice write SetDevice;
    property Panel: TPanel read FPanel write SetPanel;

end;

procedure Register;

implementation

constructor TWebCam.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  CoInitialize(nil);
end;

destructor TWebCam.Destroy;
begin
  inherited;
  CoUninitialize;
end;

function TWebCam.GetDevice: HResult;
begin
  Result := E_FAIL;
  if FAILED(CameraInitialization) then Exit;
  Result := S_OK;
end;

procedure TWebCam.CamCreate;
begin
  if FAILED(CreateGraph) then Exit;
end;

procedure TWebCam.CamDestroy;
begin
  pEnum := NIL;
  pDevEnum := NIL;
  pMoniker := NIL;
  PropertyName := NIL;
  DeviceName := Unassigned;
  FMediaControl.Stop;
  FPanel.Parent := nil;
end;

procedure TWebCam.SetDevice(Value: TComboBox);
begin
  if FDevice <> Value then
  begin
    FDevice := Value;
  end;
end;

procedure TWebCam.SetPanel(Value: TPanel);
begin
  if FPanel <> Value then
  begin
    FPanel := Value;
  end;
end;

function TWebCam.CameraInitialization: HResult;
begin
  Result := CoCreateInstance(CLSID_SystemDeviceEnum, NIL, CLSCTX_INPROC_SERVER, IID_ICreateDevEnum, pDevEnum);
  if Result <> S_OK then EXIT;
  Result := pDevEnum.CreateClassEnumerator(CLSID_VideoInputDeviceCategory, pEnum, 0);
  if Result <> S_OK then EXIT;
  setlength(MArray1, 0);
  while (S_OK = pEnum.Next(1, pMoniker, Nil)) do
  begin
    setlength(MArray1, length(MArray1) + 1);
    MArray1[length(MArray1) - 1] := pMoniker;
    Result := pMoniker.BindToStorage(NIL, NIL, IPropertyBag, PropertyName);
    if FAILED(Result) then Continue;
    Result := PropertyName.Read('FriendlyName', DeviceName, NIL);
    if FAILED(Result) then Continue;
    FDevice.Items.Add(DeviceName);
  end;
  if FDevice.Items[0] = '' then
  begin
    FDevice.Text := '';
    Result := E_FAIL;
    Exit;
  end
  else
  begin
    FDevice.Text := FDevice.Items[0];
    FDevice.ItemIndex := 0;
  end;
  Result := S_OK;
end;

function TWebCam.CreateGraph: HResult;
begin
  FVideoCaptureFilter := NIL;
  FVideoWindow := NIL;
  FMediaControl := NIL;
  FSampleGrabber := NIL;
  FBaseFilter := NIL;
  FCaptureGraphBuilder := NIL;
  FGraphBuilder := NIL;
  Result := CoCreateInstance(CLSID_FilterGraph, NIL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, FGraphBuilder);
  if FAILED(Result) then EXIT;
  Result := CoCreateInstance(CLSID_SampleGrabber, NIL, CLSCTX_INPROC_SERVER, IID_IBaseFilter, FBaseFilter);
  if FAILED(Result) then EXIT;
  Result := CoCreateInstance(CLSID_CaptureGraphBuilder2, NIL, CLSCTX_INPROC_SERVER, IID_ICaptureGraphBuilder2, FCaptureGraphBuilder);
  if FAILED(Result) then EXIT;
  Result := FGraphBuilder.AddFilter(FBaseFilter, 'GRABBER');
  if FAILED(Result) then EXIT;
  Result := FBaseFilter.QueryInterface(IID_ISampleGrabber, FSampleGrabber);
  if FAILED(Result) then EXIT;
  if FSampleGrabber <> NIL then
  begin
    ZeroMemory(@MediaType, sizeof(AM_MEDIA_TYPE));
    with MediaType do
    begin
      majortype := MEDIATYPE_Video;
      subtype := MEDIASUBTYPE_RGB24;
      formattype := FORMAT_VideoInfo;
    end;
    FSampleGrabber.SetMediaType(MediaType);
    FSampleGrabber.SetBufferSamples(TRUE);
    FSampleGrabber.SetOneShot(FALSE);
  end;
  Result := FCaptureGraphBuilder.SetFiltergraph(FGraphBuilder);
  if FAILED(Result) then EXIT;
  if FDevice.ItemIndex >= 0 then
  begin
    MArray1[FDevice.ItemIndex].BindToObject(NIL, NIL, IID_IBaseFilter, FVideoCaptureFilter);
    FGraphBuilder.AddFilter(FVideoCaptureFilter, 'VideoCaptureFilter');
  end;
  Result := FCaptureGraphBuilder.RenderStream(@PIN_CATEGORY_PREVIEW, nil, FVideoCaptureFilter, FBaseFilter, nil);
  if FAILED(Result) then EXIT;
  Result := FGraphBuilder.QueryInterface(IID_IVideoWindow, FVideoWindow);
  if FAILED(Result) then EXIT;
  FVideoWindow.put_WindowStyle(WS_CHILD or WS_CLIPSIBLINGS);
  FVideoWindow.put_Owner(FPanel.Handle);
  FVideoRect := FPanel.ClientRect;
  FVideoWindow.SetWindowPosition(FVideoRect.Left, FVideoRect.Top, FVideoRect.Right - FVideoRect.Left, FVideoRect.Bottom - FVideoRect.Top);
  FVideoWindow.put_Visible(TRUE);
  Result := FGraphBuilder.QueryInterface(IID_IMediaControl, FMediaControl);
  if FAILED(Result) then Exit;
  FMediaControl.Run();
end;

function TWebCam.CamScreen(FPath: string): HResult;
var
  bSize: integer;
  pVideoHeader: TVideoInfoHeader;
  MediaType: TAMMediaType;
  BitmapInfo: TBitmapInfo;
  Buffer: Pointer;
  tmp: array of byte;
  Bitmap: TBitmap;
begin
  Result := E_FAIL;
  if FSampleGrabber = NIL then EXIT;
  Result := FSampleGrabber.GetCurrentBuffer(bSize, NIL);
  if (bSize <= 0) or FAILED(Result) then EXIT;
  Bitmap := TBitmap.Create;
  try
    ZeroMemory(@MediaType, sizeof(TAMMediaType));
    Result := FSampleGrabber.GetConnectedMediaType(MediaType);
    if FAILED(Result) then EXIT;
    pVideoHeader := TVideoInfoHeader(MediaType.pbFormat^);
    ZeroMemory(@BitmapInfo, sizeof(TBitmapInfo));
    CopyMemory(@BitmapInfo.bmiHeader, @pVideoHeader.bmiHeader, sizeof(TBITMAPINFOHEADER));
    Buffer := NIL;
    Bitmap.Handle := CreateDIBSection(0, BitmapInfo, DIB_RGB_COLORS, Buffer, 0, 0);
    SetLength(tmp, bSize);
    try
      FSampleGrabber.GetCurrentBuffer(bSize, @tmp[0]);
      CopyMemory(Buffer, @tmp[0], MediaType.lSampleSize);
      Bitmap.SaveToFile(FPath);
    except
      Result := E_FAIL;
    end;
  finally
    SetLength(tmp, 0);
    Bitmap.Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('ZERO COM', [TWebCam]);
end;

end.