program Exemple_RDL;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  RDL in 'RDL.pas';

{$R *.res}
{$R WindowsXP.res}

begin
  Application.Initialize;
  Application.Title := 'Exemple RDL';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
