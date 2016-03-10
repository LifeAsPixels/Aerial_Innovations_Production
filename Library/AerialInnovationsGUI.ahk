#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force ; Forces a single instance when trying to reopen script
 ;~ Warn  ; Enable warnings to assist with detecting common errors.

user1 := "Shawn"
user2 := "Meredith"

pc1 := "WS1"
pc2 := "WS2"

;~ return

; GUI
iniLoad(){
 IniRead, 
 
; read through user ini file and set variables

; read through pc ini file and set variabls
}
iniSave(){
 
}
AIguiStart(){
 global
 
Gui, Add, Tab2,, Workspace|Change Settings
; create user-choice radio buttons
Gui, Add, Text,, Select user:
Gui, Add, Radio, altsubmit vUserRadio1, %user1%
Gui, Add, Radio, altsubmit, %user2%
Gui, Add, Text,, Input Flight Date`nusing YYMMDD:

; create pc-choice radio buttons
Gui, Add, Text, ym, Select work station:
Gui, Add, Radio, altsubmit vPCRadio, %pc1%
Gui, Add, Radio, altsubmit , %pc2%
Gui, Add, Edit, vFlightDate

Gui, Tab, 2
Gui, Add, Button, 
Gui, Show
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