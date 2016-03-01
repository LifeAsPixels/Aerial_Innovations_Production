#SingleInstance force
SetWorkingDir %A_ScriptDir%

; Example: Achieve an effect similar to SplashTextOn:
GUI1(){
Gui, +AlwaysOnTop +Disabled -SysMenu +Owner  ; +Owner avoids a taskbar button.
Gui, Add, Text,, Some text to display.
Gui, Show, NoActivate, Title of Window  ; NoActivate avoids deactivating the currently active window.
}

^`:: ; Re-open this AHK script
	Run, %A_ScriptFullPath%
	ExitApp

^!+1::
GUI1()
return