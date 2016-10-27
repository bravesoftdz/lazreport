unit lr_expres;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, ButtonPanel, ComCtrls, SynEdit, LR_Const;

type

  { TlrExpresionEditorForm }

  TlrExpresionEditorForm = class(TForm)
    BitBtn2: TToolButton;
    BitBtn3: TToolButton;
    BitBtn1: TToolButton;
    btnCancel: TToolButton;
    btnConfirm: TToolButton;
    ImageList1: TImageList;
    Label1: TLabel;
    Memo1: TSynEdit;
    ToolBot: TToolBar;
    ToolBot1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddWord(S:string);
  public
    function ResultExpresion:string;
  end; 

implementation

{$R *.lfm}

uses LR_Var, LR_Flds, lr_funct_editor_unit, lr_funct_editor_unit1, LR_Class;

{ TlrExpresionEditorForm }

procedure TlrExpresionEditorForm.Button13Click(Sender: TObject);
begin
  AddWord((Sender as TToolButton).Caption);
end;

procedure TlrExpresionEditorForm.btnConfirmClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TlrExpresionEditorForm.btnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TlrExpresionEditorForm.FormCreate(Sender: TObject);
begin
  Caption := sInsertExpression;
  Label1.Caption := sVar2;
  BitBtn3.Hint := sDBField;
  BitBtn2.Hint := sVariable;
  BitBtn1.Hint := sEditorFormFunction;
  btnConfirm.Hint := sOk;
  btnCancel.Hint  := sCancel;
end;

procedure TlrExpresionEditorForm.BitBtn2Click(Sender: TObject);
begin
  frVarForm := TfrVarForm.Create(nil);
  try
    with frVarForm do
    if ShowModal = mrOk then
    begin
      if SelectedItem <> '' then
        AddWord('[' + SelectedItem + ']');
    end;
  finally
    frVarForm.Free;
  end;
end;

procedure TlrExpresionEditorForm.BitBtn1Click(Sender: TObject);
var
  LR_FunctEditorForm: TLR_FunctEditorForm;
  FD:TfrFunctionDescription;
  LR_FunctEditor1Form: TLR_FunctEditor1Form;
begin
  FD:=nil;
  LR_FunctEditorForm:=TLR_FunctEditorForm.Create(Application);
  try
    if LR_FunctEditorForm.ShowModal = mrOk then
      FD:=LR_FunctEditorForm.CurentFunctionDescription;
  finally
    LR_FunctEditorForm.Free;
  end;
  if Assigned(FD) then
  begin
    LR_FunctEditor1Form:=TLR_FunctEditor1Form.Create(Application);
    try
      LR_FunctEditor1Form.SetFunctionDescription(FD);
      if LR_FunctEditor1Form.ShowModal = mrOk then
        AddWord(LR_FunctEditor1Form.ResultText);
    finally
      LR_FunctEditor1Form.Free;
    end;
  end;
end;

procedure TlrExpresionEditorForm.BitBtn3Click(Sender: TObject);
begin
  frFieldsForm := TfrFieldsForm.Create(nil);
  try
    with frFieldsForm do
    begin
      if ShowModal = mrOk then
      begin
        if DBField <> '' then
          AddWord('[' + DBField + ']');
      end;
    end;
  finally
    frFieldsForm.Free;
  end;
end;

procedure TlrExpresionEditorForm.AddWord(S: string);
begin
  if Memo1.Lines.Count = 0 then
    Memo1.Lines.Add(S)
  else
  begin
    Memo1.Lines[Memo1.Lines.Count-1]:=Memo1.Lines[Memo1.Lines.Count-1] + S;
  end;
  Memo1.CaretY:=Memo1.Lines.Count-1;
  Memo1.CaretX:=Length(Memo1.Lines[Memo1.Lines.Count-1])+1;
  Memo1.SetFocus;
end;

function TlrExpresionEditorForm.ResultExpresion: string;
begin
  Result:=Trim(Memo1.Text);
end;

end.

