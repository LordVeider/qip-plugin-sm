unit FormSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ImgList, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  LibCommon;

type
  TfrmSettings = class(TForm)
    pgcSettings: TPageControl;
    btnOk: TButton;
    imglSettings: TImageList;
    btnCancel: TButton;
    tsIntegration: TTabSheet;
    tsAbout: TTabSheet;
    tsActions: TTabSheet;
    lblPluginName: TLabel;
    lblPluginVersion: TLabel;
    lblPluginDesc: TLabel;
    grDeveloper: TGroupBox;
    lblAuthor: TLabel;
    lblAuthorL: TLabel;
    grThirdParty: TGroupBox;
    lblTC1: TLabel;
    lblTC1L: TLabel;
    lblTC3: TLabel;
    lblTC3L: TLabel;
    tsDatabase: TTabSheet;
    rgContactIcon: TRadioGroup;
    chkContactShow: TCheckBox;
    edtContactName: TEdit;
    chkContactName: TCheckBox;
    chkButtonShow: TCheckBox;
    rgButtonIcon: TRadioGroup;
    chkFilterSave: TCheckBox;
    chkCloseAfterApply: TCheckBox;
    chkSaveStatusMyself: TCheckBox;
    chkBackupEnabled: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    FPluginHWnd: NativeUInt;
    FPluginOptions: TPluginOptions;
  public
    constructor Create(AOwner: TComponent; APluginHWND: HWND; APluginOptions: TPluginOptions);
  end;

implementation

{$R *.dfm}

{ TfrmSettings }

constructor TfrmSettings.Create(AOwner: TComponent; APluginHWND: HWND;
  APluginOptions: TPluginOptions);
var
  Version: TVersion;
begin
  inherited Create(AOwner);
  FPluginHWnd := APluginHWND;
  FPluginOptions := APluginOptions;
  with FPluginOptions do
  begin
    //Integration
    chkContactShow.Checked := ContactShow;
    chkContactName.Checked := not ContactName.IsEmpty;
    edtContactName.Text := ContactName;
    rgContactIcon.ItemIndex := ContactIcon;
    chkButtonShow.Checked := ButtonShow;
    rgButtonIcon.ItemIndex := ButtonIcon;
    //Status list
    chkFilterSave.Checked := FilterSave;
    chkCloseAfterApply.Checked := CloseAfterApply;
    //Database
    chkSaveStatusMyself.Checked := SaveStatusMyself;
    //Self
    Self.Color := ColorScheme.Background;
  end;
  lblPluginName.Caption := PLUGIN_NAME;
  lblPluginDesc.Caption := PLUGIN_DESC;
  Version.Get(HInstance);
  lblPluginVersion.Caption := Version.ToString;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmSettings.btnOkClick(Sender: TObject);
begin
  with FPluginOptions do
  begin
    //Integration
    ContactShow := chkContactShow.Checked;
    if chkContactName.Checked then
      ContactName := edtContactName.Text
    else
      ContactName := EmptyStr;
    ContactIcon := rgContactIcon.ItemIndex;
    ButtonShow := chkButtonShow.Checked;
    ButtonIcon := rgButtonIcon.ItemIndex;
    //Status list
    FilterSave := chkFilterSave.Checked;
    CloseAfterApply := chkCloseAfterApply.Checked;
    //Database
    SaveStatusMyself := chkSaveStatusMyself.Checked;
    SendMessage(FPluginHWnd, MSG_SET_PLUGINCONTACT, Integer(ContactShow), 0);
  end;
  Close;
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

end.
