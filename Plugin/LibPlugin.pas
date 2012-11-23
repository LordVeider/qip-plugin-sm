unit LibPlugin;

interface

uses
  Classes, SysUtils,
  Vcl.Forms, Vcl.Graphics, Vcl.Dialogs, Vcl.Controls, Vcl.ImgList, Vcl.Menus,
  Winapi.Windows, Winapi.Messages, Winapi.SHFolder, Winapi.CommCtrl,
  Data.SqlExpr,
  PngImage,
  u_plugin_info, u_baseplugin, u_plugin_msg, u_common, u_gui_graphics, u_gr_ids,
  LibCommon, FormMain, FormSettings;

type
  TFontColorSettings = record
    FontName: WideString;
    FontSize: Integer;
    Colors: TQipColors;
  end;
  TQipPlugin = class(TBaseQipPlugin)
  private
    FHandle: NativeUInt;
    FFormMain: TfrmMain;
    FFormSettings: TfrmSettings;
    FMenu: TPopupMenu;
    FPluginOptions: TPluginOptions;
    FConnection: TSQLConnection;
    FSemaphore: NativeUInt;
    FThread: TThread;
    FPluginIcon: HICON;
    FGraphHandle: NativeUInt;
    FFontColorSettings: TFontColorSettings;
    FStatusImages: TPngImageList;
    FPluginContactID: NativeUInt;
    FPluginButtonID: NativeUInt;
    //Window Procedure
    procedure OnMessage(var Message: TMessage);
    //Property-ready methods
    function GetApplicationPath: String;
    function GetSkinsPath: String;
    function GetSkinsConfigFile: String;
    function GetSkinStatusesFile: String;
    function GetPluginPath: String;
    function GetPluginHomePath: String;
    function GetPluginOptionsFile: String;
    function GetPluginDatabaseFile: String;
    function GetStatusImages: TPngImageList;
    //Plugin messages processing
    procedure InitPlugin; override;
    procedure FinalPlugin; override;
    procedure OnOptions; override;
    procedure GetPluginInformation(var VersionMajor, VersionMinor: Word;
      var PluginName, Creator, Description, Hint: PWideChar); override;
    function PluginIcon: HICON; override;
    procedure PaintContact(const DestCanvas: TCanvas; const ARect: TRect;
      const UniqueID, UserData: Integer); override;
    procedure PaintContactHint(const HintCanvas: TCanvas; const ARect: TRect;
      const UniqueID, UserData: Integer); override;
    procedure OnGetFakeContactHintSize(const UniqueID, UserData: Integer;
      var Width, Height: Integer); override;
    procedure OnFakeContactDblClk(const UniqueID, UserData: Integer); override;
    procedure OnFakeContactRightClick(const UniqueID, UserData: Integer;
      const PopupPoint: TPoint); override;
    procedure NeedAddButtons(const AccountName, ProtoName: WideString;
      const ProtoHandle: Integer = -1); override;
    procedure ButtonClicked(const UniqueID, ProtoHandle: Integer;
      const AccountName, ProtoName: WideString; const BtnData: TBtnClick); override;
    procedure XStatusChanged(const ActiveStatus: Integer;
      const StatusText, StatusDescription: WideString); override;
    procedure ContactXStatusChanged(var Message: TPluginMessage);	message PM_PLUGIN_CONT_XST_CHANGE;
    procedure AntiBossChanged(const SwitchedOn: Boolean); override;
    procedure PluginMessageReceived(SenderDllHandle: Integer; var LParam, NParam, AResult: Integer); override;
  public
    //Other methods
    procedure LoadOptions; override;
    procedure SaveOptions; override;
    procedure FormMainShow(Sender: TObject = nil);
    procedure FormSettingsShow(Sender: TObject = nil);
    procedure CreatePluginMenu;
    procedure AddPluginContact;
    procedure RemovePluginContact;
    procedure SetXStatus(Image: Integer; Header, Description: String);
    //Properties
    property StatusImages: TPngImageList read GetStatusImages;
  end;

implementation

{ TQipPlugin }

{$REGION 'Window Procedure'}

procedure TQipPlugin.OnMessage(var Message: TMessage);
begin
  with Message do
    case Msg of
      MSG_OPTIONS:
      begin
        FormSettingsShow;
      end;
      MSG_SET_PLUGINCONTACT:
      begin
        if WParam = 0 then
          RemovePluginContact
        else
          AddPluginContact;
      end;
      MSG_SET_XSTATUS:
      begin
        with PStatus(WParam)^ do
          SetXStatus(Image, Header, Description);
        Dispose(PStatus(WParam));
      end;
      else
        Result := DefWindowProc(FHandle, Msg, wParam, lParam);
    end;
end;

{$ENDREGION}

{$REGION 'Property-ready methods'}

function TQipPlugin.GetApplicationPath: String;
begin
	Result := ExtractFilePath(Application.ExeName);
end;

function TQipPlugin.GetSkinsPath: String;
begin
  Result := GetApplicationPath + 'Skins\';
end;

function TQipPlugin.GetSkinsConfigFile: String;
begin
  SetLength(Result, MAX_PATH);
  SHGetFolderPath(0, CSIDL_APPDATA, 0, 0, PChar(Result));
  SetLength(Result, StrLen(PChar(Result)));
  Result := Result + '\QIP\Skins\current.cfg';
  if not FileExists(Result) then
    Result := GetSkinsPath + 'current.cfg';
end;

function TQipPlugin.GetSkinStatusesFile: String;
var
   CurrentList: TStringList;
begin
  //Get current skin name
	if FileExists(GetSkinsConfigFile) then
  begin
    CurrentList := TStringList.Create;
    CurrentList.LoadFromFile(GetSkinsConfigFile);
    Result := CurrentList.Strings[0];
    FreeAndNil(CurrentList);
  end
  else  //Set default value
   	Result := 'QIP';
  Result := GetSkinsPath + Result + '\XStatuses\xstatuses_alpha.png';
end;

function TQipPlugin.GetPluginPath: String;
begin
  Result := GetApplicationPath + 'Plugins\StatusManager\';
end;

function TQipPlugin.GetPluginHomePath: String;
begin
  Result := GetPluginsDataDirectory + 'StatusManager\';
end;

function TQipPlugin.GetPluginOptionsFile: String;
begin
  Result := GetPluginHomePath + 'Options.xml';
end;

function TQipPlugin.GetPluginDatabaseFile: String;
begin
  Result := GetPluginHomePath + 'Database.sqlite';
end;

function TQipPlugin.GetStatusImages: TPngImageList;
var
  NoImage: TIcon;
begin
  if FGraphHandle <> GetGraphHandle then
  begin
    NoImage := TIcon.Create;
    NoImage.Handle := CoreUtils.Draw.GetSkinIm_AsIcon(PChar(Format(DEFAULT_SKIN_RESOURCE, [GR_XST_PIC_NO])));
    FStatusImages.LoadFromFile(GetSkinStatusesFile, 16, 16);
    FStatusImages.InsertIcon(0, NoImage);
    FreeAndNil(NoImage);
    FGraphHandle := GetGraphHandle;
  end;
  Result := FStatusImages;
end;

{$ENDREGION}

{$REGION 'Plugin messages processing'}

procedure TQipPlugin.InitPlugin;
begin
  //Set environment variables
  SetEnvVar('PATH', GetPluginPath + ';' + GetEnvVar('PATH'));
  //Create files & directories
  ForceDirectories(GetPluginHomePath);
  if not FileExists(GetPluginDatabaseFile) then
    FileClose(FileCreate(GetPluginDatabaseFile));
  //Load options
  FPluginOptions := TPluginOptions.Create(Application);
  LoadOptions;
  FStatusImages := TPngImageList.Create(Application);
  with FFontColorSettings do
    GetFontColorSettings(FontName, FontSize, Colors);
  CreatePluginMenu;
  if FPluginOptions.ContactShow then
    AddPluginContact;
  //Connect to database
  FConnection := TSQLConnection.Create(Application);
  FConnection.DriverName := 'SQLite';
  FConnection.LoginPrompt := False;
  FConnection.Params.Values['Database'] := GetPluginDatabaseFile;
  FSemaphore := CreateSemaphore(nil, 0, 1, 'SQLConnectionAccessSemaphore');
  try
    FConnection.Open;
    FConnection.Execute(SQL_CREATE_NOEXISTS, nil);
  finally
    ReleaseSemaphore(FSemaphore, 1, nil);
  end;
  //Allocate handle and window procedure
  FHandle := AllocateHWnd(OnMessage);
end;

procedure TQipPlugin.FinalPlugin;
begin
  //Destroy objects
  if FormOnScreen('frmMain') then
    FFormMain.Close;
  if FormOnScreen('frmSettings') then
    FFormSettings.Close;
  if Assigned(FMenu) then
  begin
    FMenu.Images.Free;
    FreeAndNil(FMenu);
  end;
  if Assigned(FConnection) then
  begin
    FConnection.Close;
    FreeAndNil(FConnection);
  end;
  DeallocateHWnd(FHandle);
  //Save options
  SaveOptions;
end;

procedure TQipPlugin.OnOptions;
begin
  FormSettingsShow;
end;

procedure TQipPlugin.GetPluginInformation(var VersionMajor, VersionMinor: Word;
  var PluginName, Creator, Description, Hint: PWideChar);
var
  Version: TVersion;
begin
  Version.Get(HInstance);
  VersionMajor := Version.Major;
  VersionMinor := Version.Minor;
  Creator      := PChar(PLUGIN_AUTHOR);
  PluginName   := PChar(PLUGIN_NAME);
  Description  := PChar(PLUGIN_DESC);
  Hint         := PChar(PLUGIN_DESC);
end;

function TQipPlugin.PluginIcon: HICON;
var
  Icon: TIcon;
  Image: TPngImage;
  ImgList: TPngImageList;
begin
  if FPluginIcon = 0 then
  begin
    //Convert default icon from resource to HICON
    Icon := TIcon.Create;
    Image := TPngImage.Create;
    Image.LoadFromResourceName(HInstance, 'ICON_MAIN');
    ImgList := TPngImageList.Create(Application);
    ImgList.GetIcon(ImgList.AddPng(Image), Icon);
    Result := Icon.Handle;
    FreeAndNil(Image);
    FreeAndNil(ImgList);
  end
  else
    Result := FPluginIcon;
end;

procedure TQipPlugin.PaintContact(const DestCanvas: TCanvas; const ARect: TRect;
  const UniqueID, UserData: Integer);
var
  Icon: TIcon;
  ActiveStatus: Integer;
  StatusText, StatusDescription: WideString;
begin
  inherited;
  if UniqueID = FPluginContactID then
    with DestCanvas do
    begin
      //Set canvas properties
      Brush.Style := bsClear;
      with Font, FFontColorSettings do
      begin
        Name := FontName;
        Size := FontSize;
        Color := Colors.Online;
      end;
      with FPluginOptions do
      begin
        if ContactIcon = 0 then  //Draw plugin icon
        begin
          Icon := TIcon.Create;
          Icon.Handle := PluginIcon;
          Draw(ARect.Left+5, ARect.Top+1, Icon);
          FreeAndNil(Icon);
        end
        else
        begin                    //Draw current status icon
          GetXStatus(ActiveStatus, StatusText, StatusDescription);
          StatusImages.Draw(DestCanvas, ARect.Left+5, ARect.Top+1, ActiveStatus);
        end;
        if ContactName.IsEmpty then
          TextOut(ARect.Left+24, ARect.Top+2, PLUGIN_NAME)
        else
          TextOut(ARect.Left+24, ARect.Top+2, ContactName);
      end;
    end;
end;

procedure TQipPlugin.PaintContactHint(const HintCanvas: TCanvas;
  const ARect: TRect; const UniqueID, UserData: Integer);
begin
  inherited;
end;

procedure TQipPlugin.OnGetFakeContactHintSize(const UniqueID, UserData: Integer;
  var Width, Height: Integer);
begin
  inherited;
end;

procedure TQipPlugin.OnFakeContactDblClk(const UniqueID, UserData: Integer);
begin
  if UniqueID = FPluginContactID then
    FormMainShow;
end;

procedure TQipPlugin.OnFakeContactRightClick(const UniqueID, UserData: Integer;
  const PopupPoint: TPoint);
begin
  if UniqueID = FPluginContactID then
    FMenu.Popup(PopupPoint.X, PopupPoint.Y);
end;

procedure TQipPlugin.NeedAddButtons(const AccountName, ProtoName: WideString;
  const ProtoHandle: Integer);
var
  IconHandle: HICON;
  ActiveStatus: Integer;
  StatusText, StatusDescription: WideString;
begin
  with FPluginOptions do
    if ButtonShow then
    begin
      if ButtonIcon = 0 then  //Draw plugin icon
        FPluginButtonID := AddAvatarButton(PluginIcon, PLUGIN_NAME, 0)
      else
      begin
        GetXStatus(ActiveStatus, StatusText, StatusDescription);
        IconHandle := ImageList_GetIcon(StatusImages.Handle, ActiveStatus, 0);
        FPluginButtonID := AddAvatarButton(IconHandle, PLUGIN_NAME, 0);
      end;
    end;
end;

procedure TQipPlugin.ButtonClicked(const UniqueID, ProtoHandle: Integer;
  const AccountName, ProtoName: WideString; const BtnData: TBtnClick);
begin
  if UniqueID = FPluginButtonID then
    if BtnData.RightClick then
      FMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
    else
      FormMainShow;
end;

procedure TQipPlugin.XStatusChanged(const ActiveStatus: Integer;
  const StatusText, StatusDescription: WideString);
var
  Image: Integer;
  Header, Description: String;
  Query: String;
begin
  if FPluginOptions.SaveStatusMyself then
  begin
    if ActiveStatus > 35 then //Trim extended status packs codes
      Image := 30
    else
      Image := ActiveStatus;
    Header := StringReplace(StatusText, '"', '""', [rfReplaceAll]);
    Description := StringReplace(StatusDescription, '"', '""', [rfReplaceAll]);
    Query := Format(SQL_INSERT_NOEXISTS, [Image, Header, Description]);
    FThread := TSQLThread.Create(FConnection, FSemaphore, Query);
  end;
  InvalidateFakeContact(FPluginContactID);
end;

procedure TQipPlugin.ContactXStatusChanged(var Message: TPluginMessage);
var
  DelimPos: Integer;
  Image: Integer;
  Header, Description: String;
  Query: String;
begin
  if FPluginOptions.SaveStatusContacts then
    with Message do
      if (WParam <> 0) and (LParam <> 0) then   //Check params
        if NParam > 0 then                      //Check image index
        begin
          if NParam > 35 then                   //Trim extended status packs codes
            Image := 30
          else
            Image := NParam;
          Description := PChar(Result);
          DelimPos := Pos('|', Description);
          Header := Copy(Description, 1, DelimPos-1);
          Header := StringReplace(Header, '"', '""', [rfReplaceAll]);
          Delete(Description, 1, DelimPos);
          Description := StringReplace(Description, '"', '""', [rfReplaceAll]);
          if not (Header.IsEmpty and Description.IsEmpty) then
          begin
            Query := Format(SQL_INSERT_NODUPLICATE, [Image, Header, Description]);
            FThread := TSQLThread.Create(FConnection, FSemaphore, Query);
          end;
        end;
end;

procedure TQipPlugin.AntiBossChanged(const SwitchedOn: Boolean);
begin
  if FormOnScreen('frmMain') then
    FFormMain.Visible := not SwitchedOn;
  if FormOnScreen('frmSettings') then
    FFormSettings.Visible := not SwitchedOn;
end;

procedure TQipPlugin.PluginMessageReceived(SenderDllHandle: Integer; var LParam, NParam, AResult: Integer);
var
  Version: TVersion;
begin
  inherited;
  if LParam <> 0 then
    if PChar(LParam) = 'PluginCheckerGet' then
    begin
      Version.Get(HInstance);
      SendMessageToPlugin(SenderDllHandle, LongInt(PChar(CURRENT_UPDATE)),
        LongInt(PChar(Version.ToString)), LongInt(PChar('PluginCheckerGet')));
    end;
end;

{$ENDREGION}

{$REGION 'Other methods'}

procedure TQipPlugin.LoadOptions;
begin
  FPluginOptions.LoadFromFile(GetPluginOptionsFile);
end;

procedure TQipPlugin.SaveOptions;
begin
  FPluginOptions.SaveToFile(GetPluginOptionsFile);
end;

procedure TQipPlugin.FormMainShow;
begin
  if not FormOnScreen('frmMain') then
    FFormMain := TfrmMain.Create(Application, FHandle, FConnection, FSemaphore, FPluginOptions, StatusImages);
  FFormMain.Show;
end;

procedure TQipPlugin.FormSettingsShow;
begin
  if not FormOnScreen('frmSettings') then
    FFormSettings := TfrmSettings.Create(Application, FHandle, FPluginOptions);
  FFormSettings.Show;
end;

procedure TQipPlugin.CreatePluginMenu;
var
  ImageList: TPngImageList;
begin
  FMenu := TPopupMenu.Create(Application);
  with FMenu do
  begin
    ImageList := TPngImageList.Create(FMenu);
    ImageList.AddPngFromResourceName(HInstance, 'ICON_TABLE');
    ImageList.AddPngFromResourceName(HInstance, 'ICON_TOOLS');
    FMenu.Images := ImageList;
    Items.Add(TMenuItem.Create(FMenu));
    Items[0].Caption := 'Status List';
    Items[0].ImageIndex := 0;
    Items[0].OnClick := FormMainShow;
    Items.Add(TMenuItem.Create(FMenu));
    Items[1].Caption := 'Settings';
    Items[1].ImageIndex := 1;
    Items[1].OnClick := FormSettingsShow;
  end;
end;

procedure TQipPlugin.AddPluginContact;
begin
  if FPluginContactID = 0 then
    FPluginContactID := AddFakeContact(1, 0)
  else
    InvalidateFakeContact(FPluginContactID);
end;

procedure TQipPlugin.RemovePluginContact;
begin
  if FPluginContactID <> 0 then
  begin
    RemoveFakeContact(FPluginContactID);
    FPluginContactID := 0;
  end;
end;

procedure TQipPlugin.SetXStatus(Image: Integer; Header, Description: String);
begin
  UpdateXStatus(Image, Header, Description);
  InvalidateFakeContact(FPluginContactID);
end;

{$ENDREGION}

end.
