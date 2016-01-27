 /*
AutoHotkey Version	---	1.1.xx.xx
Language	---	English
Platform	---	Win9x/NT
Author	---	Shawn Nix	<shawn@shawnnixphotography.com>
Script Function	---
	This script allows for faster photo production at Aerial Innovations of GA.
*/
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		Auto Execute Section, Default Variables, RegEx Variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	#SingleInstance force ; Forces a single instance when trying to reopen script
	#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
	SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
	#Include Library\Get_Explorer_Paths.ahk ; Library - gets explorer file and window paths
	#include Library\Defaults.ahk
	#include Library\WinGetAll.ahk
	#include Config\AIGlobalVariables.ahk
	#include Config\AIUserVariables.ahk
	InitializeVariables()
	Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;		Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitializeVariables() {
	; Run Functions and Timed Events
	gosub Backups
	gosub TitleblockFilenames
	titleblockFolderGroup()
	RunProgram("ahk_exe Photoshop.exe", Photoshop) 
	RunProgram("ahk_exe Bridge.exe", Bridge)
	
	Defaults(True)
	MsgBox, ,Startup Complete, Startup Complete
}

titleblockFolderGroup(){ ; Sets all folders inside defined root folder as part of a group for variably accessing an explorer window
	global
	GroupAdd, groupTB, _Titleblock Templates
	Loop, %folderTitleBlocks%*, 2, 0 
		GroupAdd, groupTB, %A_LoopFileName%
}
ArrayPrint(ArrayVar){ ; Print out the key and value pairs in an array. used for debugging
	Loop, % ArrayVar.MaxIndex() ;MaxIndex() will provide the maximum Key (note this will break when sparsely populated)
	MsgBox,,Simple loop using "A_Index", % "Item: " A_Index " has the Value of: " ArrayVar[A_Index]
}
PsBatch(SetNumber,ActionNumber,FromBridge = true) { ; Automatically Navigate the Photoshop Batch processes GUI
	gosub WaitM
	If (FromBridge = true) {
		gosub BridgeBatch
	}
	else {
		Send ^b
	}
	WinWaitActive ahk_class PSFloatC
	Send {Tab}
	Send {Up 7}{Down}{Up}
	Send {Down %SetNumber%}
	Send {Tab}
	Send {Down %ActionNumber%}
	Send {Enter}
	Defaults()
	}
PsSaveAs(PsDirectory,PsWindowAttribute) { ; Automatically navigate the Photoshop SaveAs GUI
	global
	GoSub FlightDateValidate
	SendInput ^+s
	WinWaitActive ahk_class #32770
	SetTitleMatchMode 3
	SetTitleMatchMode Fast
	While WinActive(ahk_class #32770, PsWindowAttribute) = 0 ; Input directory and check for success.
	{
		WinActivate, ahk_class #32770
		SendInput {F4}^a%PsDirectory%{Enter}
		SendInput ^{Tab}!n
		GoSub WaitL
	}
	SetTitleMatchMode, Slow
	While WinActive(ahk_class #32770, "JPEG (*.JPG;*.JPEG;*.JPE)") = 0 ; Set file to JPEG check for success.
	{
		WinActivate, ahk_class #32770
		SendInput !tij
	}
	While WinActive("ahk_class #32770", TBFilenamePrefix . " " . YYMMDD . "D" . PsFileNumberSuffix) = 0 ; Input filename and save
	{
		WinActivate, ahk_class #32770
		SendEvent !n^a
		SendInput %TBFilenamePrefix%{Space}%YYMMDD%D%PsFileNumberSuffix%
		GoSub WaitS
		If A_Index = 1
			GoSub WaitXS
	}
	SendInput {Enter}
	WinWaitActive, Confirm Save As, , .3
	If !ErrorLevel ; save over if file exists
	{
		While WinActive(Confirm Save As)
		{
			If A_Index > 1
				GoSub WaitXS
			SendInput !y
		}
	}
	SetTitleMatchMode, 2
	SetTitleMatchMode, Fast
	WinWaitActive, JPEG Options
	gosub waitS
	SendInput 12{Enter}
	While WinActive(PsFilename) = 0
	{
		if (A_Index = 1){
			gosub WaitS
		}
		SendEvent ^{Tab}
		gosub WaitS
	}
	SendEvent ^{Tab}
	Defaults()
}
RunProgram(WinTitle, FilePath) { ; Run a program only if it isn't already running
	SetTitleMatchMode, 2 ; approximate match
	IfWinExist, %WinTitle%
		WinActivate, %WinTitle%
	else
	{
		Run, %FilePath%
		WinWaitActive, %WinTitle%
	}
}
Wait(Seconds) { ;creating a new syntax for pausing in AHK
	Seconds := Seconds*1000
	If Seconds <= 0
		return
	Sleep %Seconds%
}
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Substrings
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
BlockAllInput:
	BlockInput, On
	BlockInput, MouseMove
	CoordMode, Mouse, Screen
	MouseGetPos, MouseX, MouseY
	MouseMove, 10000, 510
	Return
DateParse:
	StringMid, YYYY, YYYYMMDD,1,4
	StringMid, YY, YYYYMMDD,3,2
	StringMid, MM, YYYYMMDD,5,2
	StringRight, DD, YYYYMMDD,2
	
	; If the month is June or July, do not abbreviate it anywhere.
	If (MM = 06 or MM = 07)
	{
		FormatTime, MMMLower, 2015%MM%21, MMMM
	}
	else if (MM = 09)
	{
		MMMLower := "SEPT"
	}
	else
	{
		FormatTime, MMMLower, 2015%MM%21, MMM
	}
	FormatTime, MMMM, 2015%MM%21, MMMM
	StringUpper, MMM, MMMLower
	Return
FlightDateInput:
	If WinName =
		WinGetActiveTitle, WinName
	InputBox, FlightDateRaw, Input Flight Date, Input date using format YYMMDD, , 320, 240
	If (RegExMatch(FlightDateRaw, regexDate8Digit) = 1 or RegExMatch(FlightDateRaw, regexDate6Digit) = 1)
	{
		If RegExMatch(FlightDateRaw, regexDate8Digit) = 1
			YYMMDD := Regexreplace(FlightDateRaw, regexDate8Digit, "$1")
		If RegExMatch(FlightDateRaw, regexDate6Digit) = 1
			YYMMDD := FlightDateRaw
		YYYYMMDD := "20" . YYMMDD
	}
	Else ErrorLevel := 1
	If ErrorLevel
	{
		MsgBox, 5, Flight Date Input Failure, 
		(LTrim
			You have not entered a valid flight date.
			Would you like to Retry or Cancel the operation?
		)
		IfMsgBox Retry
			GoSub FlightDateInput
		Else
			Exit
		Return
	}
	Else
	{
		GoSub DateParse
		MsgBox, 6, Flight Date Input Success,
		(LTrim
			You entered: %FlightDateRaw%
			Standard format: %MMMM% %DD%, %YYYY%
			Titleblock: %MMM% %DD% %YYYY%
			Folder Tree: %YYMMDD%
		)
		IfMsgBox TryAgain
			GoSub FlightDateInput
		IfMsgBox Cancel
			Exit
	}
	SetTitleMatchMode Fast
	SetTitleMatchMode 1
	WinActivate, %WinName%
	WinName := ""
	Return
FlightDateValidate:
	If FlightDateRaw =
		GoSub FlightDateInput
	Return
BridgeBatch:
	GoSub WaitXL
	Send {Alt}
	Send TP{Enter}
	WinWaitActive, ahk_class #32770, , .3
	If !ErrorLevel
		Send !y
	Return
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
WaitXXL:
	Sleep 2000
	return
WaitXXXL:
	Sleep 3000
Backups:
	gosub, BackupAppdata
	return
BackupAppdata:
	FormatTime, BackupDate, ,yyyyMMdd
	For i, value in AppDataBackups
	{
		IfExist, %folderShawnBackups%%BackupDate%%value%
			continue
		FileCopyDir, %A_Appdata%%value%, %folderShawnBackups%%BackupDate%%value%, 1
	}
	; Delete all folders in the backups folder dated older than 31 days
	CurrentTime := 
	EnvAdd, CurrentTime,  -31, days
	FormatTime, CurrentTime, %CurrentTime%, yyMMdd
	Loop, %folderShawnBackups%*, 2, 0
	{
		If (A_LoopFileName < CurrentTime and RegExMatch(A_LoopFileName, regexDate6Digit))
			FileRemoveDir, %A_LoopFileLongPath%, 1
	}
	; schedule "BackupAppdata" to run again tomorrow at the same time
	SetTimer, Backups, 86400000
	return
TitleblockFilenames:
	Filelist := ""
	Loop , %folderTitleBlocks%*.psd, 0, 1
	{
		LoopFileShortNameNoExt := RegExReplace(A_LoopFileName, regexRemovePSD, "$1")
		Filelist = %Filelist%%LoopFileShortNameNoExt%`n
	}
	Sort, Filelist, U
	FileDelete, %folderShawnDocs%AI Titleblocks.csv
	FileAppend, %Filelist%, %folderShawnDocs%AI Titleblocks.csv
	return
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Adobe Bridge Shortcuts
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#IfWinActive ahk_class Bridge_WindowClass
!F12:: ; 96 ppi TB/CR
	PsBatch(3, 5)
	Return
!F11:: ; 96 ppi CR
	PsBatch(3, 6)
	Return
!F10:: ; 96 ppi
	PsBatch(3, 7)
	Return
!F8:: ; 300 ppi TB/CR to CD Folder
	PsBatch(3, 2)
	Return
!F7:: ; 300 ppi CR to CD Folder
	PsBatch(3, 3)
	Return
!p:: ; Basic action to edit in Photoshop
	PsBatch(0, 0)
	WinActivate, ahk_class CabinetWClass ahk_group groupTB
	Return
$^n:: ; New small Basic window resets workspace
	Send ^n^{F2}!ww{Enter}
	Return
$!n:: ; New large Main Browser Window resets workspace
	Send ^n^{F1}!ww{Enter}
	Return
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Adobe Photoshop Shortcuts
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#IfWinActive ahk_group Photoshop
+F12:: ; Captures tab title, stores file number & use PS action Flat/Sharp
	gosub BlockAllInput
	Send ^{Tab}
	gosub WaitS
	Send ^+{Tab}
	gosub WaitS
	SetTitleMatchMode 3
	WinGetActiveTitle, PsWinTitle
	PsFilename := RegExReplace(PsWinTitle,regexOrigFilename,"$1$2$3$4$6$7$8")
	PsFileNumberSuffix := RegExReplace(PsWinTitle,regexOrigFilename,"$3$7")
	;~ MsgBox, ,pswindow name captured, %PsWinTitle%
	GoSub WaitXXXL
	Send {F2}
	GoSub WaitXXXL
	SetTitleMatchMode Fast
	SetTitleMatchMode 2
	Send !w1
	GoSub WaitXL
	Send ^+{tab}
	GoSub WaitXL
	Send +{F2}
	GoSub WaitS
	Send ^t
	Send ^0
	Defaults(True)
	MouseMove, 1307, 937
	Return
^+F11:: ; Flattten, sharpen, and save to Temp
	PsBatch(3, 0, false)
	WinActivate, Temp ahk_class Bridge WindowClass
	Return
^+F10:: ; Save As automation for TB images
	;~ PsSaveAs("Y:\","Address: Y:\")
	PsSaveAs("C:\Users\WS2\Desktop\Temp", "Address: C:\Users\WS2\Desktop\Temp")
	Return
^+F9:: ; Flatten and save to Temp
	PsBatch(3, 1, false)
	WinActivate, Temp ahk_class Bridge WindowClass
	Return
^+F8:: ; Flatten and Save over
	PsBatch(2, 0, false)
	Return
~$^!w:: ; Auto close all Photoshop windows
	WinWaitActive ahk_class #32770
	Send +{Tab}{Space}{Tab 2}{Enter}
	Return
~$^w:: ; Auto close current Photoshop window
	WinWaitActive ahk_class #32770
	Send !n
	Send ^{Tab}
	Return
^+w:: ; Auto close current Photoshop window and save over original file
	Send ^w
	WinWaitActive, ahk_class #32770, , .3
	Send !y
	Return
^!a:: ; Change TB Date then swap tabs in Photoshop
	GoSub FlightDateValidate
	GoSub BlockAllInput
	SendInput {Home}+{End}%MMM% %DD% %YYYY%{NumPadEnter}
	Gosub WaitM
	SendInput v^s
	Gosub WaitS
	WinMaximize A
	WinRestore A
	WinGetActiveTitle, WinName
	TBFilenamePrefix := RegExReplace(WinName,regexPStabTB,"$1")
	SendInput ^{Tab}
	WinActivate
	Defaults()
	Return
^NumpadAdd:: ; Set active window as TB window similar to +F12
	Send ^{Tab}
	Gosub WaitS
	Send ^+{Tab}
	Gosub WaitS
	WinGetActiveTitle, WinName
	TBFilenamePrefix := RegExReplace(WinName,regexPStabTB,"$1")
	MsgBox,,Titel Block Window, The TB Window is:`n%WinName%`n`nThe prefix is:`n%TBFilenamePrefix%
	Return
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; General Shortcuts
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#IfWinActive
^`:: ; Re-open this AHK script
	Run, %A_ScriptFullPath%
	ExitApp
^+`::
	Defaults()
	Return
^+e:: ; set explorer working space for production
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
	Run, %Email%
	If WinExist("Zenfolio")
	{}
	Else Run, %Zenfolio%
	Defaults()
	return
	
^+a:: ; Send email signature with variable date based on the flight date
	GoSub FlightDateValidate
	GoSub BlockAllInput
	Send {End} - Aerial Photos{Space}
	SendInput %MMMM% %DD%, %YYYY%
	If winactive("Hightail" ahk_class YsiMainWindow){
		SendInput {Tab}
		gosub WaitM
		SendInput %emailSigAerialPhotos%%userName%{Enter}
		gosub WaitS
		WinActivate, CD Folder
	}
	else {
		SendInput {Tab 4}
		gosub WaitXS
		SendInput %emailSigAerialPhotos%%userName%{Enter}
		gosub WaitXS
		WinActivate, Email Folder
	}
	Defaults()
	return
^!d:: ; Draft title block email template
	Send {space}Title Block Approval{Tab 4}
	SendInput %emailSigTitleblockApproval%%userName%{Enter}
	WinActivate, groupTB
	return
!NumpadDiv:: ; Input Flight Date variable
	GoSub FlightDateInput
	Return
^NumpadSub:: ; List Variables
	WinGetActiveTitle, PsWinTitleTB
	TBReplaceCount :=
	TBFilenamePrefix := RegExReplace(PsWinTitleTB, regexPStabTB,"$1",TBReplaceCount)
	PsFilename := RegExReplace(PsWinTitle, RegExTabB,"$1$2$3")
	PsFileNumberSuffix := RegExReplace(PsWinTitle, regexOrigFilename,"$3")
	ArrayPrint(ProdExplorer)
	ListVars
	Return
^!NumpadSub:: ; get window testing show hidden PS files
	WinGetActiveTitle, PsWinTitle
	WinGet, WindowTabID, ID
	ListVars
	Return
^+!NumpadAdd:: ; capture window names to CSV for debugging
	GoSub BlockAllInput
	DetectHiddenWindows, On
	WinGet, id, list,,, Program Manager
	FileDelete, WindowInfo.txt
	FileAppend,
	(
	ahk_id,ahk_pid,ahk_class,title`n
	), WindowInfo.txt

	Loop, %id%
	{
		this_id := id%A_Index%
		WinGetClass, this_class, ahk_id %this_id%
		WinGetTitle, this_title, ahk_id %this_id%
		WinGet, this_pid, PID, ahk_id %this_id%
		FileAppend,
		(
		"%this_id%","%this_pid%","%this_class%","%this_title%"`n
		), WindowInfo.txt
	}
	MsgBox, , Window Parse Complete, %id% windows parsed.
	Defaults()
	Return
	
^!NumpadAdd:: ; cycle though all windows for debugging
	WinGetAll(False, True)
	Return
^!+F1:: ; Most all files from curerntly selected folders into %folderArchives% then moves the folder to a temp backup location
	 ; Declare/Clear variables used in this function
	FolderPath := Array()
	For i, value in FolderPath
		FolderPath.Remove(i)
	; Retrieve Folders in which to search for .jpg files
	selectedPaths := Explorer_GetSelected() 
	If (selectedPaths = "`n")
	{
		MsgBox,,Error,"You need to select the folders to be transferred to Customer before activating."
		return
	}
	; parse selected folders into array
	FormatTime, CurrentTime, ,yyyyMMdd\HH_mm_ss\
	Loop,  parse, selectedPaths,`n
	{
		FileList := ""
		LogInput := ""
		; for each folder that was selected, add the folder to an array. Look for files inside each folder for a given file pattern
		FolderPath.Insert(A_LoopField)
		; add matching files to a temp list
		Loop, % FolderPath[A_Index]BackupFilePattern, 0, 1
			Filelist = %Filelist%%A_LoopFileLongPath%`n
		
		; Parse the list, move the files
		Loop, Parse, Filelist,`n 
		{
			FileMove, %A_LoopField%, %folderArchivesTemp%, 1
			If ErrorLevel != 0 
			{
				MsgBox,,, Could not move %A_LoopField% into %DestinationFolder%. `n ErrorLevel is %ErrorLevel%
				LogInput := %LogInput%%A_LoopField%`n
			}
		}
		If LogInput !=
			FileAppend, %LogInput%, BackupLog_%CurrentTime%.txt
		else
		{
			RootDir := Regexreplace(FolderPath[A_Index], regexDir, "$2")
			FileMoveDir, % FolderPath[A_Index], %folderNASRecycle%%CurrentTime%%RootDir%, 1
		}
	}
	MsgBox,,, Backup Complete
	return
	
^!+F12::
Send %emailSigAerialPhotos%