  ; shortcuts to workaround win10 hogging of keys and other global-ish utils
; https://github.com/elonderin/ahk-scripts/blob/main/win10.ahk

#SingleInstance Force

; ------ HELP
; https://www.autohotkey.com/docs/v1/KeyList.htm
; https://www.autohotkey.com/docs/v1/lib/Send.htm#keynames
; https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
; 	dbl click on AHK icon and then cltrl+k
; https://jacks-autohotkey-blog.com/2016/04/14/understanding-autohotkey-keyboard-scan-codes-and-virtual-key-codes-beginning-hotkeys-part-12/
; # win
; ! alt
; ^ ctrl
; + shift


; -------- move maxed intellij
; the main use case is to move maxed intellij windows from one scren to the next, which causes them to flicker and crash sometimes
; 	 by de-maximizing them this is mitigated.
; so far i dont see the need to limit this just to WSL/intellij windows
#+Left::MoveMaxedWindowWorkaround("{Left}")
#+Right::MoveMaxedWindowWorkaround("{Right}")
#+Up::MoveMaxedWindowWorkaround("{Up}")
#+Down::MoveMaxedWindowWorkaround("{Down}")

MoveMaxedWindowWorkaround(key){
	WinGetActiveTitle, activeWindowTitle
	WinGet, wasMax, MinMax, A

	; Demaximize the active window
	WinRestore, %activeWindowTitle%

	SoundBeep, 750, 500

	Send, #+%key%
	if (wasMax = 1) {
		WinMaximize, %activeWindowTitle%
	}
}


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
; old cut/Copy/paste
;https://www.autohotkey.com/docs/v1/lib/Send.htm#keynames
;https://www.autohotkey.com/docs/v1/lib/Send.htm#Repeating_or_Holding_Down_a_Key
;https://www.autohotkey.com/boards/viewtopic.php?t=13902
;https://www.autohotkey.com/docs/v1/Hotkeys.htm
; ## i need to release the mod keys on the left side, ie. +Del::^x results in +^x
; --------
;^Ins::^c
;+Ins::^v
;+Del::^x


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
; workaround for win10/11 capturing win+v and also win+shift+v
;#^v::
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
; SPOTIFY
; media key always goes to spotify (MS teams interferes often and then it wont work)
SC122::
Media_Play_Pause::
	WinActivate, ahk_exe Spotify.exe
	Send {Space}
	WinSet, Bottom,,A
return

; ### aint working
	WinGet, active_id, ID, ahk_exe Spotify.exe
	ControlSend ,ahk_parent,{Space}, ahk_id %active_id%
; ### aint working -- might be due to the fakt of >1 processes
	ControlSend ,ahk_parent,{Space}, ahk_exe Spotify.exe
;	SoundBeep
;#### works
	WinGet, active_id, ID, A
	WinActivate, ahk_exe Spotify.exe
	Send {Space}
	WinActivate, ahk_id %active_id%
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
#IfWinActive

; --------------------------------------
; win 11: close window function when window maneu has been opend in taskbar
; sample from spy:
;	Jump List for Estlcam V12 CAM
;	ahk_class Windows.UI.Core.CoreWindowccc
;	ahk_exe ShellExperienceHost.exe
;	ahk_pid 15576
#if WinActive("ahk_exe ShellExperienceHost.exe")
		and WinActive("Jump List for")
		and WinActive("ahk_class Windows.UI.Core.CoreWindow")
c::
	SendInput {Up}{Space}
return
#if

; ----
