#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoit_resources\gw2_icon.ico
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <File.au3>
;~ #include "autoit_resources\Toast.au3"
;~ I plan on using toast when I have tome to get it to be non-blocking.

#include "GW2_LaunchTool_Menu.au3"
#include "GW2_LaunchTool_ShortcutUtil.au3"


Global $GW2_Path = "..\"
Global $GW2_Exe = "Gw2-64.exe"
Global $AccName = ""
Global $UseLinks = True
Global $GW2_FullPath
Global $GW2_RunPath
Global $SyncAfterShutdown

Global $LIVE_DAT=@AppDataDir & "\Guild Wars 2\Local.dat"
if FileExists($LIVE_DAT) Then
Else
	ShowMsg("Cannot find GW2 DAT file.  Run GW2 at least once on this machine and try again.")
	Exit
EndIf


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

			Case "SyncDat"
				$SyncAfterShutdown = True

			Case Else
;~ 				ShowMsg("Unknown Key: >" & String($Key) & "<")
				if $AccName = "" then $AccName = $Key
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

	$GW2_FullPath = _PathFull($GW2_Path )
	$GW2_FullPath = FileGetShortName( $GW2_FullPath )
	$GW2_RunPath = FileGetShortName( $GW2_FullPath & $GW2_Exe )

EndFunc   ;==>CheckGW2Path
