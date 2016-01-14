unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  urlmon,  StdCtrls, wininet, ComCtrls, IEDownload, ExtCtrls, Buttons,
  FileCtrl, StrUtils;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Panel2: TPanel;
    ListFiles: TListView;
    Button9: TButton;
    Button10: TButton;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    EditDir: TEdit;
    BitBtn1: TBitBtn;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    Button1: TButton;
    OD: TOpenDialog;
    SD: TSaveDialog;
    IEDownload: TIEDownload;
    Button11: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure IEDownloadProgress(Sender: TBSCB; ulProgress, ulProgressMax,
      ulStatusCode: Cardinal; szStatusText: PWideChar; ElapsedTime, Speed,
      EstimatedTime: string);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure IEDownloadComplete(Sender: TBSCB; Stream: TStream;
      Result: HRESULT);
    procedure ListFilesClick(Sender: TObject);
    procedure Button11Click(Sender: TObject);
  end;

var
  MainForm: TMainForm;
  strListFiles: TStringList;
  DefaultDir: string;
  index : integer = -1;

implementation

{$R *.DFM}

function ThereIsNoSlash(URL: string):boolean;
begin
  result := Pos('\',URL) = 0;
  if not result then
    ShowMessage('Invalid URL: '+ URL)
end;

function ThereIsNoSlashAtEnd(URL: string):boolean;
begin
  result := URL[length(URL)] <> '/';
end;

function WheneThereIsSlah(URL: string):string;
var
  Filename: string;
begin
  Filename := URL;
  repeat
    if not ThereIsNoSlashAtEnd(Filename) then
      if not InputQuery('Giviang a file name', 'Please give a file name to save the current url  ' + #13 + Filename ,Filename) then
        begin
          Result := '';
          exit;
        end;
  until ThereIsNoSlashAtEnd(Filename);
  result := Filename;
end;

function Encode(URL: string): string;
var
  I: Integer;
  Hex: string;
begin
  for I := 1 to Length(URL) do
    case URL[i] of
      ' ': result := Result + '+';
      'A'..'Z', 'a'..'z', '*', '@', '.', '_', '-',
        '0'..'9', '$', '!', '''', '(', ')':
        result := Result + URL[i];
    else
      begin
        Hex := IntToHex(ord(URL[i]), 2);
        if Length(Hex) = 2 then Result := Result + '%' + Hex else
          Result := Result + '%0' + hex;
      end;
    end;
end;

function GetFileName(URL: string):string;
var
  i, Slash: integer;
begin
  Slash := 0;
  for i:= length(URL) downto 0 do
    if URL[i] = '/' then
      begin
        Slash := i;
        break;
      end;
  result := Copy (URL, Slash + 1, Length(URL))
end;

procedure TMainForm.Button1Click(Sender: TObject);
var
  i: integer;
  strFile: string;
begin
  if ListFiles.Items.Count <> -1 then
    for i := 0 to ListFiles.Items.Count - 1 do
      if ListFiles.Items[i].SubItems[0] = '-' then
        begin
          strFile := DefaultDir + Encode(ListFiles.Items[i].Caption);
          IEDownload.Go(strListFiles.Strings[i],  strFile);
        end;
end;

procedure TMainForm.IEDownloadProgress(Sender: TBSCB; ulProgress,
  ulProgressMax, ulStatusCode: Cardinal; szStatusText: PWideChar;
  ElapsedTime, Speed, EstimatedTime: string);
var
  Size, Resume, Received, percent: Extended;
  i:integer;
begin
  if ulStatusCode = BINDSTATUS_DOWNLOADINGDATA then
    begin
      caption := inttostr(ulProgress);
      i := StrListFiles.IndexOf(Sender.Url);
      Size := ulProgressMax;
      Received := ulProgress;
      Resume := Size - Received;
      percent := round ((Received * 100) / Size);
      with ListFiles.Items[i] do
        begin
          SubItems[1] := floattostr(percent);
          SubItems[2] := floattostr(Received);
          SubItems[3] := floattostr(Resume);
          SubItems[4] := floattostr(Size);
        end;
    end;       
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  i: integer;
  ListItem: TListItem;
  URL, Filename: string;
begin
  if od.Execute then
    begin
      strListFiles.LoadFromFile(od.FileName);
      with ListFiles do
        for i := 0 to strListFiles.Count -1 do
          begin
            URL := strListFiles[i];
            if ThereIsNoSlash(URL) then
              begin
                Filename := GetFileName(URL);
                if not ThereIsNoSlashAtEnd(URL) then
                  Filename := WheneThereIsSlah(URL)
                else
                  Filename := GetFileName(URL);
                if Filename = '' then
                  exit;
                ListItem := Items.Add;
                ListItem.Caption := Filename;
                ListItem.SubItems.Add('-');
                ListItem.SubItems.Add('0');
                ListItem.SubItems.Add('0');
                ListItem.SubItems.Add('0');
                ListItem.SubItems.Add('0');
              end;
          end;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  strListFiles := TStringList.Create;
  DefaultDir := ExtractFilePath(Application.ExeName);
  if DefaultDir[length(DefaultDir)] <> '\' then
    DefaultDir := DefaultDir + '\';
  EditDir.Text := DefaultDir;
  Caption := Application.Title + ' - [' + DefaultDir + ']';
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  strListFiles.Free;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  IEDownload.Cancel;
  ListFiles.Clear;
  strListFiles.Clear;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  if ListFiles.Items.Count <> 0 then
    if SD.Execute then
      strListFiles.SaveToFile(SD.FileName);
end;

procedure TMainForm.Button5Click(Sender: TObject);
var
  URL : TBSCB;
  strFile: string;
begin
  if index <> -1 then
    begin
      URL.Url := pwidechar( strListFiles.Strings[index]);
      strFile := DefaultDir + Encode(ListFiles.Items[index].Caption);
      IEDownload.Go(strListFiles.Strings[index],  strFile);
    end;
end;

procedure TMainForm.Button6Click(Sender: TObject);
var
  URL : TBSCB;
begin
  if index <> -1 then
    begin
      URL.Url := pwidechar( strListFiles.Strings[index]);
      IEDownload.Cancel(URL);
      ListFiles.Items[index].SubItems[0] := '-';
    end;
end;

procedure TMainForm.Button7Click(Sender: TObject);
var
  i:integer;
  strFile: string;
begin
  if ListFiles.Items.Count > -1 then
    for i := 0 to ListFiles.Items.Count -1 do
      if ListFiles.Items[i].SubItems[0] = '-' then
        begin
          strFile := DefaultDir + Encode(ListFiles.Items[i].Caption);
          IEDownload.Go(strListFiles.Strings[i],  strFile);
        end;
end;

procedure TMainForm.Button8Click(Sender: TObject);
var
  i:integer;
begin
  IEDownload.Cancel;
  if ListFiles.Items.Count > -1 then
    for i := 0 to ListFiles.Items.Count -1 do
      ListFiles.Items[index].SubItems[0] := '-';
end;

procedure TMainForm.Button9Click(Sender: TObject);
var
  URL, Filename: string;
  ListItem: TListItem;
begin
  if Inputquery('Add URL','Ex: http://www.siteweb.com/file.txt',URL)then
    if ThereIsNoSlash(URL) then
      begin
        Filename := GetFileName(URL);
        if not ThereIsNoSlashAtEnd(URL) then
          Filename := WheneThereIsSlah(URL)
        else
          Filename := GetFileName(URL);
        if Filename = '' then
          exit;
        strListFiles.Add(URL);
        ListItem := ListFiles.Items.Add;
        ListItem.Caption := Filename;
        ListItem.SubItems.Add('-');
        ListItem.SubItems.Add('0');
        ListItem.SubItems.Add('0');
        ListItem.SubItems.Add('0');
        ListItem.SubItems.Add('0');
      end;
end;

procedure TMainForm.Button10Click(Sender: TObject);
begin
  if index <> -1 then
    begin
      ListFiles.Items[index].Delete;
      strListFiles.Delete(index);
    end;
end;

procedure TMainForm.RadioButton1Click(Sender: TObject);
begin
  if RadioButton1.Checked then
    IEDownload.Options :=   IEDownload.Options + [Asynchronous]
end;

procedure TMainForm.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked then
    IEDownload.Options :=   IEDownload.Options - [Asynchronous]
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('Select Directory','', Dir) then
    begin
      if Dir[length(Dir)] <> '\' then
        Dir := Dir + '\';
      EditDir.Text := Dir;
      DefaultDir := Dir;
      Caption := Application.Title + ' - [' + DefaultDir + ']';
    end;
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  Dir: string;
begin
  Dir := EditDir.Text;
  if Dir[length(Dir)] <> '\' then
    Dir := Dir + '\';
  EditDir.Text := Dir;
  DefaultDir := Dir;
  Caption := Application.Title + ' - [' + DefaultDir + ']';
end;

procedure TMainForm.IEDownloadComplete(Sender: TBSCB; Stream: TStream;
  Result: HRESULT);
begin
  if Result = S_OK then
    ListFiles.Items[strListFiles.IndexOf(Sender.Url)].SubItems[0] := '+'
  else
    ListFiles.Items[strListFiles.IndexOf(Sender.Url)].SubItems[0] := 'Faild'
end;

procedure TMainForm.ListFilesClick(Sender: TObject);
begin
  index := ListFiles.ItemIndex;
end;

procedure TMainForm.Button11Click(Sender: TObject);
begin
  IEDownload.Cancel;
end;

end.

