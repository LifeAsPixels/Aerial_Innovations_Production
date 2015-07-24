Defaults(MouseReset = False) { ; Creates and resets default variables for frequently changed variables
	/*
	This function sets default variables that are commonly used with assumed values
	Passing True through this function will snap the mouse back to a stored location
	*/
	global
	CoordMode, Mouse, Screen
	BrBatchRun := 0
	SendMode Event
	SetTitleMatchMode 1
	SetTitleMatchMode Fast
	BlockInput, Off
	BlockInput, MouseMoveOff
	DetectHiddenWindows, Off
	If MouseReset {
		MouseMove, %MouseX%, %MouseY%, 0
		CoordMode, Mouse, Window
	}
}