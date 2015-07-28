#SingleInstance force ; Forces a single instance when trying to reopen script
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
ThreadActive := True
autoKey := []
return

threeOn = False


multiAutoFire:
    While (multiAutoFireActive = True and ThreadActive = True)
    {
        multiAutoFireActive := 0
        for i, value in autoKey
        {
            If GetKeyState(value, "P")
            {
                If autoKeyToggle[i] = True
                Send %value%
            }
        }
    }
    return


Pause::
    WinGetTitle, ActiveWinTitle, A
    ThreadActive := !ThreadActive
    return
;--------------------------------------------------------------
#IfWinActive, Minecraft
~$*LButton::
#IfWinActive, Diablo
~$*LButton::
#IfWinActive, Borderlands 2
~$*LButton::
#IfWinActive, WARFRAME
~$*LButton::
#IfWinActive, ahk_class StarCraft II


~$*LButton::
    If (!ThreadActive)
        Return
    While GetKeyState("LButton", "P")
        {
        Click
        ;~ sendinput 1
        Sleep 1
        }
    return
;--------------------------------------------------------------
#IfWinActive, Minecraft
~$*RButton::
    If (!ThreadActive)
        Return
    While GetKeyState("RButton", "P")
        {
        Click Right
        Sleep 250
        }
    return
;--------------------------------------------------------------
#IfWinActive, WARFRAME

^!+F12::
    Sleep 500
    
    Loop % autoKey.MaxIndex()
        Hotkey, % autoKey[A_Index], multiAutoFire
    return
    

~$*1::
  If (!ThreadActive)
        Return
    While GetKeyState("1", "P")
        {
        Send 1
        Sleep 1
        }
    return
~$*2::
  If (!ThreadActive)
        Return
    While GetKeyState("2", "P")
        {
        Send 2
        Sleep 1
        }
    return
~$*3::
    ;~ threeOn := !threeOn
    ;~ while threeOn
    ;~ {
        ;~ IfWinActive ,,,,Warframe or !ThreadActive
            ;~ break
        ;~ send 3
        ;~ sleep 1000
    ;~ }
    If (!ThreadActive)
        Return
    While GetKeyState("3", "P")
        {
        Send 3
        Sleep 1
        }
    return
~$*4::
  If (!ThreadActive)
        Return
    While GetKeyState("4", "P")
        {
        Send 4
        Sleep 1
        }
    return

^`::
    ExitApp
;------------------------------------------------------------------
/* Below is a working script to create a hotkey for variable amount of keys pressed.


    keys = ``1234567890-=qwertyuiop[]\asdfghjkl;'zxcvbnm,./

    Loop Parse, keys

       HotKey ~*%A_LoopField%, Hoty



    Hoty:

       SoundBeep 999, 1

    Return



OR


    Loop 26

     Hotkey, % "~" Chr(A_Index+96),SomeLabel ;loop creating hotkeys for a-z

    Return



    SomeLabel:

    Func(A_ThisHotkey)

    Return



    Func(var) {

    MsgBox %var%

    }