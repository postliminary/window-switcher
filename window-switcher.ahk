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

!+`::	; Last window
WinGet ActiveProcess, ProcessName, A
WinGet WinCount, Count, ahk_exe %ActiveProcess%
if (WinCount > 1) 
{
	; Special handling for explorer windows
	if (ActiveProcess = "Explorer.EXE") 
	{
		WinActivateBottom, ahk_class CabinetWClass
	}
	else 
	{
		WinActivateBottom, ahk_exe %ActiveProcess%
	}
}
return