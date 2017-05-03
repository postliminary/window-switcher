; Only works if running as admin. AHK can't interact with admin windows unless it is running as admin...
if not A_IsAdmin
{
	try
	{
		Run *RunAs "%A_ScriptFullPath%"
	}
	ExitApp
}

!`::	; Next window
WinGet ActiveProcess, ProcessName, A
WinGet WinCount, Count, ahk_exe %ActiveProcess%
if (WinCount > 1) 
{
	WinSet, Bottom,, A
	; Special handling for explorer windows
	if (ActiveProcess = "Explorer.EXE") 
	{
		WinActivate, ahk_class CabinetWClass
	}
	else 
	{
		WinActivate, ahk_exe %ActiveProcess%
	}
}
return

!+`::    ; Last window
WinGetClass, ActiveClass, A
WinActivateBottom, ahk_class %ActiveClass%
return

!+w::
r = Windows:`n
WinGet ActiveProcess, ProcessName, A
r .= ActiveProcess . "`n"
WinGet, List, List, % "ahk_exe " ActiveProcess
Loop, % List
{
	id := List%A_Index%
	WinGetTitle wt, ahk_id %id%
	WinGetClass wc, ahk_id %id%
	r .= A_Index . ". " . wt . " " . wc . "`n"
}
MsgBox %r%
return