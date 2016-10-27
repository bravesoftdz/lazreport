
{*****************************************}
{                                         }
{             FastReport v2.3             }
{        'Values' property editor         }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit LR_Ev_ed;

interface

{$I LR_Vers.inc}

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ExtCtrls, ButtonPanel, ComCtrls, CustomDrawnControls, LR_Class,
  TreeFilterEdit,GraphType;

type

  { TfrEvForm }

  TfrEvForm = class(TForm)
    ImTool: TImageList;
    ImgDataset: TImageList;
    ImgVars: TImageList;
    Label2: TLabel;
    Edit1: TMemo;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    PRight: TPanel;
    PLeft: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnCategory: TToolButton;
    btnEdit: TToolButton;
    btnDelete: TToolButton;
    btnList: TToolButton;
    btnVar: TToolButton;
    ToolButton4: TToolButton;
    btnConfirm: TToolButton;
    btnCancel: TToolButton;
    ToolButton7: TToolButton;
    ToolVar: TToolBar;
    TreeDB: TTreeView;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeFilterEdit2: TTreeFilterEdit;
    TreeFilterEdit3: TTreeFilterEdit;
    TreeFilterEdit4: TTreeFilterEdit;
    TreeVars: TTreeView;
    Label1: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    TreeVarsPers: TTreeView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnCategoryClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeDBDblClick(Sender: TObject);
    procedure TreeVarsClick(Sender: TObject);
    procedure TreeVarsDblClick(Sender: TObject);
    procedure TreeVarsPersClick(Sender: TObject);
    procedure TreeVarsPersEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure TreeVarsPersEditingEnd(Sender: TObject; Node: TTreeNode;
      Cancel: Boolean);
    procedure Edit1Exit(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function CurVar: String;
    function CurVal: String;
    function CurDataSet: String;
    procedure FillVarCombo;
    procedure FillValCombo;
    procedure ShowVarValue(Value: String);
    procedure PostVal;
    procedure SetValExpression;
    procedure CheckForExpr;
  public
    { Public declarations }
    Doc: TfrReport;
    Str: TMemoryStream;
    Sl: TStringList;
    procedure Init;
    procedure RefreshVarList(Memo: TStrings);
    procedure RefreshVarTree;
    procedure CancelChanges;
  end;


function ShowEvEditor(Component: TfrReport): Boolean;

implementation

{$R *.lfm}

uses LR_Vared, LR_Const, LR_Utils, LR_DBRel, DB;

var
  SMemo: TStringList;
  VarClipbd: TMemoryStream;
  nCountCat : Integer = 0;
  nCountVar : Integer = 0;

function ShowEvEditor(Component: TfrReport): Boolean;
begin
  Result := False;
  with TfrEvForm.Create(nil) do
  try
    Doc := Component;
    Str := TMemoryStream.Create;
    Sl  := TStringList.Create;
    
    Doc.Values.WriteBinaryData(Str);
    Doc.Values.Items.Sorted := False;
    Sl.Assign(Doc.Variables);
    if ShowModal = mrOk then
      Result := True
    else
      CancelChanges;
  finally
    Str.Free;
    Sl.Free;
    Free;
  end
end;

procedure TfrEvForm.Button3Click(Sender: TObject);
begin
  with TfrVaredForm.Create(nil) do
  try
    Doc := Self.Doc;
    if ShowModal = mrOk then
      RefreshVarList(Edit1.Lines);
  finally
    Free;
  end
end;

procedure TfrEvForm.Init;
begin

end;

procedure TfrEvForm.RefreshVarList(Memo: TStrings);
var
  i, j, n: Integer;
  L      : TStringList;
begin
  L := TStringList.Create;
  try
    Doc.Variables.Assign(Memo);
    with Doc.Values do
    begin
      for i := Items.Count-1 downto 0 do
        if Doc.FindVariable(Items[i]) = -1 then
        begin
          Objects[i].Free;
          Items.Delete(i);
        end;
    end;
    
    Doc.GetCategoryList(L);
    n := L.Count;
    for i := 0 to n-1 do
    begin
      Doc.GetVarList(i, L);
      for j := 0 to L.Count-1 do
        with Doc.Values do
          if FindVariable(L[j]) = nil then
            Items[AddValue] := L[j];
    end;
    FillVarCombo;
  Finally
    L.Free;
  end;
end;

procedure TfrEvForm.RefreshVarTree;
var
  i, j, n: Integer;
  L      : TStringList;
  oMemo  : TMemo;
  x      : Integer = 0;
begin
 oMemo := TMemo.Create(Self);
 with TreeVarsPers.Items do
 begin
   for x := 0 to Pred(Count) do begin
       if Item[x].Level > 0 then begin
         if Item[x].Level > 1 then begin  // Add Variable
            oMemo.Lines.AddText(' '+Item[x].Text);
         end
         else begin // Add Category
            oMemo.Lines.AddText(Item[x].Text);
         end;
       end;
   end;
 end;

  L := TStringList.Create;
  try
    Doc.Variables.Assign(oMemo.Lines);
    oMemo.Free;
    with Doc.Values do
    begin
      for i := Items.Count-1 downto 0 do
        if Doc.FindVariable(Items[i]) = -1 then
        begin
          Objects[i].Free;
          Items.Delete(i);
        end;
    end;

    Doc.GetCategoryList(L);
    n := L.Count;
    for i := 0 to n-1 do
    begin
      Doc.GetVarList(i, L);
      for j := 0 to L.Count-1 do
        with Doc.Values do
          if FindVariable(L[j]) = nil then
            Items[AddValue] := L[j];
    end;
  Finally
    L.Free;
  end;
end;

procedure TfrEvForm.CancelChanges;
begin
  Str.Position := 0;
  Doc.Values.ReadBinaryData(Str);
  Doc.Variables.Assign(Sl);
end;

function TfrEvForm.CurVar: String;
begin
  Result := '';
   with TreeVarsPers do
    begin
      if Items.Count > 0 then begin
         if Selected.Index >= 0 then begin
           if Selected.Level > 1 then
              Result := Selected.Text;
         end;
      end;
    end;
end;

function TfrEvForm.CurVal: String;
var
  node : TTreeNode;
begin
  Result := '';
  with PageControl1 do begin
    if ActivePageIndex = 0 then
      begin
        with TreeDB do begin
         if (Items.Count > 0) and (Selected.Index >= 0) then
          begin
            if Selected.Level > 1  then
               Result := Selected.Text;
          end
        end;
      end
    else
      begin
        with TreeVars do begin
         if (Items.Count > 0) and (Selected.Index >= 0) then
          begin
            if Selected.Level > 1  then
               Result := Selected.Text;
          end
        end;
      end;
  end;
end;

function TfrEvForm.CurDataSet: String;
var
   node   : TTreeNode;
begin
  Result := '';
  with PageControl1 do begin
   if ActivePageIndex = 0 then
    begin
      with TreeDB do
        begin
          if (Items.Count > 0) then
           begin
             if  Selected.Index >=0 then begin
                if Selected.Level > 1 then
                   Result := Selected.Parent.Text;
             end;
           end
        end;
    end
   else
     begin
      with TreeVars do
        begin
          if (Items.Count > 0) then
           begin
             if  Selected.Index >= 0 then
              begin
                if Selected.Level > 1 then
                   Result := Selected.Parent.Text;
               end;
           end
        end;
      end
  end;
end;

procedure TfrEvForm.FillVarCombo;
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
  with TreeVarsPers.Items do
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
              ts.Clear;
              CurReport.GetVarList(i, ts);
              x := 0;
              for x := 0 to Pred(ts.Count) do
                 AddChild(Items[i],ts.Strings[x]);
            end;
         end;
      end;
    end;
  ts.Free;
  s.Free;
end;

procedure TfrEvForm.FillValCombo;
var  Lst: TStringList;
   s : TStringList;
  i  : Integer = 0;
  x  : Integer = 0;
  ts : TStringList;
  z  : Integer = 0;
  v  : Integer = 0;
  c   : String;
  DataSet : TDataSet;
begin
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

  s := TStringList.Create;
  ts := TStringList.Create;
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
                    for x := 0 to (frSpecCount-1) do
                        AddChild(Items[i],frSpecArr[x]);
                  end;
            end;
         end;
      end;
    end;
  ts.Free;
  s.Free;
end;

procedure TfrEvForm.TreeVarsDblClick(Sender: TObject);
begin
  SetValExpression;
  PostVal;
end;

procedure TfrEvForm.TreeVarsPersClick(Sender: TObject);
begin
  try
    with TreeVarsPers do
    begin
      if Items.Count > 0 then
       begin
          if Selected.Level = 2 then
            ShowVarValue(Selected.Text)
          else
            Edit1.Text:= '';
        end
      else
        Edit1.Text:= '';
    end;
    CheckForExpr;
  Except on E : Exception do
     begin
       MessageDlg(E.Message,mtError,[mbOK],0);
     end;
  end;
end;
procedure TfrEvForm.TreeVarsPersEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
  if Node.Level = 0 then begin
    AllowEdit:= False;
  end;
end;

procedure TfrEvForm.TreeVarsPersEditingEnd(Sender: TObject; Node: TTreeNode;
  Cancel: Boolean);
var
  oMemo : TMemo;
  x : Integer = 0;
begin
   if Cancel = False then
     RefreshVarTree;
end;


procedure TfrEvForm.FormShow(Sender: TObject);
begin
  FillVarCombo;
  FillValCombo;
  CheckForExpr;
end;

procedure TfrEvForm.TreeDBDblClick(Sender: TObject);
begin
  SetValExpression;
  PostVal;
end;

procedure TfrEvForm.TreeVarsClick(Sender: TObject);
begin
  CheckForExpr;
end;

procedure TfrEvForm.btnConfirmClick(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

procedure TfrEvForm.btnCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TfrEvForm.btnCategoryClick(Sender: TObject);
var
  cNode: String;
  obj  : TToolButton;
  oNode: TTreeNode;
begin
  try
    obj := (Sender AS TToolButton);

    with TreeVarsPers.Items do
    begin
      case obj.Tag of
       1 :  // Add Category
       begin
         nCountCat     := nCountCat+1;
         cNode         := sVarFormCapNew+' '+sVarFormCapCat+inttostr(nCountCat);
         AddChild(Item[0],cNode);
         oNode         := FindNodeWithText(cNode);
         oNode.ImageIndex:= 1;
         oNode.Selected:= True;
         oNode.EditText;
         oNode.Focused:= True;
       end;
       2 :  // Add Variable
       begin
         nCountVar     := nCountVar+1;
         cNode         := sVarFormCapNew+' '+sVarFormCapVar+inttostr(nCountVar);
         if TreeVarsPers.Selected.Index >= 0 then begin
           oNode         := FindNodeWithText(TreeVarsPers.Selected.Text);
           if  oNode.Level = 1 then begin
             AddChild(oNode,cNode);
             oNode         := FindNodeWithText(cNode);
             oNode.Selected:= True;
             TreeVarsPersClick(Nil);
             oNode.EditText;
             oNode.Focused:= True;
           end
           else if oNode.Level > 1 then begin
              oNode := oNode.Parent;
              AddChild(oNode,cNode);
              oNode         := FindNodeWithText(cNode);
              oNode.Selected:= True;
              TreeVarsPersClick(Nil);
              oNode.EditText;
              oNode.Focused := True;
           end
           else
             nCountVar := nCountVar -1;
         end
         else if Count > 1  then begin
          oNode   := Item[Count-1];
          if oNode.Level > 1 then
              oNode := oNode.Parent;
          oNode.Selected:= True;
          AddChild(oNode,cNode);
          oNode         := FindNodeWithText(cNode);
          oNode.Selected:= True;
          TreeVarsPersClick(Nil);
          oNode.EditText;
          oNode.Focused:= True;
         end
         else
           nCountVar := nCountVar -1;
       end;
       3 : // Adit Node;
       begin
         if TreeVarsPers.Selected.Index >= 0 then begin
           oNode         := FindNodeWithText(TreeVarsPers.Selected.Text);
           if  oNode.Level >= 1 then begin
              oNode.EditText;
              oNode.Focused:= True;
           end;
         end;
       end;
       4 : // Delete Node
         if TreeVarsPers.Selected.Index >= 0 then begin
           oNode         := FindNodeWithText(TreeVarsPers.Selected.Text);
           if  oNode.Level >= 1 then begin
              oNode.Delete;
              if oNode.Deleting then
                RefreshVarTree;
           end;
         end;
      end;
    end;
    CheckForExpr;
  except on E : Exception do
    MessageDlg(E.Message,mtError,[mbOK],0);
  end;
end;

procedure TfrEvForm.ShowVarValue(Value: String);
var
    frValue: TfrValue;
    c : String = '';
    oNode : TTreeNode;
begin
  if Value = '' then
     Exit;
  try
    frValue  := Doc.Values.FindVariable(Value);

    if frValue = nil then
      Edit1.Text:= ''
    else
    begin
      with frValue do
        case Typ of
          vtNotAssigned: begin
           c := '';
           with TreeDB do begin
            if Selected.Index >= 0 then
               Selected.Selected:= False;
           end;

            with TreeVars do begin
            if Selected.Index >= 0 then
               Selected.Selected:= False;
           end;

          end;
          vtDBField: begin
            PageControl1.ActivePageIndex:= 0;
            c               := Field;
            if (DataSet <> '') AND (c <> '') then begin
              c               := DataSet +'.'+ c;
              oNode           := TreeDB.Items.FindNodeWithText(DataSet);
              oNode.Selected  := True;
              oNode           := oNode.FindNode(Field);
              oNode.Selected  := True;
            end;
          end;
          vtFRVar: begin
           PageControl1.ActivePageIndex:= 1;
           c := Field;
           if Category <> '' then begin
              oNode           := TreeVars.Items.FindNodeWithText(Category);
              oNode.Selected  := True;
              oNode.Items[OtherKind].Selected:= True;
            end;
          end;
          vtOther:
            begin
              //if OtherKind = 1 then
              PageControl1.ActivePageIndex:= 1;
              c := Field;
              if Category <> '' then begin
                oNode           := TreeVars.Items.FindNodeWithText(Category);
                oNode.Selected  := True;
                oNode.Items[OtherKind].Selected:= True;
              end;
            end;
        end;
       Edit1.Text:= c;
    end;
  except on E : Exception do
      MessageDlg(E.Message,mtError,[mbOK],0);
   end;
end;

procedure TfrEvForm.Edit1Exit(Sender: TObject);
begin
  PostVal;
end;

procedure TfrEvForm.PostVal;
var
  Val: TfrValue;
    i: Integer;
  s: String;
begin
  try
    with TreeVarsPers do begin
      if Items.Count > 0 then begin
        if Selected.Index >= 0 then begin
          Val := Doc.Values.FindVariable(CurVar);
          if Val <> nil then
            with Val do begin
              if CurVal = sNotAssigned then
               Typ := vtNotAssigned
              else if CurDataSet = sSpecVal then
               begin
                  Typ       := vtOther;
                  s         := CurVal;
                  Category  := CurDataSet;
                  for i := 0 to frSpecCount - 1 do
                    if s = frSpecArr[i] then
                     begin
                        OtherKind := i;
                        //if i = 1 then
                        Field := Edit1.Text;
                        break;
                      end;
                end
              else if CurDataSet = sFRVariables then
                begin
                  Typ     := vtFRVar;
                  Field   := CurVal;
                end
              else
                begin
                  Typ        := vtDBField;
                  DataSet    := CurDataSet;
                  Field      := CurVal;
                  OtherKind  := 0;
                end;
            end;
        end;
      end;
    end;
  Except on E : Exception do
    MessageDlg(E.Message,mtError,[mbOK],0);
  end;
end;

procedure TfrEvForm.SetValExpression;
var
c : String = '';
begin
  try
     with TreeVarsPers do begin
      if Items.Count > 0 then begin
        if Selected.Index >= 0 then begin
          if Selected.Level > 1 then begin
            with PageControl1 do
            begin
              if ActivePageIndex = 0 then begin
                with TreeDB do
                begin
                    if Selected.Level > 1 then
                      c := Selected.Parent.Text+'.'+Selected.Text;
                end;
              end
              else if ActivePageIndex =  1 then
                begin
                  with TreeVars do begin
                   if Selected.Level > 1 then
                     begin
                      if Selected.Parent.Text = sSpecVal then
                        begin
                         c:= frSpecFuncs[Selected.Index];
                         if Selected.Index = 1 then begin
                           CheckForExpr;
                           Edit1.Text:= Selected.Text;
                           Edit1.SetFocus;
                         end;
                        end
                      else
                        c :=  Selected.Text;
                     end;
                  end;
                end
              else
               c:= '';
            end;
          end;
        end;
      end;
     end;
  Except on E : Exception do begin
     c:= '';
     MessageDlg(E.Message,mtError,[mbOK],0);
    end;
  end;
  Edit1.Text:= c;
end;

procedure TfrEvForm.CheckForExpr;
var
  e : Boolean = False;
begin
  try
    with TreeVarsPers do
    begin
     if Items.Count > 0 then
       if Selected.Index >= 0 then begin
        if Selected.Level > 1 then begin
           with PageControl1 do begin
             if ActivePageIndex = 1 then
               with TreeVars do begin
                 if Items.Count > 0 then begin
                    if (Selected.Index >= 0) AND (Selected.Level > 1) then
                       e:= (CurDataSet = sSpecVal) and (CurVal = frSpecArr[1]);
                 end;
               end;
           end;
        end;
       end;
    end;
  Except on ER : Exception do begin
      e :=  False;
      MessageDlg(ER.Message,mtError,[mbOK],0);
    end;
  end;
  Edit1.Enabled:= e;
  if e then
    Edit1.Color:=  clWhite
  else
    Edit1.Color:= clBtnFace;
end;


procedure TfrEvForm.FormCreate(Sender: TObject);
begin
  Caption := sEvFormCapt;
  Label1.Caption := sEvFormVar;
  Label2.Caption := sEvFormValue;
  Label3.Caption := sEvFormExp;

  btnList.Hint       := sEvFormVars;
  btnCategory.Hint   := sVarFormCapNew+' '+sVarFormCapCat;
  btnVar.Hint        := sVarFormCapNew+' '+sVarFormCapVar;
  btnEdit.Hint       := sVarFormCapEdit;
  btnDelete.Hint     := sVarFormCapDel;
  btnConfirm.Hint    := sOk;
  btnCancel.Hint     := sCancel;
end;


initialization

  SMemo := TStringList.Create;
  VarClipbd := TMemoryStream.Create;

finalization
  SMemo.Free;
  VarClipbd.Free;
end.

