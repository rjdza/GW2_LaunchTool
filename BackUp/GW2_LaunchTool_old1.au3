#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoit_resources\gw2_icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "GW2_LaunchTool_Menu.au3"
#include "GW2_LaunchTool_ShortcutUtil.au3"

if $CmdLine[0] = "" Then
	MainMenu()
Else
	SetProfileDat($CmdLine[0])
EndIf
