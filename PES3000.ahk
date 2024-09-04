#SingleInstance force
#Requires Autohotkey v2.0+

if WinExist("Diablo IV")
{
	WinActivate()
}
else
{
	MsgBox("Diablo IV is not running.`n`PES3000 will now be terminated.", "Error", "")
	ExitApp()
}

global iniFilePath := "Settings.ini"
global ChatActive := false
global CDDuration := 250
global TeleportKey := "MButton"
global CuriosityKey := "NumpadDot"

#HotIf WinActive("ahk_exe Diablo IV.exe")
{
	; https://www.autohotkey.com/docs/v2/KeyList.htm

	if !FileExist("Settings.ini")
		FileAppend("
			(
			[Cooldown]
			;250 msec = 0.25 sec
			CDDuration=250
			[Hotkeys]
			TeleportKey=MButton
			CuriosityKey=NumpadDot
			)", iniFilePath)
			
	CDDuration := IniRead(iniFilePath, "Cooldown", "CDDuration", "250")
	TeleportKey := IniRead(iniFilePath, "Hotkeys", "TeleportKey", "MButton")
	CuriosityKey := IniRead(iniFilePath, "Hotkeys", "CuriosityKey", "NumpadDot")

	; Ctrl -> ^
	; Alt -> !
	; Shift -> +
	; Win -> #

	!Tab::
	LWin::
	RWin::
	#Tab::
	{
		Return
	}
	
	ToggleChatActive(hk)
	{
		global ChatActive
		ChatActive := !ChatActive
		Send(hk)
		Return
	}

	Enter::ToggleChatActive("{Enter}")

	NumpadEnter::ToggleChatActive("{NumpadEnter}")

	Hotkey(CuriosityKey, HandleCuriosityKey)
	HandleCuriosityKey(hk)
	{
		Send("{RButton 33}")
		Return
	}

	~RButton:: ; Allow the default RButton action (Whirlwind)
	{
		While GetKeyState("RButton", "P") ; Check if the right mouse button is pressed
		{
			if (ChatActive = false)
			{
				Send("1") ; Iron Skin
				Sleep(10)
				Send("2") ; War Cry
				Sleep(10)
				Send("3") ; Rallying Cry
				Sleep(CDDuration)
			}
		}
	}

	Hotkey(TeleportKey, HandleTeleportKey)
	HandleTeleportKey(hk)
	{
		Send("{T}")
		Return
	}

	End::
	{
		ExitApp()
	}

}
