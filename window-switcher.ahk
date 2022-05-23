; Only works if running as admin. AHK can't interact with admin windows unless it is running as admin...
if not A_IsAdmin {
	try {
		Run *RunAs "%A_ScriptFullPath%"
	}
	ExitApp
}

; Retrieves the display monitor that has the largest area of intersection with a specified window
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4606
DisplayFromHWND(HWND) {
   Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", 0, "UPtr")
}

; Setup window switching
SetCurrentProgram() {
	global
	local A
	local ActiveProgram
	local ActiveDisplay
	WinGet ActiveProgram, ProcessName, A
	WinGet, ActiveID, ID, A
	ActiveDisplay := DisplayFromHWND(ActiveID)
	if (ActiveProgram <> CurrentProgram Or ActiveDisplay <> CurrentDisplay) {
		if (ActiveProgram = "Explorer.EXE") {
			WinGet, ProgramArray, list, ahk_class CabinetWClass
		}
		else {
			WinGet, ProgramArray, list, ahk_exe %ActiveProgram%
		}
		CurrentProgram := ActiveProgram
		CurrentDisplay := ActiveDisplay
		ProgramCursor := 1
	}
}

; Next window
NextProgramWindow() {
	global
	if (ProgramArray > 1) {
		ProgramCursor := ProgramCursor + 1
		if (ProgramCursor > ProgramArray) {
			ProgramCursor := 1
		}
		local CursorID := ProgramArray%ProgramCursor%
		local CursorDisplay := DisplayFromHWND(CursorID)
		if (CurrentDisplay = CursorDisplay) {
			WinActivate, ahk_id %CursorID%
		}
		else {
			NextProgramWindow()
		}
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
		local CursorID := ProgramArray%ProgramCursor%
		local CursorDisplay := DisplayFromHWND(CursorID)
		if (CurrentDisplay = CursorDisplay) {
			WinActivate, ahk_id %CursorID%
		}
		else {
			PrevProgramWindow()
		}
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
