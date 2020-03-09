unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.ComCtrls, UStr, Vcl.Grids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, inifiles;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    N1: TMenuItem;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    PageControl1: TPageControl;
    Оплаты: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    StringGrid1: TStringGrid;
    BitBtn6: TBitBtn;
    ProgressBar1: TProgressBar;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Label4: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Auto(stringgridn:tstringgrid);
    procedure BitBtn6Click(Sender: TObject);
    function LoadNBRBFile(Sf:string):integer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.LoadNBRBFile(Sf:string):integer;///////////////////////////////////////////////
 var
  errc:integer;
  fi,fo:textfile;
  s,s1:string;
 begin  // loading one file from NBRB
  errc:=0;
  assignfile(fi,sf);
  reset(fi);// open for read
  ReadLn(fi,s);
  if CheckBox1.Checked then // checking for first string
   begin
    if pos(edit2.Text,s)<>1 then
     errc:=errc+1;
   end;
  While not(eof(fi)) do // loading every string
   begin
    ReadLn(fi,s);
    // parse and load this string

   end;
  CloseFile(fi); // and closing file
  LoadNBRBFile:=errc;// returning result
 end;

procedure TForm1.Auto(stringgridn:tstringgrid);
 var
  x, y, w: integer;
  MaxWidth: integer;
begin
    with StringGridn do
    begin
      for x := 0 to ColCount - 1 do
      begin
        MaxWidth := 0;
        for y := 0 to RowCount - 1 do
        begin
          w := Canvas.TextWidth(Cells[x,y]);
          if w > MaxWidth then
            MaxWidth := w;
        end;
        ColWidths[x] := MaxWidth + 8;
      end;
    end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
 i:integer;
begin
OpenDialog1.InitialDir:=Edit1.Text;
 if OpenDialog1.Execute then
  begin
    Stringgrid1.Rowcount:=OpenDialog1.Files.Count;
    Stringgrid1.Cols[1]:=OpenDialog1.Files;
    for i:=0 to Stringgrid1.Rowcount-1 do
     begin
      StringGrid1.Cells[0,i]:='0';
     end;

   Auto(Stringgrid1);
  end;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
var
 i,errc:integer;
begin
  Progressbar1.Max:=Stringgrid1.RowCount-1;
  ProgressBar1.Min:=0;
  ProgressBar1.Position:=0;
  errc:=0;
  for i:=0 to Stringgrid1.RowCount-1 do
   begin
    if LoadNBRBFile(Stringgrid1.Cells[1,i])=0 then
      begin
        Stringgrid1.Cells[0,i]:='Загружен';
        Auto(Stringgrid1);
      end
    else
     begin
      Stringgrid1.Cells[0,i]:='Ошибка';
      errc:=errc+1;
      Auto(Stringgrid1);
     end;
    ProgressBar1.Position:=i;
    end;
  If errc>0 then
   begin
    ShowMessage('Обнаружены ошибки при загрузке');
   end
  else
   begin
    ShowMessage('Все файлы загружены успешно');
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if OpenDialog1.Execute then
  begin
    Edit1.Text:=ExtractFilePath(OpenDialog1.FileName);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
 var
  f:TIniFile;
  s:string;
begin
 Timer1Timer(Form1 as TObject);
 f:=Tinifile.Create(extractfilepath(application.exename)+'/settings.ini');
 s:=edit1.Text;
 Edit1.Text:=f.ReadString('MAIN', 'INPUT FOLDER', s);
 s:=edit2.Text;
 Edit2.Text:=f.ReadString('MAIN', 'FIRST PATTERN', s);

 f.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  f:TIniFile;
  s:string;
begin
 f:=Tinifile.Create(extractfilepath(application.exename)+'/settings.ini');
 f.WriteString('MAIN', 'INPUT FOLDER', Edit1.Text);
 f.WriteString('MAIN', 'FIRST PATTERN', Edit2.Text);

 f.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 Label1.Caption:=datetostr(Date);
 Label2.Caption:=TimeToStr(Time);
end;

end.
