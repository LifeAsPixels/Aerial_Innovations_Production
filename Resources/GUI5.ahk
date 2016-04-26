#SingleInstance force
return
; Example: Display context-senstive help (via ToolTip) whenever the user moves the mouse over a particular control:
gui:
Gui, Add, Edit, vMyEdit
MyEdit_TT := "This is a tooltip for the control whose variable is MyEdit."
Gui, Add, DropDownList, vMyDDL, Red|Green|Blue
MyDDL_TT := "Choose a color from the drop-down list."
Gui, Add, Checkbox, vMyCheck, This control has no tooltip.
Gui, Show
OnMessage(0x200, "WM_MOUSEMOVE")
return

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


GuiClose:
gui destroy

^`:: ; Re-open this AHK script
	Run, %A_ScriptFullPath%
	ExitApp

^!+5::
gosub gui
return