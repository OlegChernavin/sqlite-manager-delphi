object frmSearch: TfrmSearch
  Left = 0
  Top = 0
  Caption = 'Search in Table'
  ClientHeight = 500
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object pnlContent: TPanel
    Left = 0
    Top = 0
    Width = 650
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 8
    Padding.Top = 8
    TabOrder = 0
    ExplicitTop = 6
    object scrFields: TScrollBox
      Left = 8
      Top = 8
      Width = 642
      Height = 442
      VertScrollBar.Visible = False
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      OnMouseWheelDown = scrFieldsMouseWheelDown
      OnMouseWheelUp = scrFieldsMouseWheelUp
      ExplicitLeft = 0
      ExplicitTop = 70
      ExplicitWidth = 650
      ExplicitHeight = 386
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 450
    Width = 650
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      650
      50)
    object btnCancel: TButton
      Left = 550
      Top = 12
      Width = 90
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 450
      Top = 12
      Width = 90
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Search'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
