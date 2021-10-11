object MainForm: TMainForm
  Left = 223
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DLL in Resources'
  ClientHeight = 201
  ClientWidth = 523
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ProgLbl: TLabel
    Left = 391
    Top = 171
    Width = 119
    Height = 23
    Caption = 'Par Bacterius'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object ConsoleMemo: TMemo
    Left = 0
    Top = 0
    Width = 523
    Height = 161
    Align = alTop
    BevelKind = bkTile
    BorderStyle = bsNone
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '----------- Exemple d'#39'utilisation de l'#39'unite RDL '
      '-----------'
      '')
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    OnClick = ConsoleMemoClick
  end
  object LoadBtn: TButton
    Left = 8
    Top = 168
    Width = 129
    Height = 25
    Caption = 'Load DLL'
    TabOrder = 1
    OnClick = LoadBtnClick
  end
  object CloseDLL: TButton
    Left = 144
    Top = 168
    Width = 121
    Height = 25
    Caption = 'Unload DLL'
    Enabled = False
    TabOrder = 2
    OnClick = CloseDLLClick
  end
  object QuitBtn: TButton
    Left = 272
    Top = 168
    Width = 105
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = QuitBtnClick
  end
  object DLLBox: TGroupBox
    Left = 8
    Top = 200
    Width = 505
    Height = 113
    Caption = ' Procedures de la DLL '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    object ParamLbl: TLabel
      Left = 10
      Top = 87
      Width = 60
      Height = 16
      Caption = 'Message:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ParamEdit: TEdit
      Left = 80
      Top = 82
      Width = 409
      Height = 23
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Courier New'
      Font.Style = []
      MaxLength = 256
      ParentFont = False
      TabOrder = 0
    end
    object BeepBox: TRadioButton
      Left = 10
      Top = 30
      Width = 247
      Height = 20
      Caption = 'Make Beep voice'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
      OnClick = MessageBoxClick
    end
    object MessageBox: TRadioButton
      Left = 10
      Top = 54
      Width = 287
      Height = 21
      Caption = 'Show a message to ecran'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = MessageBoxClick
    end
    object ExecuteBtn: TButton
      Left = 312
      Top = 24
      Width = 177
      Height = 41
      Caption = 'Execute procedure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = ExecuteBtnClick
    end
  end
end
