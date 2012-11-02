program Importer;



{$R *.dres}

uses
  Vcl.Forms,
  FormMain in 'FormMain.pas' {frmMain},
  LibCommon in '..\Plugin\LibCommon.pas';

{$R *.res}

var
  frmMain: TfrmMain;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Status Manager 2.0 SQLite Database Importer';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
