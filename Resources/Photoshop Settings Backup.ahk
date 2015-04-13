/*
AutoHotkey Version	---	1.1.xx.xx
Language	---	English
Platform	---	Win9x/NT
Author	---	Shawn Nix	<shawn@shawnnixphotography.com>

Script Function	---
	Backup user settings for various adobe programs and Aerial Innovations settings folders..
*/

#NoTrayIcon
#SingleInstance Force
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
goto Defaults
SetTimer, Backup, 3600000
return

Defaults:
	DataBackup := []
	AppDataBackups := ["\Adobe\Adobe Photoshop CC 2014\Adobe Photoshop CC 2014 Settings", "\Adobe\Bridge CC\Adobe Output Module", "\Adobe\Bridge CC\Batch Rename Settings", "\Adobe\Bridge CC\Collections", "\Adobe\Bridge CC\Favorite Alias", "\Adobe\Bridge CC\Workspaces"]
	Laura := "Z:\LAURA\Backups"
	Shawn := "Z:\Shawn\Backups"
	return

Backup:

gosub, BackupAppdata
return

BackupAppdata:
	For i, value in AppDataBackups
		FileCopyDir, %A_Appdata%%value%, %Shawn%%value%, 1
	SetTimer, Backup, Off
	return

^`:: ; Close AHK script
	ExitApp