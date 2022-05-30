'
' TinyPTC by Gaffer
' www.gaffer.org/tinyptc
'
 
'
' TinyPTC Extension by rbraz 2007
'

'
' FreeBsic version verification by rdc
'

#include windows.bi

#if __FB_VERSION__ < "0.17" 
    '$inclib: "opengl32"
    '$inclib: "user32"
    '$inclib: "gdi32"
    '$inclib: "glu32"

    '$inclib: "mmx"
    '$inclib: "tinyptc_ext"
#else
    #inclib "opengl32"
    #inclib "user32"
    #inclib "gdi32"
    #inclib "glu32"

    #inclib "mmx"
    #inclib "tinyptc_ext"
#endif

#inclib "opengl32"
#inclib "user32"
#inclib "gdi32"
#inclib "glu32"

#inclib "mmx"
#inclib "tinyptc_ext"

'tinyptc api
declare function ptc_open	cdecl alias "ptc_open"		(byval title as zstring ptr, byval width as integer, byval height as integer ) as integer
declare function ptc_update	cdecl alias "ptc_update"	(byval buffer as integer ptr) as integer
declare function ptc_close	cdecl alias "ptc_close"		() as integer

'tinyptc extension
declare function ptc_setflip	cdecl alias "ptc_setflip"	(byval interval as integer) as integer
declare function ptc_getmousex	cdecl alias "ptc_getmousex"		() as integer
declare function ptc_getmousey	cdecl alias "ptc_getmousey"		() as integer
declare function ptc_getleftbutton	cdecl alias "ptc_getleftbutton"		() as integer
declare function ptc_getrightbutton	cdecl alias "ptc_getrightbutton"	() as integer
declare function ptc_setdialog	cdecl alias "ptc_setdialog"	(byval enable as integer, byval text as zstring ptr, byval mode as integer, byval border as integer ) as integer
declare function ptc_allowclose	cdecl alias "ptc_allowclose"	(byval enable as integer) as integer
declare function ptc_getwindow	cdecl alias "ptc_getwindow"		() as HWND
declare function ptc_setmousewheel	cdecl alias "ptc_setmousewheel"	(byval range as integer, byval delta as integer) as integer
declare function ptc_getmousewheel	cdecl alias "ptc_getmousewheel"	() as integer
