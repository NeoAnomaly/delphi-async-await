unit System.Threading.AsynAwait;

interface

uses
  System.SysUtils;

type
  IAwaitable = interface
    procedure Await(const AwaitProc: TProc); overload;
    procedure Await(const AwaitCatchProc: TProc<Exception>); overload;
  end;

  function Async(const AsyncProc: TProc): IAwaitable;

implementation

uses
  System.Classes,
  System.Threading;

type
  TAwaitable = class(TInterfacedObject, IAwaitable)
  private
    fAsyncProc: TProc;

    //procedure GenericAwait<T:IInterface>(const AwaitProc: T);
    procedure InternalAwait(const AwaitProc: TProc; const AwaitCatchProc: TProc<Exception>);
  public
    constructor Create(const AsyncProc: TProc);
    procedure Await(const AwaitProc: TProc); overload;
    procedure Await(const AwaitCatchProc: TProc<Exception>); overload;
  end;

{ TAwait }

constructor TAwaitable.Create(const AsyncProc: TProc);
begin
  fAsyncProc := AsyncProc;
end;

procedure TAwaitable.InternalAwait(const AwaitProc: TProc; const AwaitCatchProc: TProc<Exception>);
var
  selfRef: IAwaitable;
begin
  selfRef := Self;

  TTask.Run(
    procedure
    var
      awaitable: IAwaitable;
      exceptionInstance: TObject;
    begin
      awaitable := selfRef;
      try
        fAsyncProc();
      except
        exceptionInstance := TObject(AcquireExceptionObject);
      end;

      Assert(Assigned(AwaitProc) xor Assigned(AwaitCatchProc));

      if Assigned(AwaitProc) then
      begin
        TThread.Queue(nil, procedure begin AwaitProc(); end);
      end;

      if Assigned(AwaitCatchProc) then
      begin
        TThread.Queue(
          nil,
          procedure
          begin
            try
              AwaitCatchProc(exceptionInstance as Exception);
            finally
              if Assigned(exceptionInstance) then
                exceptionInstance.Free;
            end
          end
        );
      end;
    end
  );
end;

procedure TAwaitable.Await(const AwaitProc: TProc);
begin
  InternalAwait(AwaitProc, nil);
end;

procedure TAwaitable.Await(const AwaitCatchProc: TProc<Exception>);
begin
  InternalAwait(nil, AwaitCatchProc);
end;

function Async(const AsyncProc: TProc): IAwaitable;
begin
  Result := TAwaitable.Create(AsyncProc);
end;

end.
