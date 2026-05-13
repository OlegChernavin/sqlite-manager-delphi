object frmRowEdit: TfrmRowEdit
  Left = 0
  Top = 0
  Caption = 'Edit Record'
  ClientHeight = 550
  ClientWidth = 700
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
    Width = 700
    Height = 500
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 8
    Padding.Top = 8
    TabOrder = 0
    ExplicitTop = 40
    ExplicitHeight = 460
    object scrFields: TScrollBox
      Left = 8
      Top = 8
      Width = 692
      Height = 492
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 0
      OnMouseWheelDown = scrFieldsMouseWheelDown
      OnMouseWheelUp = scrFieldsMouseWheelUp
      ExplicitLeft = 0
      ExplicitTop = -6
      ExplicitWidth = 700
      ExplicitHeight = 500
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 500
    Width = 700
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      700
      50)
    object btnCancel: TButton
      Left = 600
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
      Left = 500
      Top = 12
      Width = 90
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
