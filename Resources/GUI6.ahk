#SingleInstance force
return
; Example: On-screen display (OSD) via transparent window:
gui:
CustomColor = 000000  ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
Gui, Font, s12 wBold Q5  ; Set a large font size (32-point).
Gui, Add, Text, vMyText cWhite, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
WinSet, TransColor, %CustomColor% 150
SetTimer, UpdateOSD, 200
Gosub, UpdateOSD  ; Make the first update immediate rather than waiting for the timer.
Gui, Show, x0 y400 NoActivate  ; NoActivate avoids deactivating the currently active window.
return

UpdateOSD:
MouseGetPos, MouseX, MouseY
GuiControl,, MyText, X%MouseX%, Y%MouseY%
return

^`:: ; Re-open this AHK script
	Run, %A_ScriptFullPath%
	ExitApp

^!+6::
gui destroy
gosub gui
return