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
'  TinySID v1.0 Generic Replay
'
'  rewritten by Stormbringer in July 2008
'
'  based on PSP original source code by Tammo Hinrichs & Rainer Sinsch
'
'  changes made:
'
'  - removed any platform/audio device/audio mechanism dependency
'  - original comments kept
'  - code cleaned
'  - added new comments to make code clearer to read
'  - functions renamed to avoid conflict with other functions in client programs (all have sid_ prefix now)
'  - removed local variables
'  - added SIDEmulator structure that holds the state of the emulator (memory, registers, etc)
'  - changed the compilation-time audio filtering with a run-time audio filtering flag
'
'  instructions:
'
'  1) declare a variable of the type SIDEmulator (emulator state)
'  2) call sid_emu_init() with the address of the emulator state variable and replay frequency (e.g. 44100)
'  3) call sid_emu_load_from_mem() with the address of the emulator variable and the address and size of the SID tune 
'	to be loaded in the emulator memory
'  4) call sid_emu_process_begin() with the address of the emulator variable and the number of the sub-song (zero-based number) to be replayed
'	you may want to call sid_emu_get_subsong_count() before to know how may sub-songs are contained in the file
'  5) call sid_emu_process() during your audio interrupt/callback to render new samples.
'
'  NOTE: the audio stream is rendered as MONO not STEREO! 
'  NOTE2: you may call sid_emu_audio_filter() to turn on and off the audio filtering (works at run-time)
'
'  web: www.retro-remake.net
'  email: stormbringer@retro-remakes.net
'
''-+----------------------------------------------------------------------+---+--+-
'
'  Freebasic library version by:
'                            - rbraz - 
'
'  Release: 06 Jul 2008
'  Freebasic Wrapper version: 1.0
'
'-+----------------------------------------------------------------------+---+--+-

#ifndef __tsidreplay_bi__
#define __tsidreplay_bi__

#if __FB_VERSION__ < "0.17" 
    '$inclib: "winmm"
    '$inclib: "tsidreplay"
#else
    #inclib "winmm"
    #inclib "tsidreplay"
#endif

'tsidReplay API

'init sound server 
declare sub sid_sound_server_replay_init cdecl alias "sid_sound_server_replay_init" (byval tuneData as any ptr, byval tuneSize as uinteger, byval subSong as ubyte)
'start sound server playback mechanism 
declare sub sid_sound_server_replay_play cdecl alias "sid_sound_server_replay_play" ()
' stop sound server /
declare sub sid_sound_server_replay_stop cdecl alias "sid_sound_server_replay_stop" ()

