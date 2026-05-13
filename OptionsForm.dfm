object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  Caption = 'Options'
  ClientHeight = 400
  ClientWidth = 500
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
    Width = 500
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblTitle: TLabel
      Left = 0
      Top = 0
      Width = 500
      Height = 50
      Align = alClient
      Caption = 'Options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnlContent: TPanel
    Left = 0
    Top = 50
    Width = 500
    Height = 300
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pcOptions: TPageControl
      Left = 0
      Top = 0
      Width = 500
      Height = 300
      ActivePage = tsGeneral
      Align = alClient
      TabOrder = 0
      TabPosition = tpLeft
      object tsGeneral: TTabSheet
        Caption = 'General'
        object chkConfirmDrop: TCheckBox
          Left = 10
          Top = 10
          Width = 250
          Height = 25
          Caption = 'Confirm before DROP operations'
          TabOrder = 0
        end
        object chkConfirmDelete: TCheckBox
          Left = 10
          Top = 40
          Width = 250
          Height = 25
          Caption = 'Confirm before DELETE operations'
          TabOrder = 1
        end
        object chkReconnectLastDb: TCheckBox
          Left = 10
          Top = 70
          Width = 250
          Height = 25
          Caption = 'Reconnect to last database on startup'
          TabOrder = 2
        end
        object lblMaxRecent: TLabel
          Left = 10
          Top = 110
          Width = 150
          Height = 15
          Caption = 'Maximum Recent Databases:'
        end
        object edtMaxRecent: TEdit
          Left = 10
          Top = 130
          Width = 100
          Height = 23
          MaxLength = 2
          TabOrder = 3
          Text = '10'
        end
      end
      object tsDisplay: TTabSheet
        Caption = 'Display'
        ImageIndex = 1
        object lblDefaultLimit: TLabel
          Left = 10
          Top = 10
          Width = 100
          Height = 15
          Caption = 'Default Row Limit:'
        end
        object edtDefaultLimit: TEdit
          Left = 10
          Top = 30
          Width = 100
          Height = 23
          TabOrder = 0
          Text = '100'
        end
        object chkShowRowNumbers: TCheckBox
          Left = 10
          Top = 70
          Width = 200
          Height = 25
          Caption = 'Show row numbers'
          TabOrder = 1
        end
        object chkHighlightSql: TCheckBox
          Left = 10
          Top = 100
          Width = 200
          Height = 25
          Caption = 'Highlight SQL keywords'
          TabOrder = 2
        end
      end
      object tsImportExport: TTabSheet
        Caption = 'Import/Export'
        ImageIndex = 2
        object lblCSVDelimiter: TLabel
          Left = 10
          Top = 10
          Width = 80
          Height = 15
          Caption = 'CSV Delimiter:'
        end
        object cbCSVDelimiter: TComboBox
          Left = 10
          Top = 30
          Width = 150
          Style = csDropDownList
          ItemHeight = 15
          TabOrder = 0
          Items.Strings = (
            'Comma (,)'
            'Semicolon (;)'
            'Tab'
            'Pipe (|)')
        end
        object chkCSVHeaders: TCheckBox
          Left = 10
          Top = 70
          Width = 250
          Height = 25
          Caption = 'Include column headers in CSV'
          TabOrder = 1
        end
        object lblBlobDisplay: TLabel
          Left = 10
          Top = 110
          Width = 80
          Height = 15
          Caption = 'BLOB Display:'
        end
        object cbBlobDisplay: TComboBox
          Left = 10
          Top = 130
          Width = 150
          Style = csDropDownList
          ItemHeight = 15
          TabOrder = 2
          Items.Strings = (
            'Show as HEX'
            'Show as Base64'
            'Show size only')
        end
      end
      object tsAI: TTabSheet
        Caption = 'AI Integration'
        ImageIndex = 3
        object lblAIStatus: TLabel
          Left = 20
          Top = 20
          Width = 200
          Height = 15
          Caption = 'AI Status: Not configured'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnAIOptions: TButton
          Left = 20
          Top = 50
          Width = 200
          Height = 35
          Caption = 'Configure AI Settings...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = btnAIOptionsClick
        end
      end
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 350
    Width = 500
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnCancel: TButton
      Left = 400
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 300
      Top = 12
      Width = 90
      Height = 25
      Caption = 'Save'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnOKClick
    end
  end
end
