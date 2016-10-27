
{*****************************************}
{                                         }
{             FastReport v2.3             }
{            Variables editor             }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit LR_Vared;

interface

{$I LR_Vers.inc}

uses
  Classes, SysUtils, LResources,
  Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls, ButtonPanel, ComCtrls,

  LR_Class,LR_Const;

type

  { TfrVaredForm }

  TfrVaredForm = class(TForm)
    ImTool: TImageList;
    Memo1: TMemo;
    Label1: TLabel;
    ToolBar1: TToolBar;
    btnConfirm: TToolButton;
    btnCancel: TToolButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Doc: TfrReport;
  end;

var
  frVaredForm: TfrVaredForm;

implementation

{$R *.lfm}

procedure TfrVaredForm.FormActivate(Sender: TObject);
begin
  Memo1.Lines.Assign(Doc.Variables);
end;

procedure TfrVaredForm.btnConfirmClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TfrVaredForm.btnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrVaredForm.FormCreate(Sender: TObject);
begin
  Caption := sVaredFormCapt;
  Label1.Caption := sVaredFormCat;
  btnConfirm.Hint    := sOk;
  btnCancel.Hint     := sCancel;
end;

end.

