
Global $hCout = ConsoleWrite   ; Cout Var, mod 4 Color output.
Global $hChk = FileExists      ; make custom func
Global $hSrchStr = StringInStr ; sting finder..
Global $hErr = SetError        ; / Exit (%errorlevel%)
Global $hRegexRp = StringRegExpReplace ; For Regular Expressions.
Global $hRegeX = StringRegExp
Global $hOpenDoc = FileOpen
Global $hClean = StringReplace
Global $sSaveToDirDefault, $sSaveToDir


; Payload is the ISO 639-1 code of the desiredLang – (if is supported by Google Translate)
Func _Lang2Prefix($sLang)
	Local $ret = ''
	; Format : ISO language name , 639-1, 639-2/T, 639-2/B,
	Switch $sLang
		Case 'en', 'English' ; done
			$ret = 'en'
		Case 'af', 'Afrikaans', 'afr' ; done
			$ret = 'af'
		Case 'sq', 'Albanian', 'sqi', 'alb' ; done
			$ret = 'sq'
		Case 'am', 'Amharic', 'amh' ; done
			$ret = 'am'
		Case 'ar', 'Arabic', 'ara' ; done
			$ret = 'ar'
		Case 'hy', 'Armenian', 'hye', 'arm' ; done
			$ret = 'hy'
		Case 'az', 'Azerbaijani', 'aze' ; done
			$ret = 'az'
		Case 'eu', 'Basque', 'eus', 'baq' ; done
			$ret = 'eu'
		Case 'be', 'Belarusian', 'bel' ; done
			$ret = 'be'
		Case 'bn', 'Bengali', 'ben' ; done
			$ret = 'bn'
		Case 'bs', 'Bosnian', 'bos' ; done
			$ret = 'bs'
		Case 'bg', 'Bulgarian', 'bul' ; done
			$ret = 'bg'
		Case 'ca', 'Catalan', 'Valencian', 'cat'  ; done
			$ret = 'ca'
		Case 'ceb', 'Cebuano'
			$ret = 'ceb'
		Case 'ny', 'Chichewa', 'nya' ; done
			$ret = 'ny'
		Case 'co', 'Corsican', 'cos' ; done
			$ret = 'co'
		Case 'hr', 'Croatian', 'hrv' ; done
			$ret = 'hr'
		Case 'cs', 'Czech', 'ces', 'cze' ; done
			$ret = 'cs'
		Case 'da', 'Danish', 'dan' ; done
			$ret = 'da'
		Case 'nl', 'Dutch', 'Flemish', 'nld', 'dut'  ; done
			$ret = 'nl'
		Case 'eo', 'Esperanto', 'epo' ; done
			$ret = 'eo'
		Case 'et', 'Estonian', 'est' ; done
			$ret = 'et'
		Case 'tl', 'Filipino' ; *
			$ret = 'tl'
		Case 'fi', 'Finnish', 'fin' ; done
			$ret = 'fi'
		Case 'fr', 'french', 'fre', 'fra' ; done
			$ret = 'fr'
		Case 'fy', 'Frisian', 'fry' ; done
			$ret = 'fy'
		Case 'gl', 'Galician', 'glg' ; done
			$ret = 'gl'
		Case 'ka', 'Georgian', 'gl', 'glg' ; done
			$ret = 'ka'
		Case 'de', 'German', 'deu', 'ger' ; done
			$ret = 'de'
			; Case 'el', 'Greek', ''
			; 	$ret = 'el'
			; Case 'gu', 'Gujarati'
			; 	$ret = 'gu'
		Case 'ht', 'Haitian Creole', 'hat' ; done
			$ret = 'ht'
		Case 'ha', 'Hausa', 'hau' ; done
			$ret = 'ha'
		Case 'haw', 'Hawaiian' ; done
			$ret = 'haw'
		Case 'iw', 'Hebrew'
			$ret = 'iw'
			; Case 'hi', 'Hindi'
			; 	$ret = 'hi'
		Case 'hmn', 'Hmong' ; done
			$ret = 'hmn'
		Case 'hu', 'Hungarian', 'hun' ; done
			$ret = 'hu'
		Case 'is', 'Icelandic', 'isl', 'ice' ; done
			$ret = 'is'
		Case 'ig', 'Igbo', 'ibo' ; done
			$ret = 'ig'
		Case 'id', 'Indonesian' , 'ind' ; done
			$ret = 'id'
		Case 'ga', 'Irish', 'gle' ;done
			$ret = 'ga'
		Case 'it', 'Italian', 'ita' ; done
			$ret = 'it'
		; Case 'ja', 'Japanese', '' ; done
		; 	$ret = 'ja'
		Case 'jw', 'Javanese', 'ja', 'jav' ; done
			$ret = 'jw'
		; Case 'kn', 'Kannada'
		; 	$ret = 'kn'
		; Case 'kk', 'Kazakh'
		; 	$ret = 'kk'
		Case 'km', 'Khmer'
			$ret = 'km'
		; Case 'ko', 'Korean'
		; 	$ret = 'ko'
		; Case 'ky', 'Kyrgyz'
		; 	$ret = 'ky'
		; Case 'lo', 'Lao'
		; 	$ret = 'lo'
		Case 'la', 'Latin', 'lat' ; done
			$ret = 'la'
		Case 'lv', 'Latvian', 'lav' ; done
			$ret = 'lv'
		Case 'lt', 'Lithuanian', 'lit' ; done
			$ret = 'lt'
		Case 'lb', 'Luxembourgish', 'ltz' ; done
			$ret = 'lb'
		; Case 'mk', 'Macedonian', ''
		; 	$ret = 'mk'
		Case 'mg', 'Malagasy', 'mlg' ; done
			$ret = 'mg'
		Case 'ms', 'Malay', 'msa','may' ; done
			$ret = 'ms'
		; Case 'ml', 'Malayalam'
		; 	$ret = 'ml'
		Case 'mt', 'Maltese', 'mlt' ; done
			$ret = 'mt'
		Case 'mi', 'Maori', 'mri', 'mao' ; done
			$ret = 'mi'
		; Case 'mr', 'Marathi'
		; 	$ret = 'mr'
		; Case 'mn', 'Mongolian'
		; 	$ret = 'mn'
		; Case 'ne', 'Nepali'
		; 	$ret = 'ne'
		Case 'no', 'Norwegian', 'nor' ; done
			$ret = 'no'
		; Case 'fa', 'Persian'
		; 	$ret = 'fa'
		Case 'pl', 'Polish', 'pol' ;done
			$ret = 'pl'
		Case 'pt', 'Portuguese', 'por' ; done
			$ret = 'pt'
		; Case 'ma', 'Punjabi'
		; 	$ret = 'ma'
		Case 'ro', 'Romanian', 'moldavian', 'ron' , 'rum' ; done
			$ret = 'ro'
		; Case 'ru', 'Russian'
		; 	$ret = 'ru'
		; Case 'sr', 'Serbian'
		; 	$ret = 'sr'
		Case 'st', 'Sesotho', 'sot' ; done
			$ret = 'st'
		; Case 'sd', 'Sindhi'
		; 	$ret = 'sd'
		; Case 'si', 'Sinhala'
		; 	$ret = 'si'
		Case 'sk', 'Slovak', 'slk', 'slo' ; done
			$ret = 'sk'
		Case 'sl', 'Slovenian' ;done
			$ret = 'sl'
		Case 'so', 'Somali', 'som' ; done
			$ret = 'so'
		Case 'es', 'Spanish', 'Castilian', 'spa' ; done
			$ret = 'es'
		Case 'su', 'Sundanese', 'sun' ; done
			$ret = 'su'
		Case 'sw', 'Swahili', 'kiswahili' ; done
			$ret = 'sw'
		Case 'sv', 'Swedish', 'swe' ; done
			$ret = 'sv'
		; Case 'tg', 'Tajik'
		; 	$ret = 'tg'
		; Case 'ta', 'Tamil'
		; 	$ret = 'ta'
		; Case 'te', 'Telugu'
		; 	$ret = 'te'
		; Case 'th', 'Thai'
		; 	$ret = 'th'
		Case 'tr', 'Turkish', 'tur' ; done
			$ret = 'tr'
		; Case 'uk', 'Ukrainian'
		; 	$ret = 'uk'
		; Case 'ur', 'Urdu'
		; 	$ret = 'ur'
		Case 'uz', 'Uzbek', 'uzb' ; done
			$ret = 'uz'
		Case 'vi', 'Vietnamese', 'vie' ; done
			$ret = 'vi'
		Case 'cy', 'Welsh', 'cym', 'wel' ;done
			$ret = 'cy'
		Case 'xh', 'Xhosa', 'xho' ; done
			$ret = 'xh'
		; Case 'yi', 'Yiddish' ; done
		; 	$ret = 'yi'
		; Case 'yo', 'Yoruba'
		; 	$ret = 'yo'
		Case 'zu', 'Zulu', 'zul'
			$ret = 'zu'
		Case Else
			$ret = "Null"
	EndSwitch
	Return StringLower($ret)
EndFunc   ;==>_Lang2Prefix



Func InterceptEventError()
	If Not IsConnected() Then
		If $g_bDebug Then
			$hCout("Error : Connection failure.              " & @CRLF)
		EndIf
		Exit (404)
	Else
		$hCout("Could not load a necessary object resource for operation." & @CRLF)
		Exit (405)
	EndIf
EndFunc   ;==>InterceptEventError
