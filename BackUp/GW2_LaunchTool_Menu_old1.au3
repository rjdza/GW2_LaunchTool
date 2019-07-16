#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include "autoit_resources\onEventFunc.au3"

Global $Index

Func MainMenu()

	#AutoIt3Wrapper_Res_File_Add=autoit_resources\gw2.jpg, rt_rcdata, GW2_BG
	#AutoIt3Wrapper_Res_File_Add=autoit_resources\gw2_icon.ico, rt_rcdata, GW2_ICO

	TraySetIcon("autoit_resources\gw2_icon.ico")

	Opt("GUIOnEventMode", 1)

	$gui = GUICreate("GW2 Multi Account Launch Tool",610,343)
	GUISetIcon("autoit_resources\gw2_icon.ico")
	$gw2_bg = GUICtrlCreatePic("autoit_resources\gw2.jpg", 0, 0,610, 343)
	GUICtrlSetState($gw2_bg, $GUI_DISABLE)

	;~ Getting list of Account Files
	Global $GetAccounts = _FileListToArray($GW2_Path , "autologin*.lnk")
	If @error = 1 Then
		MsgBox($MB_SYSTEMMODAL, "", "GW2 Path was invalid.")
		Exit
	EndIf
	If @error = 4 Then
		MsgBox($MB_SYSTEMMODAL, "", "No account file(s) were found.")
		Exit
	EndIf
	$NumberOfAccounts = UBound($GetAccounts) -1
	Global $AccountButton[50]

	;~ _ArrayDisplay($GetAccounts,"Accounts")

	$BtnTop = 20
	$BtnLeft = 20
	$BtnWidth = 150
	$BtnHeight = 35
	$BtnHGap = $BtnHeight + 10
	$BtnVGap = $BtnWidth + 20

	$Btn_Start = GUICtrlCreateDummy()
	For $Acc = 1 to $NumberOfAccounts
		$AccountButton[$Acc] = GUICtrlCreateButton($GetAccounts[$Acc], $BtnLeft, $BtnTop, $BtnWidth, $BtnHeight)
		SetOnEventA(-1,"ClickAccount",$paramByVal,$Acc)
		$BtnTop += $BtnHGap
	Next
	$Btn_End = GUICtrlCreateDummy()

	$BtnExit = GUICtrlCreateButton("E&xit", 450,  260, 150, 40)
	GUICtrlSetOnEvent(-1, "ClickExit")

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
			sleep(10)
		WEnd
EndFunc

Func ClickExit()
	Exit
EndFunc

Func ClickAccount($Index)
;~ 	MsgBox($MB_SYSTEMMODAL, "Button Click", "Clicked Account " & String($Index) & ": " & $GetAccounts[$Index] )
	ShellExecute("..\" & $GetAccounts[$Index])
EndFunc
