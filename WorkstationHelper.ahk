;
; AutoHotkey Version: 1.x
; Language:       English
; Author:         Shawn Nix
;
#SingleInstance force ; Forces a single instance when trying to reopen script
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include Library\Get_Explorer_Paths.ahk
#Include Library\WinGetAll.ahk
InitializeVariables()
Return

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Functions
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
InitializeVariables() {
	global ; create all these variables with global scope
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	; RegEx Variables
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	runNoExplorer := "^https?|.exe$"
	runBat := ".bat"
	
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	; Static Variables
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	; Arrays
	;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	; WAMP, GitHub, LCS Site local explorer, mySQL local explorer, asana, phpmyadmin, LCS site localhost, fantasy API, Riot API, toggl
	LCSfantasyTrackerWorkspace := ["C:\Program Files\wamp\wampmanager.exe", "Resources\GitHub.bat", "C:\Program Files\wamp\www\LCS-Fantasy-Tracker", "C:\Program Files\wamp\bin\mysql", "https://app.asana.com/", "http://localhost/phpmyadmin/index.php", "http://localhost/lcs-fantasy-tracker/index.php", "http://na.lolesports.com/api/swagger#!/api", "https://developer.riotgames.com/api/methods", "https://www.toggl.com/app/timer"]
	LCSfantasyTrackerWorkspaceTitles := ["AeTrayMenu[{wampserver}]", "GitHub", "LCS-Fantasy-Tracker", "mysql", "Asana", "localhost / mysql wampserver | phpMyAdmin", "", "Swagger documentation | LoL Esports", "API Documentation - Riot Games API", "Toggl"]

	gosub Daily
	Defaults()
}

Open(pathName, winTitles) { ; pathName is opened, but not if a corresponding window match is found from winTitles
	global
	SetTitleMatchMode, 2
	DetectHiddenWindows On
	SetTitleMatchMode Slow
	if isobject(pathName) {
		For i, value in pathName	{
			if winexist(winTitles[i]) 
				continue
			else	{
				if RegExMatch(value,runNoExplorer)
					Run, %value%
				else if RegExMatch(value,runBat)
					Run, %value%,,Hide
				else
					Run explore %value%
			}
		}
	}
}

SongKickSearch() {
	SKSearch := "https://www.songkick.com/search?utf8=?&query="
	SKSearching := "&type=artists"
	FileRead,  FileContents, Resources\Artist.txt

	Loop, Parse, FileContents, `n, `r
	{
		run, %SKSearch%%A_LoopField%%SKSearching%
	}
}
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Substrings
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
Daily:
gosub iTunesBackup
SetTimer, Daily, 86400000
return

iTunesBackup:
FileCopy, E:\Music\iTunes\iTunes Music Library.xml, C:\Users\Shawn\Music\iTunes, 1
return

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
^`:: ; Re-open this AHK script
	Run, %A_ScriptFullPath%
	ExitApp

^!+e:: ; LCS Fantasy Tracker Workspace
	Open(LCSfantasyTrackerWorkspace, LCSfantasyTrackerWorkspaceTitles)
	return

^+F1:: ; CSV for all open window information
	WinGetAll(true, true)
	return
	

^!+F12::
	SongKickSearch()
Return