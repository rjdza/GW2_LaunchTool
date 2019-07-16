#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoit_resources\gw2_icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Run_Tidy=n
#AutoIt3Wrapper_Run_Au3Stripper=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>

#include "GW2_LaunchTool_Menu.au3"
#include "GW2_LaunchTool_ShortcutUtil.au3"

Global $GW2_Path = "..\"
Global $GW2_Exe = "Gw2-64.exe"
Global $AccName = "default"
Global $UseLinks = True
Global $GW2_FullPath


If $CmdLine[0] = "" Then
	MainMenu()
Else
;~ 	SetProfileDat($CmdLine[1])

	For $Count = 1 To $CmdLine[0]

		$CmdArg = StringSplit($CmdLine[$Count] & "=", "=")
		$Key = StringLower($CmdArg[1])
		$Val = $CmdArg[2]
		Switch $Key
			Case "gw2path"
				$GW2_Path = $Val
;~ 				ShowMsg("GW2 Path: " & $GW2_Path)

			Case "gw2exe"
				$GW2_Exe = $Val
;~ 				ShowMsg("GW2 Exe: " & $GW2_Exe)

			Case "accname"
				$AccName = $Val
;~ 				ShowMsg("AccName: " & $AccName)

			Case "uselinks"
				$UseLinks = True

			Case "usedat"
				$UseLinks = False
				ShowMsg("Use DAT not yet implemented")

			Case Else
;~ 				ShowMsg("Unknown Key: >" & String($Key) & "<")
				$AccName = $Key
		EndSwitch

	Next
;~ 	_ArrayDisplay($CmdLine, "Commandline Args")

EndIf

CheckGW2Path()

If $AccName = "" Then
	MainMenu()
Else
	SetProfileDat($AccName)
EndIf


Func ShowMsg($Message)
	MsgBox($MB_SYSTEMMODAL, "Gw2 Launcher", $Message)
EndFunc   ;==>ShowMsg

Func CheckGW2Path()

	Global $CheckBin = _FileListToArray($GW2_Path, $GW2_Exe)
	If @error = 1 Then
		ShowMsg("The GW2 path is invalid: [" & $GW2_Path & "]")
		Exit
	EndIf
	If @error = 4 Then
		ShowMsg("No GW2 Executable file (" & $GW2_Exe & ") was found in path: [" & $GW2_Path & "]")
		Exit
	EndIf

	$GW2_FullPath = _PathFull($GW2_Path & $GW2_Exe )
	$GW2_FullPath = FileGetShortName( $GW2_FullPath )

EndFunc   ;==>CheckGW2Path
