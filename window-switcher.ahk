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
	local ActiveProcess
	local A
	WinGet ActiveProcess, ProcessName, A
	if (ActiveProcess <> CurrentProcess) {
		if (ActiveProcess = "Explorer.EXE")
		{
			WinGet, ProcessArray, list, ahk_class CabinetWClass
		}
		else
		{
			WinGet, ProcessArray, list, ahk_exe %ActiveProcess%
		}
		CurrentProcess := ActiveProcess
		ProcessCursor := 1
	}
}

; Next window
NextProgramWindow() {
	global
	local CursorID
	if (ProcessArray > 1) {
		ProcessCursor := ProcessCursor + 1
		if (ProcessCursor > ProcessArray) {
			ProcessCursor := 1
		}
		CursorID := ProcessArray%ProcessCursor%
		WinActivate, ahk_id %CursorID%
	}
}

; Prev window
PrevProgramWindow() {
	local CursorID
	if (ProcessArray > 1) {
		ProcessCursor := ProcessCursor - 1
		if (ProcessCursor < 1) {
			ProcessCursor := ProcessArray
		}
		CursorID := ProcessArray%ProcessCursor%
		WinActivate, ahk_id %CursorID%
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
