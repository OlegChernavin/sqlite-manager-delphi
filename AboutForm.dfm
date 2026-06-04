object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  Caption = 'About SQLite Manager'
  ClientHeight = 350
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = 4144959
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 80
      Top = 20
      Width = 360
      Height = 40
      Caption = 'SQLite Manager'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 80
    Width = 450
    Height = 220
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object imgLogo: TImage
      Left = 20
      Top = 20
      Width = 48
      Height = 48
      Stretch = True
    end
    object lblVersion: TLabel
      Left = 80
      Top = 20
      Width = 350
      Height = 25
      Caption = 'Version: 1.0.0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object lblDescription: TLabel
      Left = 80
      Top = 50
      Width = 350
      Height = 30
      Caption = 'A standalone application for managing SQLite databases.'
      WordWrap = True
    end
    object lblBasedOn: TLabel
      Left = 80
      Top = 90
      Width = 350
      Height = 30
      Caption = 'Based on the Firefox extension by lazierthanthou.'
      WordWrap = True
    end
    object lblLicense: TLabel
      Left = 80
      Top = 130
      Width = 350
      Height = 15
      Caption = 'License: MPL-1.1'
    end
    object lblGitHub: TLabel
      Left = 80
      Top = 155
      Width = 350
      Height = 30
      Caption = 'https://github.com/OlegChernavin/sqlite-manager-delphi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 300
    Width = 450
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnOK: TButton
      Left = 350
      Top = 12
      Width = 90
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
end
