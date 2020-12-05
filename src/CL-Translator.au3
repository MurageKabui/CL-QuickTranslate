#NoTrayIcon
#include-once

#include "Funcs-CL-Translator.au3"
#include <String.au3>
#include <inet.au3>
#include <MsgBoxConstants.au3>

Opt('MustDeclareVars', 0)

; If Not @Compiled Then
; 	CompileRunningScript(@ScriptFullPath, @ScriptDir & "\Build\QuickTranslator_CRS.exe", "F:\Autoit Cool\Projects\Translator\yaTL.ico", 4, True, "x86", True)
; EndIf

Global $sStrTL

; Define a general COM error handler for intercepting COM errors
Global $h_gObjErr = ObjEvent("AutoIt.Error", "InterceptEventError")

;  Draft :
; =====================================================================================
; CL-Translate.exe -s "hello world" -l "fr"
; CL-Translate.exe -f "EULA.txt" -l 'ru' -o "%l - %f EULA.txt"
; CL-Translate.exe -f "License.txt" -l 'russian' -o "Ru - License.md"
; CL-Translate.exe -f "License.txt" -l 'swahili' -o "Ru - License.md"
; CL-Translate.exe -f "License.txt;EULA.rtf" -l 'sw' -o "sw-License.md"
; ======================================================================================
;  Some HAndles..

; -f 'sString as file handle.' | sFileName | FQPN
; -s 'sString' | String
; -o 'SString as file handle.' | sFileName | sOutPutFQPN
; -i sFileName | Input

Global $g_bDebug = _CmdLine_KeyExists('debug')

; Default is print to stdout
Global $b_gSaveToFile = False
Global $sDef_o, $s_gSaveAs

Select
	Case Not _CmdLine_GetValByIndex(1, False)
		MsgBox($MB_TOPMOST, @ScriptName, InitHelp(0))
		Exit
	Case _CmdLine_KeyExists('?')
		$hCout(InitHelp(0))
		Exit
	Case _CmdLine_KeyExists('ver') Or _CmdLine_KeyExists('version') Or _CmdLine_KeyExists('v')
		$hCout(FileGetVersion(@ScriptFullPath) & @CRLF)
		Exit (0)
	Case _CmdLine_KeyExists('o')
		$sDef_o = @ScriptDir & '\' & Random(10000000, 30999999, 1) & ".txt"
		$s_gSaveAs = _CmdLine_Get('o', $sDef_o)
		If Not _IsParam($s_gSaveAs) And $s_gSaveAs <> "" And UnvalidatedIsFile($s_gSaveAs) Then
			$b_gSaveToFile = True
		Else
			$s_gSaveAs = $sDef_o
			$b_gSaveToFile = True
		EndIf
EndSelect

If _CmdLine_KeyExists('s') Then ;  s = String
	Local $sLangPfx

	$sStrTL = _CmdLine_Get('s', Null)
	$sLangPfx = _CmdLine_Get('l', '')

	$vLangResult = _Lang2Prefix($sLangPfx)

	If $vLangResult = '' Or _IsParam($sStrTL) Or $sStrTL = Null Then
		If $g_bDebug Then $hCout(" > Missing / invalid arguments." & @CRLF)
		Exit
	ElseIf $vLangResult = "custom" Then
		$hCout(Yodanize($sStrTL) & @CRLF)
	Else
		If $b_gSaveToFile Then
			; CL-Translate.exe -f "EULA.txt" -l 'ru' -o "%l - %f EULA.txt"
			Select
				Case StringInStr($s_gSaveAs, '%f')
					$s_gSaveAs = StringReplace($s_gSaveAs, '%f', "")
				Case StringInStr($s_gSaveAs, '%l')
					$s_gSaveAs = StringReplace($s_gSaveAs, '%l', $vLangResult)
			EndSelect
			WriteToFile($s_gSaveAs, TransLate($sStrTL, 'auto', $vLangResult, 'Error Translating string'))
			$hCout("Saved to file : " & $s_gSaveAs & @CRLF)
		Else
			$hCout(TransLate($sStrTL, 'auto', $vLangResult, 'Error Translating string'))
		EndIf
	EndIf
	Exit
ElseIf _CmdLine_KeyExists('f') Then
	Local $sFilename = _CmdLine_Get('f', '')
	; companion param is -l | -o (optional)
	If $sFilename <> '' And Not _IsParam($sFilename) Then
		Local $aMtpleEnc = StringSplit($sFilename, ";", $STR_ENTIRESPLIT)
		If $aMtpleEnc[0] <> 0 Then
			For $i = 1 To $aMtpleEnc[0]
				If $aMtpleEnc[$i] <> '' Then
					If $hChk($aMtpleEnc[$i]) Then
						Switch IsFile($aMtpleEnc[$i])
							Case 1
								Switch StringLower(_GetFileExtension($aMtpleEnc[$i]))
									Case ".txt", ".lrc", ".rtf", ".md", ".ini" ; ".pdf", ".md", ".str"
										$sLangPfx = _CmdLine_Get('l', '')
										$vLangResult = _Lang2Prefix($sLangPfx)
										Select
											Case $vLangResult <> ''
												Local $sContent = sGetContent($aMtpleEnc[$i])
												If $sContent <> '' Then
													Local $res = TransLate($sContent, 'auto', $vLangResult, 'Error Translating string')
													$res = StringReplace($res, '09223118', @CRLF, 0, 2)
													If $b_gSaveToFile Then
														Select
															Case StringInStr($s_gSaveAs, '%f')
																; FQPN to filename.
																Local $sRep = StringRegExpReplace($aMtpleEnc[$i], "^.*\\", "")
																; strip extension
																$sRep = StringReplace($sRep, _GetFileExtension($sRep), "")
																
																$s_gSaveAs = StringReplace($s_gSaveAs, '%f', $sRep)
																ContinueCase
															Case StringInStr($s_gSaveAs, '%l')
																$s_gSaveAs = StringReplace($s_gSaveAs, '%l', StringUpper($vLangResult))
														EndSelect
														WriteToFile($s_gSaveAs, $res)
														$hCout("Saved to file : " & $s_gSaveAs & @CRLF)
													Else
														$hCout($res & @CRLF)
													EndIf
												Else
													If $g_bDebug Then $hCout(" File '" & $aMtpleEnc[$i] & "' is empty." & @CRLF)
												EndIf
											Case Else
												If $g_bDebug Then $hCout(" Could not resolve requested ISO prefix :'" & $sLangPfx & "'" & @CRLF)
												Exit (16)
										EndSelect
										; Case ".au3"
										; 	If $g_bDebug Then $hCout(" Processing comments .." & @CRLF)
										; 	; Translate autoit comments to all Comments + Index to specified language.
										; 	; Read all code comments with index
									Case Else
										If $g_bDebug Then $hCout( _
												" > Error : '" & $aMtpleEnc[$i] & "' : not supported file type." & @CRLF)
								EndSwitch
							Case Else                                                     ; is not a valid file.
								If $g_bDebug Then $hCout(" > Error : '" & $aMtpleEnc[$i] & "' is not valid." & @CRLF)
						EndSwitch
					Else                                                                 ; File given does not exist.5
						If $g_bDebug Then $hCout(" > Error : '" & $aMtpleEnc[$i] & "' not found." & @CRLF)
					EndIf
				EndIf
			Next
		EndIf
	Else
		$hCout(" > Error : Expected Arguments after '-f' parameter. Eg: [-f 'Example.xyz']" & @CRLF)
	EndIf
	Exit
EndIf
; $bHelp = _CmdLine_KeyExists('help')
; $bHelp2 = _CmdLine_KeyExists('?')
; $vFirArg = _CmdLine_GetValByIndex(1, False)
Exit

Func __Array2dToAinA(ByRef $A)
	If UBound($A, 0) <> 2 Then Return SetError(1, UBound($A, 0), False)
	Local $N = UBound($A), $u = UBound($A, 2)
	Local $a_Ret[$N]

	For $i = 0 To $N - 1
		Local $t[$u]
		For $j = 0 To $u - 1
			$t[$j] = $A[$i][$j]
		Next
		$a_Ret[$i] = $t
	Next
	Return $a_Ret
EndFunc   ;==>__Array2dToAinA

Func __ArrayAinATo2d(ByRef $A)
	If UBound($A, 0) <> 1 Then Return SetError(1, UBound($A, 0), False)
	Local $N = UBound($A)
	If $N < 1 Then Return SetError(2, $N, False)
	Local $u = UBound($A[0])
	If $u < 1 Then Return SetError(3, $u, False)

	Local $a_Ret[$N][$u]

	For $i = 0 To $N - 1
		Local $t = $A[$i]
		If UBound($t) > $u Then ReDim $a_Ret[$N][UBound($t)]
		For $j = 0 To UBound($t) - 1
			$a_Ret[$i][$j] = $t[$j]
		Next
	Next
	Return $a_Ret
EndFunc   ;==>__ArrayAinATo2d

Func __IsFolder($sFilePath)
	If StringInStr(FileGetAttrib($sFilePath), "D") = 0 Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>__IsFolder

; helper function for converting a AutoIt-sting into a json formatted string
Func __JSON_FormatString(ByRef $s_String)
	$s_String = StringReplace($s_String, '\', '\\', 0, 1)
	$s_String = StringReplace($s_String, Chr(8), "\b", 0, 1)
	$s_String = StringReplace($s_String, Chr(12), "\f", 0, 1)
	$s_String = StringReplace($s_String, @CRLF, "\n", 0, 1)
	$s_String = StringReplace($s_String, @CR, "\r", 0, 1)
	$s_String = StringReplace($s_String, '"', '\"', 0, 1)
EndFunc   ;==>__JSON_FormatString

; helper function for converting a json formatted string into an AutoIt-string
Func __JSON_ParseString(ByRef $s_String)
	Local $aB[5]

	Local $a_RE = StringRegExp($s_String, '\\\\(*SKIP)(?!)|(\\["bf/]|\\u\d{4})', 3)
	If Not @error Then
		For $s_Esc In $a_RE
			Switch StringMid($s_Esc, 2, 1)
				Case "b"
					If $aB[0] Then ContinueLoop
					$s_String = StringRegExpReplace($s_String, '\\\\(*SKIP)(?!)|(\\b)', Chr(8))
					$aB[0] = True
				Case "f"
					If $aB[1] Then ContinueLoop
					$s_String = StringRegExpReplace($s_String, '\\\\(*SKIP)(?!)|(\\f)', Chr(12))
					$aB[1] = True
				Case "/"
					If $aB[2] Then ContinueLoop
					$s_String = StringRegExpReplace($s_String, '\\\\(*SKIP)(?!)|(\\\/)', "/")
					$aB[2] = True
				Case '"'
					If $aB[3] Then ContinueLoop
					$s_String = StringRegExpReplace($s_String, '\\\\(*SKIP)(?!)|(\\")', '"')
					$aB[3] = True
				Case "u"
					If $aB[4] Then ContinueLoop
					$a_RE = StringRegExp($s_String, '\\\\(*SKIP)(?!)|\\u\K\d{4}', 3)
					If Not @error Then
						For $s_Code In $a_RE
							$s_String = StringReplace($s_String, "\u" & $s_Code, ChrW(Int($s_Code)), 0, 1)
						Next
						$aB[4] = True
					EndIf
			EndSwitch
		Next
	EndIf

	$s_String = StringFormat(StringReplace($s_String, "%", "%%", 0, 1))
	Return $s_String
EndFunc   ;==>__JSON_ParseString

Func _Base64Decode(Const ByRef $s_Input, Const $b_base64url = False)
	Local $h_DLL_Crypt32 = DllOpen("Crypt32.dll")
	Local $a_Ret = DllCall($h_DLL_Crypt32, "BOOLEAN", "CryptStringToBinary", _
			"STR", $s_Input, _ ; pszString
			"DWORD", 0, _ ; cchString
			"DWORD", 1, _ ; dwFlags
			"PTR", Null, _ ; pbBinary
			"DWORD*", 0, _ ; pcbBinary
			"PTR", Null, _ ; pdwSkip
			"PTR", Null) ; pdwFlags
	Local $t_Ret = DllStructCreate("BYTE Out[" & $a_Ret[5] & "]")
	If @error Or Not IsArray($a_Ret) Or $a_Ret[0] = 0 Then Return SetError(1, @error, DllClose($h_DLL_Crypt32))
	Local $a_Ret2 = DllCall($h_DLL_Crypt32, "BOOLEAN", "CryptStringToBinary", _
			"STR", $s_Input, _ ; pszString
			"DWORD", 0, _ ; cchString
			"DWORD", 1, _ ; dwFlags
			"STRUCT*", $t_Ret, _ ; pbBinary
			"DWORD*", $a_Ret[5], _ ; pcbBinary
			"PTR", Null, _ ; pdwSkip
			"PTR", Null) ; pdwFlags
	If @error Or Not IsArray($a_Ret2) Or $a_Ret2[0] = 0 Then Return SetError(2, @error, DllClose($h_DLL_Crypt32))
	DllClose($h_DLL_Crypt32)
	Local $s_Output = $t_Ret.Out
	If $b_base64url Then $s_Output = StringReplace(StringReplace($s_Output, "_", "/", 0, 1), "-", "+", 0, 1)

	Return $s_Output
EndFunc   ;==>_Base64Decode

Func _Base64Encode(Const ByRef $s_Input, Const $b_base64url = False)
	Local $b_Input = IsBinary($s_Input) ? $s_Input : Binary($s_Input)
	Local $t_BinArray = DllStructCreate("BYTE[" & BinaryLen($s_Input) & "]")
	DllStructSetData($t_BinArray, 1, $b_Input)
	Local $h_DLL_Crypt32 = DllOpen("Crypt32.dll")
	; first run to calculate needed size of output buffer
	Local $a_Ret = DllCall($h_DLL_Crypt32, "BOOLEAN", "CryptBinaryToString", _
			"STRUCT*", $t_BinArray, _     ; *pbBinary
			"DWORD", DllStructGetSize($t_BinArray), _     ; cbBinary
			"DWORD", 1, _     ; dwFlags
			"PTR", Null, _ ; pszString
			"DWORD*", 0)
	If @error Or Not IsArray($a_Ret) Or $a_Ret[0] = 0 Then Return SetError(1, @error, DllClose($h_DLL_Crypt32))
	; second run to calculate base64-string:
	Local $t_Output = DllStructCreate("CHAR Out[" & $a_Ret[5] & "]")
	Local $a_Ret2 = DllCall($h_DLL_Crypt32, "BOOLEAN", "CryptBinaryToString", _
			"STRUCT*", $t_BinArray, _     ; *pbBinary
			"DWORD", DllStructGetSize($t_BinArray), _     ; cbBinary
			"DWORD", 1, _     ; dwFlags
			"STRUCT*", $t_Output, _ ; pszString
			"DWORD*", $a_Ret[5])
	If @error Or Not IsArray($a_Ret2) Or $a_Ret2[0] = 0 Then Return SetError(2, @error, DllClose($h_DLL_Crypt32))
	Local $s_Output = $t_Output.Out
	If StringInStr($s_Output, "=", 1, 1) Then $s_Output = StringLeft($s_Output, StringInStr($s_Output, "=", 1, 1) - 1)
	If $b_base64url Then $s_Output = StringReplace(StringReplace($s_Output, "/", "_", 0, 1), "+", "-", 0, 1)
	DllClose($h_DLL_Crypt32)
	Return $s_Output
EndFunc   ;==>_Base64Encode

;  _____               _ _     _             ______ _            ______ _           _     _          _
; /  __ \             | | |   (_)            |  ___| |           |  _  (_)         | |   | |        | |
; | /  \/_ __ ___   __| | |    _ _ __   ___  | |_  | | __ _  __ _| | | |_ ___  __ _| |__ | | ___  __| |
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \ |  _| | |/ _` |/ _` | | | | / __|/ _` | '_ \| |/ _ \/ _` |
; | \__/\ | | | | | (_| | |___| | | | |  __/ | |   | | (_| | (_| | |/ /| \__ \ (_| | |_) | |  __/ (_| |
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___| \_|   |_|\__,_|\__, |___/ |_|___/\__,_|_.__/|_|\___|\__,_|
;                                        ______              __/ |
;                                       |______|            |___/

Func _CmdLine_FlagDisabled($sKey)
	For $i = 1 To $CmdLine[0]
		If $hRegeX($CmdLine[$i], "\-([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagDisabled

;  _____               _ _     _             ______ _             _____            _     _          _
; /  __ \             | | |   (_)            |  ___| |           |  ___|          | |   | |        | |
; | /  \/_ __ ___   __| | |    _ _ __   ___  | |_  | | __ _  __ _| |__ _ __   __ _| |__ | | ___  __| |
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \ |  _| | |/ _` |/ _` |  __| '_ \ / _` | '_ \| |/ _ \/ _` |
; | \__/\ | | | | | (_| | |___| | | | |  __/ | |   | | (_| | (_| | |__| | | | (_| | |_) | |  __/ (_| |
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___| \_|   |_|\__,_|\__, \____/_| |_|\__,_|_.__/|_|\___|\__,_|
;                                        ______              __/ |
;                                       |______|            |___/
Func _CmdLine_FlagEnabled($sKey)
	For $i = 1 To $CmdLine[0]
		If $hRegeX($CmdLine[$i], "\+([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagEnabled

;  _____               _ _     _             ______ _             _____     _     _
; /  __ \             | | |   (_)            |  ___| |           |  ___|   (_)   | |
; | /  \/_ __ ___   __| | |    _ _ __   ___  | |_  | | __ _  __ _| |____  ___ ___| |_ ___
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \ |  _| | |/ _` |/ _` |  __\ \/ / / __| __/ __|
; | \__/\ | | | | | (_| | |___| | | | |  __/ | |   | | (_| | (_| | |___>  <| \__ \ |_\__ \
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___| \_|   |_|\__,_|\__, \____/_/\_\_|___/\__|___/
;                                        ______              __/ |
;                                       |______|            |___/
Func _CmdLine_FlagExists($sKey)
	For $i = 1 To $CmdLine[0]
		If $hRegeX($CmdLine[$i], "(\+|\-)([a-zA-Z]*)" & $sKey & "([a-zA-Z]*)") Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_FlagExists
;  _____               _ _     _            _____      _
; /  __ \             | | |   (_)          |  __ \    | |
; | /  \/_ __ ___   __| | |    _ _ __   ___| |  \/ ___| |_
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \ | __ / _ \ __|
; | \__/\ | | | | | (_| | |___| | | | |  __/ |_\ \  __/ |_
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___|\____/\___|\__|

Func _CmdLine_Get($sKey, $mDefault = Null)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = "/" & $sKey Or $CmdLine[$i] = "-" & $sKey Then ; Or $CmdLine[$i] = "--" & $sKey
			If $CmdLine[0] >= $i + 1 Then
				Return $CmdLine[$i + 1]
			EndIf
		EndIf
	Next
	Return $mDefault
EndFunc   ;==>_CmdLine_Get

;  _____               _ _     _             _____      _   _   _       _______      _____          _
; /  __ \             | | |   (_)           |  __ \    | | | | | |     | | ___ \    |_   _|        | |
; | /  \/_ __ ___   __| | |    _ _ __   ___ | |  \/ ___| |_| | | | __ _| | |_/ /_   _ | | _ __   __| | _____  __
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \| | __ / _ \ __| | | |/ _` | | ___ \ | | || || '_ \ / _` |/ _ \ \/ /
; | \__/\ | | | | | (_| | |___| | | | |  __/| |_\ \  __/ |_\ \_/ / (_| | | |_/ / |_| || || | | | (_| |  __/>  <
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___| \____/\___|\__|\___/ \__,_|_\____/ \__, \___/_| |_|\__,_|\___/_/\_\
;                                        ______                                  __/ |
;                                       |______|                                |___/

Func _CmdLine_GetValByIndex($iIndex, $mDefault = Null)
	If $CmdLine[0] >= $iIndex Then
		Return $CmdLine[$iIndex]
	Else
		Return $mDefault
	EndIf
EndFunc   ;==>_CmdLine_GetValByIndex

;  _____               _ _     _            _   __           _____     _     _
; /  __ \             | | |   (_)          | | / /          |  ___|   (_)   | |
; | /  \/_ __ ___   __| | |    _ _ __   ___| |/ /  ___ _   _| |____  ___ ___| |_ ___
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \    \ / _ \ | | |  __\ \/ / / __| __/ __|
; | \__/\ | | | | | (_| | |___| | | | |  __/ |\  \  __/ |_| | |___>  <| \__ \ |_\__ \
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___\_| \_/\___|\__, \____/_/\_\_|___/\__|___/
;                                                       __/ |
;                                                      |___/
Func _CmdLine_KeyExists($sKey)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = "/" & $sKey Or $CmdLine[$i] = "-" & $sKey Then ; or $CmdLine[$i] = "--" & $sKey
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_KeyExists

;  _____               _ _     _             _   _       _            _____     _     _
; /  __ \             | | |   (_)           | | | |     | |          |  ___|   (_)   | |
; | /  \/_ __ ___   __| | |    _ _ __   ___ | | | | __ _| |_   _  ___| |____  ___ ___| |_ ___
; | |   | '_ ` _ \ / _` | |   | | '_ \ / _ \| | | |/ _` | | | | |/ _ \  __\ \/ / / __| __/ __|
; | \__/\ | | | | | (_| | |___| | | | |  __/\ \_/ / (_| | | |_| |  __/ |___>  <| \__ \ |_\__ \
;  \____/_| |_| |_|\__,_\_____/_|_| |_|\___| \___/ \__,_|_|\__,_|\___\____/_/\_\_|___/\__|___/
Func _CmdLine_ValueExists($sValue)
	For $i = 1 To $CmdLine[0]
		If $CmdLine[$i] = $sValue Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>_CmdLine_ValueExists

Func _GetFileExtension($sFileName_)
	Local $fl_Ext = ''
	For $YLoop = StringLen($sFileName_) To 1 Step -1
		If StringMid($sFileName_, $YLoop, 1) == "." Then
			$fl_Ext = StringMid($sFileName_, $YLoop)
			$YLoop = 1
		EndIf
	Next
	Return $fl_Ext
EndFunc   ;==>_GetFileExtension

Func _IsParam($sStr)
	Local $ret = False
	Switch StringLeft($sStr, 1)
		Case "-", "/"
			$ret = True
	EndSwitch
	Return $ret
EndFunc   ;==>_IsParam

Func _JSON_Generate(ByRef $o_Object, $s_ObjIndent = @TAB, $s_ObjDelEl = @CRLF, $s_ObjDelKey = "", $s_ObjDelVal = " ", $s_ArrIndent = @TAB, $s_ArrDelEl = @CRLF, $i_Level = 0)
	Local Static $s_JSON_String
	If $i_Level = 0 Then $s_JSON_String = ""

	Select
		Case IsString($o_Object) ; String
			__JSON_FormatString($o_Object)
			$s_JSON_String &= '"' & $o_Object & '"'

		Case IsNumber($o_Object) ; Number
			$s_JSON_String &= String($o_Object)
			; $s_JSON_String &= StringRegExpReplace(StringFormat("%g", $o_Object), '(-?(?>0|[1-9]\d*)(?>\.\d+)?)(?:([eE][-+]?)0*(\d+))?', "$1$2$3", 1)
		Case IsBool($o_Object) ; True/False
			$s_JSON_String &= StringLower($o_Object)

		Case IsKeyword($o_Object) = 2 ; Null
			$s_JSON_String &= "null"

		Case IsBinary($o_Object)
			$s_JSON_String &= '"' & _Base64Encode($o_Object) & '"'

		Case IsArray($o_Object) And UBound($o_Object, 0) < 3 ; Array
			If UBound($o_Object, 0) = 2 Then $o_Object = __Array2dToAinA($o_Object)
			If UBound($o_Object) = 0 Then
				$s_JSON_String &= "[]"
			Else
				$s_JSON_String &= "[" & $s_ArrDelEl
				For $o_Value In $o_Object
					$s_JSON_String &= _StringRepeat($s_ArrIndent, $i_Level + 1)
					_JSON_Generate($o_Value, $s_ObjIndent, $s_ObjDelEl, $s_ObjDelKey, $s_ObjDelVal, $s_ArrIndent, $s_ArrDelEl, $i_Level + 1)

					$s_JSON_String &= "," & $s_ArrDelEl
				Next
				$s_JSON_String = StringTrimRight($s_JSON_String, StringLen("," & $s_ArrDelEl)) & $s_ArrDelEl & _StringRepeat($s_ArrIndent, $i_Level) & "]"
			EndIf
		Case IsObj($o_Object) And ObjName($o_Object) = "Dictionary" ; Object
			Local $s_KeyTemp, $o_Value
			If $o_Object.Count() = 0 Then
				$s_JSON_String &= "{}"
			Else
				$s_JSON_String &= "{" & $s_ObjDelEl
				For $s_Key In $o_Object.Keys
					$s_KeyTemp = $s_Key
					$o_Value = $o_Object($s_Key)
					__JSON_FormatString($s_KeyTemp)

					$s_JSON_String &= _StringRepeat($s_ObjIndent, $i_Level + 1) & '"' & $s_KeyTemp & '"' & $s_ObjDelKey & ':' & $s_ObjDelVal

					_JSON_Generate($o_Value, $s_ObjIndent, $s_ObjDelEl, $s_ObjDelKey, $s_ObjDelVal, $s_ArrIndent, $s_ArrDelEl, $i_Level + 1)

					$s_JSON_String &= "," & $s_ObjDelEl
				Next
				$s_JSON_String = StringTrimRight($s_JSON_String, StringLen("," & $s_ObjDelEl)) & $s_ObjDelEl & _StringRepeat($s_ObjIndent, $i_Level) & "}"
			EndIf
		Case Else
	EndSelect

	If $i_Level = 0 Then
		Local $s_Temp = $s_JSON_String
		$s_JSON_String = ""
		Return $s_Temp
	EndIf
EndFunc   ;==>_JSON_Generate

Func _JSON_Get(ByRef $o_Object, Const $s_Pattern)
	Local $o_Current = $o_Object, $d_Val
	Local $a_Tokens = StringRegExp($s_Pattern, '(?:(?<Key>\b[^\.\[\]]+\b\+?)|\[(?<Index>\d+)\])', 4)
	If @error Then Return SetError(1, @error, "")
	For $a_CurToken In $a_Tokens
		If UBound($a_CurToken) = 2 Then ; KeyName
			If Not IsObj($o_Current) Or ObjName($o_Current) <> "Dictionary" Then Return SetError(2, 0, "")
			If Not $o_Current.Exists($a_CurToken[1]) Then Return SetError(3, 0, "")
			$o_Current = $o_Current($a_CurToken[1])
		ElseIf UBound($a_CurToken) = 3 Then ; ArrayIndex
			If (Not IsArray($o_Current)) Or UBound($o_Current, 0) <> 1 Then Return SetError(4, UBound($o_Current, 0), "")
			$d_Val = Int($a_CurToken[2])
			If $d_Val < 0 Or $d_Val >= UBound($o_Current) Then Return SetError(5, $d_Val, "")
			$o_Current = $o_Current[$d_Val]
		EndIf
	Next
	Return $o_Current
EndFunc   ;==>_JSON_Get

Func _JSON_Parse(ByRef $s_String, $i_Os = 1)
	Local $i_OsC = $i_Os, $o_Current
	; Inside a character class, \R is treated as an unrecognized escape sequence, and so matches the letter "R" by default, but causes an error if
	Local Static $s_RE_s = '[\x20\r\n\t]', _ ;  = [\x20\x09\x0A\x0D]
			$s_RE_G_String = '\G[\x20\r\n\t]*"((?>[^\\"]+|\\.)*)"', _    ; only for real valid JSON: "((?>[^\\"]+|\\[\\"bfnrtu\/])*)"        second (a little slower) alternative: "((?>[^\\"]+|\\\\|\\.)*)"
			$s_RE_G_Number = '\G[\x20\r\n\t]*(-?(?>0|[1-9]\d*)(?>\.\d+)?(?>[eE][-+]?\d+)?)', _
			$s_RE_G_KeyWord = '\G[\x20\r\n\t]*\b(null|true|false)\b', _
			$s_RE_G_Object_Begin = '\G[\x20\r\n\t]*\{', _
			$s_RE_G_Object_Key = '\G[\x20\r\n\t]*"((?>[^\\"]+|\\.)+)"[\x20\r\n\t]*:', _
			$s_RE_G_Object_Further = '\G[\x20\r\n\t]*,', _
			$s_RE_G_Object_End = '\G[\x20\r\n\t]*\}', _
			$s_RE_G_Array_Begin = '\G[\x20\r\n\t]*\[', _
			$s_RE_G_Array_End = '\G[\x20\r\n\t]*\]'

	$o_Current = StringRegExp($s_String, $s_RE_G_String, 1, $i_Os) ; String
	If Not @error Then Return SetExtended(@extended, __JSON_ParseString($o_Current[0]))

	StringRegExp($s_String, $s_RE_G_Object_Begin, 1, $i_Os) ; Object
	If Not @error Then
		$i_OsC = @extended

		Local $s_Key, $o_Value, $a_T
		$o_Current = ObjCreate("Scripting.Dictionary")

		StringRegExp($s_String, $s_RE_G_Object_End, 1, $i_OsC) ; check for empty object
		If Not @error Then ; empty object
			$i_OsC = @extended
		Else
			Do
				$a_T = StringRegExp($s_String, $s_RE_G_Object_Key, 1, $i_OsC) ; key of element
				If @error Then Return SetError(2, $i_OsC, "")
				$i_OsC = @extended

				$s_Key = __JSON_ParseString($a_T[0])

				$o_Value = _JSON_Parse($s_String, $i_OsC)
				If @error Then Return SetError(3, $i_OsC, "")
				$i_OsC = @extended

				$o_Current($s_Key) = $o_Value ; add key:value to dictionary

				StringRegExp($s_String, $s_RE_G_Object_Further, 1, $i_OsC) ; more elements
				If Not @error Then
					$i_OsC = @extended
					ContinueLoop
				Else
					StringRegExp($s_String, $s_RE_G_Object_End, 1, $i_OsC) ; end of array
					If Not @error Then
						$i_OsC = @extended
						ExitLoop
					Else
						Return SetError(4, $i_OsC, "")
					EndIf
				EndIf
			Until False
		EndIf
		Return SetExtended($i_OsC, $o_Current)
	EndIf

	StringRegExp($s_String, $s_RE_G_Array_Begin, 1, $i_Os) ; Array
	If Not @error Then
		$i_OsC = @extended

		Local $o_Current[1], $d_N = 1, $i_C = 0

		StringRegExp($s_String, $s_RE_G_Array_End, 1, $i_OsC) ; check for empty array
		If Not @error Then ; empty array
			ReDim $o_Current[0]
			$i_OsC = @extended
			Return SetExtended($i_OsC, $o_Current)
		EndIf

		Do
			$o_Value = _JSON_Parse($s_String, $i_OsC)
			If @error Then Return SetError(3, $i_OsC, "")
			$i_OsC = @extended

			If $i_C = $d_N - 1 Then
				$d_N *= 2
				ReDim $o_Current[$d_N]
			EndIf
			$o_Current[$i_C] = $o_Value
			$i_C += 1

			StringRegExp($s_String, $s_RE_G_Object_Further, 1, $i_OsC) ; more elements
			If Not @error Then
				$i_OsC = @extended
				ContinueLoop
			Else
				StringRegExp($s_String, $s_RE_G_Array_End, 1, $i_OsC) ; end of array
				If Not @error Then
					$i_OsC = @extended
					ExitLoop
				Else
					Return SetError(5, $i_OsC, "")
				EndIf
			EndIf

		Until False
		If UBound($o_Current) <> $i_C Then ReDim $o_Current[$i_C]
		Return SetExtended($i_OsC, $o_Current)
	EndIf

	$o_Current = StringRegExp($s_String, $s_RE_G_Number, 1, $i_Os) ; Number
	If Not @error Then Return SetExtended(@extended, Number($o_Current[0], 0))

	$o_Current = StringRegExp($s_String, $s_RE_G_KeyWord, 1, $i_Os) ; KeyWord
	If Not @error Then Return SetExtended(@extended, Execute($o_Current[0])) ; $o_Current[0] = "null" ? Null : $o_Current[0] = "true" ? True : False)

	Return SetError(1, $i_OsC, "")
EndFunc   ;==>_JSON_Parse

Func _UnicodeURLEncode($UnicodeURL)
	; From my copied snippets
	Local $UnicodeBinary = StringToBinary($UnicodeURL, 4)
	Local $UnicodeBinary2 = StringReplace($UnicodeBinary, '0x', '', 1)
	Local $UnicodeBinaryLength = StringLen($UnicodeBinary2)
	Local $EncodedString, $UnicodeBinaryChar

	For $i = 1 To $UnicodeBinaryLength Step 2
		$UnicodeBinaryChar = StringMid($UnicodeBinary2, $i, 2)
		If StringInStr("$-_.+!*'(),;/?:@=&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", BinaryToString('0x' & $UnicodeBinaryChar, 4)) Then
			$EncodedString &= BinaryToString('0x' & $UnicodeBinaryChar)
		Else
			$EncodedString &= '%' & $UnicodeBinaryChar
		EndIf
	Next
	Return $EncodedString
EndFunc   ;==>_UnicodeURLEncode

Func Get_filetype($sFilename)
	Local $sFileName_ = $hRegexRp($sFilename, ".*\\", "")
	Return StringRight($sFileName_, 4) ; returns name from fqpn
EndFunc   ;==>Get_filetype

;  _____      _____                            _           _
; |_   _|    / ____|                          | |         | |
;   | |  ___| |     ___  _ __  _ __   ___  ___| |_ ___  __| |
;   | | / __| |    / _ \| '_ \| '_ \ / _ \/ __| __/ _ \/ _` |
;  _| |_\__ \ |___| (_) | | | | | | |  __/ (__| ||  __/ (_| |
; |_____|___/\_____\___/|_| |_|_| |_|\___|\___|\__\___|\__,_|
;                                                         ______
;                                                        |______|
Func IsConnected()
	Local $aRet, $iResult

	$aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)
	Select
		Case BitAND($aRet[1], $eNETWORK_ALIVE_LAN)
			$iResult &= "LAN connected" & @LF
		Case BitAND($aRet[1], $eNETWORK_ALIVE_WAN)
			$iResult &= "WAN connected" & @LF
		Case BitAND($aRet[1], $eNETWORK_ALIVE_AOL)
			$iResult &= "AOL connected" & @LF
	EndSelect
	Return $iResult
EndFunc   ;==>IsConnected

Func IsFile($sFilePath)
	Return Int($hChk($sFilePath) And $hSrchStr(FileGetAttrib($sFilePath), 'D', Default, 1) = 0)
EndFunc   ;==>IsFile

Func TransLate($sTextStr, $sFromLang = 'auto', $sToLang = 'en', $sDefalutReturn = 'Null')
	$sTextStr = BinaryToString(StringToBinary($sTextStr, 4), 1)
	$sClient = "gtx"
	$g_sOutput = ""
	$g_Url = "https://translate.googleapis.com/translate_a/single?client=" & $sClient & "&sl=" & $sFromLang & "&tl=" & $sToLang & "&dt=t&q=" & $sTextStr
	$g_oHTTP = ObjCreate("Microsoft.XMLHTTP")
	$g_oHTTP.Open("POST", $g_Url, False)
	$g_oHTTP.Send()
	$g_sResponse = $g_oHTTP.ResponseText
	$g_JSONData = _JSON_Parse($g_sResponse)
	If VarGetType($g_JSONData) = 'Array' Then
		$g_aData = $g_JSONData[0]
		If VarGetType($g_aData) = 'Array' Then
			For $i = 0 To UBound($g_aData) - 1 Step 1
				$g_sOutput &= ($g_aData[$i])[0] & @CRLF
			Next
		EndIf
	EndIf
	$ret = StringReplace($g_sOutput, '[@CRLF]', @CRLF)
	$ret = BinaryToString(StringToBinary($ret, 4), 1)
	Return $ret
EndFunc   ;==>TransLate

; ========================================================================================
; 		Check if the filepath is a file. Does not validate if the file exists.
; ========================================================================================
Func UnvalidatedIsFile($sFilePath)
	Return StringInStr(FileGetAttrib($sFilePath), "D") = 0
EndFunc   ;==>UnvalidatedIsFile
; ========================================================================================

Func WriteToFile($sFilename, $sContent)
	$hFilehandle = FileOpen($sFilename, $FO_OVERWRITE + $FO_ANSI)
	If FileExists($sFilename) Then
		FileWrite($hFilehandle, $sContent)
	Else
		If $g_bDebug Then $hCout(" Failed to create file. '" & $sFilename & "'" & @CRLF)
	EndIf
	FileClose($hFilehandle)
	Return
EndFunc   ;==>WriteToFile

;
; {
;     "success": {
;         "total": 1
;     },
;     "contents": {
;         "translated": "Lost a planet,  master obiwan has.",
;         "text": "Master Obiwan has lost a planet.",
;         "translation": "yoda"
;     }
; }

; {
;     "error": {
;         "code": 429,
;         "message": "Too Many Requests: Rate limit of 5 requests per hour exceeded . Please wait for 59 minutes and 56 seconds."
;     }
; }

; For public calls you don't need to pass any API key. Just invoke the endpoint
; (see examples below). For paid subscriptions you need to pass the API key.

;  {
;     "success": {
;         "total": 1
;     },
;     "contents": {
;         "translated": "Force be with you world",
;         "text": "hello world",
;         "translation": "yoda"
;     }
; }
; https://api.funtranslations.com/translate/yoda.json?text=hello%20world
Func Yodanize($sString)
	$sTextStr = BinaryToString(StringToBinary($sString, 4), 1)

	$g_sOutput = ""
	$sString = StringReplace($sString, " ", "%20")
	MsgBox(0, "translating :", $sString)

	$g_Url = "https://api.funtranslations.com/translate/yoda.json?text=" & $sString

	$g_oHTTP = ObjCreate("Microsoft.XMLHTTP")
	$g_oHTTP.Open("POST", $g_Url, False)
	$g_oHTTP.Send()
	$g_sResponse = $g_oHTTP.ResponseText

	MsgBox(0, "1", $g_sResponse)

	$g_JSONData = _JSON_Parse('[' & $g_sResponse & ']')
	MsgBox(0, "2", $g_JSONData)
	Return
	; If VarGetType($g_JSONData) = 'Array' Then
	; 	$g_aData = $g_JSONData[0]
	; 	If VarGetType($g_aData) = 'Array' Then
	; 		For $i = 0 To UBound($g_aData) - 1 Step 1
	; 			$g_sOutput &= ($g_aData[$i])[0] & @CRLF
	; 		Next
	; 	EndIf
	; EndIf
	; MsgBox(0, "", $g_sOutput)
	; Return $g_sOutput
	; Global $sURLEndPoint = "https://api.funtranslations.com/translate/yoda.json?" &
	; https://api.funtranslations.com/translate/yoda.json?text=Master%20Obiwan%20has%20lost%20a%20planet.
EndFunc   ;==>Yodanize
