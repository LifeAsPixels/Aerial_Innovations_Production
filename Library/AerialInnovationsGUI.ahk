user1 := "Shawn"
user2 := "Meredith"

pc1 := "WS01"
pc2 := "WS02"

;~ return

; GUI
iniLoad(){
; read through user ini file and set variables

; read through pc ini file and set variabls
}
iniSave(){
 
}
AIguiStart(){
 global
 
;~ Gui, Add, Tab2,, Workspace|Change Settings
; create user-choice radio buttons
Gui, Add, Text,, Select user:
Gui, Add, DropDownList, vUserChoice, Shawn|Meredith
Gui, Add, Text,, Select work station:
Gui, Add, DropDownList, vWorkStationChoice, WS01|WS02
Gui, Add, Text,, Input Flight Date`nusing YYMMDD:
Gui, Add, Edit, vFlightDate

;~ Gui, Tab, 2
Gui, Add, Button, Default, OK
Gui, Show

GuiClose:
return
ButtonOK:
Gui, Submit  ; Save the input from the user to each control's associated variable.
MsgBox You entered %UserChoice% %WorkStationChoice%.
return
}
AIguiAddUser(){

}
AIguiAddPC(){

}
AIguiUpdate(){

}

; HUD
AIhudStart(){
Gui, +E0x20 +AlwaysOnTop +Disabled -SysMenu +Owner
}
AIhudupdate(){

}

;~ ^`:: ; Re-open this AHK script
 ;~ Run, %A_ScriptFullPath%
 ;~ ExitApp

;~ ^!+1::
;~ AIguiStart()
;~ return