; shortcuts to workaround win10 hogging of keys and other utils
; https://github.com/elonderin/ahk-scripts/blob/main/win10.ahk

; ------ HELP
; # win
; ! alt
; ^ ctrl
; + shift

; -------------------------
; PAUSE:  display off / goto sleep
PAUSE::
	SoundBeep
	Run, doff.bat
return

+PAUSE::
	SoundBeep, 750, 500
	Run, sleep.bat
return

; --------------------------
; virtua win
; win+ctrl+left/right are now taken by windows remap them to win+alt+left/right which has to be now the config'ed setting in VWin
#^Left::
	SendInput, #!{Left}
return

#^Right::
	SendInput, #!{Right}

; --------------------------
; DITTO
#c::
if !WinActive("Ditto") {
	SendInput, #{Ins}
	WinActivate, Ditto
}
return

#v::
if !WinActive("Ditto") {
	SendInput, #+{Ins}
	WinActivate, Ditto
}
return

; --------------------------
; one note sniping tool back on win+s
#s::
Send #+s
return


; --------------------------
; MS teams: remap key bindings: ctrl+1-6 -> F1-6, etc
#IfWinActive ahk_exe Teams.exe
!F4::!F4
F1::^1
F2::^2
F3::^3
F4::^4
F5::^5
F6::^6
F9::^+M
F12::^+k
return

; zoom key bindings: to align them with teams
#IfWinActive ahk_exe Zoom.exe
F9::!a
return


; ## i dont think, the rest below here work ATM

; --------------------------
; win + ` -- switch to next of same app
;   note: SC029 is DE's '^' / EN's '`'
; TODO
;   + dont minimize to put to background
;   + show list of windows
;   + sort them by window id and be able to quickly select one by hitting the number, similar to alt + w, # in eclipse and other programs
;   + integrate in alt+tab window selection -- if possible


#!SC029::    ; Next window
WinGet, ActiveProcess, PID, A
WinGet, OpenWindowsAmount, Count, ahk_pid %ActiveProcess%
If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
Else {
	WinSet, Bottom,, A
	WinActivate, ahk_pid %ActiveProcess%
}
return

#!+SC029::    ; Last window
WinGet, ActiveProcess, PID, A
WinGet, OpenWindowsAmount, Count, ahk_pid %ActiveProcess%
If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
Else {
	WinActivateBottom, ahk_pid %ActiveProcess%
}
return
