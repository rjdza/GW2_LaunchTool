#include <File.au3>
If Not IsDeclared ( "GW2_Path" ) Then  Global $GW2_Path
If Not IsDeclared ( "GW2_FullPath" ) Then  Global $GW2_FullPath
If Not IsDeclared ( "GW2_RunPath" ) Then  Global $GW2_RunPath
If Not IsDeclared ( "GW2_Exe" ) Then  Global $GW2_Exe
If Not IsDeclared ( "SyncAfterShutdown" ) Then  Global $SyncAfterShutdown
If Not IsDeclared ( "LIVE_DAT" ) Then  Global $LIVE_DAT

Func SetProfileDat($AccountInfo)

;~ 	ShowMsg("Processing Account: " & $AccountInfo)
;~ 	_ArrayDisplay($CmdLine, "Commandline Args")

	$ACC_DAT=$GW2_Path & "GW2LT-" & $AccountInfo & ".dat"
	if FileExists($ACC_DAT) Then
;~ 		ShowMsg("ACCOUNT FILE EXISTS: " & $ACC_DAT)
	Else
		ShowMsg("Cannot find the account file " & $ACC_DAT & ".  I will create it.")
		FileCopy( $LIVE_DAT, $ACC_DAT )

	EndIf

	FileCopy( $ACC_DAT, $LIVE_DAT, $FC_OVERWRITE )

;~ 	ShowMsg("Full GW2 Run Path: " & $GW2_RunPath)
	Run('"' & $GW2_RunPath & '"' & " -autologin -bmp -maploadinfo")

	if $SyncAfterShutdown = True Then
		ProcessWaitClose($GW2_Exe)
;~ 		ShowMsg("Process closed, copying file")
		Local $CopyStatus = FileCopy( $LIVE_DAT, $ACC_DAT, $FC_OVERWRITE )
		If Not $CopyStatus Then ShowMsg("File sync failed.  No more data available.")
	EndIf

;~ 	ShowMsg("Run complete")

EndFunc   ;==>SetProfileDat
