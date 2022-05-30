'  ===========================================================================
'   MiniFMOD public source code release.
'   This source is provided as-is.  Firelight Multimedia will not support
'   or answer questions about the source provided.
'   MiniFMOD Sourcecode is copyright (c) 2000, Firelight Multimedia.
'   MiniFMOD Sourcecode is in no way representative of FMOD 3 source.
'   Firelight Multimedia is a registered business name.
'   This source must not be redistributed without this notice.
'  ===========================================================================
'
'  ===========================================================================
'   MiniFMOD Main header file. Copyright (c), FireLight Multimedia 2000.
'   Based on FMOD, copyright (c), FireLight Multimedia 2000.
'  ===========================================================================

'  ===========================================================================
'   Freebasic compatible library and wrapper by rbz - 24 Dec 2008
'  ===========================================================================

#ifndef _MINIFMOD_H_
#define _MINIFMOD_H_

#include "windows.bi"
#include "win/mmsystem.bi"

#if __FB_VERSION__ < "0.17" 
    '$inclib: "winmm"
    '$inclib: "minifmod170"
#else
    #inclib "winmm"
    #inclib "minifmod170" 
#endif

'' ===========================================================================
''                              MiniFmod API                                
'' ===========================================================================
Declare Function MiniFmod_Init         Cdecl Alias "MiniFmod_Init"         (byval Music as any ptr, byval size as integer) as integer
Declare Sub      MiniFmod_Play         Cdecl Alias "MiniFmod_Play"         ()
Declare Sub      MiniFmod_Stop         Cdecl Alias "MiniFmod_Stop"         ()
Declare Sub      MiniFmod_Free         Cdecl Alias "MiniFmod_Free"         ()
Declare Function MiniFmod_GetOrder     Cdecl Alias "MiniFmod_GetOrder"     () as integer
Declare Function MiniFmod_GetRow       Cdecl Alias "MiniFmod_GetRow"       () as integer
Declare Function MiniFmod_GetTime      Cdecl Alias "MiniFmod_GetTime"      () as unsigned integer
Declare Function MiniFmod_GetSynch     Cdecl Alias "MiniFmod_GetSynch"     (byval channel as integer) as unsigned integer
Declare Function MiniFmod_GetChannels  Cdecl Alias "MiniFmod_GetChannels"  () as integer
