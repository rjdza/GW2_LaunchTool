#include <File.au3>

Func SetProfileDat($AccountInfo)
 	MsgBox($MB_SYSTEMMODAL, "GW2 Launcher", "Processing Account: " & $AccountInfo )
	_ArrayDisplay($CmdLine,"Commandline Args")
EndFunc
