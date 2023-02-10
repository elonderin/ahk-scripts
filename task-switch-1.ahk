this is not working (yet)!!!


; --------------------------
; win + ` -- switch to next of same app
;   note: SC029 is DE's '^' / EN's '`'
; TODO
;   + dont minimize to put to background
;   + show list of windows
;   + sort them by window id and be able to quickly select one by hitting the number, similar to alt + w, # in eclipse and other programs
;   + integrate in alt+tab window selection -- if possible
; see https://www.autohotkey.com/docs/Hotkeys.htm#alttab

;!`::
;#!SC029::
;SoundBeep, 300
;nextWindowOfApp()
;Return
  
nextWindowOfApp() {
   WS_EX_TOOLWINDOW = 0x80
   WS_EX_APPWINDOW = 0x40000
   tw := []
   aw := []

   WinGet, wantedProcessName, ProcessName, A
   wantedProcessName = "firefox.exe"

   DetectHiddenWindows, Off
   windowIds :=  AltTab_window_list(1)

   ; mark all other windows as tool window, so they are hidden in window list
   For i, wid  in windowIds {
      WinGet, processName2, ProcessName, ahk_id %wid%

      ;better to find root process for firefox running >1 instances
      if (processName2 != wantedProcessName) {
         WinGet, exStyle2, ExStyle, ahk_id %wid%

         if (!(exStyle2 & WS_EX_TOOLWINDOW)) {
            tw.InsertAt(0, wid)
            WinSet, ExStyle, ^0x80, ahk_id %wid%
         }

         if ((exStyle2 & WS_EX_APPWINDOW)) {
            aw.InsertAt(0, wid)
            WinSet, ExStyle, ^0x40000, ahk_id %wid%
         }
      }
   }

   Send {Alt Down}{Tab} ; Bring up switcher immediately

   KeyWait, ``, T.25  ; Go to next window; wait .25s before looping
   if (Errorlevel == 0) {
      While ( GetKeyState( "Alt","P" ) ) { 
         KeyWait, ``, D T.25
         if (Errorlevel == 0)  {
            if (GetKeyState( "Shift","P" )) {
               Send {Alt Down}{Shift Down}{Tab} 
               Sleep, 200
            } else {
               Send {Alt Down}{Tab}
               Sleep, 200
            }
         }
      }
   }

   Send {Alt Up} ; Close switcher on hotkey release

   for index, wid in tw {
      WinSet, ExStyle, ^0x80, ahk_id %wid%
   }

   for index, wid in aw {
      WinSet, ExStyle, ^0x40000, ahk_id %wid%
   }
}
return

AltTab_window_list(excludeToolWindows) {
   WS_EX_CONTROLPARENT =0x10000
   WS_EX_APPWINDOW =0x40000
   WS_EX_TOOLWINDOW =0x80
   WS_DISABLED =0x8000000
   WS_POPUP =0x80000000
   windowIds := []
   WinGet, Window_List, List,,, Program Manager ; Gather a list of running programs

   Loop, %Window_List% {
      wid := Window_List%A_Index%
      WinGetTitle, wid_Title, ahk_id %wid%
      WinGet, Style, Style, ahk_id %wid%

      If ((Style & WS_DISABLED) or ! (wid_Title)) ; skip unimportant windows
         Continue

      WinGet, es, ExStyle, ahk_id %wid%
      WinGetClass, Win_Class, ahk_id %wid%
      Parent :=  DllCall( "GetParent", "uint", wid ) 
      WinGet, Style_parent, Style, ahk_id %Parent%

      If ((excludeToolWindows & (es & WS_EX_TOOLWINDOW))
         or ((es & ws_ex_controlparent) and ! (Style & WS_POPUP) and !(Win_Class ="#32770") and ! (es & WS_EX_APPWINDOW)) ; pspad child window excluded
         or ((Style & WS_POPUP) and (Parent) and ((Style_parent & WS_DISABLED) =0))) ; notepad find window excluded ; note - some windows result in blank value so must test for zero instead of using NOT operator!
         continue
      windowIds.Push(wid)
   }  
;   AltTab_ID_List_0 := windowIds
   Return windowIds
}


