; shortcuts to workaround win10 hogging of keys and other global-ish utils
; https://github.com/elonderin/ahk-scripts/blob/main/win10.ahk

#SingleInstance Force

; ------ HELP
; https://www.autohotkey.com/docs/v1/lib/Send.htm#keynames
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
return

; --------------------------
; DITTO
; reqs:  tab "keyboard shortcuts"
; show popup
#c::
if !WinActive("Ditto") {
	SendInput, #{Ins}
	WinActivate, Ditto
}
return

; paste plain text
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
; media key always goes to spotify (MS teams interferes often and then i wont work)
Media_Play_Pause:
	SetTitleMatchMode, 1
	ControlSend ,, {Media_Play_Pause}, Spotify
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
	F10::^+o
	F12::^+k
return

; zoom key bindings: to align them with teams
#IfWinActive ahk_exe Zoom.exe
   F9::!a
return
