; shortcuts to workaround win10 hogging of keys and other utils

; --------------------------
; virtua win
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
; win + ` -- switch to next of same app
;   note: SC029 is DE's '^' / EN's '`'
; TODO
;   + show list of windows
;   + sort them by window id and be able to quickly select one by hitting the number, similar to alt + w, # in eclipse and other programs
;   + integrate in alt+tab window selection -- if possible


!SC029::    ; Next window
WinGet, ActiveProcess, PID, A
WinGet, OpenWindowsAmount, Count, ahk_pid %ActiveProcess%
If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
Else {
	WinSet, Bottom,, A
	WinActivate, ahk_pid %ActiveProcess%
}
return



!+SC029::    ; Last window
WinGet, ActiveProcess, PID, A
WinGet, OpenWindowsAmount, Count, ahk_pid %ActiveProcess%
If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
    Return
Else {
	WinActivateBottom, ahk_pid %ActiveProcess%
}
return
