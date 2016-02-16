#SingleInstance force


; Example: Achieve an effect similar to SplashTextOn:
GUI1(){
	Gui, +AlwaysOnTop +Disabled -SysMenu +Owner  ; +Owner avoids a taskbar button.
	Gui, Add, Text,, Some text to display.
	Gui, Show, NoActivate, Title of Window  ; NoActivate avoids deactivating the currently active window.
}
; Example: A simple input-box that asks for first name and last name:
GUI2(){
	Gui, Add, Text,, First name:
	Gui, Add, Text,, Last name:
	Gui, Add, Edit, vFirstName ym  ; The ym option starts a new column of controls.
	Gui, Add, Edit, vLastName
	Gui, Add, Button, default, OK  ; The label ButtonOK (if it exists) will be run when the button is pressed.1
	Gui, Show,, Simple Input Example
	return  ; End of auto-execute section. The script is idle until the user does something.

	GuiClose1:
	ButtonOK1:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	MsgBox You entered "%FirstName% %LastName%".
	ExitApp
}
; Example: Tab control:
GUI3(){
	Gui, Add, Tab2,, First Tab|Second Tab|Third Tab  ; Tab2 vs. Tab requires v1.0.47.05.
	Gui, Add, Checkbox, vMyCheckbox, Sample checkbox
	Gui, Tab, 2
	Gui, Add, Radio, vMyRadio, Sample radio1
	Gui, Add, Radio,, Sample radio2
	Gui, Tab, 3
	Gui, Add, Edit, vMyEdit r5  ; r5 means 5 rows tall.
	Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.
	Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
	Gui, Show
	return

	ButtonOK2:
	GuiClose2:
	GuiEscape2:
	Gui, Submit  ; Save each control's contents to its associated variable.
	MsgBox You entered:`n%MyCheckbox%`n%MyRadio%`n%MyEdit%
	ExitApp
}
; Example: ListBox containing files in a directory:
GUI4(){
	Gui, Add, Text,, Pick a file to launch from the list below.`nTo cancel, press ESCAPE or close this window.
	Gui, Add, ListBox, vMyListBox gMyListBox w640 r10
	Gui, Add, Button, Default, OK
	Loop, C:\*.*  ; Change this folder and wildcard pattern to suit your preferences.
	{
		GuiControl,, MyListBox, %A_LoopFileFullPath%
	}
	Gui, Show
	return

	MyListBox:
	if A_GuiEvent <> DoubleClick
		return
	; Otherwise, the user double-clicked a list item, so treat that the same as pressing OK.
	; So fall through to the next label.
	ButtonOK3:
	GuiControlGet, MyListBox  ; Retrieve the ListBox's current selection.
	MsgBox, 4,, Would you like to launch the file or document below?`n`n%MyListBox%
	IfMsgBox, No
		return
	; Otherwise, try to launch it:
	Run, %MyListBox%,, UseErrorLevel
	if ErrorLevel = ERROR
		MsgBox Could not launch the specified file.  Perhaps it is not associated with anything.
	return

	GuiClose3:
	GuiEscape3:
	ExitApp
}
; Example: Display context-senstive help (via ToolTip) whenever the user moves the mouse over a particular control:
GUI5(){
	Gui, Add, Edit, vMyEdit
	MyEdit_TT := "This is a tooltip for the control whose variable is MyEdit."
	Gui, Add, DropDownList, vMyDDL, Red|Green|Blue
	MyDDL_TT := "Choose a color from the drop-down list."
	Gui, Add, Checkbox, vMyCheck, This control has no tooltip.
	Gui, Show
	OnMessage(0x200, "WM_MOUSEMOVE")
	return

	GuiClose4:
	ExitApp
}
; Example: On-screen display (OSD) via transparent window:
GUI6(){
	CustomColor = EEAA99  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %CustomColor%
	Gui, Font, s32  ; Set a large font size (32-point).
	Gui, Add, Text, vMyText cLime, XXXXX YYYYY  ; XX & YY serve to auto-size the window.
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
}
; Example: A moving progress bar overlayed on a background image.
GUI7(){
	Gui, Color, White
	Gui, Add, Picture, x0 y0 h350 w450, %A_WinDir%\system32\ntimage.gif
	Gui, Add, Button, Default xp+20 yp+250, Start the Bar Moving
	Gui, Add, Progress, vMyProgress w416
	Gui, Add, Text, vMyText wp  ; wp means "use width of previous".
	Gui, Show
	return

	ButtonStartTheBarMoving:
	Loop, %A_WinDir%\*.*
	{
		if A_Index > 100
			break
		GuiControl,, MyProgress, %A_Index%
		GuiControl,, MyText, %A_LoopFileName%
		Sleep 50
	}
	GuiControl,, MyText, Bar finished.
	return

	GuiClose5:
	ExitApp
}
; Example: Simple image viewer:
GUI8(){
	Gui, +Resize
	Gui, Add, Button, default, &Load New Image
	Gui, Add, Radio, ym+5 x+10 vRadio checked, Load &actual size
	Gui, Add, Radio, ym+5 x+10, Load to &fit screen
	Gui, Add, Pic, xm vPic
	Gui, Show
	return

	ButtonLoadNewImage:
	FileSelectFile, file,,, Select an image:, Images (*.gif; *.jpg; *.bmp; *.png; *.tif; *.ico; *.cur; *.ani; *.exe; *.dll)
	if file =
		return
	Gui, Submit, NoHide ; Save the values of the radio buttons.
	if Radio = 1  ; Display image at its actual size.
	{
		Width = 0
		Height = 0
	}
	else ; Second radio is selected: Resize the image to fit the screen.
	{
		Width := A_ScreenWidth - 28  ; Minus 28 to allow room for borders and margins inside.
		Height = -1  ; "Keep aspect ratio" seems best.
	}
	GuiControl,, Pic, *w%width% *h%height% %file%  ; Load the image.
	Gui, Show, xCenter y0 AutoSize, %file%  ; Resize the window to match the picture size.
	return

	GuiClose6:
	ExitApp
}
; Example: Simple text editor with menu bar.
GUI9(){
	; Create the sub-menus for the menu bar:
	Menu, FileMenu, Add, &New, FileNew
	Menu, FileMenu, Add, &Open, FileOpen
	Menu, FileMenu, Add, &Save, FileSave
	Menu, FileMenu, Add, Save &As, FileSaveAs
	Menu, FileMenu, Add  ; Separator line.
	Menu, FileMenu, Add, E&xit, FileExit
	Menu, HelpMenu, Add, &About, HelpAbout

	; Create the menu bar by attaching the sub-menus to it:
	Menu, MyMenuBar, Add, &File, :FileMenu
	Menu, MyMenuBar, Add, &Help, :HelpMenu

	; Attach the menu bar to the window:
	Gui, Menu, MyMenuBar

	; Create the main Edit control and display the window:
	Gui, +Resize  ; Make the window resizable.
	Gui, Add, Edit, vMainEdit WantTab W600 R20
	Gui, Show,, Untitled
	CurrentFileName =  ; Indicate that there is no current file.
	return

	FileNew:
	GuiControl,, MainEdit  ; Clear the Edit control.
	return

	FileOpen:
	Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, SelectedFileName, 3,, Open File, Text Documents (*.txt)
	if SelectedFileName =  ; No file selected.
		return
	Gosub FileRead
	return

	FileRead:  ; Caller has set the variable SelectedFileName for us.
	FileRead, MainEdit, %SelectedFileName%  ; Read the file's contents into the variable.
	if ErrorLevel
	{
		MsgBox Could not open "%SelectedFileName%".
		return
	}
	GuiControl,, MainEdit, %MainEdit%  ; Put the text into the control.
	CurrentFileName = %SelectedFileName%
	Gui, Show,, %CurrentFileName%   ; Show file name in title bar.
	return

	FileSave:
	if CurrentFileName =   ; No filename selected yet, so do Save-As instead.
		Goto FileSaveAs
	Gosub SaveCurrentFile
	return

	FileSaveAs:
	Gui +OwnDialogs  ; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, SelectedFileName, S16,, Save File, Text Documents (*.txt)
	if SelectedFileName =  ; No file selected.
		return
	CurrentFileName = %SelectedFileName%
	Gosub SaveCurrentFile
	return

	SaveCurrentFile:  ; Caller has ensured that CurrentFileName is not blank.
	IfExist %CurrentFileName%
	{
		FileDelete %CurrentFileName%
		if ErrorLevel
		{
			MsgBox The attempt to overwrite "%CurrentFileName%" failed.
			return
		}
	}
	GuiControlGet, MainEdit  ; Retrieve the contents of the Edit control.
	FileAppend, %MainEdit%, %CurrentFileName%  ; Save the contents to the file.
	; Upon success, Show file name in title bar (in case we were called by FileSaveAs):
	Gui, Show,, %CurrentFileName%
	return

	HelpAbout:
	Gui, About:+owner1  ; Make the main window (Gui #1) the owner of the "about box".
	Gui +Disabled  ; Disable main window.
	Gui, About:Add, Text,, Text for about box.
	Gui, About:Add, Button, Default, OK
	Gui, About:Show
	return

	AboutButtonOK4:  ; This section is used by the "about box" above.
	AboutGuiClose7:
	AboutGuiEscape7:
	Gui, 1:-Disabled  ; Re-enable the main window (must be done prior to the next step).
	Gui Destroy  ; Destroy the about box.
	return

	GuiDropFiles:  ; Support drag & drop.
	Loop, Parse, A_GuiEvent, `n
	{
		SelectedFileName = %A_LoopField%  ; Get the first file only (in case there's more than one).
		break
	}
	Gosub FileRead
	return

	GuiSize:
	if ErrorLevel = 1  ; The window has been minimized.  No action needed.
		return
	; Otherwise, the window has been resized or maximized. Resize the Edit control to match.
	NewWidth := A_GuiWidth - 20
	NewHeight := A_GuiHeight - 20
	GuiControl, Move, MainEdit, W%NewWidth% H%NewHeight%
	return

	FileExit:     ; User chose "Exit" from the File menu.
	GuiClose8:  ; User closed the window.
	ExitApp
}

WM_MOUSEMOVE()
{
	static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
	CurrControl := A_GuiControl
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
		ToolTip  ; Turn off any previous tooltip.
		SetTimer, DisplayToolTip, 1000
		PrevControl := CurrControl
	}
	return

	DisplayToolTip:
	SetTimer, DisplayToolTip, Off
	ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
	SetTimer, RemoveToolTip, 3000
	return

	RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
}

^!+1::
GUI1()
return
^!+2::
GUI2()
return
^!+3::
GUI3()
return
^!+4::
GUI4()
return
^!+5::
GUI5()
return
^!+6::
GUI6()
return
^!+7::
GUI7()
return
^!+8::
GUI8()
return
^!+9::
GUI9()
return