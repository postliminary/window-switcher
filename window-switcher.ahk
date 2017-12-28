; Only works if running as admin. AHK can't interact with admin windows unless it is running as admin...
if not A_IsAdmin
{
	try
	{
		Run *RunAs "%A_ScriptFullPath%"
	}
	ExitApp
}

; Disable CapsLock default function
SetCapsLockState, AlwaysOff

; Remap CapsLock to send kaomojis
Capslock::SendInput {U+00AF}{U+005C}{U+005F}{U+0028}{U+30C4}{U+0029}{U+005F}{U+002F}{U+00AF}
!Capslock::SendInput {U+0CA0}{U+005F}{U+0CA0}

; Setup window switching
SetCurrentProgram() {
	global
	local ActiveProgram
	local A
	WinGet ActiveProgram, ProcessName, A
	if (ActiveProgram <> CurrentProgram) {
		if (ActiveProgram = "Explorer.EXE")
		{
			WinGet, ProgramArray, list, ahk_class CabinetWClass
		}
		else
		{
			WinGet, ProgramArray, list, ahk_exe %ActiveProgram%
		}
		CurrentProgram := ActiveProgram
		ProgramCursor := 1
	}
}

; Clear tracked program
ResetCurrentProgram() {
	global
	if (!GetKeyState("Alt", "P")) {
		SetTimer, ResetCurrentProgram, Off
		CurrentProgram := ""
	}
}

; Performs actual window switch
SwitchToProgramWindow() {
	global
	local CursorID := ProgramArray%ProgramCursor%
	WinActivate, ahk_id %CursorID%
	SetTimer, ResetCurrentProgram, 100
}

; Next window
NextProgramWindow() {
	global
	if (ProgramArray > 1) {
		ProgramCursor := ProgramCursor + 1
		if (ProgramCursor > ProgramArray) {
			ProgramCursor := 1
		}
		SwitchToProgramWindow()
	}
}

; Prev window
PrevProgramWindow() {
	global
	if (ProgramArray > 1) {
		ProgramCursor := ProgramCursor - 1
		if (ProgramCursor < 1) {
			ProgramCursor := ProgramArray
		}
		SwitchToProgramWindow()
	}
}

; Window switcher key bindings

!`::
SetCurrentProgram()
NextProgramWindow()
return

!+`::
SetCurrentProgram()
PrevProgramWindow()
return
