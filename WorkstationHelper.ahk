;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;
#SingleInstance force ; Forces a single instance when trying to reopen script
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Library\Get_Explorer_Paths.ahk
;~ InitializeVariables()
Return

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Variables
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Arrays
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; LCS Site local, mySQL local, 
LCSprodExplorer := ["C:\Program Files\wamp\www\LCS-Fantasy-Tracker", "C:\Program Files\wamp\bin\mysql"]
; WAMP, GitHub, 
LCSprodExe := ["C:\Program Files\wamp\wampmanager.exe", "C:\Users\Shawn\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu\GitHub.appref-ms"]


;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Functions
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

LCSfantasyEnvironment() {
	SetTitleMatchMode 3
	Loop
	{
		WinActivate, ahk_class CabinetWClass
		WinWaitActive, ahk_class CabinetWClass, , .5
		If ErrorLevel
			break
		else
			WinClose, ahk_class CabinetWClass
	}
	For i, value in ProdExplorer
	{
		Temp := ProdExplorer[A_Index]
		Run explore %Temp%
		Temp := ""
		gosub WaitS
	}
	SetTitleMatchMode 1
	SetTitleMatchMode Fast
	If WinExist("Hightail" ahk_class YsiMainWindow)
	{}
	Else Run, %Hightail%
	If WinExist("Zenfolio")
	{}
	Else Run, %Zenfolio%
	;~ If WinExist(ahk_group EmailClient)
	;~ {MsgBox,,, Email is active
		;~ GroupActivate, EmailClient
	;~ }
	;~ Else Run, %Email%
	;~ Run, %Zenfolio%
	Run, %Email%
	Defaults()
	return
}
Defaults() {
	for i, value in LCSprodExplorer
		Run i
}
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Substrings
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
WaitXXXS:
	Sleep 1
	Return
WaitXXS:
	Sleep 75
	Return
WaitXS:
	Sleep 100
	Return
WaitS:
	Sleep 250
	Return
WaitM:
	Sleep 500
	Return
WaitL:
	Sleep 750
	Return
WaitXL:
	Sleep 1000
	Return
WaitXXXL:
	Sleep 1500
	Return

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Hotkeys
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
^`:: ; Close AHK script
	Run, %thisScript%
	ExitApp
	
^!+e::
	Defaults()
	return
