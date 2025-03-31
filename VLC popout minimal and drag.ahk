#Persistent
#SingleInstance Force
SetTitleMatchMode, 2  ; Matches partial window title
vlcTitle := "ahk_exe vlc.exe"
global isToggled := false

; Set a hotkey for Ctrl+H, but don't replace its default behavior
Hotkey, ^~LButton, CheckVLCState, On

ResizeVLC(width, height) {
    ; Get current window position and size
    WinGetPos, x, y, currentWidth, currentHeight, %vlcTitle%  ; Get current position and size of VLC window
    ; Resize the VLC window while retaining its current x and y position
    WinMove, %vlcTitle%, , x, y, width, height
}

CheckVLCState:  ; Use normal Ctrl+H behavior + additional functions
    if WinActive(vlcTitle) {  
        ; Send Ctrl + H to toggle the normal VLC minimal UI
        Send ^h  ; Send the normal VLC "minimal UI" toggle
        
        isToggled := !isToggled  ; Toggle state
        if (isToggled) {
            WinSet, AlwaysOnTop, On, %vlcTitle%  ; Set Always on Top
            WinSet, Style, -0xC00000, %vlcTitle%  ; Remove title bar
            
            ; Get current window size (height) and calculate width based on 16:9 aspect ratio
            WinGetPos, x, y, currentWidth, currentHeight, %vlcTitle%  ; Get current position and size of VLC window
            newWidth := (currentHeight * 16) // 9  ; Calculate width based on current height (16:9 aspect ratio)
            ResizeVLC(newWidth, currentHeight)
        } else {
            WinSet, AlwaysOnTop, Off, %vlcTitle%  ; Remove Always on Top
            WinSet, Style, +0xC00000, %vlcTitle%  ; Restore title bar
        }
    }
return

~LButton::
    if WinActive(vlcTitle) {  ; Only drag VLC when it's active
        CoordMode, Mouse, Screen
        MouseGetPos, startX, startY, winID
        if winID {
            WinGetPos, winX, winY,,, ahk_id %winID%
            while GetKeyState("LButton", "P") {
                MouseGetPos, newX, newY
                dx := newX - startX
                dy := newY - startY
                WinMove, ahk_id %winID%, , winX + dx, winY + dy
                Sleep, 1
            }
        }
    }
return