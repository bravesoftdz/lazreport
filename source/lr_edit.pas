
{*****************************************}
{                                         }
{             FastReport v2.3             }
{               Memo editor               }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit LR_Edit;

interface

{$I LR_Vers.inc}

uses
  Classes, SysUtils, LResources,
  Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls,ClipBrd,ExtCtrls,

  LCLType,LCLIntf,LCLProc, ComCtrls,
  
  LR_Class, lr_propedit, SynEdit, SynHighlighterPas;

type

  { TfrEditorForm }

  TfrEditorForm = class(TPropEditor)
    btnBigFont: TSpeedButton;
    btnWordWrap: TSpeedButton;
    ImageList1: TImageList;
    Label1: TLabel;
    M1: TMemo;
    ScriptPanel: TPanel;
    Label2: TLabel;
    MemoPanel: TPanel;
    M2: TSynEdit;
    btnScript: TSpeedButton;
    Splitter: TSplitter;
    SynPasSyn1: TSynPasSyn;
    ToolBot: TToolBar;
    Button3: TToolButton;
    Button4: TToolButton;
    Button6: TToolButton;
    ToolButton2: TToolButton;
    Button5: TToolButton;
    ToolButton5: TToolButton;
    Button1: TToolButton;
    Button2: TToolButton;
    procedure btnBigFontChangeBounds(Sender: TObject);
    procedure btnBigFontClick(Sender: TObject);
    procedure btnScriptClick(Sender: TObject);
    procedure btnWordWrapClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure M1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure M1Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    FActiveMemo: TWinControl;
    procedure InsertText(const S:string);
    function CheckScript:boolean;
  public
    function ShowEditor(AView: TfrView): TModalResult; virtual;
  end;

implementation

{$R *.lfm}

uses LR_Desgn, LR_Fmted, LR_Var, LR_Flds, LR_Const, lr_expres, strutils;

function TfrEditorForm.ShowEditor(AView: TfrView): TModalResult;
begin
  Button5.Enabled       := Assigned(AView);
  btnScript.Enabled     := Assigned(AView);
  btnBigFont.Enabled    := Assigned(AView);
  btnWordWrap.Enabled   := Assigned(AView);
  Result                := inherited ShowEditor(AView);
end;

procedure TfrEditorForm.FormShow(Sender: TObject);
begin
  {$IFDEF DebugLR}
  DebugLn('TfrEditorForm.FormShow INIT HandleAllocated=', dbgs(HandleAllocated));
  {$ENDIF}

  btnScriptClick(nil);
  btnBigFontClick(nil);
  btnWordWrapClick(nil);
  if Assigned(View) then
    begin
      M1.Lines.Text   := View.Memo.Text;
      if not M1.HandleAllocated then
        M1.SelStart  :=0;
      M1.SetFocus;
      FActiveMemo    := M1;
      btnScript.Down := (View.Script.Count>0) or (View is TfrControl);
      M2.Lines.Text  := View.Script.Text;
      Button5.Visible:= (View is TfrMemoView);
    end
  else
    begin
      Button5.Visible := false;
    end;
  M1.Font.Charset := frCharset;
  M2.Font.Charset := frCharset;

  if edtScriptFontName <> '' then
    M2.Font.Name       := edtScriptFontName;

  if edtScriptFontSize > 0 then
    M2.Font.Size       := edtScriptFontSize;

  {$IFDEF DebugLR}
  DebugLn('TfrEditorForm.FormShow END');
  {$ENDIF}
end;


procedure TfrEditorForm.Button3Click(Sender: TObject);
begin
  frVarForm := TfrVarForm.Create(Application);
  try
    if (frVarForm.ShowModal = mrOk) then
      InsertText(frVarForm.SelectedItem);
  finally
    frVarForm.Free;
  end;
  FActiveMemo.SetFocus;
end;

procedure TfrEditorForm.btnBigFontChangeBounds(Sender: TObject);
begin

end;

procedure TfrEditorForm.btnBigFontClick(Sender: TObject);
begin

end;

procedure TfrEditorForm.btnScriptClick(Sender: TObject);
begin
  ScriptPanel.Visible := btnScript.Down;
  Splitter.Visible:= btnScript.Down;
  if Splitter.Visible then
    Splitter.Top:=MemoPanel.Height+1;

  if ScriptPanel.Visible then
    M2.SetFocus
  else
    M1.SetFocus;
end;

procedure TfrEditorForm.btnWordWrapClick(Sender: TObject);
begin
   M1.WordWrap := btnWordWrap.Down;
end;

procedure TfrEditorForm.Button1Click(Sender: TObject);
begin
  ModalResult:= mrOK;
end;


procedure TfrEditorForm.Button2Click(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrEditorForm.Button6Click(Sender: TObject);
var
  lrExpresionEditorForm: TlrExpresionEditorForm;
begin
  lrExpresionEditorForm:=TlrExpresionEditorForm.Create(Application);
  try
    if lrExpresionEditorForm.ShowModal = mrOk then
      InsertText(lrExpresionEditorForm.ResultExpresion);
  finally
    lrExpresionEditorForm.Free;
  end;
end;

procedure TfrEditorForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose := CheckScript;
    if CanClose then
    begin
      frDesigner.BeforeChange;
      M1.WordWrap := False;
      if Assigned(View) then
      begin
        View.Memo.Text := M1.Text;
        View.Script.Text := M2.Text;
      end;
    end
    else
      ModalResult:=mrNone;
  end;
end;

procedure TfrEditorForm.M1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then Button3Click(Self);
  if Key = vk_Escape then ModalResult := mrCancel;
end;

procedure TfrEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Chr(Key) = 'F') and (ssCtrl in Shift) and Button5.Visible then
  begin
    Button5Click(nil);
    Key := 0;
  end;
  if (Key = vk_Return) and (ssCtrl in Shift) then
  begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TfrEditorForm.Button4Click(Sender: TObject);
begin
  frFieldsForm := TfrFieldsForm.Create(Application);
  try
    if frFieldsForm.ShowModal = mrOk then
      InsertText(frFieldsForm.DBField);
  finally
    frFieldsForm.Free;
  end;
  FActiveMemo.SetFocus;
end;

procedure TfrEditorForm.M1Enter(Sender: TObject);
begin
  FActiveMemo := Sender as TWinControl;
end;


procedure TfrEditorForm.FormCreate(Sender: TObject);
begin
  Caption := sEditorFormCapt;
  Label1.Caption := sEditorFormMemo;
  btnScript.Hint := sEditorFormScript;
  btnBigFont.Hint:= sEditorFormBig;
  btnWordWrap.Hint:= sEditorFormWord;
  Label2.Caption := sEditorFormScr;
  Button3.Hint := sEditorFormVar;
  Button4.Hint := sEditorFormField;
  Button5.Hint := sEditorFormFormat;
  Button6.Hint := sEditorFormFunction;
  Button1.Hint := sOk;
  Button2.Hint := sCancel;

end;

procedure TfrEditorForm.Button5Click(Sender: TObject);
var
  t: TfrMemoView;
begin
  if not Assigned(View) then Exit;
  t := TfrMemoView(View);
  frFmtForm := TfrFmtForm.Create(nil);
  with frFmtForm do
  begin
    EdFormat := t.Format;
    EdFormatStr:=t.FormatStr;
    if ShowModal = mrOk then
    begin
      frDesigner.BeforeChange;
      t.Format := EdFormat;
      t.FormatStr := EdFormatStr;
    end;
  end;
  frFmtForm.Free;
end;

procedure TfrEditorForm.InsertText(const S: string);
begin
  if S<>'' then
  begin
    if FActiveMemo is TMemo then
      TMemo(FActiveMemo).SelText:='['+S+']'
    else
    if FActiveMemo is TSynEdit then
      TSynEdit(FActiveMemo).SelText:='['+S+']'
  end;
end;

function TfrEditorForm.CheckScript: boolean;
var
  sl1, sl2: TStringList;

procedure ErrorPosition(S:string);
var
  X, Y: LongInt;
begin
  if Pos('/', S) = 0 then exit;

  Y := StrToInt(Copy2SymbDel(S, '/'));
  X := StrToInt(Copy2SymbDel(S,':'));
  M2.CaretX:=X;
  M2.CaretY:=Y;
  M2.SetFocus;
end;

begin
  Result:=true;
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  try
    frInterpretator.PrepareScript(M2.Lines, sl1, sl2);
    if sl2.Count > 0 then
    begin
      ErrorPosition(Copy(sl2.Text, Length(sErrLine)+1, Length(sl2.Text)));
      ShowMessage(sl2.Text);
      Result:=false;
    end;
  finally
    sl1.Free;
    sl2.Free;
  end;
end;

end.

