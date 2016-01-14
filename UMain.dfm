object MainForm: TMainForm
  Left = 30
  Top = 39
  Width = 658
  Height = 364
  AutoSize = True
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Benbac Download Manager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 650
    Height = 41
    Align = alTop
    TabOrder = 0
    object Button2: TButton
      Left = 144
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Import'
      TabOrder = 0
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 568
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Clear'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 208
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Export'
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 344
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Resume'
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 280
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Pause'
      TabOrder = 4
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 488
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Resume All'
      TabOrder = 5
      OnClick = Button7Click
    end
    object Button8: TButton
      Left = 416
      Top = 8
      Width = 65
      Height = 25
      Caption = 'Pause All'
      TabOrder = 6
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 8
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Add'
      TabOrder = 7
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 72
      Top = 8
      Width = 57
      Height = 25
      Caption = 'Remove'
      TabOrder = 8
      OnClick = Button10Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 650
    Height = 241
    Align = alTop
    TabOrder = 1
    object ListFiles: TListView
      Left = 8
      Top = 8
      Width = 633
      Height = 217
      Columns = <
        item
          Caption = 'File name'
          Width = 300
        end
        item
          Caption = 'Status'
        end
        item
          Caption = '%'
        end
        item
          Caption = 'Received'
          Width = 70
        end
        item
          Caption = 'Resume'
          Width = 70
        end
        item
          Caption = 'Size'
        end>
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListFilesClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 288
    Width = 650
    Height = 49
    Align = alBottom
    TabOrder = 2
    object SpeedButton1: TSpeedButton
      Left = 576
      Top = 16
      Width = 23
      Height = 25
      Caption = '...'
      OnClick = SpeedButton1Click
    end
    object Label1: TLabel
      Left = 208
      Top = 24
      Width = 67
      Height = 13
      Caption = 'Download Dir:'
    end
    object EditDir: TEdit
      Left = 280
      Top = 16
      Width = 289
      Height = 21
      TabOrder = 0
    end
    object BitBtn1: TBitBtn
      Left = 608
      Top = 16
      Width = 33
      Height = 25
      Caption = 'OK'
      TabOrder = 1
      OnClick = BitBtn1Click
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 24
      Width = 89
      Height = 17
      Caption = 'Synchronous'
      TabOrder = 2
      OnClick = RadioButton2Click
    end
    object RadioButton1: TRadioButton
      Left = 8
      Top = 8
      Width = 89
      Height = 17
      Caption = 'Asynchronous'
      Checked = True
      TabOrder = 3
      TabStop = True
      OnClick = RadioButton1Click
    end
    object Button1: TButton
      Left = 98
      Top = 16
      Width = 47
      Height = 25
      Caption = 'Start'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button11: TButton
      Left = 152
      Top = 16
      Width = 49
      Height = 25
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = Button11Click
    end
  end
  object OD: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt'
    Left = 72
    Top = 264
  end
  object SD: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text Files|*.txt'
    Left = 40
    Top = 288
  end
  object IEDownload: TIEDownload
    TimeOut = 0
    Codepage = Ansi
    Method = Get
    Options = [Asynchronous, AsyncStorage, GetNewestVersion, NoWriteCache, PullData]
    UrlEncode = []
    Security.InheritHandle = False
    Range.RangeBegin = 0
    Range.RangeEnd = 0
    AdditionalHeader.Strings = (
      'Content-Type: application/x-www-form-urlencoded')
    UserAgent = 'Mozilla/4.0 (compatible; MSIE 6.0; Win32)'
    OnProgress = IEDownloadProgress
    OnComplete = IEDownloadComplete
    Left = 8
    Top = 288
  end
end
