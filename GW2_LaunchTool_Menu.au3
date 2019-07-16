#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include "autoit_resources\onEventFunc.au3"

Global $Index
If Not IsDeclared ( "GW2_Path" ) Then  Global $GW2_Path
If Not IsDeclared ( "GW2_FullPath" ) Then  Global $GW2_FullPath
Opt("GUIOnEventMode", 1)

Func MainMenu()

	#AutoIt3Wrapper_Res_File_Add=autoit_resources\gw2.jpg, rt_rcdata, GW2_BG
	#AutoIt3Wrapper_Res_File_Add=autoit_resources\gw2_icon.ico, rt_rcdata, GW2_ICO

	TraySetIcon("autoit_resources\gw2_icon.ico")

	$gui = GUICreate("GW2 Multi Account Launch Tool", 610, 343)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ClickExit")
	GUISetIcon("autoit_resources\gw2_icon.ico")
	$gw2_bg = GUICtrlCreatePic("autoit_resources\gw2.jpg", 0, 0, 610, 343)
	GUICtrlSetState($gw2_bg, $GUI_DISABLE)

;~ Getting list of Account Files
	Global $GetAccounts = _FileListToArray($GW2_Path, "GW2LT - *.lnk")
	If @error = 1 Then
		MsgBox($MB_SYSTEMMODAL, "", "GW2 Path was invalid.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox($MB_SYSTEMMODAL, "", "No account file(s) were found.")
		Exit
	EndIf
	$NumberOfAccounts = UBound($GetAccounts) - 1
	Global $AccountButton[50]

;~ _ArrayDisplay($GetAccounts,"Accounts")

	$BtnTop = 20
	$BtnLeft = 20
	$BtnWidth = 150
	$BtnHeight = 35
	$BtnHGap = $BtnHeight + 10
	$BtnVGap = $BtnWidth + 20
	$BtnFontSize = 14
	$BtnFontWeight = 400

	$Btn_Start = GUICtrlCreateDummy()
	For $Acc = 1 To $NumberOfAccounts
		$BtnName = StringTrimLeft($GetAccounts[$Acc], 8)
		$BtnName = StringTrimRight($BtnName, 4)
		$AccountButton[$Acc] = GUICtrlCreateButton($BtnName, $BtnLeft, $BtnTop, $BtnWidth, $BtnHeight)
		SetOnEventA(-1, "ClickAccount", $paramByVal, $Acc)
		GUICtrlSetFont(-1, $BtnFontSize, $BtnFontWeight)
		$BtnTop += $BtnHGap
	Next
	$Btn_End = GUICtrlCreateDummy()

;~ 	$BtnNew = GUICtrlCreateButton("Dupe Account", 450, 230, 150, 40)
;~ 	GUICtrlSetOnEvent(-1, "DupeAccount")
;~ 	GUICtrlSetFont(-1, $BtnFontSize, $BtnFontWeight)

	$BtnExit = GUICtrlCreateButton("Exit", 450, 290, 150, 40)
	GUICtrlSetOnEvent(-1, "ClickExit")
	GUICtrlSetFont(-1, $BtnFontSize, $BtnFontWeight)

	GUISetState(@SW_SHOW, $gui)

	While 1
		$GetMessage = GUIGetMsg()
		Switch $GetMessage
			Case $GUI_EVENT_CLOSE
				Exit
				ExitLoop

			Case 0
			Case Else
				MsgBox($MB_SYSTEMMODAL, "", $GetMessage)

		EndSwitch
		Sleep(10)
	WEnd
EndFunc   ;==>MainMenu

Func ClickExit()
	Exit
EndFunc   ;==>ClickExit

Func ClickAccount($Index)
;~ 	MsgBox($MB_SYSTEMMODAL, "Button Click", "Clicked Account " & String($Index) & ": " & $GetAccounts[$Index] )
	ShellExecute("..\" & $GetAccounts[$Index])
EndFunc   ;==>ClickAccount

Func DupeAccount()

;~ 	ShowMsg("Dupe Account")
	Local $NewAcc = InputBox("Duplicate Current Account", "Name for new account")
	ShowMsg("Dupe Account to name: " & $NewAcc)

EndFunc   ;==>ClickAccount
