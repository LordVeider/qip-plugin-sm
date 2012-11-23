unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ImgList,
  Vcl.StdCtrls, Data.FMTBcd, Datasnap.DBClient, Data.DB, Data.SqlExpr,
  Datasnap.Provider, Data.DbxSqlite, Vcl.ExtCtrls, MidasLib,
  LibCommon;

type
  TEditMode = (emCancel, emAdd, emEdit);
  TDBGridExt = class(TDBGrid)
  protected
    procedure UpdateScrollBar; override;
    procedure UpdateColWidths;
  end;
  TDBGrid = class(TDBGridExt);
  TfrmMain = class(TForm)
    grdList: TDBGrid;
    grdFilter: TStringGrid;
    imglMain: TImageList;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDel: TButton;
    btnSet: TButton;
    btnSettings: TButton;
    pnlAddEdit: TPanel;
    cbbImage: TComboBox;
    edtHeader: TEdit;
    mmoDescription: TMemo;
    btnConfirm: TButton;
    btnReject: TButton;
    lblNotice: TLabel;
    procedure grdFilterDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnEditClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure grdListDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdFilterSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdListTitleClick(Column: TColumn);
    procedure cbbImageDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnRejectClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure EditModeDoChange(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure grdFilterMouseWheel(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    FPluginHWnd: NativeUInt;
    FPluginOptions: TPluginOptions;
    FDataSet: TSQLQuery;
    FDataProvider: TDataSetProvider;
    FClientDataSet: TClientDataSet;
    FDataSource: TDataSource;
    FConnection: TSQLConnection;
    FSemaphore: NativeUInt;
    FThread: TThread;
    FStatusImages: TPngImageList;
    FOrderDescending: Boolean;
    FEditMode: TEditMode;
    FHasChanges: Boolean;
  public
    constructor Create(AOwner: TComponent; APluginHWND: HWND; AConnection: TSQLConnection; ASemaphore: NativeUInt;
      APluginOptions: TPluginOptions; AStatusImages: TPngImageList);
    procedure ReloadData(Filter: Integer; OrderBy: Integer = 0; Descending: Boolean = False);
    procedure SaveStatus(Image: Integer; Header, Description: String; ID: NativeUInt = 0);
    procedure DeleteStatus(ID: NativeUInt);
    procedure SetStatus(Image: Integer; Header, Description: String);
    procedure SetControlState(Enabled: Boolean);
    procedure SetEditMode(EditMode: TEditMode);
  end;

implementation

{$R *.dfm}

{ TfrmMain }

{$REGION 'Form methods & events'}

constructor TfrmMain.Create(AOwner: TComponent; APluginHWND: HWND; AConnection: TSQLConnection; ASemaphore: NativeUInt;
  APluginOptions: TPluginOptions; AStatusImages: TPngImageList);
var
  Index: Integer;
begin
  inherited Create(AOwner);
  FPluginHWnd := APluginHWND;
  FConnection := AConnection;
  FSemaphore := ASemaphore;
  FStatusImages := AStatusImages;
  FDataSet := TSQLQuery.Create(Self);
  FDataProvider := TDataSetProvider.Create(Self);
  FClientDataSet := TClientDataSet.Create(Self);
  FDataSource := TDataSource.Create(Self);
  FDataSet.SQLConnection := FConnection;
  FDataProvider.DataSet := FDataSet;
  FDataProvider.Name := 'SQLQueryDataProvider';
  FClientDataSet.ProviderName := FDataProvider.Name;
  FDataSource.DataSet := FClientDataSet;
  grdList.DataSource := FDataSource;
  //
  FPluginOptions := APluginOptions;
  with FPluginOptions do
  begin
    //Set window state and position
    Self.WindowState := WindowState;
    if WindowState = wsNormal then
    begin
      Left := WindowPosition.Left;
      Top := WindowPosition.Top;
      Width := WindowPosition.Width;
      Height := WindowPosition.Height;
    end;
    Self.Color := ColorScheme.Background;
    edtHeader.MaxLength := StatusParams.MaxHeader;
    mmoDescription.MaxLength := StatusParams.MaxDesc;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  with FPluginOptions do
    if FilterSave then
    begin
      grdFilter.Col := FilterIndex div 6;
      grdFilter.Row := FilterIndex mod 6;
      ReloadData(FilterIndex);
    end
    else
    begin
      grdFilter.Col := 0;
      grdFilter.Row := 0;
      ReloadData(0);
    end;
  SetEditMode(emCancel);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  NewPosition: TSquare;
begin
  with FPluginOptions do
  begin
    //Write window state and position
    WindowState := Self.WindowState;
    if WindowState = wsNormal then
    begin
      NewPosition := TSquare.Create;
      NewPosition.Left := Left;
      NewPosition.Top := Top;
      NewPosition.Width := Width;
      NewPosition.Height := Height;
      WindowPosition.Free;
      WindowPosition := NewPosition;
    end;
    with grdFilter do
      FilterIndex := 6 * Col + Row;
  end;
  Action := caFree;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  grdList.UpdateColWidths;
end;

{$ENDREGION}

{$REGION 'Buttons'}

procedure TfrmMain.btnSetClick(Sender: TObject);
begin
  if not grdList.Fields[0].IsNull then
  begin
    with grdList do
      SetStatus(Fields[1].Value, Fields[2].Value, Fields[3].Value);
    with FPluginOptions do
      if CloseAfterApply then
        Close;
  end;
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
begin
  SetEditMode(emAdd);
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
begin
  if not grdList.Fields[0].IsNull then
    SetEditMode(emEdit);
end;

procedure TfrmMain.btnDelClick(Sender: TObject);
begin
  if not grdList.Fields[0].IsNull then
    if Application.MessageBox('Are you sure to delete selected status?',
    'Delete', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2 + MB_TOPMOST) =
    IDYES then
      DeleteStatus(grdList.Fields[0].Value);
end;

procedure TfrmMain.btnConfirmClick(Sender: TObject);
begin
  if FHasChanges then
  case FEditMode of
    emAdd: SaveStatus(cbbImage.ItemIndex+1, edtHeader.Text, mmoDescription.Lines.Text);
    emEdit: SaveStatus(cbbImage.ItemIndex+1, edtHeader.Text, mmoDescription.Lines.Text, grdList.Fields[0].Value);
  end;
  SetEditMode(emCancel);
end;

procedure TfrmMain.btnRejectClick(Sender: TObject);
begin
  SetEditMode(emCancel);
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  SendMessage(FPluginHWnd, MSG_OPTIONS, 0, 0);
end;

{$ENDREGION}

{$REGION 'Grids & filters'}

procedure TfrmMain.grdFilterDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  Index: Integer;
begin
  with grdFilter, Canvas do
  begin
    Index := 6 * ACol + ARow;
    FStatusImages.Draw(Canvas, Rect.Left-1, Rect.Top+3, Index);
  end;
end;

procedure TfrmMain.grdFilterSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  ReloadData(6 * ACol + ARow);
  FOrderDescending := False;
end;

procedure TfrmMain.grdFilterMouseWheel(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Handled := True;
  grdList.SetFocus;
end;

procedure TfrmMain.grdListDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
var
  Image: Integer;
  OutRect: TRect;
  OutText: String;
begin
  with TDBGrid(Sender), Canvas do
  begin
    if gdSelected in State then
      Brush.Color := clGradientActiveCaption
    else
      Brush.Color := clWindow;
    FillRect(Rect);
    if Field.Index = 1 then
    begin
      //Resize columns, set captions
      with Columns do
        if Items[0].Visible then
        begin
          Items[0].Visible := False;
          Items[1].Title.Caption := ' ';
          UpdateColWidths;
        end;
      //Draw status image
      if TryStrToInt(Field.AsString, Image) then
        FStatusImages.Draw(Canvas, Rect.Left+4, Rect.Top+1, Image);
    end
    else
    begin
      //Fix bug with displaying (WIDEMEMO) instead of text
      OutRect := Rect;
      OutRect.Left := Rect.Left+4;
      OutRect.Top := Rect.Top+1;
      OutText := PrettyStr(Field.AsString, Columns.Items[Field.Index].Width-4, Canvas);
      //Font.Size := 8;
      TextRect(OutRect, OutText);
    end;
  end;
end;

procedure TfrmMain.grdListTitleClick(Column: TColumn);
begin
  with grdFilter do
  begin
    ReloadData(6 * Col + Row, Column.Index, FOrderDescending);
    FOrderDescending := not FOrderDescending;
  end;
end;

procedure TfrmMain.cbbImageDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with TComboBox(Control), Canvas do
  begin
    FillRect(Rect);
    FStatusImages.Draw(Canvas, Rect.Left+4, Rect.Top+1, Index+1);
  end;
end;

{$ENDREGION}

{$REGION 'Contol commons'}

procedure TfrmMain.SetControlState(Enabled: Boolean);
begin
  grdFilter.Enabled := Enabled;
  grdList.Enabled := Enabled;
  btnSet.Enabled := Enabled;
  btnAdd.Enabled := Enabled;
  btnEdit.Enabled := Enabled;
  btnDel.Enabled := Enabled;
end;

procedure TfrmMain.SetEditMode(EditMode: TEditMode);
begin
  case EditMode of
    emCancel:
    begin
      SetControlState(True);
      pnlAddEdit.Hide;
    end;
    emAdd:
    begin
      cbbImage.ItemIndex := 0;
      edtHeader.Text := EmptyStr;
      mmoDescription.Lines.Clear;
      SetControlState(False);
      pnlAddEdit.Show;
    end;
    emEdit:
    begin
      cbbImage.ItemIndex := grdList.Fields[1].Value-1;
      edtHeader.Text := grdList.Fields[2].Value;
      mmoDescription.Lines.Text := grdList.Fields[3].Value;
      SetControlState(False);
      pnlAddEdit.Show;
    end;
  end;
  FEditMode := EditMode;
  FHasChanges := False;
end;

procedure TfrmMain.EditModeDoChange(Sender: TObject);
begin
  FHasChanges := True;
end;

{$ENDREGION}

{$REGION 'Data manipulation'}

procedure TfrmMain.ReloadData(Filter, OrderBy: Integer; Descending: Boolean);
var
  Query, FilterParams, OrderParams: String;
begin
  if Filter > 0 then
    FilterParams := Format(' WHERE "Image" = "%d"', [Filter]);
  if OrderBy > 0 then
  begin
    case OrderBy of
      1: OrderParams := '"Image"';
      2: OrderParams := '"Header"';
      3: OrderParams := '"Description"';
    end;
    if Descending then
      OrderParams := Format(' ORDER BY %s DESC', [OrderParams])
    else
      OrderParams := Format(' ORDER BY %s', [OrderParams]);
  end;
  Query := Format(SQL_SELECT, [FilterParams, OrderParams]);
  WaitForSingleObject(FSemaphore, INFINITE);
  try
    FClientDataSet.Close;
    FDataSet.CommandText := Query;
    FClientDataSet.DisableControls;
    FClientDataSet.Open;
    FClientDataSet.EnableControls;
  finally
    ReleaseSemaphore(FSemaphore, 1, nil);
  end;
end;

procedure TfrmMain.SaveStatus(Image: Integer; Header, Description: String; ID: NativeUInt);
var
  Query: String;
begin
  Header := StringReplace(Header, '"', '""', [rfReplaceAll]);
  Description := StringReplace(Description, '"', '""', [rfReplaceAll]);
  if ID = 0 then
    Query := Format(SQL_INSERT_NOEXISTS, [Image, Header, Description])
  else
    Query := Format(SQL_UPDATE, [Image, Header, Description, ID]);
  FThread := TSQLThread.Create(FConnection, FSemaphore, Query);
end;

procedure TfrmMain.DeleteStatus(ID: NativeUInt);
var
  Query: String;
begin
  Query := Format(SQL_DELETE, [ID]);
  FThread := TSQLThread.Create(FConnection, FSemaphore, Query);
end;

procedure TfrmMain.SetStatus(Image: Integer; Header, Description: String);
var
  Status: PStatus;
begin
  New(Status);
  Status^.Image := Image;
  Status^.Header := Header;
  Status^.Description := Description;
  SendMessage(FPluginHWnd, MSG_SET_XSTATUS, Integer(Status), 0);
end;

{$ENDREGION}

{ TDBGridExt }

{$REGION 'TDBGridExt'}

procedure TDBGridExt.UpdateScrollBar;
begin
  inherited;
  ShowScrollBar(Self.Handle, SB_HORZ, False);
end;

procedure TDBGridExt.UpdateColWidths;
begin
  try
    with Columns do
    begin
      Items[1].Width := 22;
      Items[2].Width := 163;
      Items[3].Width := Width - 220;
    end;
  except
    //
  end;
end;

{$ENDREGION}

end.
