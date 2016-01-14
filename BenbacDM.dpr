program BenbacDM;

uses
  Forms,
  UMain in 'UMain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Benbac Download Manager';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
  end.
