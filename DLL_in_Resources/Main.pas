unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RDL;

type
  TMainForm = class(TForm)
    ConsoleMemo: TMemo;
    LoadBtn: TButton;
    CloseDLL: TButton;
    QuitBtn: TButton;
    ProgLbl: TLabel;
    DLLBox: TGroupBox;
    ParamLbl: TLabel;
    ParamEdit: TEdit;
    BeepBox: TRadioButton;
    MessageBox: TRadioButton;
    ExecuteBtn: TButton;
    procedure ConsoleMemoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QuitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadBtnClick(Sender: TObject);
    procedure CloseDLLClick(Sender: TObject);
    procedure MessageBoxClick(Sender: TObject);
    procedure ExecuteBtnClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type
  TProcedureSansParametre = procedure;
  TProcedureAvecParametre = procedure (lpBuffer: PChar);

const
  NomRessource = 'MADLL';

var
  MainForm: TMainForm;
  MaDLL: TRDL;

implementation

{$R *.dfm}
{$R DLLRes.res}

procedure TMainForm.ConsoleMemoClick(Sender: TObject);
begin
 ConsoleMemo.SelStart := Length(ConsoleMemo.Text);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 DoubleBuffered := True;
end;

procedure TMainForm.QuitBtnClick(Sender: TObject);
begin
 Close;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if CloseDLL.Enabled then CloseDLLClick(self);
end;

procedure TMainForm.LoadBtnClick(Sender: TObject);
begin
 MaDLL := TRDL.Create(NomRessource);
 if not MaDLL.Linked then
  begin
   ConsoleMemo.Lines.Add('> Erreur d''extraction/liaison de la DLL');
   raise Exception.Create('Erreur lors de l''extraction ou de la liaison de la DLL.');
   MaDLL.Free;
  end;

 ConsoleMemo.Lines.Add('> DLL loaded');
 if not MaDLL.AddProcName('MakeABeep') then ConsoleMemo.Lines.Add('> Error: procedure "MakeABeep" non trouvée.')
  else ConsoleMemo.Lines.Add('> Procedure "MakeABeep" loaded.');
 if not MaDLL.AddProcName('ShowAMessage') then ConsoleMemo.Lines.Add('> Error: procedure "ShowAMessage" non trouvée.')
  else ConsoleMemo.Lines.Add('> Procedure "ShowAMessage" loaded.');
 LoadBtn.Enabled := False;
 CloseDLL.Enabled := True;
 ClientHeight := 321;
end;

procedure TMainForm.CloseDLLClick(Sender: TObject);
begin
 MaDLL.Free;
 ConsoleMemo.Lines.Add('> DLL unloaded');
 ConsoleMemo.Lines.Add('');
 LoadBtn.Enabled := True;
 CloseDLL.Enabled := False;
 ClientHeight := 201;
end;

procedure TMainForm.MessageBoxClick(Sender: TObject);
begin
 ParamEdit.Enabled := MessageBox.Checked;
end;

procedure TMainForm.ExecuteBtnClick(Sender: TObject);
begin
 case BeepBox.Checked of
  False: TProcedureAvecParametre(MaDLL.GetFunction('ShowAMessage'))(PChar(ParamEdit.Text));
  True: TProcedureSansParametre(MaDLL.GetFunction('MakeABeep'));
 end;

 case BeepBox.Checked of
  False: ConsoleMemo.Lines.Add('> Procedure "ShowAMessage" executed.');
  True: ConsoleMemo.Lines.Add('> Procedure "MakeABeep" executed.');
 end;
end;

end.
