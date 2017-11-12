unit formMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Threading, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    mmoLog: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure Log(const Msg: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.Threading.AsynAwait;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  Log(Format('Message from GUI thread. ThreadId: %d', [TThread.Current.ThreadID]));

  Async(
    procedure
    begin
      Log(Format('Start long operation. ThreadId: %d', [TThread.Current.ThreadID]));

      Sleep(1000);

      Log(Format('End long operation. ThreadId: %d', [TThread.Current.ThreadID]));
    end
  ).Await(
    procedure
    begin
      Log(Format('Message from await proc. ThreadId: %d', [TThread.Current.ThreadID]));
    end
  );

  ///
  ///
  ///
  Async(
    procedure
    begin
      Log(Format('Start operation with exception. ThreadId: %d', [TThread.Current.ThreadID]));

      raise Exception.Create('Error Message');
    end
  ).Await(
    procedure(E: Exception)
    begin
      Log(Format('Message from await proc. Exception message: %s. ThreadId: %d', [E.ToString, TThread.Current.ThreadID]));
    end
  );

  Async(
    procedure
    begin
      Log(Format('Start operation with exception handler but without exception. ThreadId: %d', [TThread.Current.ThreadID]));
    end
  ).Await(
    procedure(E: Exception)
    begin
        Log(Format('Message from await proc. No exception. ThreadId: %d', [TThread.Current.ThreadID]));
    end
  );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
end;

procedure TForm1.Log(const Msg: string);
begin
  TThread.Queue(nil, procedure begin mmoLog.Lines.Add(Format('[%s]%s', [TimeToStr(Now), Msg])); end);
end;

end.
