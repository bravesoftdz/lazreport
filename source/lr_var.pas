
{*****************************************}
{                                         }
{             FastReport v2.3             }
{             Variables form              }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit LR_Var;

interface

{$I LR_Vers.inc}

uses
  Classes, SysUtils, LResources,
  Forms, Controls, Graphics, Dialogs,
  StdCtrls,

  LCLType,LCLIntf, ExtCtrls, ComCtrls,

  LR_Const, TreeFilterEdit;

type

  { TfrVarForm }

  TfrVarForm = class(TForm)
    ImgVars: TImageList;
    Label1: TLabel;
    Panel1: TPanel;
    TreeFilterEdit5: TTreeFilterEdit;
    TreeVars: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure TreeVarsDblClick(Sender: TObject);
    procedure TreeVarsKeyDown(Sender: TObject; var Key: Word;{%H-}Shift: TShiftState
      );
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
  private
    { Private declarations }
    procedure FillValCombo;
  public
    { Public declarations }
    SelectedItem: String;
  end;

var
  frVarForm: TfrVarForm;

implementation

{$R *.lfm}

uses LR_Class;

var
  LastCategory: String;


procedure TfrVarForm.FillValCombo;
var
  s: TStringList;
  i : Integer = 0;
  x : Integer = 0;
  ts : TStringList;
  z  : Integer = 0;
  v  : Integer = 0;
begin
  s := TStringList.Create;
  ts := TStringList.Create;
  CurReport.GetCategoryList(s);
  s.Add(sSpecVal);
  s.Add(sFRVariables);
  with TreeVars.Items do
    begin
      Clear;
      AddFirst(nil,sVarFormCapt);  //Nodo principal
      Item[0].ImageIndex:= 0;    // Imagen del nodo
      if s.Count > 0 then begin
         for i := 0 to s.Count-1 do // Nodos hijos
           AddChild(Item[0],s.Strings[i]);
         {Se agregan o cargan las variables}
         for i := 0 to Pred(Item[0].Count) do begin
           with Item[0] do begin
              Items[i].ImageIndex:= 1;
             if Items[i].Text = sFRVariables then begin
                  for x := 0 to Pred(frVariables.Count) do
                    AddChild(Items[i],frVariables.Name[x]);
                end
              else if Items[i].Text = sSpecVal then begin
                    x := 0;
                    for x := 0 to (frSpecCount-1) do begin
                      if x <> 1 then
                        AddChild(Items[i],frSpecArr[x]);
                    end;
                  end
              else
                begin
                   ts.Clear;
                   CurReport.GetVarList(i, ts);
                   x := 0;
                   for x := 0 to Pred(ts.Count) do
                     AddChild(Items[i],ts.Strings[x]);
                end;
            end;
         end;
      end;
    end;
  ts.Free;
  s.Free;
end;

procedure TfrVarForm.TreeVarsDblClick(Sender: TObject);
begin
  SelectedItem:= '';
   with TreeVars do
   begin
     if Selected.Level = 2 then
     begin
       if Selected.Parent.Text <> sSpecVal then
        SelectedItem := Selected.Text
       else if Selected.Index > 0 then
          SelectedItem := frSpecFuncs[Selected.Index + 1]
        else
          SelectedItem := frSpecFuncs[0];
       ModalResult:=mrOk;
     end;
   end;
end;

procedure TfrVarForm.TreeVarsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Return then
  begin
    TreeVarsDblClick(Sender);
  end;
end;

procedure TfrVarForm.FormShow(Sender: TObject);
begin
  FillValCombo;
  TreeFilterEdit5.SetFocus;
end;

procedure TfrVarForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_Escape then
    ModalResult := mrCancel;
end;

procedure TfrVarForm.FormCreate(Sender: TObject);
begin
  Caption         := sVarFormCapt;
  Label1.Caption  := sVarFormCat;
end;

end.

