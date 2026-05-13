object frmAIOptions: TfrmAIOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AI Integration Settings'
  ClientHeight = 520
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object lblPreset: TLabel
    Left = 20
    Top = 97
    Width = 67
    Height = 15
    Caption = 'Quick Setup:'
  end
  object lblAPIKey: TLabel
    Left = 20
    Top = 170
    Width = 43
    Height = 15
    Caption = 'API Key:'
  end
  object lblEndpoint: TLabel
    Left = 20
    Top = 205
    Width = 51
    Height = 15
    Caption = 'Endpoint:'
  end
  object lblModel: TLabel
    Left = 20
    Top = 240
    Width = 37
    Height = 15
    Caption = 'Model:'
  end
  object lblTimeout: TLabel
    Left = 20
    Top = 310
    Width = 47
    Height = 15
    Caption = 'Timeout:'
  end
  object lblMaxTokens: TLabel
    Left = 280
    Top = 310
    Width = 65
    Height = 15
    Caption = 'Max Tokens:'
  end
  object lblTemperature: TLabel
    Left = 20
    Top = 350
    Width = 69
    Height = 15
    Caption = 'Temperature:'
  end
  object lblPresetInfo: TLabel
    Left = 20
    Top = 31
    Width = 540
    Height = 30
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblProvider: TLabel
    Left = 20
    Top = 135
    Width = 47
    Height = 15
    Caption = 'Provider:'
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 580
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object lblSubtitle: TLabel
      Left = 20
      Top = 15
      Width = 433
      Height = 21
      Caption = 'Configure AI-powered SQL formatting, explanations, and more'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
  end
  object cbEnableAI: TCheckBox
    Left = 20
    Top = 67
    Width = 161
    Height = 17
    Caption = 'Enable AI Features'
    TabOrder = 1
  end
  object cbPreset: TComboBox
    Left = 180
    Top = 94
    Width = 380
    Height = 23
    Style = csDropDownList
    DropDownCount = 20
    TabOrder = 2
    OnChange = cbPresetChange
  end
  object edtAPIKey: TEdit
    Left = 180
    Top = 167
    Width = 380
    Height = 23
    TabOrder = 3
  end
  object edtEndpoint: TEdit
    Left = 180
    Top = 202
    Width = 380
    Height = 23
    TabOrder = 4
  end
  object edtModel: TEdit
    Left = 180
    Top = 237
    Width = 380
    Height = 23
    TabOrder = 5
  end
  object btnGetAPIKey: TButton
    Left = 480
    Top = 130
    Width = 80
    Height = 25
    Caption = 'Get API Key'
    TabOrder = 6
    OnClick = btnGetAPIKeyClick
  end
  object cbProvider: TComboBox
    Left = 180
    Top = 132
    Width = 180
    Height = 23
    Style = csDropDownList
    TabOrder = 7
    OnChange = cbProviderChange
  end
  object edtTimeout: TEdit
    Left = 20
    Top = 327
    Width = 120
    Height = 23
    NumbersOnly = True
    TabOrder = 8
    Text = '30000'
  end
  object edtMaxTokens: TEdit
    Left = 280
    Top = 327
    Width = 120
    Height = 23
    NumbersOnly = True
    TabOrder = 9
    Text = '1024'
  end
  object edtTemperature: TEdit
    Left = 20
    Top = 367
    Width = 120
    Height = 23
    NumbersOnly = True
    TabOrder = 10
    Text = '3'
  end
  object btnTestConnection: TButton
    Left = 20
    Top = 405
    Width = 140
    Height = 28
    Caption = 'Test Connection'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = btnTestConnectionClick
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 460
    Width = 580
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 12
    object btnOK: TButton
      Left = 340
      Top = 12
      Width = 100
      Height = 28
      Caption = 'OK'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
    end
    object btnCancel: TButton
      Left = 446
      Top = 12
      Width = 100
      Height = 28
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
    end
  end
  object memLog: TMemo
    Left = 280
    Top = 405
    Width = 280
    Height = 50
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 13
    WantReturns = False
    OnKeyDown = memLogKeyDown
  end
  object udTemperature: TUpDown
    Left = 140
    Top = 367
    Width = 17
    Height = 23
    Associate = edtTemperature
    Max = 20
    Position = 3
    TabOrder = 14
  end
end
