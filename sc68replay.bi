' |                                                                             |
'-+-----------------------------------------------------------------------------+-
' |           ___________________________________________________               |
' |        oOo\______   \_   _____/\__    ___/\______   \\_____  \        o     |
' |    ______  |     / _/|    __)_   |    |    |     / _/ /   |   \   ______    |
' |   /_____/  |    |   \|        \  |    |    |    |   \/    |    \ /_____/    |
' |            |____|_  /_______  /  |____|    |____|_   /\_______  /    oOo    |
' |                   \/        \/                    \/                        |
' |  ooOOoo     tTTTt                 rrRROORRrr                                |
' |  _____________________   _____      _____   ____  __.___________ _________  |
' |  \______   \_   _____/  /     \    /  _  \ |    |/ _|\_   _____//   _____/  |
' |   |     / _/|    __)_  /  \ /  \  /  /_\  \|      <   |    __)_ \_____  \   |
' |   |    |   \|        \/    Y    \/    |    \    |  \  |        \/    /   \  |
' |   |____|_  /_______  /\____|__  /\____|__  /____|__ \/_______  /_______  /  |
' |          \/        \/         \/         \/        \/        \/        \/   | 
' |       rRORr          ..::. www.retro-remakes.net .::..                      |          
'-+-----------------------------------------------------<Shockwave^S!P>--+---+--+-
' |                                                                      | O |  |
' |                                                             rRr      |   |  |
' |                        _ __ __  _____  _____  _____                  +---+--+-
' |                   _    _|  |  ||     ||  |  || __  |                     |o |
' | ooOOoo               _  |_   _||  |  ||  |  ||    -|                     |  |
' |                         _ |_|  |_____||_____||__|__|                     | O|
' |                                    ., your ,.              ooOoo         |  |
' |                 _  .---..----..-..-..---. .---..---.                     +--+-
' |                  _  \ \ | || || || || |-< | |  | |-                         |
' |      oOo       _   `---'`----'`----'`-'`-'`---'`---'            oOo         |
' |                       ., source ,.                                          |
' |          _  .---..----..---.  .---..-..-..---..-.   .-..---..-..-.          |
' |            _| |- | || || |-<  | O ,| || || | || |__ | |`| |' >  /           |
' |       _     `-'  `----'`-'`-' `-'\\`----'`-^-'`----'`-' `-'  `-'            |
' |                ., for ,.             ., quality ,.                          |
' |               _.--. .---..-.-.-..----. .---..---..---..-..-..---.           |
' |            _ = | \ \| |- | | | || || |  \ \ | |  | |- | .` || |-            |
' |               _`-'-'`---'`-'-'-'`----' `---'`---'`---'`-'`-'`---'           |
' |                    ., demo ,.                   ., scene ,.                 |
' |             _  ______ _______ _______ _______ __  __ _______ _______        |
' |         _    _|   __ \    ___|   |   |   __  |  |/  |    ___|     __|       |
' |      _    _   |   \/ <    ___|       |   \/  |  |  <|   ==__|__     |       |
' |              _|___|__|_______|__|_|__|___|___|__|\__|_______|_______|       |
' |                                   ., remakes ,.                             |
' |         ooOOoo                                                     oOo      |
'-+----------------------------------------------------------------------+---+--+-
'                            sc68 Library
'         Copyright (C) 2001 Ben(jamin) Gerard <ben@sashipa.com>
'
'  This program is free software; you can redistribute it and/or modify it
'  under the terms of the GNU General Public License as published by the
'  Free Software Foundation; either version 2 of the License, or (at your
'  option) any later version.
'
'  This program is distributed in the hope that it will be useful, but
'  WITHOUT ANY WARRANTY; without even the implied warranty of
'  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
'  General Public License for more details.
'
'  You should have received a copy of the GNU General Public License along
'  with this program; if not, write to the Free Software Foundation, Inc.,
'  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
'-+----------------------------------------------------------------------+---+--+-
'
'  Minimal version of the SC68 Emulator and replay routines by:
'                                             - Stormbringer -
'
'  Freebasic sc68replay library version 1.01 by:
'                                             - rbraz - 
'
'  Release: 01 Apr 2008
'  Freebasic Wrapper version: 1.0
'
'-+----------------------------------------------------------------------+---+--+-

#ifndef __sc68replay_bi__
#define __sc68replay_bi__

#if __FB_VERSION__ < "0.17" 
    '$inclib: "winmm"
    '$inclib: "sc68replay"
#else
    #inclib "winmm"
    #inclib "sc68replay"
#endif

#define SC68Replay_MEMORY 0
#define SC68Replay_FILE   1

'sc68replay API
declare function sc68replay_Init cdecl alias "sc68replay_Init" (byval musicDisk as any ptr, byval size as uinteger, byval mode as uinteger) as integer
declare function sc68replay_Play cdecl alias "sc68replay_Play" () as integer
declare function sc68replay_Stop cdecl alias "sc68replay_Stop" () as integer
