;;기능 1.	"ㅈㅈㅈ." 입력하면 무조건 "www."로 변경됨. 이후 영어로 키입력 전환
;;기능 2.	'윈도우'키 + '스페이스'키 = 무조건 '한글'로 처음 입력. 이후 소리로 한영상태 확인
;;	(=우측하단 알트키 -> 무조건 한글 시작)
;;기능 3.	'알트'키 + '스페이스'키   = 무조건 '영어'로 처음 입력. 이후 소리로 한영상태 확인
;;	(=우측하단 컨트롤키 -> 무조건 한글 시작)
;;기능 4.	'쉬프트'키 + '스페이스'키 = '한/영'키처럼 언어 전환. 이후 소리로 한영상태 확인
;;	(한/영 키를 누를 때도 소리로 한영상태 확인)
;;기능 5.	'윈도우'키 + 'ESC' 누르면, 이 프로그램은 종료
;;	'윈도우'키 + ' ` ' 누르면, 이 프로그램은 멈춤
;;기능 6.	'트레이 아이콘'에 '한/영' 표시 (종료 기능)
;;기능 7.	'마우스 커서'에 '한/영 대소문자' 표시됨
;;기능 8.	"네이버", "다음", '영어'이던지 '한글'이던지, 뒤에 '마침표' 찍으면 해당 싸이트 이동.
;;(예1. 네이버. -> www.naver.com) (예2. spdlqj. -> www.naver.com)
;;기능 9.	'언어' 변환시에 beep 표시 듣기 가능 (한글 beep*2, 영어 beep*1)
;;기능 10.	"네이버", "다음", "구글" 자주가는 사이트 단축키 설정
;;기능 11.	우측하단 윈도우키 : 한 단어 한영 타이핑 전환. 이후 소리로 한영상태 확인
;;	(=왼쪽하단 컨트럴키+스페이스키)
;;기능 12.	우측하단 메뉴키  : 한 줄 한영 타이핑 전환. 이후 소리로 한영상태 확인

;;코딩 초기
;;================================================
;;무조건 새것으로 실행
#SingleInstance, Force
#NoEnv
SetBatchLines, -1
ListLines, Off
#persistent

;;IMECur_v0.71에서 따옴
;;================================================
Ico = %A_ScriptDir%\ez_key.ico
Ini = %A_ScriptDir%\ez_key.ini
Ver = 1.01
Link = http://about:blank/
SettingList =
(Join LTrim
GetIMEStatus,1,2,2|
ShowEnglishIBeam,0,1,1|
ShowJapaneseIBeam,0,1,1|
ShowKoreanIBeam,0,1,1|
PlayEnglishSound,0,1,0|
PlayJapaneseSound,0,1,0|
PlayKoreanSound,0,1,0|
ShowIMETrayIcon,0,1,1|
PlaySounds,0,1,0
)
Loop, Parse, SettingList, |
{
	StringSplit, $, A_LoopField, `,
	IniRead, %$1%, %Ini%, Settings, %$1%, %A_Space%
	If %$1% Is Integer
		If %$1% Between %$2% And %$3%
			Continue
	%$1% := $4
}
Menu, Tray, UseErrorLevel
Menu, Tray, NoStandard
Menu, Tray, Add, Sound Play, MenuPlaySounds
Menu, Tray, Add
Menu, Tray, Add, Setting, MenuSettings
;;Menu, Tray, Add
;;Menu, Tray, Add, About(&A), MenuAbout
;;Menu, Tray, Add
;;Menu, Tray, Add, Exit, MenuExit
Menu, Tray, Default, Sound Play
Menu, Tray, Icon, % A_IsCompiled ? A_ScriptFullPath : Ico
Menu, Tray, Tip, EZ_KEY
Menu, Tray, % PlaySounds = 1 ? "Check" : "UnCheck", Sound Play


Menu, Tray, add  ; Creates a separator line.
;;Menu, Tray, add, (&5) FindYouMed , FindYouMed
Menu, Tray, add, (&4) YouTube , YouTube
Menu, Tray, add, (&3) Daum , Daum
Menu, Tray, add, (&2) Google, Google
Menu, Tray, add, (&1) Naver, Naver
Menu, Tray, add, (&0) Chrome, moveChrome
Menu, Tray, add, Pause/Resume, PauseApp
Menu, Tray, add, (^ESC) Exit, ExitApp

;Menu, Tray, add  ; Creates a separator line.
;;Menu, Tray, add,  Exit (&ESC), ExitApp
Menu, Tray, add  ; Creates a separator line.
;;return

SetTimer, IMECheckTimer, 100
Return
Daum:
Run, http://www.daum.net
return
Google:
Run, http://www.google.com
return
Naver:
Run, http://www.naver.com
return
YouTube:
Run, http://youtube.com
return
;;FindYouMed:
;;Run, http://findyoumed.com
;;return

ExitApp:
exitapp
return

PauseApp:
pause
return

MenuPlaySounds:
PlaySounds := !PlaySounds
Menu, Tray, % PlaySounds = 1 ? "Check" : "UnCheck", Sound Play
IniWrite, %PlaySounds%, %Ini%, Settings, PlaySounds
Return

MenuSettings:
Gui, 1:+LastFoundExist
IfWinExist
{
	WinActivate
	Return
}
Gui, 2:+LastFoundExist
IfWinExist,,, Gosub, 2GuiClose
Gui, 1:-MinimizeBox
Gui, 1:Margin, 10, 10
Gui, 1:Font, s9, Gulim

Gui, 1:Add, GroupBox, xm ym w240 h230, Setup
Gui, 1:Add, Text, xp+15 yp+25 h15, Default IME Settings:
Gui, 1:Add, DropDownList, xp y+2 w210 r2 AltSubmit Choose%GetIMEStatus% vGetIMEStatus, Controls focused on the active window|Controls focused on the mouse cursor location
Gui, 1:Add, CheckBox, xp y+13 h15 Checked%ShowEnglishIBeam% vShowEnglishIBeam, English Cursor Display
Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowJapaneseIBeam% vShowJapaneseIBeam, Japanese Cursor Display
Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowKoreanIBeam% vShowKoreanIBeam, Korean Cursor Display
Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayEnglishSound% vPlayEnglishSound, English Sound Notification
Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayJapaneseSound% vPlayJapaneseSound, Japanese Sound Notification
Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayKoreanSound% vPlayKoreanSound, Korean Sound Notification
Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowIMETrayIcon% vShowIMETrayIcon, IME Tray Icon Display
Gui, 1:Add, Button, xm+85 ym+250 w75 h25 Default gButtonOK, OK
Gui, 1:Add, Button, x+5 yp wp hp gButtonCancel, Cancel
Gui, 1:Show,, EZ_KEY Setting %Ver%

;;Gui, 1:Add, GroupBox, xm ym w240 h230, 설정
;;Gui, 1:Add, Text, xp+15 yp+25 h15, IME 상태 가져오기:
;;Gui, 1:Add, DropDownList, xp y+2 w210 r2 AltSubmit Choose%GetIMEStatus% vGetIMEStatus, 활성 창의 포커싱된 컨트롤|마우스 커서 위치의 컨트롤
;;Gui, 1:Add, CheckBox, xp y+13 h15 Checked%ShowEnglishIBeam% vShowEnglishIBeam, 영어 커서 표시
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowJapaneseIBeam% vShowJapaneseIBeam, 일본어 커서 표시
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowKoreanIBeam% vShowKoreanIBeam, 한국어 커서 표시
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayEnglishSound% vPlayEnglishSound, 영어 소리 재생
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayJapaneseSound% vPlayJapaneseSound, 일본어 소리 재생
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%PlayKoreanSound% vPlayKoreanSound, 한국어 소리 재생
;;Gui, 1:Add, CheckBox, xp y+5 hp Checked%ShowIMETrayIcon% vShowIMETrayIcon, IME 트레이 아이콘 표시
;;Gui, 1:Add, Button, xm+85 ym+250 w75 h25 Default gButtonOK, 확인
;;Gui, 1:Add, Button, x+5 yp wp hp gButtonCancel, 취소
;;Gui, 1:Show,, EZ_KEY Setting %Ver%
Return



ButtonOK:
Gui, 1:Submit, NoHide
Loop, Parse, SettingList, |
{
	StringSplit, $, A_LoopField, `,
	IniWrite, % %$1%, %Ini%, Settings, %$1%
}
If (ShowIMETrayIcon = 0)
	SetTrayIcon()
Gui, 1:Destroy
Return

GuiClose:
GuiEscape:
ButtonCancel:
Gui, 1:Destroy
Return

MenuAbout:
Gui, 2:+LastFoundExist
IfWinExist
{
	WinActivate
	Return
}
Gui, 1:+LastFoundExist
IfWinExist,,, Gosub, GuiClose
Gui, 2:-MinimizeBox
Gui, 2:Margin, 10, 10
Gui, 2:Font, s9, Gulim
Gui, 2:Add, GroupBox, xm ym w240 h120
Gui, 2:Add, Picture, xp+15 yp+25 w32 h32 Icon1, % A_IsCompiled ? A_ScriptFullPath : Ico
Gui, 2:Add, Text, x+23 yp h15, EZ_KEY %Ver%
Gui, 2:Add, Text, xp y+5 hp, 한/영/일 마우스 커서
Gui, 2:Font, Underline
Gui, 2:Add, Text, xp y+25 h15 cBlue vLink gTextLink, %Link%
Gui, 2:Font, Normal
Gui, 2:Add, Button, xm+165 ym+140 w75 h25 Default g2ButtonClose, 닫기
Gui, 2:Show,, EZ_KEY 정보
OnMessage(0x20, "WM_MOUSEMOVE")
OnMessage(0x200, "WM_MOUSEMOVE")
Return

TextLink:
GuiControlGet, hLink, 2:Hwnd, Link
KeyWait, LButton
MouseGetPos,,,, hCtrl, 2
IfEqual, hCtrl, %hLink%, Run, %Link%,, UseErrorLevel
Return

2GuiClose:
2GuiEscape:
2ButtonClose:
Gui, 2:Destroy
Return

MenuExit:
DllCall("SystemParametersInfo", "UInt", 87, "UInt", 0, "UInt", 0, "UInt", 0)
ExitApp

IMECheckTimer:
ShowIME(GetIME(GetIMEStatus))
Return

WM_MOUSEMOVE(wParam, lParam, uMsg)
{
	Static Hover, HandCur, OldCur
	IfNotEqual, A_Gui, 2, Return
	If (uMsg = 0x20 && Hover = 1)
		Return, 1
	Else If (uMsg = 0x200)
	{
		If (A_GuiControl = "Link")
		{
			If (Hover = "")
			{
				HandCur := DllCall("LoadCursor", "UInt", 0, "UInt", 32649)
				Hover = 1
			}
			OldCur := DllCall("SetCursor", "UInt", HandCur)
		}
		Else If (Hover = 1)
		{
			DllCall("SetCursor", "UInt", OldCur)
			Hover =
		}
	}
}

GetIME(GetIMEStatus= 1)
{

	If (GetIMEStatus = 1)
	{
		VarSetCapacity(GuiThreadInfo, 48, 0)
		NumPut(48, GuiThreadInfo, 0)
		DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &GuiThreadInfo)
		hWnd := NumGet(GuiThreadInfo, 12)
	}
	Else If (GetIMEStatus = 2)
	{
		MouseGetPos,,, hWnd, hCtrl, 2
		hWnd := hCtrl ? hCtrl : hWnd
	}
	If (hWnd)
	{
		IMEWnd := DllCall("imm32.dll\ImmGetDefaultIMEWnd", "UInt", hWnd)
		IME := (DllCall("SendMessage", "UInt", IMEWnd, "UInt", 0x283, "Int", 5, "Int", 0)) ; WM_IME_CONTROL = 0x283, IMC_GETOPENSTATUS = 5
			? DllCall("SendMessage", "UInt", IMEWnd, "UInt", 0x283, "Int", 1, "Int", 0) : 0 ; IMC_GETCONVERSIONMODE = 1
	}
	Return, IME
}

ShowIME(IME = 0)
{
	Global
	Static OldIME, OldCaps, OldShift
	Local Caps, Shift
	Caps := GetKeyState("Capslock", "T")
	Shift := GetKeyState("Shift", "P")
	If (IME <> OldIME || Caps <> OldCaps || Shift <> OldShift)
	{
		If IME In 0,8,16,24
		{
			SetCursor(ShowEnglishIBeam = 1 ? Caps + Shift = 1 ? "EU" : "EL" : "")
			SetTrayIcon(ShowIMETrayIcon = 1 ? "E" : "")
		}
		Else If IME In 9,25
		{
			SetCursor(ShowJapaneseIBeam = 1 ? "JH" : "")
			SetTrayIcon(ShowIMETrayIcon = 1 ? "J" : "")
		}
		Else If IME In 3,11,19,27
		{
			SetCursor(ShowJapaneseIBeam = 1 ? "JK" : "")
			SetTrayIcon(ShowIMETrayIcon = 1 ? "J" : "")
		}
		Else If IME = 1
		{
			SetCursor(ShowKoreanIBeam = 1 ? "K" : "")
			SetTrayIcon(ShowIMETrayIcon = 1 ? "K" : "")
		}
		Else
		{
			SetCursor()
			SetTrayIcon()
		}
		If (PlaySounds = 1)
		{
			If IME In 0,8,16,24
			{
				If OldIME Not In 0,8,16,24
					IfEqual, PlayEnglishSound, 1, SoundPlay, %A_ScriptDir%\IMEE.wav
			}
			Else If IME In 3,9,11,19,25,27
			{
				If OldIME Not In 3,9,11,19,25,27
					IfEqual, PlayJapaneseSound, 1, SoundPlay, %A_ScriptDir%\IMEJ.wav
			}
			Else If (IME = 1 && OldIME <> 1)
				IfEqual, PlayKoreanSound, 1, SoundPlay, %A_ScriptDir%\IMEK.wav
		}
		OldIME := IME
		OldCaps := Caps
		OldShift := Shift
	}
}

SetCursor(Type = "")
{
	If (Type = "EL")
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE0000001000000010000000100000001000000010000000100000001000000010000
		000101E00001003000010030000101F00001033000010330000EE1F0000000000000000000000000000000000000000000000000000000000000000000000000
		)
	}
	Else If (Type = "EU")
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE000000100000001000000010000000100000001000000010000000100C0000101E0
		000103300001033000010330000103F00001033000010330000EE330000000000000000000000000000000000000000000000000000000000000000000000000
		)
	}
	Else If (Type = "JH")
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE000000100000001000000010000000100000001000000010000000100C0000100F0
		000103C0000100D8000101FC000103F6000106E6000106C6000EE39C000000000000000000000000000000000000000000000000000000000000000000000000
		)
	}
	Else If (Type = "JK")
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE0000001000000010000000100000001000000010000000100000001006000010060
		000103FC0001006C0001006C000100CC000100CC0001018C000EE338000000000000000000000000000000000000000000000000000000000000000000000000
		)
	}
	Else If (Type = "K")
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE000000100000001000000010000000100000001000000010000000107EC0001006C
		0001006C0001006C0001006F000100CC000100CC0001018C000EE70C0000000C0000000000000000000000000000000000000000000000000000000000000000
		)
	}
	Else
	{
		XorStr =
		(Join LTrim
		00000000000000000000000000000000000000000000000000000000000EE0000001000000010000000100000001000000010000000100000001000000010000
		000100000001000000010000000100000001000000010000000EE000000000000000000000000000000000000000000000000000000000000000000000000000
		)
	}
	nSize := StrLen(XorStr) // 2
	VarSetCapacity(AndMask, nSize, 0xFF)
	VarSetCapacity(XorMask, nSize, 0)
	Loop, %nSize%
		NumPut("0x" . SubStr(XorStr, A_Index * 2 - 1, 2), XorMask, A_Index - 1, "Char")
	hCur := DllCall("CreateCursor", "UInt", 0, "Int", 15, "Int", 15, "Int", 32, "Int", 32, "UInt", &AndMask, "UInt", &XorMask)
	DllCall("SetSystemCursor", "UInt", hCur, "UInt", 32513)
	DllCall("DestroyCursor", "UInt", hCur)
}

SetTrayIcon(Type = "")
{
	If (Type = "E")
	{
		IconStr =
		(Join LTrim
		28000000100000002000000001000400000000000000000000000000000000000000000000000000000000000000800000800000008080008000000080008000
		80800000C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0088888880000000008FFFFF00000000008F0FFA2000000A20
		8F007A220000A2208F000FA20000A2008F0780A2222222008F07808A200A20008F07780A20AA20008FF07800A20200008F707780A22200008FFF07800A200000
		888807000A200000000000780000000000000077800000000000000780000000000000000000000001FF00000078000000780000007000000001000000010000
		00230000000300000107000000070000008F0000000F0000F80F0000F83F0000FC3F0000FC7F0000
		)
	}
	Else If (Type = "J")
	{
		IconStr =
		(Join LTrim
		28000000100000002000000001000400000000000000000000000000000000000000000000000000000000000000800000800000008080008000000080008000
		80800000C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000800000000000000000070000000000000000F000
		000000080008F800000091100008FF80009910001108FF70099109999918FF780991199999187F809999199999918F009999999999910110D999999999910310
		D9999999999109100D999999999003100FD999999990091000FD9999990003100000DD9900000910FF030000FE010000FE010000FC610000F0600000C0200000
		8000000080000000000100000009000000090000000900008019000080190000C0390000F0F90000
		)
	}
	Else If (Type = "K")
	{
		IconStr =
		(Join LTrim
		28000000100000002000000001000400000000000000000000000000000000000000000000000000000000000000800000800000008080008000000080008000
		80800000C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0088888880000000008FFFFF800000D9008F0FFF399000D900
		8F007F8DD900D9008F000F80D990D9008F0780800D90D9908F0780800D90D9D08F0778000D90D9008FF078099990D9008F707780DDD0DD008FFF078000000000
		8888070000000000000000780000000000000077800000000000000780000000000000000000000001F100000071000000310000001100000100000001800000
		0180000000010000000100000001000000FF0000007F0000F87F0000F83F0000FC3F0000FC7F0000
		)
	}
	Else
	{
		IconStr =
		(Join LTrim
		28000000100000002000000001000400000000000000000000000000000000000000000000000000000000000000800000800000008080008000000080008000
		80800000C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0088888888888880008FFFFF8FFFFF80008F0FFF8FFFFF8000
		8F007F8F777F80008F000F8FFFFF80008F07808F777F80008F07808FFFFF80008F07780F777F80008FF0780FFFFF80008F707780777F80008FFF0780FFFF8000
		88880700088880000000007800000000000000778000000000000007800000000000000000000000000700000007000000070000000700000007000000070000
		000700000007000000070000000700000007000000070000F87F0000F83F0000FC3F0000FC7F0000
		)
	}
	nSize := StrLen(IconStr) // 2
	VarSetCapacity(IconData, nSize, 0)
	Loop, %nSize%
		NumPut("0x" . SubStr(IconStr, A_Index * 2 - 1, 2), IconData, A_Index - 1, "Char")
	hIcon := DllCall("CreateIconFromResourceEx", "UInt", &IconData, "UInt", 0, "Int", 1, "UInt", 196608, "Int", 16, "Int", 16, "UInt", 0)
	pid := DllCall("GetCurrentProcessId")
	VarSetCapacity(nid, 444, 0)
	NumPut(444, nid)
	DetectHiddenWindows, On
	NumPut(WinExist("ahk_class AutoHotkey ahk_pid " . pid), nid, 4)
	DetectHiddenWindows, Off
	NumPut(1028, nid, 8)
	NumPut(2, nid, 12)
	NumPut(hIcon, nid, 20)
	DllCall("shell32.dll\Shell_NotifyIcon", "UInt", 1, "UInt", &nid)
	DllCall("DestroyIcon", "UInt", hIcon)
}

;;소스 시작 start
;;=============================================
;;컨트롤 + esc 누르면 프로그램 종료
<^esc::exitapp
<^`::Pause  ; Pressing Win+` once will pause the script. Pressing it again will unpause.

;;;; 환경변수 설정 ;;;;
ThisVersion:="2009.11.07"
Lock_Count=0 ; numbers
LockDown_Time=60 ; seconds
Interval=200 ; miliseconds
Forced_LockDown_Time=10 ; seconds
;;;;==== 아래는 트레이 메뉴 ====;;;;
FileDelete, %A_WinDir%\system32\pmFlash.exe
FileDelete, %A_WinDir%\system32\pmcl.exe
;Menu, Tray, Icon, %A_WinDir%\system32\shell32.dll, 166 1
;Menu, Tray, Icon, C:\Windows\system32\user32.dll, 4 1
<!0::moveChrome()
<!1::Run, "http://www.naver.com"
<!2::Run, "http://www.google.com"
<!3::Run, "http://youtube.com"
<!4::Run, "http://www.daum.net"
;;<!5::Run, "http://findyoumed.com"

<!Numpad0::moveChrome()
<!Numpad1::Run, "http://www.naver.com"
<!Numpad2::Run, "http://www.google.com"
<!Numpad3::Run, "http://youtube.com"
<!Numpad4::Run, "http://www.daum.net"
;;<!Numpad5::Run, "http://findyoumed.com"
;;LedLight()
moveChrome()
{
IfWinNotExist, ahk_class Chrome_WidgetWin_1
{
Run, chrome.exe
}
else
{
WinActivate, ahk_class Chrome_WidgetWin_1
Winset, Top, ,ahk_class Chrome_WidgetWin_1
send,{ctrldown}1{ctrlup}
}
}

;;참고자료
;;http://v1.autohotkey.co.kr/cgi/board.php?bo_table=script&wr_id=357

IME_CHECK(WinTitle)
{
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}

Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON

     SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
    if (DetectSave <> A_DetectHiddenWindows)
        DetectHiddenWindows,%DetectSave%
    return ErrorLevel
}

ImmGetDefaultIMEWnd(hWnd)
{
    return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}

$#Space::                    ; I want Win-[space] key to be "Absolutely Hangul(Korean)" mode key. I hate toggling :(
;;LedLight()
ret := IME_CHECK("A")
        ;SoundBeep, 2000, 50
	;Sleep, 50
        ;SoundBeep, 2000, 50
    if %ret% = 0                ; 0 means IME is in English mode now.
    {
        Send, {vk15sc138}       ; Turn IME into Hangul(Korean) mode.
    }
return

$!Space::                    ; I want Alt-[space] key to be "Absolutely English" mode key. I hate toggling :(
;;LedLight()
    ret := IME_CHECK("A")
  	;SoundBeep, 700, 250
    if %ret% <> 0               ; 1 means IME is in Hangul(Korean) mode now.
    {
        Send, {vk15sc138}       ; Turn IME into English mode.
     }
return

$+Space::
;;LedLight()
Send, {vk15sc138}
;;윈도우+스페이스=영어, 쉬프트+스페이스=전환, 알트+스페이스=한글
;;컨트롤+스페이스=영문 오타 한글전환
If CheckIME(WinExist("A"))
        {
	  }
Else
	 {
	  }
return

;;한영 전환하기 위하여 한영키 누를 때 소리
$SC1F2:: ;pc용
;;$SC138:: laptop용
;;LedLight()
Send, {vk15sc138}
If CheckIME(WinExist("A"))
        {
	  }
Else
	 {
	  }
return


;;================================================
;;;; ㅈㅈㅈ. 를 입력하면 www. 로 바꾸어주는 핫 스트링 스크립트. ;;;;

:*b0:www.::
SetKeyDelay, -1
If CheckIME(WinExist("A"))
Send, {Backspace 4}{vk15sc138}www.
Return


;; http://www.clien.net/cs2/bbs/board.php?bo_table=lecture&wr_id=146672 에서 위 스크립트를 퍼옴.
;; http://blog.daum.net/eigenvalue/15398708
;;_!


	return




CheckIME(hWnd)
{
DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hWnd)
DetectSave := A_DetectHiddenWindows
DetectHiddenWindows, On
SendMessage, 0x283, 0x005, 0,, ahk_id %DefaultIMEWnd%
DetectHiddenWindows, %DetectSave%
Return ErrorLevel
}

;;LED불 키기
;;LedLight()
;;{
;;If CheckIME(WinExist("A"))
;;        {
;;	KeyboardLED(1, "off", 0)  ; all LED('s) according to keystate (Command = on or off)
;;	  }
;;Else
;;	 {
;;	KeyboardLED(1, "on", 0)  ; all LED('s) according to keystate (Command = on or off)
;;	}
;;}
;;return

KeyboardLED(LEDvalue, Cmd, Kbd)
{
  SetUnicodeStr(fn,"\Device\KeyBoardClass" Kbd)
  h_device:=NtCreateFile(fn,0+0x00000100+0x00000080+0x00100000,1,1,0x00000040+0x00000020,0)

  If Cmd= switch  ;switches every LED according to LEDvalue
   KeyLED:= LEDvalue
  If Cmd= on  ;forces all choosen LED's to ON (LEDvalue= 0 ->LED's according to keystate)
   KeyLED:= LEDvalue | (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
  If Cmd= off  ;forces all choosen LED's to OFF (LEDvalue= 0 ->LED's according to keystate)
    {
    LEDvalue:= LEDvalue ^ 7
    KeyLED:= LEDvalue & (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    }

  success := DllCall( "DeviceIoControl"
              ,  "ptr", h_device
              , "uint", CTL_CODE( 0x0000000b     ; FILE_DEVICE_KEYBOARD
                        , 2
                        , 0             ; METHOD_BUFFERED
                        , 0  )          ; FILE_ANY_ACCESS
              , "int*", KeyLED << 16
              , "uint", 4
              ,  "ptr", 0
              , "uint", 0
              ,  "ptr*", output_actual
              ,  "ptr", 0 )

  NtCloseFile(h_device)
  return success
}

CTL_CODE( p_device_type, p_function, p_method, p_access )
{
  Return, ( p_device_type << 16 ) | ( p_access << 14 ) | ( p_function << 2 ) | p_method
}


NtCreateFile(ByRef wfilename,desiredaccess,sharemode,createdist,flags,fattribs)
{
  VarSetCapacity(objattrib,6*A_PtrSize,0)
  VarSetCapacity(io,2*A_PtrSize,0)
  VarSetCapacity(pus,2*A_PtrSize)
  DllCall("ntdll\RtlInitUnicodeString","ptr",&pus,"ptr",&wfilename)
  NumPut(6*A_PtrSize,objattrib,0)
  NumPut(&pus,objattrib,2*A_PtrSize)
  status:=DllCall("ntdll\ZwCreateFile","ptr*",fh,"UInt",desiredaccess,"ptr",&objattrib
                  ,"ptr",&io,"ptr",0,"UInt",fattribs,"UInt",sharemode,"UInt",createdist
                  ,"UInt",flags,"ptr",0,"UInt",0, "UInt")
  return % fh
}

NtCloseFile(handle)
{
  return DllCall("ntdll\ZwClose","ptr",handle)
}


SetUnicodeStr(ByRef out, str_)
{
  VarSetCapacity(out,2*StrPut(str_,"utf-16"))
  StrPut(str_,&out,"utf-16")
}
return




/*

    Keyboard LED control for AutoHotkey_L
        http://www.autohotkey.com/forum/viewtopic.php?p=468000#468000

    KeyboardLED(LEDvalue, "Cmd", Kbd)
        LEDvalue  - ScrollLock=1, NumLock=2, CapsLock=4
        Cmd       - on/off/switch
        Kbd       - index of keyboard (probably 0 or 2)

*/

^y:: ;;한줄지움
Send,{home}
Send,{shiftdown}{end}{shiftup}
Send,{delete}{delete}
return

^Backspace:: ;;한 블락 지움
Send,{shiftdown}{ctrldown}{left}{ctrlup}{shiftup}
Send,{delete}
return


+Pause:: ;;tray보이기
ShowTray()
return

$^,:: ;;검색엔진
Run, searchengine.exe
return

ShowTray(){
ToolTip % A_ThisMenuItem
Menu,Tray,Show
}