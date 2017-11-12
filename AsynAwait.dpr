program AsynAwait;

uses
  Vcl.Forms,
  formMain in 'src\formMain.pas' {Form1},
  System.Threading.AsynAwait in 'src\System.Threading.AsynAwait.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
