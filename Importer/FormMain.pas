unit FormMain;

interface

uses
  Winapi.ActiveX,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ImgList, Vcl.ComCtrls,
  Data.FMTBcd, Data.DB, Data.SqlExpr, Data.DbxSqlite,
  LibCommon;

type
  TStatusOld = record
    Image: Integer;
    Header: array [0..20] of Char;
    Description: array [0..512] of Char;
  end;
  TImportingThread = class(TThread)
  private
    Connection: TSQLConnection;
    Completed, OverallCount: Integer;
    procedure SetProgress;
    procedure SetControls;
  protected
    FSource: String;
    FDatabase: String;
    FDropDatabase, FCheckEmpty, FCheckDuplicates: Boolean;
    function OpenSourceFile: Integer; virtual; abstract;
    procedure CloseSourceFile; virtual; abstract;
    function ReadStatusFromSourceFile: TStatus; virtual; abstract;
  public
    constructor Create(ASource, ADatabase: String; ADropDatabase, ACheckEmpty, ACheckDuplicates: Boolean);
    destructor Destroy; override;
    procedure Execute; override;
  end;
  TImportingThreadOld = class(TImportingThread)
  private
    SourceFile: file of TStatusOld;
    function OpenSourceFile: Integer; override;
    procedure CloseSourceFile; override;
    function ReadStatusFromSourceFile: TStatus; override;
  end;
  TImportingThreadSXS = class(TImportingThread)
  private
    SourceReader: TFileStream;
    function OpenSourceFile: Integer; override;
    procedure CloseSourceFile; override;
    function ReadStatusFromSourceFile: TStatus; override;
  end;
  TImportingThreadXSC = class(TImportingThread)
  private
    CurrentCount: Integer;
    CurrentCap: AnsiString;
    Caps: TStringList;
    SourceReader: TFileStream;
    function OpenSourceFile: Integer; override;
    procedure CloseSourceFile; override;
    function ReadStatusFromSourceFile: TStatus; override;
  end;
  TfrmMain = class(TForm)
    rgSourceFormat: TRadioGroup;
    imglMain: TImageList;
    grPaths: TGroupBox;
    edtDatabase: TLabeledEdit;
    edtSource: TLabeledEdit;
    btnOpenDatabase: TButton;
    btnOpenSource: TButton;
    btnRun: TButton;
    dlgOpenFile: TOpenDialog;
    lblProgress: TLabel;
    grOptions: TGroupBox;
    chkDropDatabase: TCheckBox;
    chkCheckEmpty: TCheckBox;
    chkCheckDuplicates: TCheckBox;
    procedure btnRunClick(Sender: TObject);
    procedure btnOpenSourceClick(Sender: TObject);
    procedure btnOpenDatabaseClick(Sender: TObject);
  private
    { Private declarations }
    ImportingThread: TImportingThread;
  public
    { Public declarations }
    procedure SetControlState(Enabled: Boolean);
    function CheckParams: Boolean;
    procedure ImportStatuses;
  end;

implementation

{$R *.dfm}

procedure TfrmMain.btnOpenSourceClick(Sender: TObject);
begin
  if dlgOpenFile.Execute then
    edtSource.Text := dlgOpenFile.FileName;
end;

procedure TfrmMain.btnOpenDatabaseClick(Sender: TObject);
begin
  if dlgOpenFile.Execute then
    edtDatabase.Text := dlgOpenFile.FileName;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
begin
  if CheckParams then
    ImportStatuses;
end;

procedure TfrmMain.SetControlState(Enabled: Boolean);
begin
  edtSource.Enabled := Enabled;
  edtDatabase.Enabled := Enabled;
  btnOpenSource.Enabled := Enabled;
  btnOpenDatabase.Enabled := Enabled;
  rgSourceFormat.Enabled := Enabled;
  grOptions.Enabled := Enabled;
  btnRun.Enabled := Enabled;
end;

function TfrmMain.CheckParams: Boolean;
begin
  Result := True;
  if not FileExists(edtSource.Text) then
  begin
    Application.MessageBox('Source file is not exists', 'Error', MB_OK + MB_ICONWARNING + MB_TOPMOST);
    Result := False;
  end;
  if not FileExists(edtDatabase.Text) then
  begin
    Application.MessageBox('Destination file is not exists', 'Error', MB_OK + MB_ICONWARNING + MB_TOPMOST);
    Result := False;
  end;
end;

procedure TfrmMain.ImportStatuses;
begin
  SetControlState(False);
  case rgSourceFormat.ItemIndex of
    0: ImportingThread := TImportingThreadOld.Create(edtSource.Text, edtDatabase.Text,
      chkDropDatabase.Checked, chkCheckEmpty.Checked, chkCheckDuplicates.Checked);
    1: ImportingThread := TImportingThreadSXS.Create(edtSource.Text, edtDatabase.Text,
      chkDropDatabase.Checked, chkCheckEmpty.Checked, chkCheckDuplicates.Checked);
    2: ImportingThread := TImportingThreadXSC.Create(edtSource.Text, edtDatabase.Text,
      chkDropDatabase.Checked, chkCheckEmpty.Checked, chkCheckDuplicates.Checked);
  end;
end;

{ TImportingThread }

procedure TImportingThread.SetProgress;
begin
  with TfrmMain(Application.MainForm) do
    lblProgress.Caption := Format('%d/%d', [Completed, OverallCount]);
end;

procedure TImportingThread.SetControls;
begin
  with TfrmMain(Application.MainForm) do
    SetControlState(True);
end;

constructor TImportingThread.Create(ASource, ADatabase: String;
  ADropDatabase, ACheckEmpty, ACheckDuplicates: Boolean);
begin
  inherited Create;
  FreeOnTerminate := True;
  FSource := ASource;
  FDatabase := ADatabase;
  FDropDatabase := ADropDatabase;
  FCheckEmpty := ACheckEmpty;
  FCheckDuplicates := ACheckDuplicates;
  Completed := 0;
  Connection := TSQLConnection.Create(Application);
  with Connection do
  begin
    DriverName := 'SQLite';
    Connection.Params.Values['Database'] := FDatabase;
    LoginPrompt := False;
  end;
end;

destructor TImportingThread.Destroy;
begin
  FreeAndNil(Connection);
  inherited;
end;

procedure TImportingThread.Execute;
var
  Query: String;
  Status: TStatus;
begin
  inherited;
  CoInitialize(nil);
  try
    try
      OverallCount := OpenSourceFile;
      Synchronize(SetProgress);
      try
        try
          Connection.Open;
          if FDropDatabase then
            Connection.Execute(SQL_DROP, nil);
          Connection.Execute(SQL_CREATE_NOEXISTS, nil);
          try
            Connection.Execute('BEGIN TRANSACTION;', nil);
            while not Terminated do
            try
              Status := ReadStatusFromSourceFile;
              with Status do
              try
                //Format query
                if FCheckDuplicates then
                  Query := Format(SQL_INSERT_NODUPLICATE, [Image, Header, Description])
                else
                  Query := Format(SQL_INSERT, [Image, Header, Description]);
                //Do with options
                if FCheckEmpty then
                  if (Header.IsEmpty and Description.IsEmpty) then
                    //do nothing
                  else
                    Connection.Execute(Query, nil)
                else
                  Connection.Execute(Query, nil);
                //Synchronize controls
                Inc(Completed);
                Synchronize(SetProgress);
                if Completed = OverallCount then
                  Terminate;
              except
                Application.MessageBox('Database query error', 'Error', MB_OK + MB_ICONSTOP + MB_TOPMOST);
              end;
            except
              Application.MessageBox('Source file read error', 'Error', MB_OK + MB_ICONSTOP + MB_TOPMOST);
              Terminate;
            end;
          finally
            Connection.Execute('COMMIT;', nil);
          end;
        except
          Application.MessageBox('Database connection error', 'Error', MB_OK + MB_ICONSTOP + MB_TOPMOST);
        end;
      finally
        Connection.Close;
      end;
    except
      Application.MessageBox('Source file open error', 'Error', MB_OK + MB_ICONSTOP + MB_TOPMOST);
    end;
  finally
    CloseSourceFile;
    Synchronize(SetControls);
  end;
end;

{ TImportingThreadOld }

function TImportingThreadOld.OpenSourceFile: Integer;
begin
  AssignFile(SourceFile, FSource);
  Reset(SourceFile);
  Result := FileSize(SourceFile);
end;

procedure TImportingThreadOld.CloseSourceFile;
begin
  CloseFile(SourceFile);
end;

function TImportingThreadOld.ReadStatusFromSourceFile: TStatus;
var
  StatusOld: TStatusOld;
begin
  //Read
  Read(SourceFile, StatusOld);
  //Return
  Result.Image := StatusOld.Image;
  Result.Header := StringReplace(String(StatusOld.Header), '"', '""', [rfReplaceAll]);
  Result.Description := StringReplace(String(StatusOld.Description), '"', '""', [rfReplaceAll]);
end;

{ TImportingThreadSXS }

function TImportingThreadSXS.OpenSourceFile: Integer;
begin
  SourceReader := TFileStream.Create(FSource, fmOpenRead);
  Result := SourceReader.Size div 537;
end;

procedure TImportingThreadSXS.CloseSourceFile;
begin
  FreeAndNil(SourceReader);
end;

function TImportingThreadSXS.ReadStatusFromSourceFile: TStatus;
var
  Index: Byte;
  Image, Header, Description: AnsiString;
begin
  //Read
  SetLength(Image, 2);
  SetLength(Header, 21);
  SetLength(Description, 513);
  with SourceReader do
  begin
    ReadBuffer(Index, 1);
    ReadBuffer(Image[1], 2);
    ReadBuffer(Header[1], 21);
    ReadBuffer(Description[1], 513);
  end;
  //Calculate image index
  //KILL SETXSTATUS AUTHOR WITH FIRE!!!
  Index := StrToInt(Copy(Image, 1, Index)) + 1;
  //Return
  Result.Image := Index;
  Result.Header := StringReplace(PAnsiChar(Header), '"', '""', [rfReplaceAll]);
  Result.Description := StringReplace(PAnsiChar(Description), '"', '""', [rfReplaceAll]);
end;

{ TImportingThreadXSC }

function TImportingThreadXSC.OpenSourceFile: Integer;
var
  CapsCount, C: Byte;
  B: Byte;
  W: Word;
  P: Int64;
  StatusCount, S: Integer;
  ResLoader: TResourceStream;
begin
  Result := 0;
  //Load caps from resources
  ResLoader := TResourceStream.Create(HInstance, 'CAPS', RT_RCDATA);
  Caps := TStringList.Create;
  Caps.LoadFromStream(ResLoader);
  FreeAndNil(ResLoader);
  //Create source file reader
  SourceReader := TFileStream.Create(FSource, fmOpenRead);
  with SourceReader do          //Calculate overall record count
  begin
    ReadBuffer(CapsCount, 1);
    for C := 1 to CapsCount do
    begin
      ReadBuffer(B, 1);
      Seek(B, soFromCurrent);
      ReadBuffer(StatusCount, 4);
      if C = 1 then
        P := Position;
      for S := 1 to StatusCount do
      begin
        ReadBuffer(B, 1);
        Seek(B, soFromCurrent);
        ReadBuffer(W, 2);
        Seek(W*2, soFromCurrent);
        ReadBuffer(W, 2);
        Seek(W*2, soFromCurrent);
        Inc(Result);
      end;
    end;
    Seek(1, soFromBeginning);     //Seek to beginning
  end;
end;

procedure TImportingThreadXSC.CloseSourceFile;
begin
  FreeAndNil(Caps);
  FreeAndNil(SourceReader);
end;

function TImportingThreadXSC.ReadStatusFromSourceFile: TStatus;
var
  Image: Integer;
  Header, Description: String;
  B: Byte;
  W: Word;
begin
  with SourceReader do
  begin
    if CurrentCount = 0 then  //Read next cap
    begin
      ReadBuffer(B, 1);
      SetLength(CurrentCap, B);
      ReadBuffer(CurrentCap[1], B);
      ReadBuffer(CurrentCount, 4);
    end;
    //Read data
    ReadBuffer(B, 1);
    Seek(B, soFromCurrent);
    ReadBuffer(W, 2);
    SetLength(Header, W);
    ReadBuffer(Header[1], W*2);
    ReadBuffer(W, 2);
    SetLength(Description, W);
    ReadBuffer(Description[1], W*2);
    Dec(CurrentCount);
  end;
  //KILL XSTC AUTHOR WITH NAPALM!!!
  //Return
  Result.Image := Caps.IndexOf(CurrentCap) + 1;
  Result.Header := StringReplace(Header, '"', '""', [rfReplaceAll]);
  Result.Description := StringReplace(Description, '"', '""', [rfReplaceAll]);
end;

end.
