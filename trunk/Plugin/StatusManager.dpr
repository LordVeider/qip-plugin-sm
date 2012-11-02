library StatusManager;

{$R *.dres}

uses
  u_plugin_info,
  System.SysUtils,
  System.Classes,
  LibCommon in 'LibCommon.pas',
  LibPlugin in 'LibPlugin.pas',
  FormMain in 'FormMain.pas' {frmMain},
  FormSettings in 'FormSettings.pas' {frmSettings};

{$R *.res}

function CreateInfiumPLUGIN(PluginService: IQIPPluginService): IQIPPlugin; stdcall;
begin
  Result := TQipPlugin.Create(PluginService);
end;

exports
  CreateInfiumPLUGIN name 'CreateInfiumPLUGIN';

end.
