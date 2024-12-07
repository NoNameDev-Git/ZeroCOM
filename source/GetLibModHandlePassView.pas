unit GetLibModHandlePassView;

interface

const
  ntdll = 'ntdll.dll';
  shell32 = 'shell32.dll';
  kernel32 = 'kernel32.dll';
  LLW = 'LoadLibraryW';
  FL = 'FreeLibrary';
  GPA = 'GetProcAddress';
  IMAGE_SIZEOF_SHORT_NAME = 8;
  {$EXTERNALSYM IMAGE_SIZEOF_SHORT_NAME}
  IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16;
  {$EXTERNALSYM IMAGE_NUMBEROF_DIRECTORY_ENTRIES}
  PAGE_NOACCESS = 1;
  {$EXTERNALSYM PAGE_NOACCESS}
  PAGE_READONLY = 2;
  {$EXTERNALSYM PAGE_READONLY}
  PAGE_READWRITE = 4;
  {$EXTERNALSYM PAGE_READWRITE}
  PAGE_EXECUTE = $10;
  {$EXTERNALSYM PAGE_EXECUTE}
  PAGE_EXECUTE_READ = $20;
  {$EXTERNALSYM PAGE_EXECUTE_READ}
  PAGE_EXECUTE_READWRITE = $40;
  {$EXTERNALSYM PAGE_EXECUTE_READWRITE}
  MAXIMUM_SUPPORTED_EXTENSION = 512;
  {$EXTERNALSYM MAXIMUM_SUPPORTED_EXTENSION}
  SIZE_OF_80387_REGISTERS = 80;
  {$EXTERNALSYM SIZE_OF_80387_REGISTERS}
  STARTF_USESHOWWINDOW = 1;
  {$EXTERNALSYM STARTF_USESHOWWINDOW}
  CREATE_SUSPENDED = $00000004;
  {$EXTERNALSYM CREATE_SUSPENDED}
  CONTEXT_i386 = $10000;     { this assumes that i386 and }
  {$EXTERNALSYM CONTEXT_i386}
  CONTEXT_INTEGER = (CONTEXT_i386 or $00000002); { AX, BX, CX, DX, SI, DI }
  {$EXTERNALSYM CONTEXT_INTEGER}
  MEM_COMMIT = $1000;
  {$EXTERNALSYM MEM_COMMIT}
  MEM_RESERVE = $2000;
  {$EXTERNALSYM MEM_RESERVE}


type
  UINT_PTR = System.UIntPtr;
  HWND = type UINT_PTR;
  HANDLE = THandle;
  PVOID = Pointer;
  LPVOID = Pointer;
  ULONG_PTR = Cardinal;
  NTSTATUS = LongInt;
  LONG_PTR = Integer;
  DWORD = LongWord;
  ULONGLONG = UInt64;
  {$EXTERNALSYM ULONGLONG}
  ULONG = Cardinal;
  {$EXTERNALSYM ULONG}
  LPSTR = MarshaledAString;
  {$EXTERNALSYM LPSTR}
  LPWSTR = PWideChar;
  {$EXTERNALSYM LPWSTR}
  DWORD64 = UInt64;
  {$EXTERNALSYM DWORD64}
  SIZE_T = ULONG_PTR;
  {$EXTERNALSYM SIZE_T}
  LPCWSTR = PWideChar;
  {$EXTERNALSYM LPCWSTR}
  BOOL = LongBool;
  {$EXTERNALSYM BOOL}
  UINT = LongWord;
  {$EXTERNALSYM UINT}


{$ALIGN 2}
type
  PImageDosHeader = ^TImageDosHeader;
    {EXTERNALSYM _IMAGE_DOS_HEADER}
  _IMAGE_DOS_HEADER = record             { DOS .EXE header                  }
      e_magic: Word;                     { Magic number                     }
      e_cblp: Word;                      { Bytes on last page of file       }
      e_cp: Word;                        { Pages in file                    }
      e_crlc: Word;                      { Relocations                      }
      e_cparhdr: Word;                   { Size of header in paragraphs     }
      e_minalloc: Word;                  { Minimum extra paragraphs needed  }
      e_maxalloc: Word;                  { Maximum extra paragraphs needed  }
      e_ss: Word;                        { Initial (relative) SS value      }
      e_sp: Word;                        { Initial SP value                 }
      e_csum: Word;                      { Checksum                         }
      e_ip: Word;                        { Initial IP value                 }
      e_cs: Word;                        { Initial (relative) CS value      }
      e_lfarlc: Word;                    { File address of relocation table }
      e_ovno: Word;                      { Overlay number                   }
      e_res: array [0..3] of Word;       { Reserved words                   }
      e_oemid: Word;                     { OEM identifier (for e_oeminfo)   }
      e_oeminfo: Word;                   { OEM information; e_oemid specific}
      e_res2: array [0..9] of Word;      { Reserved words                   }
      _lfanew: LongInt;                  { File address of new exe header   }
  end;
  TImageDosHeader = _IMAGE_DOS_HEADER;
  {$EXTERNALSYM IMAGE_DOS_HEADER}
  IMAGE_DOS_HEADER = _IMAGE_DOS_HEADER;


type
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

type
  PFloatingSaveArea = ^TFloatingSaveArea;
  {$EXTERNALSYM PFloatingSaveArea}
  _FLOATING_SAVE_AREA = record
    ControlWord: DWORD;
    StatusWord: DWORD;
    TagWord: DWORD;
    ErrorOffset: DWORD;
    ErrorSelector: DWORD;
    DataOffset: DWORD;
    DataSelector: DWORD;
    RegisterArea: array[0..SIZE_OF_80387_REGISTERS - 1] of Byte;
    Cr0NpxState: DWORD;
  end;
  {$EXTERNALSYM _FLOATING_SAVE_AREA}
  TFloatingSaveArea = _FLOATING_SAVE_AREA;
  {$EXTERNALSYM TFloatingSaveArea}
  FLOATING_SAVE_AREA = _FLOATING_SAVE_AREA;
  {$EXTERNALSYM FLOATING_SAVE_AREA}

 PContext = ^TContext;
{$IF DEFINED(CPUX64)}
  {$ALIGN 16}
  M128A = record
    Low: ULONG_PTR;
    High: LONG_PTR;
  end;
  {$EXTERNALSYM M128A}

  _XSAVE_FORMAT = record
    ControlWord: WORD;
    StatusWord: WORD;
    TagWord: Byte;
    Reserved1: Byte;
    ErrorOpcode: WORD;
    ErrorOffset: DWORD;
    ErrorSelector: WORD;
    Reserved2: WORD;
    DataOffset: DWORD;
    DataSelector: WORD;
    Reserved3: WORD;
    MxCsr: DWORD;
    MxCsr_Mask: DWORD;
    FloatRegisters: array[0..7] of M128A;
{$IFDEF WIN64}
    XmmRegisters: array[0..15] of M128A;
    Reserved4: array[0..95] of Byte;
{$ELSE}
    XmmRegisters: array[0..7] of M128A;
    Reserved4: array[0..191] of Byte;

  {  The fields below are not part of XSAVE/XRSTOR format.
     They are written by the OS which is relying on a fact that
     neither (FX)SAVE nor (F)XSTOR used this area }

  StackControl: array[0..6] of DWORD;    // KERNEL_STACK_CONTROL structure actualy
  Cr0NpxState: DWORD;
{$ENDIF}
  end;
  {$EXTERNALSYM _XSAVE_FORMAT}
  XSAVE_FORMAT = _XSAVE_FORMAT;
  {$EXTERNALSYM XSAVE_FORMAT}
  PXSAVE_FORMAT = ^XSAVE_FORMAT;
  {$EXTERNALSYM PXSAVE_FORMAT}
  XMM_SAVE_AREA32 = XSAVE_FORMAT;
  {$EXTERNALSYM XMM_SAVE_AREA32}


 _CONTEXT = record
  {$EXTERNALSYM _CONTEXT}

  { Register parameter home addresses.
    N.B. These fields are for convience - they could be used to extend the
         context record in the future }

    P1Home: DWORD64;
    P2Home: DWORD64;
    P3Home: DWORD64;
    P4Home: DWORD64;
    P5Home: DWORD64;
    P6Home: DWORD64;

  { Control flags }

    ContextFlags: DWORD;
    MxCsr: DWORD;

  { Segment Registers and processor flags }

    SegCs: WORD;
    SegDs: WORD;
    SegEs: WORD;
    SegFs: WORD;
    SegGs: WORD;
    SegSs: WORD;
    EFlags: DWORD;

  { Debug registers }

    Dr0: DWORD64;
    Dr1: DWORD64;
    Dr2: DWORD64;
    Dr3: DWORD64;
    Dr6: DWORD64;
    Dr7: DWORD64;

  { Integer registers }

    Rax: DWORD64;
    Rcx: DWORD64;
    Rdx: DWORD64;
    Rbx: DWORD64;
    Rsp: DWORD64;
    Rbp: DWORD64;
    Rsi: DWORD64;
    Rdi: DWORD64;
    R8: DWORD64;
    R9: DWORD64;
    R10: DWORD64;
    R11: DWORD64;
    R12: DWORD64;
    R13: DWORD64;
    R14: DWORD64;
    R15: DWORD64;

  { Program counter }

    Rip: DWORD64;

  { Floating point state }

    case Integer of
      0: (
        FltSave: XMM_SAVE_AREA32;
        VectorRegister: array[0..25] of M128A; { Vector registers }
        VectorControl: DWORD64;
        DebugControl: DWORD64; { Special debug control registers }
        LastBranchToRip: DWORD64;
        LastBranchFromRip: DWORD64;
        LastExceptionToRip: DWORD64;
        LastExceptionFromRip: DWORD64);
      1: (
        Header: array[0..1] of M128A;
        Legacy: array[0..7] of M128A;
        Xmm0: M128A;
        Xmm1: M128A;
        Xmm2: M128A;
        Xmm3: M128A;
        Xmm4: M128A;
        Xmm5: M128A;
        Xmm6: M128A;
        Xmm7: M128A;
        Xmm8: M128A;
        Xmm9: M128A;
        Xmm10: M128A;
        Xmm11: M128A;
        Xmm12: M128A;
        Xmm13: M128A;
        Xmm14: M128A;
        Xmm15: M128A);
  end;
  {$ALIGN ON}
{$ELSEIF DEFINED(CPUX86)}
  _CONTEXT = record
  {$EXTERNALSYM _CONTEXT}

  { The flags values within this flag control the contents of
    a CONTEXT record.
    If the context record is used as an input parameter, then
    for each portion of the context record controlled by a flag
    whose value is set, it is assumed that that portion of the
    context record contains valid context. If the context record
    is being used to modify a threads context, then only that
    portion of the threads context will be modified.
    If the context record is used as an IN OUT parameter to capture
    the context of a thread, then only those portions of the thread's
    context corresponding to set flags will be returned.
    The context record is never used as an OUT only parameter. }

    ContextFlags: DWORD;

  { This section is specified/returned if CONTEXT_DEBUG_REGISTERS is
    set in ContextFlags.  Note that CONTEXT_DEBUG_REGISTERS is NOT
    included in CONTEXT_FULL. }

    Dr0: DWORD;
    Dr1: DWORD;
    Dr2: DWORD;
    Dr3: DWORD;
    Dr6: DWORD;
    Dr7: DWORD;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_FLOATING_POINT. }

    FloatSave: TFloatingSaveArea;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_SEGMENTS. }

    SegGs: DWORD;
    SegFs: DWORD;
    SegEs: DWORD;
    SegDs: DWORD;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_INTEGER. }

    Edi: DWORD;
    Esi: DWORD;
    Ebx: DWORD;
    Edx: DWORD;
    Ecx: DWORD;
    Eax: DWORD;

  { This section is specified/returned if the
    ContextFlags word contians the flag CONTEXT_CONTROL. }

    Ebp: DWORD;
    Eip: DWORD;
    SegCs: DWORD;
    EFlags: DWORD;
    Esp: DWORD;
    SegSs: DWORD;

  { This section is specified/returned if the ContextFlags word
    contains the flag CONTEXT_EXTENDED_REGISTERS.
    The format and contexts are processor specific}

    ExtendedRegisters: array[0..MAXIMUM_SUPPORTED_EXTENSION-1] of Byte;
  end;
{$ENDIF}
  TContext = _CONTEXT;
  CONTEXT = _CONTEXT;
  {$EXTERNALSYM CONTEXT}

type
  PStartupInfoA = ^TStartupInfoA;
  PStartupInfoW = ^TStartupInfoW;
  PStartupInfo = PStartupInfoW;
  _STARTUPINFOA = record
    cb: DWORD;
    lpReserved: LPSTR;
    lpDesktop: LPSTR;
    lpTitle: LPSTR;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
  _STARTUPINFOW = record
    cb: DWORD;
    lpReserved: LPWSTR;
    lpDesktop: LPWSTR;
    lpTitle: LPWSTR;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
  _STARTUPINFO = _STARTUPINFOW;
  TStartupInfoA = _STARTUPINFOA;
  TStartupInfoW = _STARTUPINFOW;
  TStartupInfo = TStartupInfoW;
  {$EXTERNALSYM STARTUPINFOA}
  STARTUPINFOA = _STARTUPINFOA;
  {$EXTERNALSYM STARTUPINFOW}
  STARTUPINFOW = _STARTUPINFOW;
  {$EXTERNALSYM STARTUPINFO}
  STARTUPINFO = STARTUPINFOW;

type
  PProcessInformation = ^TProcessInformation;
  _PROCESS_INFORMATION = record
    hProcess: THandle;
    hThread: THandle;
    dwProcessId: DWORD;
    dwThreadId: DWORD;
  end;
  {$EXTERNALSYM _PROCESS_INFORMATION}
  TProcessInformation = _PROCESS_INFORMATION;
  PROCESS_INFORMATION = _PROCESS_INFORMATION;
  {$EXTERNALSYM PROCESS_INFORMATION}

type
  PImageDataDirectory = ^TImageDataDirectory;
  _IMAGE_DATA_DIRECTORY = record
    VirtualAddress: DWORD;
    Size: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_DATA_DIRECTORY}
  TImageDataDirectory = _IMAGE_DATA_DIRECTORY;
  IMAGE_DATA_DIRECTORY = _IMAGE_DATA_DIRECTORY;
  {$EXTERNALSYM IMAGE_DATA_DIRECTORY}


{$ALIGN 4}
type
  PImageOptionalHeader32 = ^TImageOptionalHeader32;
  _IMAGE_OPTIONAL_HEADER32 = record
    { Standard fields. }
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    { NT additional fields. }
    ImageBase: DWORD;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: DWORD;
    SizeOfStackCommit: DWORD;
    SizeOfHeapReserve: DWORD;
    SizeOfHeapCommit: DWORD;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: packed array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1] of TImageDataDirectory;
  end;
  TImageOptionalHeader32 = _IMAGE_OPTIONAL_HEADER32;
  IMAGE_OPTIONAL_HEADER32 = _IMAGE_OPTIONAL_HEADER32;
  {$EXTERNALSYM IMAGE_OPTIONAL_HEADER32}

  PImageRomOptionalHeader = ^TImageRomOptionalHeader;
  _IMAGE_ROM_OPTIONAL_HEADER = record
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    BaseOfData: DWORD;
    BaseOfBss: DWORD;
    GprMask: DWORD;
    CprMask: packed array[0..3] of DWORD;
    GpValue: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_ROM_OPTIONAL_HEADER}
  TImageRomOptionalHeader = _IMAGE_ROM_OPTIONAL_HEADER;
  IMAGE_ROM_OPTIONAL_HEADER = _IMAGE_ROM_OPTIONAL_HEADER;
  {$EXTERNALSYM IMAGE_ROM_OPTIONAL_HEADER}

  TISHMisc = record
    case Integer of
      0: (PhysicalAddress: DWORD);
      1: (VirtualSize: DWORD);
  end;

  PPImageSectionHeader = ^PImageSectionHeader;
  PImageSectionHeader = ^TImageSectionHeader;

  _IMAGE_SECTION_HEADER = record
    Name: packed array[0..IMAGE_SIZEOF_SHORT_NAME-1] of Byte;
    Misc: TISHMisc;
    VirtualAddress: DWORD;
    SizeOfRawData: DWORD;
    PointerToRawData: DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations: Word;
    NumberOfLinenumbers: Word;
    Characteristics: DWORD;
  end;
  {$EXTERNALSYM _IMAGE_SECTION_HEADER}
  TImageSectionHeader = _IMAGE_SECTION_HEADER;
  IMAGE_SECTION_HEADER = _IMAGE_SECTION_HEADER;
  {$EXTERNALSYM IMAGE_SECTION_HEADER}
{$ALIGN ON}

type
  PImageOptionalHeader64 = ^TImageOptionalHeader64;
  _IMAGE_OPTIONAL_HEADER64 = record
    { Standard fields. }
    Magic: Word;
    MajorLinkerVersion: Byte;
    MinorLinkerVersion: Byte;
    SizeOfCode: DWORD;
    SizeOfInitializedData: DWORD;
    SizeOfUninitializedData: DWORD;
    AddressOfEntryPoint: DWORD;
    BaseOfCode: DWORD;
    { NT additional fields. }
    ImageBase: ULONGLONG;
    SectionAlignment: DWORD;
    FileAlignment: DWORD;
    MajorOperatingSystemVersion: Word;
    MinorOperatingSystemVersion: Word;
    MajorImageVersion: Word;
    MinorImageVersion: Word;
    MajorSubsystemVersion: Word;
    MinorSubsystemVersion: Word;
    Win32VersionValue: DWORD;
    SizeOfImage: DWORD;
    SizeOfHeaders: DWORD;
    CheckSum: DWORD;
    Subsystem: Word;
    DllCharacteristics: Word;
    SizeOfStackReserve: ULONGLONG;
    SizeOfStackCommit: ULONGLONG;
    SizeOfHeapReserve: ULONGLONG;
    SizeOfHeapCommit: ULONGLONG;
    LoaderFlags: DWORD;
    NumberOfRvaAndSizes: DWORD;
    DataDirectory: packed array[0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES-1] of TImageDataDirectory;
  end;
  {$EXTERNALSYM _IMAGE_OPTIONAL_HEADER64}
  TImageOptionalHeader64 = _IMAGE_OPTIONAL_HEADER64;
  IMAGE_OPTIONAL_HEADER64 = _IMAGE_OPTIONAL_HEADER64;
  {$EXTERNALSYM IMAGE_OPTIONAL_HEADER64}

{$ALIGN 4}
  PImageFileHeader = ^TImageFileHeader;
  _IMAGE_FILE_HEADER = record
    Machine: Word;
    NumberOfSections: Word;
    TimeDateStamp: DWORD;
    PointerToSymbolTable: DWORD;
    NumberOfSymbols: DWORD;
    SizeOfOptionalHeader: Word;
    Characteristics: Word;
  end;
  {$EXTERNALSYM _IMAGE_FILE_HEADER}
  TImageFileHeader = _IMAGE_FILE_HEADER;
  IMAGE_FILE_HEADER = _IMAGE_FILE_HEADER;
  {$EXTERNALSYM IMAGE_FILE_HEADER}

  PImageNtHeaders64 = ^TImageNtHeaders64;
  _IMAGE_NT_HEADERS64 = record
    Signature: DWORD;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader64;
  end;
  {$EXTERNALSYM _IMAGE_NT_HEADERS64}
  TImageNtHeaders64 = _IMAGE_NT_HEADERS64;
  IMAGE_NT_HEADERS64 = _IMAGE_NT_HEADERS64;
  {$EXTERNALSYM IMAGE_NT_HEADERS64}

  PImageNtHeaders32 = ^TImageNtHeaders32;
  _IMAGE_NT_HEADERS32 = record
    Signature: DWORD;
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageOptionalHeader32;
  end;
  TImageNtHeaders32 = _IMAGE_NT_HEADERS32;
  IMAGE_NT_HEADERS32 = _IMAGE_NT_HEADERS32;
  {$EXTERNALSYM IMAGE_NT_HEADERS32}


  PImageRomHeaders = ^TImageRomHeaders;
  _IMAGE_ROM_HEADERS = record
    FileHeader: TImageFileHeader;
    OptionalHeader: TImageRomOptionalHeader;
  end;
  {$EXTERNALSYM _IMAGE_ROM_HEADERS}
  TImageRomHeaders = _IMAGE_ROM_HEADERS;
  IMAGE_ROM_HEADERS = _IMAGE_ROM_HEADERS;
  {$EXTERNALSYM IMAGE_ROM_HEADERS}

{$IFDEF WIN64}
  TImageNtHeaders = TImageNtHeaders64;
  PImageNtHeaders = PImageNtHeaders64;
  IMAGE_NT_HEADERS = IMAGE_NT_HEADERS64;
  _IMAGE_NT_HEADERS = IMAGE_NT_HEADERS64;
  IMAGE_OPTIONAL_HEADER = IMAGE_OPTIONAL_HEADER64;
  _IMAGE_OPTIONAL_HEADER = IMAGE_OPTIONAL_HEADER64;
  TImageOptionalHeader = TImageOptionalHeader64;

const
  IMAGE_SIZEOF_NT_OPTIONAL_HEADER64      = 240;
  {$EXTERNALSYM IMAGE_SIZEOF_NT_OPTIONAL_HEADER64}
  IMAGE_NT_OPTIONAL_HDR64_MAGIC          = $020B;
  {$EXTERNALSYM IMAGE_NT_OPTIONAL_HDR64_MAGIC}
  IMAGE_NT_OPTIONAL_HDR_MAGIC = IMAGE_NT_OPTIONAL_HDR64_MAGIC;
  IMAGE_SIZEOF_NT_OPTIONAL_HEADER = IMAGE_SIZEOF_NT_OPTIONAL_HEADER64;
{$ELSE}
  TImageNtHeaders = TImageNtHeaders32;
  PImageNtHeaders = PImageNtHeaders32;
  IMAGE_NT_HEADERS = IMAGE_NT_HEADERS32;
  _IMAGE_NT_HEADERS = IMAGE_NT_HEADERS32;
  IMAGE_OPTIONAL_HEADER = IMAGE_OPTIONAL_HEADER32;
  _IMAGE_OPTIONAL_HEADER = IMAGE_OPTIONAL_HEADER32;
  TImageOptionalHeader = TImageOptionalHeader32;

const
  IMAGE_SIZEOF_NT_OPTIONAL_HEADER32      = 224;
  {$EXTERNALSYM IMAGE_SIZEOF_NT_OPTIONAL_HEADER32}

  IMAGE_NT_OPTIONAL_HDR32_MAGIC          = $010B;
  {$EXTERNALSYM IMAGE_NT_OPTIONAL_HDR32_MAGIC}

  IMAGE_ROM_OPTIONAL_HDR_MAGIC           = $0107;
  {$EXTERNALSYM IMAGE_ROM_OPTIONAL_HDR_MAGIC}
  IMAGE_NT_OPTIONAL_HDR_MAGIC = IMAGE_NT_OPTIONAL_HDR32_MAGIC;
  IMAGE_SIZEOF_NT_OPTIONAL_HEADER = IMAGE_SIZEOF_NT_OPTIONAL_HEADER32;
{$ENDIF}
  {$EXTERNALSYM _IMAGE_NT_HEADERS}
  {$EXTERNALSYM _IMAGE_OPTIONAL_HEADER}
  {$EXTERNALSYM IMAGE_NT_HEADERS}
  {$EXTERNALSYM IMAGE_OPTIONAL_HEADER}
  {$EXTERNALSYM IMAGE_NT_OPTIONAL_HDR_MAGIC}
  {$EXTERNALSYM IMAGE_SIZEOF_NT_OPTIONAL_HEADER}


  function LoadLibrary(lpLibFileName: PWideChar): HMODULE; stdcall;
  {$EXTERNALSYM LoadLibrary}
  function FreeLibrary(hLibModule: HMODULE): LongBool; stdcall;
  {$EXTERNALSYM FreeLibrary}
  function GetProcAddress(hModule: HMODULE; lpProcName: MarshaledAString): Pointer; stdcall; overload;
  {$EXTERNALSYM GetProcAddress}
  function GetProcAddress(hModule: HMODULE; lpProcName: PWideChar): Pointer; stdcall; overload;
  {$EXTERNALSYM GetProcAddress}
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
  dwSize: SIZE_T; flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL; stdcall; overload;
  {$EXTERNALSYM VirtualProtectEx}
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
    dwSize: SIZE_T; flNewProtect: DWORD; var OldProtect: DWORD): BOOL; stdcall; overload;
  {$EXTERNALSYM VirtualProtectEx}

implementation

  function LoadLibrary; external kernel32 name LLW;
  function FreeLibrary; external kernel32 name FL;
  function GetProcAddress(hModule: HMODULE; lpProcName: MarshaledAString): Pointer; external kernel32 name GPA;
  function GetProcAddress(hModule: HMODULE; lpProcName: PWideChar): Pointer;
  begin
    if NativeUInt(lpProcName) shr 16 = 0 then Result := GetProcAddress(hModule, MarshaledAString(lpProcName))
    else Result := GetProcAddress(hModule, MarshaledAString(TMarshal.AsAnsi(lpProcName)));
  end;
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
  dwSize: SIZE_T; flNewProtect: DWORD; lpflOldProtect: Pointer): BOOL;
  external kernel32 name 'VirtualProtectEx';
  function VirtualProtectEx(hProcess: THandle; lpAddress: Pointer;
  dwSize: SIZE_T; flNewProtect: DWORD; var OldProtect: DWORD): BOOL;
  external kernel32 name 'VirtualProtectEx';
end.
