Global Const $MB_SYSTEMMODAL = 4096
Global Const $_ARRAYCONSTANT_SORTINFOSIZE = 11
Global $__g_aArrayDisplay_SortInfo[$_ARRAYCONSTANT_SORTINFOSIZE]
Global Const $_ARRAYCONSTANT_tagLVITEM = "struct;uint Mask;int Item;int SubItem;uint State;uint StateMask;ptr Text;int TextMax;int Image;lparam Param;" & "int Indent;int GroupID;uint Columns;ptr pColumns;ptr piColFmt;int iGroup;endstruct"
#Au3Stripper_Ignore_Funcs=__ArrayDisplay_SortCallBack
Func __ArrayDisplay_SortCallBack($nItem1, $nItem2, $hWnd)
If $__g_aArrayDisplay_SortInfo[3] = $__g_aArrayDisplay_SortInfo[4] Then
If Not $__g_aArrayDisplay_SortInfo[7] Then
$__g_aArrayDisplay_SortInfo[5] *= -1
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
Else
$__g_aArrayDisplay_SortInfo[7] = 1
EndIf
$__g_aArrayDisplay_SortInfo[6] = $__g_aArrayDisplay_SortInfo[3]
Local $sVal1 = __ArrayDisplay_GetItemText($hWnd, $nItem1, $__g_aArrayDisplay_SortInfo[3])
Local $sVal2 = __ArrayDisplay_GetItemText($hWnd, $nItem2, $__g_aArrayDisplay_SortInfo[3])
If $__g_aArrayDisplay_SortInfo[8] = 1 Then
If(StringIsFloat($sVal1) Or StringIsInt($sVal1)) Then $sVal1 = Number($sVal1)
If(StringIsFloat($sVal2) Or StringIsInt($sVal2)) Then $sVal2 = Number($sVal2)
EndIf
Local $nResult
If $__g_aArrayDisplay_SortInfo[8] < 2 Then
$nResult = 0
If $sVal1 < $sVal2 Then
$nResult = -1
ElseIf $sVal1 > $sVal2 Then
$nResult = 1
EndIf
Else
$nResult = DllCall('shlwapi.dll', 'int', 'StrCmpLogicalW', 'wstr', $sVal1, 'wstr', $sVal2)[0]
EndIf
$nResult = $nResult * $__g_aArrayDisplay_SortInfo[5]
Return $nResult
EndFunc
Func __ArrayDisplay_GetItemText($hWnd, $iIndex, $iSubItem = 0)
Local $tBuffer = DllStructCreate("wchar Text[4096]")
Local $pBuffer = DllStructGetPtr($tBuffer)
Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM)
DllStructSetData($tItem, "SubItem", $iSubItem)
DllStructSetData($tItem, "TextMax", 4096)
DllStructSetData($tItem, "Text", $pBuffer)
If IsHWnd($hWnd) Then
DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", 0x1073, "wparam", $iIndex, "struct*", $tItem)
Else
Local $pItem = DllStructGetPtr($tItem)
GUICtrlSendMsg($hWnd, 0x1073, $iIndex, $pItem)
EndIf
Return DllStructGetData($tBuffer, "Text")
EndFunc
Global Const $FC_OVERWRITE = 1
Global Const $FLTA_FILESFOLDERS = 0
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""
$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\"
If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
If $bReturnPath Then $sFullPath = $sFilePath
If $sFilter = Default Then $sFilter = "*"
If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
If Not($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
If @error Then Return SetError(4, 0, 0)
While 1
$sFileName = FileFindNextFile($hSearch)
If @error Then ExitLoop
If($iFlag + @extended = 2) Then ContinueLoop
$sFileList &= $sDelimiter & $sFullPath & $sFileName
WEnd
FileClose($hSearch)
If $sFileList = "" Then Return SetError(4, 0, 0)
Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc
Func _PathFull($sRelativePath, $sBasePath = @WorkingDir)
If Not $sRelativePath Or $sRelativePath = "." Then Return $sBasePath
Local $sFullPath = StringReplace($sRelativePath, "/", "\")
Local Const $sFullPathConst = $sFullPath
Local $sPath
Local $bRootOnly = StringLeft($sFullPath, 1) = "\" And StringMid($sFullPath, 2, 1) <> "\"
If $sBasePath = Default Then $sBasePath = @WorkingDir
For $i = 1 To 2
$sPath = StringLeft($sFullPath, 2)
If $sPath = "\\" Then
$sFullPath = StringTrimLeft($sFullPath, 2)
Local $nServerLen = StringInStr($sFullPath, "\") - 1
$sPath = "\\" & StringLeft($sFullPath, $nServerLen)
$sFullPath = StringTrimLeft($sFullPath, $nServerLen)
ExitLoop
ElseIf StringRight($sPath, 1) = ":" Then
$sFullPath = StringTrimLeft($sFullPath, 2)
ExitLoop
Else
$sFullPath = $sBasePath & "\" & $sFullPath
EndIf
Next
If StringLeft($sFullPath, 1) <> "\" Then
If StringLeft($sFullPathConst, 2) = StringLeft($sBasePath, 2) Then
$sFullPath = $sBasePath & "\" & $sFullPath
Else
$sFullPath = "\" & $sFullPath
EndIf
EndIf
Local $aTemp = StringSplit($sFullPath, "\")
Local $aPathParts[$aTemp[0]], $j = 0
For $i = 2 To $aTemp[0]
If $aTemp[$i] = ".." Then
If $j Then $j -= 1
ElseIf Not($aTemp[$i] = "" And $i <> $aTemp[0]) And $aTemp[$i] <> "." Then
$aPathParts[$j] = $aTemp[$i]
$j += 1
EndIf
Next
$sFullPath = $sPath
If Not $bRootOnly Then
For $i = 0 To $j - 1
$sFullPath &= "\" & $aPathParts[$i]
Next
Else
$sFullPath &= $sFullPathConst
If StringInStr($sFullPath, "..") Then $sFullPath = _PathFull($sFullPath)
EndIf
Do
$sFullPath = StringReplace($sFullPath, ".\", "\")
Until @extended = 0
Return $sFullPath
EndFunc
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_DROPPED = -13
Global Const $GUI_DISABLE = 128
Const $PARAMBYVAL = 0
Const $PARAMBYREF = 1
Const $PARAMWINDOW = 3
Const $ParamArray = 2
Const $OE_HOTKEY = 1
Const $OE_CONTROL = 0
Const $OE_GUI = 2
Const $MAX_NUM_PARAMS = 5
Global $CtrlLib[6][2][$MAX_NUM_PARAMS + 3]
Func SetOnEventA($iCtrl, $sFunc, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '')
Local $iParCount =(@NumParams - 2) / 2
Return SetOnEventAT(0, $iParCount, $iCtrl, $sFunc, $ParType1, $Par1, $ParType2, $par2, $ParType3, $Par3, $ParType4, $Par4, $ParType5, $Par5)
EndFunc
Func SetOnEventAT($CtrlType, $iParCount, $iCtrl, $sFunc, $ParType1 = 0, $Par1 = '', $ParType2 = 0, $par2 = '', $ParType3 = 0, $Par3 = '', $ParType4 = 0, $Par4 = '', $ParType5 = 0, $Par5 = '')
Local $n, $aval, $item = 0
If $iCtrl = -1 Then $iCtrl = _GUIGetLastCtrlID()
For $n = 1 To $CtrlLib[0][0][0]
If $CtrlLib[$n][1][0] = $iCtrl Then
$item = $n
ExitLoop
EndIf
Next
If $item = 0 Then
$CtrlLib[0][0][0] += 1
$item = $CtrlLib[0][0][0]
If UBound($CtrlLib) < $item + 1 Then ReDim $CtrlLib[$item + 2][2][$MAX_NUM_PARAMS + 3]
EndIf
If $CtrlType = 0 Then
If IsString($iCtrl) Then
If Not IsString($iCtrl) Or $iCtrl = '' Then Return -6
HotKeySet($iCtrl, "HK_EventFunc")
$CtrlLib[$item][0][0] = $OE_HOTKEY
Else
If Opt("GUIOnEventMode") = 0 Then
Return -3
EndIf
If $iCtrl < -2 And $iCtrl > -14 Then
If $ParType1 <> $PARAMBYVAL Then Return -4
If IsHWnd($Par1) Then
$CtrlLib[$item][0][1] = $Par1
ElseIf Number($Par1) = 0 Then
$CtrlLib[$item][0][1] = 0
Else
Return -5
EndIf
If $sFunc = '' Then
GUISetOnEvent($iCtrl, "")
Else
GUISetOnEvent($iCtrl, "EventGuiFunc")
EndIf
$CtrlLib[$item][0][0] = $OE_GUI
Else
$CtrlLib[$item][0][0] = $OE_CONTROL
If $sFunc = '' Then
GUICtrlSetOnEvent($iCtrl, "")
Else
GUICtrlSetOnEvent($iCtrl, "EventCtrlFunc")
EndIf
EndIf
EndIf
Else
TrayItemSetOnEvent($iCtrl, "TrayEventCtrlFunc")
$CtrlLib[$item][0][0] = $OE_CONTROL
EndIf
Switch $CtrlLib[$item][0][0]
Case $OE_HOTKEY
$CtrlLib[$item][1][0] = $iCtrl
Case $OE_CONTROL
$CtrlLib[$item][1][0] = $iCtrl
Case $OE_GUI
$CtrlLib[$item][1][0] = $iCtrl
EndSwitch
$CtrlLib[$item][1][1] = $sFunc
$CtrlLib[$item][1][2] = $iParCount
For $n = 1 To $iParCount
$CtrlLib[$item][0][$n + 2] = Eval("ParType" & $n)
If $CtrlLib[$item][0][$n + 2] = $PARAMBYVAL Then
$CtrlLib[$item][1][$n + 2] = Eval("Par" & $n)
ElseIf($CtrlLib[$item][0][$n + 2] = $PARAMBYREF) Then
$aval = Eval("Par" & $n)
If Not IsString($aval) Then
$CtrlLib[$item][1][1] = ""
SetError($n)
Return -2
EndIf
If StringLeft($aval, 1) = '$' Then
$aval = StringRight($aval, StringLen($aval) - 1)
EndIf
$CtrlLib[$item][1][$n + 2] = $aval
Else
$CtrlLib[$item][1][1] = ""
Return -1
EndIf
Next
If $CtrlLib[$item][0][0] = $OE_GUI And $iParCount = 0 Then
$CtrlLib[$item][1][1 + 2] = 0
EndIf
Return 1
EndFunc
Func _GUIGetLastCtrlID()
Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", GUICtrlGetHandle(-1))
Return $aRet[0]
EndFunc
Func EventCtrlFunc()
Local $item
$item = GetItem(@GUI_CtrlId)
If $item = -1 Then $item = GetItem(@TRAY_ID)
If $item = -1 Then Return
$CtrlLib[0][1][1] = $item
$CtrlLib[0][1][2] = @GUI_CtrlId
BuildFnCall($item)
EndFunc
Func TrayEventCtrlFunc()
Local $item
$item = GetItem(@TRAY_ID)
If $item = -1 Then Return
$CtrlLib[0][1][1] = $item
$CtrlLib[0][1][2] = @TRAY_ID
BuildFnCall($item)
EndFunc
Func EventGuiFunc()
Local $item
$item = GetItem(@GUI_CtrlId, @GUI_WinHandle)
If $item = -1 Then Return
$CtrlLib[0][1][1] = $item
$CtrlLib[0][1][2] = @GUI_CtrlId
If @GUI_CtrlId = $GUI_EVENT_DROPPED Then
$CtrlLib[0][1][3] = @GUI_DragId
$CtrlLib[0][1][4] = @GUI_DragFile
$CtrlLib[0][1][5] = @GUI_DropId
EndIf
BuildFnCall($item)
EndFunc
Func HK_EventFunc()
Local $item
$item = GetItem(@HotKeyPressed)
If $item = -1 Then Return
$CtrlLib[0][1][1] = $item
$CtrlLib[0][1][2] = @HotKeyPressed
BuildFnCall($item)
EndFunc
Func BuildFnCall($index)
Local $Arrayset[$CtrlLib[$index][1][2] + 1]
$Arrayset[0] = "CallArgArray"
For $n = 1 To $CtrlLib[$index][1][2]
If $CtrlLib[$index][0][$n + 2] = $PARAMBYVAL Then
$Arrayset[$n] = $CtrlLib[$index][1][$n + 2]
Else
$Arrayset[$n] = Eval($CtrlLib[$index][1][$n + 2])
EndIf
Next
If $CtrlLib[$index][1][2] = 0 Then
Call($CtrlLib[$index][1][1])
Else
Call($CtrlLib[$index][1][1], $Arrayset)
EndIf
EndFunc
Func GetItem($id, $hWnd = 0)
For $n = 0 To UBound($CtrlLib) - 1
If $CtrlLib[$n][1][0] = $id Then
If $CtrlLib[$n][0][0] = $OE_GUI Then
If $CtrlLib[$n][0][1] = $hWnd Or $CtrlLib[$n][0][1] = 0 Then
Return $n
EndIf
Else
Return $n
EndIf
EndIf
Next
Return -1
EndFunc
If Not IsDeclared("GW2_Path") Then Global $GW2_Path
If Not IsDeclared("GW2_FullPath") Then Global $GW2_FullPath
Opt("GUIOnEventMode", 1)
$GW2_BG_Image = @MyDocumentsDir & "\Guild Wars 2\GW2LT-BGImg.jpg"
If Not FileExists($GW2_BG_Image) Then
FileInstall("autoit_resources\gw2.jpg", $GW2_BG_Image)
EndIf
Func MainMenu()
TraySetIcon("autoit_resources\gw2_icon.ico")
$gui = GUICreate("GW2 Multi Account Launch Tool", 610, 343)
GUISetOnEvent($GUI_EVENT_CLOSE, "ClickExit")
GUISetIcon("autoit_resources\gw2_icon.ico")
$gw2_bg = GUICtrlCreatePic($GW2_BG_Image, 0, 0, 610, 343)
GUICtrlSetState($gw2_bg, $GUI_DISABLE)
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
EndFunc
Func ClickExit()
Exit
EndFunc
If Not IsDeclared("GW2_Path" ) Then Global $GW2_Path
If Not IsDeclared("GW2_FullPath" ) Then Global $GW2_FullPath
If Not IsDeclared("GW2_RunPath" ) Then Global $GW2_RunPath
If Not IsDeclared("GW2_Exe" ) Then Global $GW2_Exe
If Not IsDeclared("SyncAfterShutdown" ) Then Global $SyncAfterShutdown
If Not IsDeclared("LIVE_DAT" ) Then Global $LIVE_DAT
Func SetProfileDat($AccountInfo)
$ACC_DAT=$GW2_Path & "GW2LT-" & $AccountInfo & ".dat"
if FileExists($ACC_DAT) Then
Else
ShowMsg("Cannot find the account file " & $ACC_DAT & ".  I will create it.")
FileCopy( $LIVE_DAT, $ACC_DAT )
EndIf
FileCopy( $ACC_DAT, $LIVE_DAT, $FC_OVERWRITE )
Run('"' & $GW2_RunPath & '"' & " -autologin -bmp -maploadinfo")
if $SyncAfterShutdown = True Then
ProcessWaitClose($GW2_Exe)
Local $CopyStatus = FileCopy( $LIVE_DAT, $ACC_DAT, $FC_OVERWRITE )
If Not $CopyStatus Then ShowMsg("File sync failed.  No more data available.")
EndIf
EndFunc
Global $GW2_Path = "..\"
Global $GW2_Exe = "Gw2-64.exe"
FindGW2Path()
Global $AccName = ""
Global $UseLinks = True
Global $GW2_FullPath
Global $GW2_RunPath
Global $SyncAfterShutdown
Global $LIVE_DAT = @AppDataDir & "\Guild Wars 2\Local.dat"
If FileExists($LIVE_DAT) Then
Else
ShowMsg("Cannot find GW2 DAT file.  Run GW2 at least once on this machine and try again.")
Exit
EndIf
If $CmdLine[0] = "" Then
MainMenu()
Else
For $Count = 1 To $CmdLine[0]
$CmdArg = StringSplit($CmdLine[$Count] & "=", "=")
$Key = StringLower($CmdArg[1])
$Val = $CmdArg[2]
Switch $Key
Case "gw2path"
$GW2_Path = $Val
Case "gw2exe"
$GW2_Exe = $Val
Case "accname"
$AccName = $Val
Case "uselinks"
$UseLinks = True
Case "usedat"
$UseLinks = False
ShowMsg("Use DAT not yet implemented")
Case "syncdat"
$SyncAfterShutdown = True
Case Else
If $AccName = "" Then $AccName = $Key
EndSwitch
Next
EndIf
CheckGW2Path()
If $AccName = "" Then
MainMenu()
Else
SetProfileDat($AccName)
EndIf
Func ShowMsg($Message)
MsgBox($MB_SYSTEMMODAL, "Gw2 Launcher", $Message)
EndFunc
Func FindGW2Path()
$TMP_Path = StringSplit("..\,.\,..\..\,..\..\..\", ",")
For $Count = 1 To UBound($TMP_Path) - 1
If FileExists($TMP_Path[$Count] & $GW2_Exe) Then
$GW2_Path = _PathFull($TMP_Path[$Count])
ExitLoop
EndIf
Next
EndFunc
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
$GW2_FullPath = _PathFull($GW2_Path)
$GW2_FullPath = FileGetShortName($GW2_FullPath)
$GW2_RunPath = FileGetShortName($GW2_FullPath & $GW2_Exe)
EndFunc
