object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 324
  ClientWidth = 414
  Color = clWindow
  Constraints.MinHeight = 352
  Constraints.MinWidth = 420
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  DesignSize = (
    414
    324)
  PixelsPerInch = 96
  TextHeight = 13
  object pgcSettings: TPageControl
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 399
    Height = 277
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 7
    Margins.Bottom = 39
    ActivePage = tsIntegration
    Align = alClient
    Images = imglSettings
    MultiLine = True
    TabOrder = 0
    object tsIntegration: TTabSheet
      Caption = 'Integration'
      ImageIndex = 6
      object rgContactIcon: TRadioGroup
        Left = 6
        Top = 76
        Width = 377
        Height = 63
        Caption = 'Contact icon'
        Items.Strings = (
          'Plugin icon'
          'Current status icon')
        TabOrder = 3
      end
      object chkContactShow: TCheckBox
        Left = 14
        Top = 3
        Width = 401
        Height = 17
        Caption = 'Show contact in contact list'
        TabOrder = 0
      end
      object edtContactName: TEdit
        Left = 14
        Top = 49
        Width = 175
        Height = 21
        TabOrder = 2
        Text = 'Status Manager'
      end
      object chkContactName: TCheckBox
        Left = 14
        Top = 26
        Width = 107
        Height = 17
        Caption = 'Use custom name'
        TabOrder = 1
      end
      object chkButtonShow: TCheckBox
        Left = 14
        Top = 155
        Width = 401
        Height = 17
        Caption = 'Show button in message window'
        TabOrder = 4
      end
      object rgButtonIcon: TRadioGroup
        Left = 6
        Top = 178
        Width = 377
        Height = 63
        Caption = 'Contact icon'
        Items.Strings = (
          'Plugin icon'
          'Current status icon')
        TabOrder = 5
      end
    end
    object tsActions: TTabSheet
      Caption = 'Status List'
      ImageIndex = 5
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object chkFilterSave: TCheckBox
        Left = 14
        Top = 3
        Width = 401
        Height = 17
        Caption = 'Save filter preferences'
        TabOrder = 0
      end
      object chkCloseAfterApply: TCheckBox
        Left = 14
        Top = 26
        Width = 355
        Height = 17
        Caption = 'Automatically close window after applying status'
        TabOrder = 1
      end
    end
    object tsDatabase: TTabSheet
      Caption = 'Database'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object chkSaveStatusMyself: TCheckBox
        Left = 14
        Top = 3
        Width = 401
        Height = 17
        Caption = 'Save my X-Statuses to database'
        TabOrder = 0
      end
      object chkBackupEnabled: TCheckBox
        Left = 14
        Top = 26
        Width = 401
        Height = 17
        Caption = 'Automatically backup database'
        TabOrder = 1
        Visible = False
      end
    end
    object tsAbout: TTabSheet
      Caption = 'About'
      ImageIndex = 3
      DesignSize = (
        391
        248)
      object lblPluginName: TLabel
        Left = 14
        Top = 3
        Width = 91
        Height = 15
        Caption = 'Status Manager'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = '@Arial Unicode MS'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPluginVersion: TLabel
        Left = 288
        Top = 3
        Width = 86
        Height = 15
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Maj.Min.Rev.Bld'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = '@Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        ExplicitLeft = 333
      end
      object lblPluginDesc: TLabel
        Left = 14
        Top = 22
        Width = 359
        Height = 30
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lblPluginDesc'#13#10'_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = '@Arial Unicode MS'
        Font.Style = []
        ParentFont = False
        WordWrap = True
        ExplicitWidth = 404
      end
      object grDeveloper: TGroupBox
        Left = 6
        Top = 55
        Width = 377
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Developer'
        TabOrder = 0
        DesignSize = (
          377
          38)
        object lblAuthor: TLabel
          Left = 8
          Top = 16
          Width = 30
          Height = 13
          Caption = 'Veider'
        end
        object lblAuthorL: TLabel
          Left = 295
          Top = 16
          Width = 73
          Height = 13
          Cursor = crHandPoint
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'http://xfire.su/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitLeft = 322
        end
      end
      object grThirdParty: TGroupBox
        Left = 6
        Top = 99
        Width = 377
        Height = 62
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Third-party components'
        TabOrder = 1
        DesignSize = (
          377
          62)
        object lblTC1: TLabel
          Left = 8
          Top = 16
          Width = 174
          Height = 13
          Caption = 'Fugue Icons by Yusuke Kamiyamane'
        end
        object lblTC1L: TLabel
          Left = 205
          Top = 16
          Width = 162
          Height = 13
          Cursor = crHandPoint
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'http://p.yusukekamiyamane.com/'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ExplicitLeft = 232
        end
        object lblTC3: TLabel
          Left = 8
          Top = 38
          Width = 113
          Height = 13
          Caption = 'NativeXml by SimDesign'
        end
        object lblTC3L: TLabel
          Left = 205
          Top = 38
          Width = 162
          Height = 13
          Cursor = crHandPoint
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'http://www.simdesign.nl/xml.html'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHotLight
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
      end
    end
  end
  object btnOk: TButton
    Left = 230
    Top = 292
    Width = 85
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ImageIndex = 0
    Images = imglSettings
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 321
    Top = 292
    Width = 85
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    ImageIndex = 1
    Images = imglSettings
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object imglSettings: TImageList
    ColorDepth = cd32Bit
    Left = 568
    Top = 304
    Bitmap = {
      494C010107000800540010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      000000000000000000000000000000000000000000120000002C0303036D0404
      0481030303810202028102020282020202830303038303030383040404830505
      0582050505820303036D0000002C0000001200000009000000160000001A0000
      001A0000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A0000001A0000001A000000160000000900000006000000170000001A0000
      001A0000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A0000001A0000001700000007000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000009000000160C0C0C73EAEA
      EAFFDFDFDFFFD6D6D6FFD3D2D2FFC2C0BCFFB4B8ACFFB5BFAEFFBECBB9FFC9D8
      C7FFD7E6D6FF0C0C0C7300000016000000090D0D046916160587161605871616
      0587161605871616058716160587161605871616058716160587161605871616
      05871616058716160587161605870D0D04690303035C06060677060606770606
      0677060606770606067706060677060606770606067706060677060606770606
      067706060677060606770303035C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000012121269E6E6
      E6FFD0D0D0FFBDBDBDFFB9B9B9FFA8A8A2FF9CA293FFA1AD99FFAFBEA9FFC0CE
      BDFFD5E2D3FF1313136A00000000000000001C1C0C81F9F9E9FFF3F3E2FFF3F3
      E2FFF3F3E2FFF3F3E2FFF3F3E2FFF3F3E2FFF3F3E2FFF3F3E2FFF3F3E2FFF3F3
      E2FFF3F3E2FFF3F3E2FFF9F9E9FF1C1C0C810E0E0E74EBEBEBFFE7E7E7FFE7E7
      E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7E7FFE7E7
      E7FFE7E7E7FFEBEBEBFF0E0E0E74000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000018181865E6E6
      E6FFD0D0D0FFBDBDBDFFB9B9B9FFA8A8A2FF9DA293FFA3AC9AFFB1BDAAFFC2CE
      BEFFD7E2D4FF1919196700000000000000002424147AF4F4E4FFFFCC43FFFECB
      42FFECD286FFDADAC9FFD8D8C7FFD6D6C5FFD4D4C3FFD3D3C2FFD1D1C0FFCFCF
      BEFFCECEBDFFCDCDBCFFF4F4E4FF2424147A19191970E9E9E9FF59CE59FF63E5
      63FF63E563FFE1E1E1FFDDB159FFF5C463FFF5C463FFE1E1E1FFDD5959FFF563
      63FFF56363FFE9E9E9FF19191970000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001D1D1D66EAEA
      EAFFDFDFDFFFD6D6D6FFD3D2D2FFC3C0BCFFB8B7ADFFBABEB1FFC3CABCFFD0D8
      CAFFDEE6D9FF1F1F1F6A000000000000000027271577F5F5E6FFFFCC43FFFFEE
      88FFECD286FFF5F5EEFFF5F5EEFFD6D6C5FFF5F5EEFFF5F5EEFFD1D1C0FFF5F5
      EEFFF5F5EEFFCDCDBCFFF5F5E6FF272715771D1D1D6FEAEAEAFF5ED35EFF68EA
      68FF68EA68FFE3E3E3FFE1B65EFFFACA68FFFACA68FFE3E3E3FFE15E5EFFFA68
      68FFFA6868FFEAEAEAFF1D1D1D6F000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F0F0F334B4B
      4BB39B9B9BFF999999FF8F8F8FFF7B7B7BFF777777FF808080FF8C8C8CFF9B9B
      9BFF535353B710101036000000000000000028281775F6F6E9FFFFCC43FFFECB
      42FFECD286FFDADAC9FFD8D8C7FFDCDCCCFFD4D4C3FFD3D3C2FFD8D8C8FFCFCF
      BEFFCECEBDFFCDCDBCFFF6F6E9FF282817752121216EEDEDEDFF5CCB5CFF61D6
      61FF61D661FFE6E6E6FFD8B05CFFE5BA61FFE5BA61FFE6E6E6FFD85C5CFFE561
      61FFE56161FFEDEDEDFF2121216E000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFAAA7A2FFA1A095FFA9AB9EFFB8BCAFFFCACD
      C2FFDFE2D8FF1F1F1F6A000000000000000029291873F7F7EBFFFFCC43FFFFEE
      88FFECD286FFF7F7F1FFF7F7F1FFD6D6C5FFF7F7F1FFF7F7F1FFD1D1C0FFF7F7
      F1FFF7F7F1FFCDCDBCFFF7F7EBFF292918732222226DEFEFEFFFE9E9E9FFE9E9
      E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9E9FFE9E9
      E9FFE9E9E9FFEFEFEFFF2222226D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFAAA6A2FFA39F96FFABAA9FFFBBBCB0FFCDCD
      C4FFE2E2DAFF1F1F1F6A00000000000000002B2B1A72F8F8EEFFFFCC43FFFECB
      42FFECD286FFDADAC9FFD8D8C7FFDDDDCEFFD4D4C3FFD3D3C2FFD9D9CAFFCFCF
      BEFFCECEBDFFCDCDBCFFF8F8EEFF2B2B1A722525256CF1F1F1FF59DDB1FF63F5
      C4FF63F5C4FFECECECFFDDDDDDFFF5F5F5FFF5F5F5FFECECECFFDD59B1FFF563
      C4FFF563C4FFF1F1F1FF2525256C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFABA5A2FFA59F97FFAEAAA0FFBEBBB2FFD0CD
      C5FFE5E2DBFF1F1F1F6A00000000000000002C2C1C70F9F9F1FFFFCC43FFFFEE
      88FFECD286FFF9F9F5FFF9F9F5FFD6D6C5FFF9F9F5FFF9F9F5FFD1D1C0FFF9F9
      F5FFF9F9F5FFCDCDBCFFF9F9F1FF2C2C1C702727276BF3F3F3FF5EE1B6FF68FA
      CAFF68FACAFFEFEFEFFFE1E1E1FFFAFAFAFFFAFAFAFFEFEFEFFFE15EB6FFFA68
      CAFFFA68CAFFF3F3F3FF2727276B000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66EAEA
      EAFFDFDFDFFFD6D6D6FFD3D2D2FFC5BEBCFFBFB6B1FFC5BDB7FFD0CAC3FFDED8
      D2FFECE6E0FF1F1F1F6A00000000000000002D2D1C6EFBFBF4FFFFCC43FFFECB
      42FFECD286FFDADAC9FFD8D8C7FFDEDED0FFD4D4C3FFD3D3C2FFDADACCFFCFCF
      BEFFCECEBDFFCDCDBCFFFBFBF4FF2D2D1C6E2929296AF6F6F6FF5CD8B0FF61E5
      BAFF61E5BAFFF2F2F2FFD8D8D8FFE5E5E5FFE5E5E5FFF2F2F2FFD85CB0FFE561
      BAFFE561BAFFF6F6F6FF2929296A000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000F0F0F334B4B
      4BB39B9B9BFF999999FF8F8F8FFF7B7B7BFF777777FF808080FF8C8C8CFF9B9B
      9BFF535353B71010103600000000000000002E2E1D6DFCFCF7FFFFCC43FFFFEE
      88FFECD286FFFCFCFAFFFCFCFAFFD6D6C5FFFCFCFAFFFCFCFAFFD1D1C0FFFCFC
      FAFFFCFCFAFFCDCDBCFFFCFCF7FF2E2E1D6D2B2B2B69F8F8F8FFF5F5F5FFF5F5
      F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5F5FFF5F5
      F5FFF5F5F5FFF8F8F8FF2B2B2B69000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFACA4A3FFA99D99FFB5A8A4FFC6BAB6FFD8CC
      C9FFEDE2DFFF1F1F1F6A00000000000000002F2F1E6BFDFDF9FFFFCC43FFFECB
      42FFF5CE63FFEBD285FFE9D083FFE7CE81FFE5CC80FFE4CB7DFFE2C97BFFE0C7
      79FFDFC678FFDEC577FFFDFDF9FF2F2F1E6B2D2D2D69FAFAFAFF59B1DDFF63C4
      F5FF63C4F5FFF8F8F8FF5959DDFF6363F5FF6363F5FFF8F8F8FFB159DDFFC463
      F5FFC463F5FFFAFAFAFF2D2D2D69000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFADA4A3FFAB9C9AFFB6A8A5FFC8BAB7FFDBCC
      CAFFF0E2E0FF1F1F1F6A000000000000000030301F6AFEFEFCFFFFCC43FFFFEE
      88FFFDCA41FFFCEB85FFFBEA84FFF8C53CFFF6E57EFFF4E37CFFF3C037FFF1E0
      79FFEFDE77FFEFBC33FFFEFEFCFF30301F6A2E2E2E68FCFCFCFF5EB6E1FF68CA
      FAFF68CAFAFFFBFBFBFF5E5EE1FF6868FAFF6868FAFFFBFBFBFFB65EE1FFCA68
      FAFFCA68FAFFFCFCFCFF2E2E2E68000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66E6E6
      E6FFD0D0D0FFBDBDBDFFBAB9B9FFADA3A3FFAB9C9BFFB8A7A6FFCAB9B8FFDDCC
      CBFFF2E2E1FF1F1F1F6A000000000000000031312068FFFFFEFFFFCC43FFFECB
      42FFFDCA41FFFCC940FFFAC73EFFF8C53CFFF6C33BFFF5C239FFF3C037FFF1BE
      35FFF0BD34FFEFBC33FFFFFFFEFF3131206830303067FEFEFEFF5CB0D8FF61BA
      E5FF61BAE5FFFDFDFDFF5C5CD8FF6161E5FF6161E5FFFDFDFDFFB05CD8FFBA61
      E5FFBA61E5FFFEFEFEFF30303067000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F1F1F66EAEA
      EAFFDFDFDFFFD6D6D6FFD3D2D2FFC7BDBDFFC5B4B4FFCEBCBCFFDBC9C9FFE9D7
      D7FFF7E6E6FF1F1F1F6A000000000000000031312167FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFF3131216731313167FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF31313167000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001919194D2121
      2166212121662121216621212166212121662121216621212166212121662121
      2166212121661919194D00000000000000002525194D33332166333321663333
      2166333321663333216633332166333321663333216633332166333321663333
      21663333216633332166333321662525194D2727274D33333366333333663333
      3366333333663333336633333366333333663333336633333366333333663333
      336633333366333333662727274D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000020000000C0000
      00160000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A000000170000000C000000020000000000000000000000020000000C0000
      00160000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A000000170000000C000000020000000000000000000000020000000C0000
      00160000001A0000001A0000001A0000001A0000001A0000001A0000001A0000
      001A000000170000000C00000002000000000000000000000001000000030000
      0005000000080000000B0000000F000000120000001500000017000000190000
      001A000000170000000F00000005000000000000000000000004000000170000
      002B0007004301220080003B00AB024600C4024600C4003B00AB012200800007
      00430000002D0000001800000004000000000000000000000004000000170000
      002B000007430000228000003BAB000046C4000046C400003BAB000022800000
      07430000002D0000001800000004000000000000000000000004000000170000
      002B010900461635008D3F6300C0657500DD756A00DD634200C03517008D0901
      00460000002D0000001800000004000000000000000000000001000000050000
      000A00000010000000160000001D00000024000000290000002E160100625A03
      00CB0000002E0000001D0000000A000000000000000000000000000000000218
      004D055600BF108C07E31BBC0DF520D210FD20D210FD1BBC0DF5108C07E30556
      00BF0218004D0000000000000000000000000000000000000000000000000000
      184D000056BF07078CE30D0DBCF51010D2FD1010D2FD0D0DBCF507078CE30000
      56BF0000184D0000000000000000000000000000000000000000000000000125
      0057228403D66BBA1BF1B4E537FAE7FA48FEFAEC48FEE5B938FABA701CF18426
      03D6260200570000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000031A030046640A00C8640A
      00C80000000000000000000000000000000000000000000000000325004D0B6D
      03CD1FBD10F622D111FF21B610FF21D110FF21D110FF21D110FF21D110FF1CBB
      0EF6096D01CD0325004D000000000000000000000000000000000000254D0303
      6DCD1111BDF61111B6FF1010D1FF1010D1FF1010D1FF1010D1FF1010B6FF0E0E
      BBF601016DCD0000254D000000000000000000000000000000000039005714A1
      08E479EB3EFBADFF58FFCDFF63FFEDFF6BFFFFF26BFFFFD265FFFFB158FFEB7A
      3AFBA11907E43A00005700000000000000000000000000000000000000000200
      00042206003C4F0D018C640F00B16F1102C46F1102C56F1102C5FA7341FF6F11
      02C50200000400000000000000000000000000000000010E001A0B6702BF25B9
      16F622C811FF21B210FFE6E6E6FF21B210FF21C810FF21C810FF21C810FF21C8
      10FF1DB50EF6096700BF010E001A000000000000000000000E1A020267BF1717
      BAF61111B2FFDCDCDCFF1010B2FF1010C8FF1010C8FF1010B2FFEEEEEEFF1010
      B2FF0E0EB5F6000067BF00000E1A0000000000000000000F001D059805D65AEC
      4BFA89FF63FFA9FF71FFCCFF82FFEDFF8CFFFFF28CFFFFD284FFFFAF74FFFF89
      5FFFEC513BFA980403D61200001D0000000000000000000000000A0100114F0E
      01868A260DD0C34E28EBE16337F8F06D3DFFF16E3DFFF16E3DFFF16E3DFF8A26
      0DD04F0E01860A010011000000000000000000000000053A006C1E9610E325C0
      14FF21AD10FFDEDEDEFFE2E2E2FFE6E6E6FF21AD10FF21BE10FF21BE10FF21BE
      10FF21BE10FF138F07E3053A006C000000000000000000003A6C121296E21515
      C1FFD1D1D1FFD6D6D6FFDCDCDCFF1010ADFF1010ADFFEAEAEAFFEEEEEEFFEEEE
      EEFF1010BEFF07078FE300003A6C0000000000000000004F007A2CCB34F16DFF
      70FF7CFF70FFA6FF8AFFCBFF9EFFECFFABFFFFF2ACFFFFD1A1FFFFAC8EFFFF84
      75FFFF5D5FFFCB1D26F15400007A0000000000000000050100085611018DA73C
      1DDEE2663CFDE56739FFD75E33FFEDEDEDFFEEEEEEFFD75E33FFE56639FFE163
      37FDA53718DE5611018D050100080000000000000000095B00A738B529F522AE
      11FFD5D5D5FFDADADAFFDEDEDEFFE2E2E2FFE6E6E6FF21A810FF21B410FF21B4
      10FF21B410FF1FA810F5095B00A7000000000000000000005BA72C2CB8F51111
      B4FF1010B4FFD1D1D1FFD6D6D6FFDCDCDCFFE2E2E2FFE6E6E6FFEAEAEAFF1010
      B4FF1010B4FF1111A8F500005BA70000000000000000008916BC61ED82FA6DFF
      8AFF81FF90FFA2FFA1FFC8FFB8FFECFFCAFFFFF1CCFFFFCEBBFFFFA8A5FFFF86
      93FFFF6985FFED4068FA890018BC00000000000000003009004D942F15D2DA66
      3CFED85F34FFD85F34FFCD582FFFE2E2E2FFEDEDEDFFCD582FFFD85F34FFD85F
      34FFD65E33FE91290ED23009004D00000000000000000C7000C44FC63EFDA9D7
      A2FFD5D5D5FFEBEBEBFF21A510FFDEDEDEFFE2E2E2FFE6E6E6FF21A310FF21AA
      10FF21AA10FF27AC16FD0C7000C40000000000000000000070C44343CBFD2525
      B5FF1313ABFF1010AAFFD1D1D1FFD6D6D6FFDCDCDCFFE2E2E2FF1010AAFF1010
      AAFF1010AAFF1717ADFD000070C4000000000000000000A63ADD87FCB7FE6CFF
      A6FF89FFB5FFA9FFC4FFC8FFD4FFEBFFE6FFFFF1E9FFFFCED7FFFFAFC7FFFF8F
      B7FFFF6FA8FFFC5B9DFEA6003EDD000000000000000060150196C35E3CEFCB58
      2FFFCB572EFFCB572EFFC3532BFFD6D6D6FFE2E2E2FFC3532BFFCB572EFFCB57
      2EFFCB572EFFB74A26EF6015019600000000000000000C7300C452C941FD3BB3
      2AFFF8F8F8FF2CA81BFF22A211FF219F10FFDEDEDEFFE2E2E2FFE6E6E6FF219E
      10FF21A110FF2BA81AFD0C7300C40000000000000000000073C44848CFFD3232
      BBFF2D2DB8FF12129FFFCECECEFFD1D1D1FFD6D6D6FFDCDCDCFF10109EFF1010
      A1FF1010A1FF1C1CAAFD000073C4000000000000000000A556D895FCD1FE6DFF
      C5FF89FFD3FFA9FFE3FFC8FFF3FFE4F9FDFFF6E8FEFFFFCDF6FFFFAFE6FFFF8F
      D6FFFF6FC7FFFC67BEFEA50059D80000000000000000781B00B7D87755FCC85E
      3AFFC0512BFFBE4F29FFB94D27FFCDCDCDFFD6D6D6FFB94D27FFBE4F29FFBE4F
      29FFBE4F29FFC05430FC781B00B700000000000000000B6500A74DC33CF546BE
      35FF3DB52CFF46BE35FF40B92FFF36AF25FF2CA41BFFE2E2E2FFE3E3E3FFE7E7
      E7FF259E14FF31A921F50B6500A70000000000000000000065A74343CAF53636
      BFFF2222ABFFFFFFFFFFF7F7F7FFE8E8E8FFDEDEDEFFDBDBDBFFDDDDDDFF1010
      9BFF1515A0FF2525ADF5000065A70000000000000000008A5FB085EDD3F777FF
      E4FF81FFEFFF9EFCFCFFB8EFFFFFCADDFFFFD9CCFFFFECBBFFFFFAA2FDFFFF86
      F2FFFF71E5FFED5EC9F78A0061B000000000000000007A1B00B7DC7C5AFCCD66
      44FFCA6240FFBE5330FFB24825FFCCCCCCFFCDCDCDFFB14724FFB44925FFB449
      25FFB44925FFBC5432FC7A1B00B700000000000000000843006C36AA27E353CB
      42FF4DC53CFF4DC53CFF4DC53CFF4DC53CFF4DC53CFF43BB32FFFFFFFFFFA7E2
      9EFF51C940FF2FA420E30843006C00000000000000000000436C2D2DB0E34848
      D1FFFFFFFFFFFFFFFFFFFFFFFFFF4141CAFF4141CAFFFFFFFFFFFFFFFFFFFFFF
      FFFF4646CFFF2525A8E30000436C00000000000000000052446D4ACBBFE39BFE
      FCFF70F3FFFF8AE3FFFF9ED3FFFFABBDFFFFB9ACFFFFD0A1FFFFE08EFFFFF175
      FFFFFD83FCFFCB37BFE35500476D000000000000000066170194D0714FEED36C
      4AFFD26B49FFD26B49FFCD6644FFAF4725FFAC4422FFB14927FFAD4523FFAD45
      23FFB14927FFB75434EE6617019400000000000000000210001A127D05BF58CF
      48F657CF46FF56CE45FF56CE45FF56CE45FF56CE45FF56CE45FF49C138FF51C9
      40FF53CA42F6127C03BF0210001A00000000000000000000101A05057EBF5252
      DAF65050D9FFFFFFFFFF4E4ED7FF4E4ED7FF4E4ED7FF4E4ED7FFFFFFFFFF4F4F
      D8FF4B4BD4F605057DBF0000101A000000000000000000101019099196B698E1
      ECF38EE4FFFF71C8FFFF82B5FFFF8C9EFFFF998CFFFFB284FFFFC574FFFFDF84
      FFFFDC7CECF38E0996B6130012190000000000000000350D004CA44122D0E685
      63FEDC7553FFDC7553FFCF6846FFFFFFFFFFFFFFFFFFCF6846FFDC7553FFDC75
      53FFE17F5CFEA03C1DD0350D004C0000000000000000000000000632004D1B8C
      0BCD5BD24AF662DA51FF5ED64DFF5ED64DFF5ED64DFF5ED64DFF61D950FF59D1
      48F6198C09CD0632004D000000000000000000000000000000000000324D0C0C
      8ECD5757DFF65E5EE7FF5A5AE3FF5A5AE3FF5A5AE3FF5A5AE3FF5E5EE7FF5454
      DCF60C0C8CCD0000324D00000000000000000000000000000000002F3945147C
      9CB99ECFEBF1A4D2FFFF7DA8FFFF7183FFFF7D71FFFFA37CFFFFCA9BFFFFC68A
      EBF179149CB92F0039450000000000000000000000000601000861180289B857
      36DBEB8C69FDE7815EFFD7704EFFFFFFFFFFFFFFFFFFD7704EFFE7815EFFEA88
      65FDB65131DB6118028906010008000000000000000000000000000000000633
      004D148205BF3AB229E35AD34AF569E158FD69E157FD5AD24AF539B128E31482
      05BF0633004D0000000000000000000000000000000000000000000000000000
      334D060682BF3030B9E35858E0F56868F1FD6767F0FD5757DFF52F2FB8E30606
      82BF0000334D0000000000000000000000000000000000000000000000000023
      36410A5189A2517EBECF9CB0E5EDBDC3FAFBBFBAFAFBAA96E5ED7A4DBECF4D0A
      89A22300374100000000000000000000000000000000000000000B0300105D17
      0282A03D1BCBD27351E9EA8D6AF8F59774FFF59774FFEA8B69F8D1704EE99F3B
      1ACB5D1702820B03001000000000000000000000000000000000000000000000
      00000211001A0848006C0E6F00A6108200C4108200C40E6F00A60848006C0211
      001A000000000000000000000000000000000000000000000000000000000000
      00000000111A0000486C00006FA6000082C4000082C400006FA60000486C0000
      111A000000000000000000000000000000000000000000000000000000000000
      000000060F150016475702187185030E859D0903859D16027185150048570600
      1015000000000000000000000000000000000000000000000000000000000301
      00042A0A003A611902867C1F01AA892202BC892202BC7C1F01AA611902862A0A
      003A030100040000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000100000000000000010000
      C003000000010000C003000000010000C003000000010000C003000000010000
      C003000000010000C003000000010000C003000000010000C003000000010000
      C003000000010000C003000000010000C003000000010000C003000000010000
      C003000000010000C00300000001000080018001800180018001800180018001
      E007E007E007FF0FC003C003C003E007800180018001C0038001800180018001
      8001800180018001800180018001800180018001800180018001800180018001
      80018001800180018001800180018001C003C003C0038001E007E007E007C003
      F00FF00FF00FE007FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
