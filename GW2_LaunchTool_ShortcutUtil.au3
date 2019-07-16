#include <File.au3>
If Not IsDeclared ( "GW2_Path" ) Then  Global $GW2_Path
If Not IsDeclared ( "GW2_FullPath" ) Then  Global $GW2_FullPath
If Not IsDeclared ( "GW2_Exe" ) Then  Global $GW2_Exe

Func SetProfileDat($AccountInfo)

	ShowMsg("Processing Account: " & $AccountInfo)
;~ 	_ArrayDisplay($CmdLine, "Commandline Args")

	$LIVE_DAT=@AppDataDir & "\Guild Wars 2\Local.dat"
	if FileExists($LIVE_DAT) Then
;~ 		ShowMsg("LIVE FILE EXISTS: " & $LIVE_DAT)
	Else
		ShowMsg("Cannot find GW2 DAT file.  Run GW2 at least once on this machine and try again.")
		Exit
	EndIf

	$ACC_DAT=$GW2_Path & "GW2LT-" & $AccountInfo & ".dat"
	if FileExists($ACC_DAT) Then
;~ 		ShowMsg("ACCOUNT FILE EXISTS: " & $ACC_DAT)
	Else
		ShowMsg("Cannot find the account file " & $ACC_DAT & ".  I will be creating it and then exiting.")
		FileCopy( $LIVE_DAT, $ACC_DAT )
	EndIf

	FileCopy( $ACC_DAT, $LIVE_DAT, $FC_OVERWRITE )

;~ 	$GW2_FullPath = _PathFull($GW2_Path & $GW2_Exe )
;~ 	$GW2_FullPath = FileGetShortName( $GW2_FullPath )
	ShowMsg("Full GW2 Path: " & $GW2_FullPath)
	RunWait('"' & $GW2_FullPath & $GW2_Exe & '"' & " -autologin -bmp -maploadinfo")

EndFunc   ;==>SetProfileDat
