unit LibCommon;

interface

uses
  NativeXml, NativeXmlObjectStorage,
  Classes, SysUtils,
  Winapi.Windows, Winapi.ActiveX,
  Data.SqlExpr, Datasnap.DBClient,
  Vcl.Controls, Vcl.Forms, Vcl.Graphics,
  ImgList, PngImage;

const
  PLUGIN_NAME             = 'Status Manager';
  PLUGIN_AUTHOR           = 'Veider';
  PLUGIN_DESC             = 'Status management tool for QIP 2012';
  //
  MSG_BASE                = 1000;
  MSG_OPTIONS             = MSG_BASE + 1;
  MSG_SET_PLUGINCONTACT   = MSG_BASE + 2;
  MSG_SET_XSTATUS         = MSG_BASE + 10;
  MSG_UPDATE_TABLE        = MSG_BASE + 20;
  //
  SQL_DROP                = 'DROP TABLE IF EXISTS "Statuses";';
  SQL_CREATE_NOEXISTS     = 'CREATE TABLE IF NOT EXISTS "Statuses" ("ID" INTEGER PRIMARY KEY, "Image" NUMERIC, "Header" TEXT, "Description" TEXT);';
  SQL_SELECT              = 'SELECT * FROM "Statuses"%s%s;';
  SQL_INSERT              = 'INSERT INTO "Statuses" ("Image", "Header", "Description") VALUES ("%d", "%s", "%s");';
  SQL_INSERT_NODUPLICATE  = 'INSERT INTO "Statuses" ("Image", "Header", "Description") SELECT "%d" as "I", "%s" as "H", "%s" as "D" WHERE NOT EXISTS (SELECT 1 FROM "Statuses" WHERE "Header" = "H" AND "Description" = "D");';
  SQL_INSERT_NOEXISTS     = 'INSERT INTO "Statuses" ("Image", "Header", "Description") SELECT "%d" as "I", "%s" as "H", "%s" as "D" WHERE NOT EXISTS (SELECT 1 FROM "Statuses" WHERE "Image" = "I" AND "Header" = "H" AND "Description" = "D");';
  SQL_UPDATE              = 'UPDATE "Statuses" SET "Image" = "%d", "Header" = "%s", "Description" = "%s" WHERE "ID" = "%d";';
  SQL_DELETE              = 'DELETE FROM "Statuses" WHERE "ID" = "%d";';
  //
  CURRENT_UPDATE          = 'http://qip-plugin-sm.googlecode.com/svn/service/plugcheck';

type
  TSquare = class(TPersistent)
  private
    FTop, FLeft, FHeight, FWidth: Integer;
  published
    property Top: Integer read FTop write FTop;
    property Left: Integer read FLeft write FLeft;
    property Height: Integer read FHeight write FHeight;
    property Width: Integer read FWidth write FWidth;
  end;
  TStatusParams = class(TPersistent)
  private
    FOverIndexMode: Integer;
    FMaxHeader: Integer;
    FMaxDesc: Integer;
  published
    property OverIndexMode: Integer read FOverIndexMode write FOverIndexMode;
    property MaxHeader: Integer read FMaxHeader write FMaxHeader;
    property MaxDesc: Integer read FMaxDesc write FMaxDesc;
  end;
  TColorScheme = class(TPersistent)
  private
    FBackground: TColor;
  published
    property Background: TColor read FBackground write FBackground;
  end;
  TPluginOptions = class(TComponent)
  private
    FContactShow: Boolean;
    FContactName: String;
    FContactIcon: Integer;
    FButtonShow: Boolean;
    FButtonIcon: Integer;
    FFilterSave: Boolean;
    FFilterIndex: Integer;
    FCloseAfterApply: Boolean;
    FWindowPosition: TSquare;
    FWindowState: TWindowState;
    FSaveStatusMyself: Boolean;
    FSaveStatusContacts: Boolean;
    FBackupCount: Integer;
    FStatusParams: TStatusParams;
    FColorScheme: TColorScheme;
    FDownloadLink: String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(FileName: String);
    procedure SaveToFile(FileName: String);
  published
    property ContactShow: Boolean read FContactShow write FContactShow;
    property ContactName: String read FContactName write FContactName;
    property ContactIcon: Integer read FContactIcon write FContactIcon;
    property ButtonShow: Boolean read FButtonShow write FButtonShow;
    property ButtonIcon: Integer read FButtonIcon write FButtonIcon;
    property FilterSave: Boolean read FFilterSave write FFilterSave;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property CloseAfterApply: Boolean read FCloseAfterApply write FCloseAfterApply;
    property WindowPosition: TSquare read FWindowPosition write FWindowPosition;
    property WindowState: TWindowState read FWindowState write FWindowState;
    property SaveStatusMyself: Boolean read FSaveStatusMyself write FSaveStatusMyself;
    property SaveStatusContacts: Boolean read FSaveStatusContacts write FSaveStatusContacts;
    property BackupCount: Integer read FBackupCount write FBackupCount;
    property StatusParams: TStatusParams read FStatusParams write FStatusParams;
    property ColorScheme: TColorScheme read FColorScheme write FColorScheme;
    property DownloadLink: String read FDownloadLink write FDownloadLink;
  end;
  TStatus = record
    Image: Integer;
    Header: String;
    Description: String;
  end;
  PStatus = ^TStatus;
  TWordArray = array [0..3] of Word;
  TVersion = record
  private
    FVersion: ^TWordArray;
    function GetMajor: Word;
    function GetMinor: Word;
    function GetRev: Word;
    function GetBuild: Word;
  public
    procedure Get(Instance: HINST);
    function ToString: String;
    property Major: Word read GetMajor;
    property Minor: Word read GetMinor;
    property Rev: Word read GetRev;
    property Build: Word read GetBuild;
  end;
  TPngImageList = class(TCustomImageList)
  public
    constructor Create(AOwner: TComponent); override;
    function AddPng(Image: TPngImage): Integer;
    function AddPngFromResourceName(Instance: NativeUInt; Name: String): Integer;
    function LoadFromFile(FileName: String; AWidth, AHeight: Integer): Integer;
  end;
  TSQLThread = class(TThread)
  private
    FConnection: TSQLConnection;
    FSemaphore: NativeUInt;
    FCommandText: String;
  public
    constructor Create(AConnection: TSQLConnection; ASemaphore: NativeUInt; ACommandText: String);
    procedure Execute; override;
  end;

procedure FreeAndNil(var Obj);
function FormOnScreen(Name: String): Boolean;
function PrettyStr(Source: String; Width: Integer; Canvas: TCanvas): String;
function GetEnvVar(VarName: String): String;
procedure SetEnvVar(VarName: String; Value: String);

implementation

procedure FreeAndNil(var Obj);
begin
  try
    TObject(Obj).Free;
  finally
    Pointer(Obj) := nil;
  end;
end;

function FormOnScreen(Name: String): Boolean;
var
  Index: Integer;
begin
  Result := False;
  for Index := Screen.FormCount-1 downto 0 do
    if Screen.Forms[Index].Name = Name then
    begin
      Result := True;
      Break;
    end;
end;

function PrettyStr(Source: String; Width: Integer; Canvas: TCanvas): String;
begin
  Result := Source;
  if Result.Length > 0 then
  begin
    Result := Trim(StringReplace(Result, #13#10, #32, [rfReplaceAll]));
    if Canvas.TextWidth(Result) > Width then
    begin
      while Canvas.TextWidth(Result + '...') > Width do
        Delete(Result, Result.Length, 1);
      Result := Result + '...';
    end;
  end;
end;

function GetEnvVar(VarName: String): String;
var
  Len: Integer;
begin
  Len := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if Len <> 0 then
  begin
    SetLength(Result, Len);
    GetEnvironmentVariable(PChar(VarName), PChar(Result), Len);
  end;
end;

procedure SetEnvVar(VarName: String; Value: String);
begin
  SetEnvironmentVariable(PChar(VarName), PChar(Value));
end;


{ TPluginOptions }

constructor TPluginOptions.Create(AOwner: TComponent);
begin
  inherited;
  FWindowPosition := TSquare.Create;
  FContactShow := True;
  FCloseAfterApply := True;
  FSaveStatusMyself := True;
  FBackupCount := 3;
  FStatusParams := TStatusParams.Create;
  with FStatusParams do
  begin
    OverIndexMode := 1;
    MaxHeader := 20;
    MaxDesc := 258;
  end;
  FColorScheme := TColorScheme.Create;
  with FColorScheme do
  begin
    Background := clWindow;
  end;
  FDownloadLink := 'http://qip-plugin-sm.googlecode.com/svn/service/plugcheck';
end;

destructor TPluginOptions.Destroy;
begin
  FreeAndNil(FWindowPosition);
  inherited;
end;

procedure TPluginOptions.LoadFromFile(FileName: String);
var
  Doc: TNativeXml;
  Reader: TsdXmlObjectReader;
begin
  inherited;
  Doc := TNativeXml.Create(Application);
  try
    Doc.LoadFromFile(FileName);
    Reader := TsdXmlObjectReader.Create;
    try
      Reader.ReadComponent(Doc.Root, Self, nil);
    finally
      Reader.Free;
    end;
  finally
    Doc.Free;
  end;
end;

procedure TPluginOptions.SaveToFile(FileName: String);
var
  Doc: TNativeXml;
  Writer: TsdXmlObjectWriter;
begin
  inherited;
  Doc := TNativeXml.CreateName('Root');
  try
    Doc.XmlFormat := xfReadable;
    Writer := TsdXmlObjectWriter.Create;
    try
      Writer.WriteComponent(Doc.Root, Self, nil);
      Doc.SaveToFile(FileName);
    finally
      Writer.Free;
    end;
  finally
    Doc.Free;
  end;
end;

{ TVersion }

procedure TVersion.Get(Instance: HINST);
var
  HR: NativeUInt;
  Handle: NativeUInt;
begin
  HR := FindResource(Instance, '#1', RT_VERSION);
  Handle := LoadResource(Instance, HR);
  Integer(FVersion) := Integer(LockResource(Handle)) + 48;
  UnlockResource(Handle);
  FreeResource(Handle);
end;

function TVersion.GetMajor: Word;
begin
  Result := FVersion^[1];
end;

function TVersion.GetMinor: Word;
begin
  Result := FVersion^[0];
end;

function TVersion.GetRev: Word;
begin
  Result := FVersion^[3];
end;

function TVersion.GetBuild: Word;
begin
  Result := FVersion^[2];
end;

function TVersion.ToString: String;
begin
  Result := Format('%d.%d.%d.%d', [FVersion^[1], FVersion^[0], FVersion^[3], FVersion^[2]]);
end;

{ TPngImageList }

constructor TPngImageList.Create(AOwner: TComponent);
begin
  inherited;
  Masked := False;
  ColorDepth := cd32bit;
end;

function TPngImageList.AddPng(Image: TPngImage): Integer;
var
  Bitmap: TBitmap;
begin
  //Add png image to image list
  Bitmap := TBitmap.Create;
  Bitmap.Assign(Image);
  Bitmap.AlphaFormat := afIgnored;
  Result := Add(Bitmap, nil);
  FreeAndNil(Bitmap);
end;

function TPngImageList.AddPngFromResourceName(Instance: NativeUInt;
  Name: String): Integer;
var
  Image: TPngImage;
begin
  Image := TPngImage.Create;
  Image.LoadFromResourceName(Instance, Name);
  Result := AddPng(Image);
  FreeAndNil(Image);
end;

function TPngImageList.LoadFromFile(FileName: String; AWidth,
  AHeight: Integer): Integer;
var
  Image: TPngImage;
begin
  //Load image list items from splitted single file
  Image := TPngImage.Create;
  Image.LoadFromFile(FileName);
  Clear;
  Width := AWidth;
  Height := AHeight;
  AddPng(Image);
  Result := Count;
  FreeAndNil(Image);
end;

{ TSQLThread }

constructor TSQLThread.Create(AConnection: TSQLConnection;
  ASemaphore: NativeUInt; ACommandText: String);
begin
  inherited Create;
  FConnection := AConnection;
  FSemaphore := ASemaphore;
  FCommandText := ACommandText;
  FreeOnTerminate := True;
end;

procedure TSQLThread.Execute;
begin
  CoInitialize(nil);
  WaitForSingleObject(FSemaphore, INFINITE);
  try
    try
      FConnection.Execute(FCommandText, nil);
    except
      //Processing exception
    end;
  finally
    ReleaseSemaphore(FSemaphore, 1, nil);
  end;
end;

end.
