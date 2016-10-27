
{*****************************************}
{                                         }
{             FastReport v2.3             }
{          Insert fields dialog           }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit LR_IFlds;

interface

{$I LR_Vers.inc}

uses
  Classes, SysUtils, LResources,
  Forms, Controls, Graphics, Dialogs,
  Buttons, StdCtrls, ButtonPanel, ComCtrls, ExtCtrls,

  LR_DBRel, TreeFilterEdit;

type

  { TfrInsertFieldsForm }

  TfrInsertFieldsForm = class(TForm)
    BandCB: TCheckBox;
    btnCancel: TToolButton;
    btnConfirm: TToolButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    HeaderCB: TCheckBox;
    HorzRB: TRadioButton;
    ImgDataset: TImageList;
    ImTool: TImageList;
    Label1: TLabel;
    PRight: TPanel;
    PLeft: TPanel;
    Splitter1: TSplitter;
    ToolButton7: TToolButton;
    ToolVar: TToolBar;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeDB: TTreeView;
    VertRB: TRadioButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeDBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DataSet: TfrTDataSet;
    procedure FillValCombo;
  end;

var
  frInsertFieldsForm: TfrInsertFieldsForm;

implementation

{$R *.lfm}

uses LR_Class, LR_Const, LR_Utils, DB;

procedure TfrInsertFieldsForm.FormShow(Sender: TObject);
begin
  FillValCombo;
end;

procedure TfrInsertFieldsForm.btnConfirmClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TfrInsertFieldsForm.btnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrInsertFieldsForm.FillValCombo;
var  Lst: TStringList;
   s : TStringList;
  i  : Integer = 0;
  x  : Integer = 0;
  ts : TStringList;
  z  : Integer = 0;
  v  : Integer = 0;
  c   : String;
begin
  DataSet := nil;
  Lst := TStringList.Create;
  try
    if CurReport.DataType = dtDataSet then
      frGetComponents(CurReport.Owner, TDataSet, Lst, nil)
    else
      frGetComponents(CurReport.Owner, TDataSource, Lst, nil);

    with TreeDB.Items do
    begin
      Clear;
      AddFirst(nil,'Conjunto de datos');  //Nodo principal
      Item[0].ImageIndex:= 0;    // Imagen del nodo
      if Lst.Count > 0 then begin
         for i := 0 to Pred(Lst.Count) do // Nodos hijos
           AddChildFirst(Item[0],Lst.Strings[i]);
         {Se agregan los campos o filas a cada dataset}
         for i := 0 to Pred(Item[0].Count) do begin
           with Item[0] do begin
              Items[i].ImageIndex:= 1;
              DataSet := frGetDataSet(Items[i].Text);
              if Assigned(DataSet) then begin
                try
                  if DataSet.FieldCount = 0 then
                      DataSet.Opening;

                  for x := 0 to Pred(DataSet.FieldCount) do begin
                    AddChild(Items[i],DataSet.FieldDefs[x].Name);
                    case Dataset.FieldDefs[x].DataType of
                      ftBoolean : z := 8;
                      ftAutoInc : z := 2;
                      ftFloat   : z := 13;
                      ftCurrency: z := 11;
                      ftDate    : z := 7;
                      ftTime,ftDateTime,ftTimeStamp   : z := 6;
                      ftMemo,ftBytes,ftFmtMemo,ftOraBlob,ftBlob : z := 9;
                      ftGraphic                                 : z := 10;
                      ftInteger                                 : z := 5;
                    else
                      z := 4;
                    end;
                    Items[i].Items[x].ImageIndex:= z;
                  end;

                  if DataSet.Active then
                     DataSet.ForceClose;
                except
                end;
              end;
            end;
         end;
      end;
    end;
  finally
    Lst.Free;
  end;
end;

procedure TfrInsertFieldsForm.FormCreate(Sender: TObject);
begin
  Caption             := sInsertFieldsFormCapt;
  Label1.Caption      := sInsertFieldsFormAviableDSet;
  GroupBox1.Caption   := sInsertFieldsFormPlace;
  HorzRB.Caption      := sInsertFieldsFormHorz;
  VertRB.Caption      := sInsertFieldsFormVert;
  HeaderCB.Caption    := sInsertFieldsFormHeader;
  BandCB.Caption      := sInsertFieldsFormBand;
  btnConfirm.Hint    := sOk;
  btnCancel.Hint     := sCancel;
end;

procedure TfrInsertFieldsForm.TreeDBClick(Sender: TObject);
begin
  with TreeDB do
  begin
    if Selected.Level > 1 then
       DataSet := frGetDataSet(Selected.Parent.Text)
    else
      DataSet := Nil;
  end;
end;

end.

