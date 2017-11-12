object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 256
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 471
    Top = 223
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = btn1Click
  end
  object mmoLog: TMemo
    Left = 9
    Top = 8
    Width = 537
    Height = 209
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
  end
end
