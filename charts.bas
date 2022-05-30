'
'
'       THE GAME SCENE CHARTS NEW ENGINE CODED BY WIDOWMAKER (C) 2009.
'
'
'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------
' INCLUDE LIBRARIES
'-------------------------------------------------------------------------------

    #INCLUDE "TINYPTC_EXT.BI"
    #INCLUDE "WINDOWS.BI"

'    #INCLUDE "mag_gfx/amypal.bas"
'    #INCLUDE "mag_gfx/amyraw.bas"

    #include "tsidreplay.bi"
    
    #include "hubbard/rh1.bas"
    #include "hubbard/rh2.bas"
    #include "hubbard/rh3.bas"
    #include "hubbard/rh4.bas"
    #include "hubbard/rh5.bas"
    #include "hubbard/rh6.bas"
    #include "hubbard/rh7.bas"
    #include "hubbard/rh8.bas"
    #include "hubbard/rh9.bas"
    #include "hubbard/rh10.bas"
    #include "hubbard/rh11.bas"
    #include "hubbard/rh12.bas"


   #INCLUDE "mag_gfx/sinefontraw.bas"
    #INCLUDE "mag_gfx/sinefontpal.bas"

    #INCLUDE "minifmod170.bi"

    'Include song
    
    #INCLUDE "music1.bas"     
    #INCLUDE "music2.bas"     
    #INCLUDE "music3.bas"     
    #INCLUDE "music4.bas"     

'-------------------------------------------------------------------------------
'   SKIN:
'-------------------------------------------------------------------------------

    #INCLUDE "mag_gfx/skinpal.bas"
    #INCLUDE "mag_gfx/skinraw.bas"

    #INCLUDE "mag_gfx/skinbpal.bas"
    #INCLUDE "mag_gfx/skinbraw.bas"


'-------------------------------------------------------------------------------
'   FONT:
'-------------------------------------------------------------------------------

    #INCLUDE "mag_gfx/font8craw.bas"
    #INCLUDE "mag_gfx/font8cpal.bas"
    
    #DEFINE ALPHAA(s,d) ((((s and &hff00ff)*(s shr 24)+(d and &hff00ff)*(256-(s shr 24)))and &hff00ff00)or(((s and &hff00)*(s shr 24)+(d and &hff00)*(256-(s shr 24)))and &hff0000))shr 8


'-------------------------------------------------------------------------------
'   FIXED ARRAYS VARIABLES MUST ALL BE DECLARED.
'-------------------------------------------------------------------------------

    OPTION STATIC
    OPTION EXPLICIT

'-------------------------------------------------------------------------------
'   PAGES:
'-------------------------------------------------------------------------------

    DIM SHARED AS INTEGER LINES,PAGES
    
    LINES=5000
    PAGES=20
    
    DIM SHARED AS STRING TEXT_LINE(LINES,PAGES)' <- HOLDS THE LETTERS.
    DIM SHARED AS STRING  COL_LINE(LINES,PAGES)' <- HOLDS THE COLOURMAP.
    DIM SHARED AS STRING FONT_LINE(LINES,PAGES)' <- HOLDS THE TEXT STYLE.
    DIM SHARED AS STRING PAGE_LINE(LINES,PAGES)' <- HOLDS PAGEBREAKS.
    
    DIM SHARED AS INTEGER CURRENT_PAGE = 11
    DIM SHARED AS INTEGER PIXEL_SCROLL = 0
    DIM SHARED AS INTEGER SCROLL_POS   = 0
    
    
    #INCLUDE "i1.txt"
    #INCLUDE "i2.txt"
    #INCLUDE "i3.txt"
    #INCLUDE "i4.txt"
    #INCLUDE "i5.txt"
    #INCLUDE "i6.txt"
    #INCLUDE "i7.txt"
    #INCLUDE "i8.txt"
    #INCLUDE "i9.txt"
    #INCLUDE "i10.txt"
    #INCLUDE "i11.txt"
    #INCLUDE "i12.txt"
    #INCLUDE "i13.txt"
    #INCLUDE "i14.txt"
    #INCLUDE "i15.txt"
    #INCLUDE "i16.txt"
    #INCLUDE "i17.txt"
    #INCLUDE "i18.txt"
    #INCLUDE "i19.txt"
    #INCLUDE "i20.txt"

    DECLARE SUB LOAD_PAGE(BYVAL PAGE_NUMBER AS INTEGER)

'    DIM SHARED AS STRING TEXTMAP (LINES,80)' <- CURRENT TEXTMAP.
'    DIM SHARED AS STRING  COLMAP (LINES,80)' <- CURRENT COLOURMAP.
'    DIM SHARED AS STRING FONTMAP (LINES,80)' <- CURRENT FONTMAP.

    DIM SHARED AS STRING  TEXTMAP (LINES,80)' <- CURRENT TEXTMAP.
    DIM SHARED AS INTEGER COLMAP (LINES,80)' <- CURRENT COLOURMAP.
    DIM SHARED AS INTEGER FONTMAP (LINES,80)' <- CURRENT FONTMAP.
    DIM SHARED AS STRING BREAKMAP(LINES)' <- CURRENT PAGEBREAKMAP.
    DIM SHARED AS INTEGER PAGE_SIZE=1

    LOAD_PAGE(11)

'-------------------------------------------------------------------------------
'   SCREEN DEFINITION (WE SET IT UP LATER).
'-------------------------------------------------------------------------------

    CONST XRES=800
    CONST YRES=600

    DIM SHARED AS UINTEGER BUFFER ( XRES * YRES )
    DIM SHARED AS UINTEGER BUFFER2( XRES * YRES ) : ' SKIN 1
    DIM SHARED AS UINTEGER BUFFER3( XRES * YRES ) : ' SKIN 2
    
    DIM SHARED AS INTEGER PHIDE =0

'===============================================================================
'   CHARTS CONTROL;
'===============================================================================

    'SID TRACKS;
    
    DIM SHARED AS UINTEGER I_ST1,I_ST2,I_ST3,I_ST4,I_ST5,I_ST6,I_ST7,I_ST8,I_ST9,I_ST10,I_ST11,I_ST12


    DIM SHARED AS INTEGER SONG_SCROLL_POINTER=1
    DIM SHARED AS INTEGER SONG_PLAYING       =1
    DIM SHARED AS STRING SONG_NOTES(5)
    DIM SHARED AS DOUBLE SONG_SPOS=0
    DIM SHARED AS STRING CHART_TITLE
    DIM SHARED AS STRING  MENU_TITLES(20)
    DIM SHARED AS INTEGER MENU_ACTIVE(20)
    DIM SHARED AS INTEGER MENU_SELECTED(21)
    DIM SHARED AS INTEGER MENU_NUMBER = 2 :'WHICH MENU TO DISPLAY (1 OR 2)
    
    SONG_NOTES(1)="                                                                 F1 To select 'Grunge' skin    F2 To select 'Carbon' skin   Selected song: "
    SONG_NOTES(2)="                                                                 F1 To select 'Grunge' skin    F2 To select 'Carbon' skin   Selected song: "
    SONG_NOTES(3)="                                                                 F1 To select 'Grunge' skin    F2 To select 'Carbon' skin   Selected song: "
    SONG_NOTES(4)="                                                                 F1 To select 'Grunge' skin    F2 To select 'Carbon' skin   Selected song: "
    SONG_NOTES(5)="                                                                 F1 To select 'Grunge' skin    F2 To select 'Carbon' skin   Selected song: "


    DIM SHARED AS STRING intro_SCT
    DIM SHARED AS STRING I_TITLES(9)
    
    intro_SCT="                                                                  "

    #INCLUDE "configuration.txt"


    DIM SHARED AS UINTEGER S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12
    ' SIDS;
    S1 = (UBOUND(rh1))+1
    S2 = (UBOUND(rh2))+1
    S3 = (UBOUND(rh3))+1
    S4 = (UBOUND(rh4))+1
    S5 = (UBOUND(rh5))+1
    S6 = (UBOUND(rh6))+1
    S7 = (UBOUND(rh7))+1
    S8 = (UBOUND(rh8))+1
    S9 = (UBOUND(rh9))+1
    S10= (UBOUND(rh10))+1
    S11= (UBOUND(rh11))+1
    S12= (UBOUND(rh12))+1














   MENU_SELECTED(1)  = 0
   MENU_SELECTED(2)  = 0
   MENU_SELECTED(3)  = 0
   MENU_SELECTED(4)  = 0
   MENU_SELECTED(5)  = 0
   MENU_SELECTED(6)  = 0
   MENU_SELECTED(7)  = 0
   MENU_SELECTED(8)  = 0
   MENU_SELECTED(9)  = 0
   MENU_SELECTED(10) = 0
   MENU_SELECTED(11) = 1 :' <--- EDITORIAL IS DEFAULT PAGE
   MENU_SELECTED(12) = 0
   MENU_SELECTED(13) = 0
   MENU_SELECTED(14) = 0
   MENU_SELECTED(15) = 0
   MENU_SELECTED(16) = 0
   MENU_SELECTED(17) = 0
   MENU_SELECTED(18) = 0
   MENU_SELECTED(19) = 0
   MENU_SELECTED(20) = 0
   MENU_SELECTED(21) = 0
'-------------------------------------------------------------------------------

   MENU_ACTIVE(12) = 1  : MENU_TITLES(12) = "Rules"
   MENU_ACTIVE(10) = 1  : MENU_TITLES(10) = "Help"

'===============================================================================
'   INITIALISE SKIN TEMPLATE;
'===============================================================================
    
    DIM SHARED AS INTEGER IMGX,IMGY

    IMGX=800:' WIDTH
    IMGY=600:' HEIGHT

    DIM SHARED AS INTEGER IMG_COLOURS(256)
    DIM SHARED AS INTEGER IMG_RAW(IMGX * IMGY)
    
    DIM SHARED AS INTEGER IMG_COLOURS2(256)
    DIM SHARED AS INTEGER IMG_RAW2(IMGX * IMGY)

    DIM SHARED AS INTEGER SKIN_SELECTED=1

    DECLARE SUB LOAD_IMAGE()
    DECLARE SUB DRAW_IMAGE(BYVAL X1 AS INTEGER , BYVAL Y1 AS INTEGER, BYVAL W AS INTEGER, BYVAL H AS INTEGER, BYVAL SX AS INTEGER , BYVAL SY AS INTEGER )
    LOAD_IMAGE()

'===============================================================================
'   INITIALISE FONTS;
'===============================================================================

    DIM SHARED AS INTEGER FONT_SW = 2048: '             FONT SCREEN WIDTH.
    DIM SHARED AS INTEGER FONT_SH = 28:'                FONT SCREEN HEIGHT.
    DIM SHARED AS INTEGER FONT_PAL(256 , 30):'          256 COLOURS , 27 HUES.
    DIM SHARED AS INTEGER FONT_DAT(FONT_SW * FONT_SH):' FONT DATA STORAGE.
    
    DECLARE SUB DRAWBREAK(BYVAL YP AS INTEGER,BYVAL XP AS INTEGER,BYVAL WD AS INTEGER, BYVAL BS AS INTEGER)
    DECLARE SUB LOADFONT()
    DECLARE SUB TEXT(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DECLARE SUB TEXTR(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DECLARE SUB TXTL(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)

    DECLARE SUB TEXT2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DECLARE SUB TXTL2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)

    DECLARE SUB TXTLP(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DECLARE SUB TXTLP2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)    
    DECLARE SUB KEEP_IT_ON()
    DECLARE SUB BLANKLEFT()
    DECLARE SUB BLANKRIGHT()


    LOADFONT()

'-------------------------------------------------------------------------------
'   MOUSE POINTER DISPLAY SETTINGS;
'-------------------------------------------------------------------------------

    DIM SHARED AS INTEGER MP_X = 11: ' WIDTH OF POINTER SPRITE.
    DIM SHARED AS INTEGER MP_Y = 11: ' HEIGHT OF POINTER SPRITE.
    DIM SHARED AS UBYTE MP_SI = 1  : ' STATUS IMAGE 1=NOTHING TO CLICK 2=SOMETHING TO CLICK.
    
    DIM SHARED AS UINTEGER MP_IMAGES(MP_X * MP_Y)
    DIM SHARED AS UINTEGER MP_IMAGEH(MP_X * MP_Y)
    DECLARE SUB READ_MOUSE_POINTER ()
    DECLARE SUB DRAW_MOUSE_POINTER ( BYVAL MP_XPOS AS INTEGER, BYVAL MP_YPOS AS INTEGER, BYVAL MP_TYPE AS INTEGER )
    READ_MOUSE_POINTER ()
    
    
    DIM SHARED AS INTEGER MP_LOC_X :'    MOUSE POINTER X LOCATION
    DIM SHARED AS INTEGER MP_LOC_Y :'    MOUSE POINTER Y LOCATION
    DIM SHARED AS INTEGER MP_LEFTS :'    MOUSE LEFT BUTTON STATUS.
    DIM SHARED AS INTEGER MP_HELD  :'    MOUSE LEFT HOLD STATUS.
    DIM SHARED AS INTEGER PB_FADE = 0 :' PROGRESS BAR BRIGHTNESS FOR MOUSEOVER.
    
    
    
'-------------------------------------------------------------------------------
'   GENERAL PURPOSE SUBS;
'-------------------------------------------------------------------------------
    
    DECLARE SUB DRAW_CPANEL()
    DECLARE SUB GET_INPUT()
    DECLARE SUB HIGHLIGHT_ZONE(BYVAL ZX AS INTEGER,BYVAL ZY AS INTEGER,BYVAL WX AS INTEGER,BYVAL WY AS INTEGER,BYVAL BR AS INTEGER,BYVAL RR AS INTEGER , BYVAL GG AS INTEGER, BYVAL BB AS INTEGER)
    DECLARE SUB SETUP_BUTTONS()
    DECLARE SUB DRAW_BUTTONS()
    DECLARE SUB PROCESS_BUTTONS()
    DECLARE SUB PROCESS_MENU2()
    DECLARE SUB CLEAR_SELECTIONS()
    DECLARE SUB SONG_SCROLLER()    
    DECLARE SUB DRAW_PAGE (BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB DRAW_BREAKS(BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB DRAW_IMAGE_FAST()
    DECLARE SUB PROGRESS()
    DECLARE SUB HANDLE_PROGRESS_BAR()
'-------------------------------------------------------------------------------
'   INITIALISE THE CHARTS;
'-------------------------------------------------------------------------------
    DIM SHARED AS DOUBLE CYC=0.0
    DIM SHARED AS DOUBLE OLD
    DIM SHARED AS INTEGER MAX_BUTTONS = 10
    
    DIM SHARED AS INTEGER BUTTON_XP(MAX_BUTTONS):' POS X
    DIM SHARED AS INTEGER BUTTON_YP(MAX_BUTTONS):' POS Y
    DIM SHARED AS INTEGER BUTTON_XW(MAX_BUTTONS):' WIDTH
    DIM SHARED AS INTEGER BUTTON_YH(MAX_BUTTONS):' HEIGHT

    DIM SHARED AS INTEGER BUTTON_XP2(MAX_BUTTONS):' POS X
    DIM SHARED AS INTEGER BUTTON_YP2(MAX_BUTTONS):' POS Y
    DIM SHARED AS INTEGER BUTTON_XW2(MAX_BUTTONS):' WIDTH
    DIM SHARED AS INTEGER BUTTON_YH2(MAX_BUTTONS):' HEIGHT


    DIM SHARED AS INTEGER BUTTON_SL(MAX_BUTTONS):' SELECTED?
    DIM SHARED AS INTEGER BUTTON_IN(MAX_BUTTONS):' INTENSITY
    DIM SHARED AS INTEGER PROG_HELD=0
    DIM SHARED AS INTEGER QUITSTATE=0
    DIM SHARED AS UINTEGER EQUBARS(YRES)
    DIM SHARED AS UINTEGER EQUBARSB(YRES)

    EQUBARS(133)=&H000000
    EQUBARS(134)=&H000000
    EQUBARS(135)=&HEEBB33
    EQUBARS(136)=&HDDAA33
    EQUBARS(137)=&HCC9933
    EQUBARS(138)=&HBB8833
    EQUBARS(139)=&HAA7733
    EQUBARS(140)=&H996622
    EQUBARS(141)=&H885522
    EQUBARS(142)=&H774422
    EQUBARS(143)=&H663322
    EQUBARS(144)=&H552211
    EQUBARS(145)=&H441111
    EQUBARS(146)=&H331111
    EQUBARS(147)=&H221111
    EQUBARS(148)=&H221111


    EQUBARSB(133)=&H000000
    EQUBARSB(134)=&H000000
    EQUBARSB(135)=&H33BBEE
    EQUBARSB(136)=&H33AADD
    EQUBARSB(137)=&H3399CC
    EQUBARSB(138)=&H3388BB
    EQUBARSB(139)=&H3377AA
    EQUBARSB(140)=&H226699
    EQUBARSB(141)=&H225588
    EQUBARSB(142)=&H224477
    EQUBARSB(143)=&H223366
    EQUBARSB(144)=&H221155
    EQUBARSB(145)=&H111144
    EQUBARSB(146)=&H111133
    EQUBARSB(147)=&H111122
    EQUBARSB(148)=&H111122

    
    DIM SHARED AS DOUBLE NEWMOUSEWHEEL,OLDMOUSEWHEEL
    NEWMOUSEWHEEL=0
    OLDMOUSEWHEEL=0
    
    
    SETUP_BUTTONS()

'-------------------------------------------------------------------------------
' VUMETERS
'-------------------------------------------------------------------------------

    DIM SHARED ABARS AS INTEGER 
    DIM SHARED BWDTH AS INTEGER 
    
    ABARS=40           :'
    BWDTH=12 :'
    
    DIM SHARED AS DOUBLE PEAKS(ABARS)
'    DIM SHARED AS UINTEGER BUFFER ( XRES * YRES )
    
    DECLARE SUB SET_STUFF()
    DECLARE SUB DECREASE_PEAKS()
    DECLARE SUB MONITOR_SOUND()
    DECLARE SUB HANDLE_SOUND()
    SET_STUFF()


    DIM SHARED AS UINTEGER MUSSIZE1,MUSSIZE2,MUSSIZE3,MUSSIZE4
    
    MUSSIZE1=(UBOUND(music1.xm))+1
    MUSSIZE2=(UBOUND(music2.xm))+1
    MUSSIZE3=(UBOUND(music3.xm))+1
    MUSSIZE4=(UBOUND(music4.xm))+1
    
    'IF MiniFmod_Init(@music4.xm(0), MUSSIZE4)  =  0  THEN
    '    END-1
    'END IF


    Dim SHARED as integer ord, row, channels, note, samp
    Dim SHARED as single mytime
    Dim SHARED as integer synchChannel
    Dim SHARED as unsigned integer inst_note
    dim shared as integer bottom_equ=147

    DECLARE SUB PLAYMUSIC1()
    DECLARE SUB PLAYMUSIC2()
    DECLARE SUB PLAYMUSIC3()
    DECLARE SUB PLAYMUSIC4()

'-------------------------------------------------------------------------------
'   SET UP THE SCREEN.
'-------------------------------------------------------------------------------
   
    PTC_ALLOWCLOSE(0)
    PTC_SETDIALOG(0,"THE GAME SCENE CHARTS PREVIEW"+CHR$(13)+"FULL SCREEN?",0,1)               
    IF (PTC_OPEN("CODED BY WIDOWMAKER :-)",XRES,YRES)=0) THEN
    END-1
    END IF    

    PHIDE=SHOWCURSOR(0)




'-------------------------------------------------------------------------------
'   INTRO VARIABLES;
'-------------------------------------------------------------------------------

    CONST I_FONTX=1888
    CONST I_FONTY=32
    
'-------------------------------------------------------------------------------
'   FONT LOADING AND STORAGE STUFF
'-------------------------------------------------------------------------------

    DECLARE SUB I_LOADFONT()    
    DIM SHARED I_FONT_COLOURS ( 256 ) AS INTEGER
    DIM SHARED I_FONT_BUFFER  ( I_FONTX * I_FONTY ) AS INTEGER     
'    DIM SHARED AS UINTEGER BUFFER ( XRES * YRES )
    DIM SHARED AS UINTEGER I_COP_COLOURS_A( YRES+30 )
    DIM SHARED AS UINTEGER I_COP_COLOURS_B( YRES+30 )
    DIM SHARED AS UINTEGER I_COP_COLOURS_C( YRES+30 )
    
        DIM SHARED AS UINTEGER I_STNM = 300    
        DIM SHARED AS DOUBLE I_STRX(I_STNM)
        DIM SHARED AS DOUBLE I_STRY(I_STNM)    
    
    I_LOADFONT()
'-------------------------------------------------------------------------------
'   INTRO VARIABLES;
'-------------------------------------------------------------------------------

    'DIM SHARED AS STRING intro_SCT
    DIM SHARED AS INTEGER I_TP1=1
    DIM SHARED AS DOUBLE I_SCP=0
    DIM SHARED AS DOUBLE I_SPAUSE=0
    DIM SHARED AS UINTEGER I_SONG_SEL=1
    'intro_SCT="                                                        "
    
    DIM SHARED AS UINTEGER I_SINETABLE_A(XRES):' TOP ONE
    DIM SHARED AS UINTEGER I_SINETABLE_B(XRES):' REFLECTION
    DIM SHARED AS DOUBLE I_TIME,I_OLD,I_DELTA
    'DIM SHARED AS STRING I_TITLES(9)
'    I_TITLES(1)="***********************"
'    I_TITLES(2)="*THE GAME SCENE CHARTS*"
'    I_TITLES(3)="***********************"
'    I_TITLES(4)=""
'    I_TITLES(5)="issue number 31"
'    I_TITLES(6)="Released on"
'    I_TITLES(7)="00-00-0000"
'    I_TITLES(8)=""
'    I_TITLES(9)="= TRY F01 TO F12 ="
'
'
'    intro_SCT=intro_SCT+"a     ** WELCOME **        ---------------------------------------------- "
'    intro_SCT=intro_SCT+"aTHE GAME SCENE CHART 31 "    
'    intro_SCT=intro_SCT+" ------------------ RELEASED BY THE GAME SCENE CHARTS STAFF ------------------ "
'    intro_SCT=intro_SCT+"INTRO CREDITS ----- MUSIC BY: "
'    intro_SCT=intro_SCT+"a     *ROB HUBBARD!*      "   
'    intro_SCT=intro_SCT+"PROGRAMMING BY: "
'    intro_SCT=intro_SCT+"a      *WIDOWMAKER*       "   
'    intro_SCT=intro_SCT+"SID REPLAY ROUTINE BY: "
'    intro_SCT=intro_SCT+"a     *STORMBRINGER*      "   
'
'    intro_SCT=intro_SCT+" PLEASE PRESS THE -LEFT MOUSE- BUTTON OR -ESCAPE- TO BEGIN   ----   WE HOPE YOU ENJOY IT   "
'    intro_SCT=intro_SCT+"   *******************************************************"
    

'-------------------------------------------------------------------------------
'   INTRO SUB ROUTINES;
'-------------------------------------------------------------------------------
    
    DECLARE SUB I_SINE_WAVES()
    DECLARE SUB I_BLIT_LETTER(BYVAL I_S AS INTEGER , BYVAL I_X AS INTEGER , BYVAL I_Y AS INTEGER)
    DECLARE SUB I_SINE_LETTER(BYVAL I_S AS INTEGER , BYVAL I_X AS INTEGER)
    DECLARE SUB I_CENTER_TEXT(BYVAL I_T AS STRING  , BYVAL I_Y AS INTEGER)
    DECLARE SUB I_SINE_TEXT  (BYVAL I_T AS STRING  , BYVAL I_X AS INTEGER)
    DECLARE SUB I_COPPER_BAR (BYVAL I_C AS INTEGER , BYVAL I_Y AS INTEGER)
    DECLARE SUB I_DRAW_TITLES()
    DECLARE SUB I_BUFFER_CLEAR()
    DECLARE SUB I_SCROLLER()
    DECLARE SUB I_BARWAVE()
    DECLARE SUB I_PREPSTARS()
    DECLARE SUB I_DRAWSTARS()
    DECLARE SUB I_SWITCHSONG(BYVAL I_TUNE AS INTEGER)
    DECLARE SUB I_DECRUNCH()
    DECLARE SUB I_DECRUNCH2()



'-------------------------------------------------------------------------------
' PROTECT AGAINST KEYDOWN!
'-------------------------------------------------------------------------------

WHILE(GETASYNCKEYSTATE(VK_ESCAPE) OR PTC_GETLEFTBUTTON=TRUE)
    erase buffer
    PTC_UPDATE@BUFFER(0)

WEND
    erase buffer
    PTC_UPDATE@BUFFER(0)



    I_PREPSTARS()
    SLEEP 150
    I_DECRUNCH()
    I_DECRUNCH()
    I_DECRUNCH2()
    RANDOMIZE TIMER
    I_SPAUSE=TIMER
    I_SONG_SEL=int(rnd(1)*12)+1
    IF I_SONG_SEL<1 THEN I_SONG_SEL=1
    IF I_SONG_SEL>12 THEN I_SONG_SEL=12
    I_SWITCHSONG(I_SONG_SEL)
WHILE(GETASYNCKEYSTATE(VK_ESCAPE)<> -32767 and PTC_GETLEFTBUTTON=FALSE)
        I_OLD=TIMER
        IF GETASYNCKEYSTATE(VK_F1)= -32767 AND I_SONG_SEL<>1 THEN I_SWITCHSONG(1):I_SONG_SEL=1:END IF
        IF GETASYNCKEYSTATE(VK_F2)= -32767 AND I_SONG_SEL<>2 THEN I_SWITCHSONG(2):I_SONG_SEL=2:END IF
        IF GETASYNCKEYSTATE(VK_F3)= -32767 AND I_SONG_SEL<>3 THEN I_SWITCHSONG(3):I_SONG_SEL=3:END IF
        IF GETASYNCKEYSTATE(VK_F4)= -32767 AND I_SONG_SEL<>4 THEN I_SWITCHSONG(4):I_SONG_SEL=4:END IF
        IF GETASYNCKEYSTATE(VK_F5)= -32767 AND I_SONG_SEL<>5 THEN I_SWITCHSONG(5):I_SONG_SEL=5:END IF
        IF GETASYNCKEYSTATE(VK_F6)= -32767 AND I_SONG_SEL<>6 THEN I_SWITCHSONG(6):I_SONG_SEL=6:END IF
        IF GETASYNCKEYSTATE(VK_F7)= -32767 AND I_SONG_SEL<>7 THEN I_SWITCHSONG(7):I_SONG_SEL=7:END IF
        IF GETASYNCKEYSTATE(VK_F8)= -32767 AND I_SONG_SEL<>8 THEN I_SWITCHSONG(8):I_SONG_SEL=8:END IF
        IF GETASYNCKEYSTATE(VK_F9)= -32767 AND I_SONG_SEL<>9 THEN I_SWITCHSONG(9):I_SONG_SEL=9:END IF
        IF GETASYNCKEYSTATE(VK_F10)= -32767 AND I_SONG_SEL<>10 THEN I_SWITCHSONG(10):I_SONG_SEL=10:END IF
        IF GETASYNCKEYSTATE(VK_F11)= -32767 AND I_SONG_SEL<>11 THEN I_SWITCHSONG(11):I_SONG_SEL=11:END IF
        IF GETASYNCKEYSTATE(VK_F12)= -32767 AND I_SONG_SEL<>22 THEN I_SWITCHSONG(12):I_SONG_SEL=12:END IF
        
        I_BARWAVE()
        I_SINE_WAVES()
        I_DRAWSTARS()
        I_DRAW_TITLES()
        'I_SINE_LETTER (32,100)
        'I_SINE_TEXT("HELLO MOTHERFUCKERS",0)
        I_SCROLLER()
        
        PTC_UPDATE@BUFFER(0)
        I_BUFFER_CLEAR()
        SLEEP 1
        I_DELTA=((TIMER-I_OLD) * 250)
        I_TIME=I_TIME+((TIMER-I_OLD) * 50)
WEND
    sid_sound_server_replay_stop()
    I_DECRUNCH()
    I_DECRUNCH()
    I_DECRUNCH2()
    I_DECRUNCH()
    I_DECRUNCH2()    
    I_DECRUNCH2()    
    SLEEP 10
'    EXITPROCESS(0)
'END



























    PLAYMUSIC1()

   
'-------------------------------------------------------------------------------
'   MAIN LOOP START
'-------------------------------------------------------------------------------
    
    ERASE BUFFER
    DRAW_IMAGE(0,0,XRES-1,YRES-1,0,0)
    
WHILE(GETASYNCKEYSTATE(VK_ESCAPE)<> -32767 AND QUITSTATE=0)  
    
    OLD=TIMER
    '---------------------------------------------------------------------------
    ' IS ARROW_DOWN PRESSED?
    '---------------------------------------------------------------------------
    IF(GETASYNCKEYSTATE(VK_DOWN))  AND SCROLL_POS<PAGE_SIZE-33 THEN
        PIXEL_SCROLL=PIXEL_SCROLL-6        
        IF PIXEL_SCROLL<=0 THEN 
            SCROLL_POS=SCROLL_POS+1
            IF SCROLL_POS>= PAGE_SIZE-33 THEN SCROLL_POS=PAGE_SIZE-33
            PIXEL_SCROLL=PIXEL_SCROLL+12    
            
        END IF
    END IF    
    '---------------------------------------------------------------------------
    ' IS ARROW_UP PRESSED?
    '---------------------------------------------------------------------------
     IF(GETASYNCKEYSTATE(VK_UP))  AND SCROLL_POS>0  THEN
        PIXEL_SCROLL=PIXEL_SCROLL+6
        IF PIXEL_SCROLL>=11 THEN 
            
            SCROLL_POS=SCROLL_POS-1
            IF SCROLL_POS<0 THEN SCROLL_POS=0
            PIXEL_SCROLL=PIXEL_SCROLL-12            
        END IF
         
     END IF
     
    OLDMOUSEWHEEL=NEWMOUSEWHEEL
    NEWMOUSEWHEEL=PTC_GETMOUSEWHEEL()

    IF NEWMOUSEWHEEL<OLDMOUSEWHEEL AND SCROLL_POS<PAGE_SIZE-33 THEN
        SCROLL_POS=SCROLL_POS+INT((OLDMOUSEWHEEL-NEWMOUSEWHEEL)*4)
        IF SCROLL_POS>=PAGE_SIZE-33 THEN SCROLL_POS=PAGE_SIZE-33
        
    END IF

    IF NEWMOUSEWHEEL>OLDMOUSEWHEEL AND SCROLL_POS>0 THEN
        SCROLL_POS=SCROLL_POS-INT((NEWMOUSEWHEEL-OLDMOUSEWHEEL)*4)
        IF SCROLL_POS<0 THEN SCROLL_POS=0
    END IF

    PROCESS_BUTTONS()
    PROCESS_MENU2()
    DRAW_IMAGE_FAST()
    DRAW_BUTTONS()
    DRAW_CPANEL()
    DRAW_BREAKS(SCROLL_POS)
    DRAW_PAGE(SCROLL_POS)
    if BUTTON_SL(6)=0 THEN HANDLE_SOUND()
    SONG_SCROLLER()
    '--------------------------
    IF PAGE_SIZE>32 THEN     
        PROGRESS()
        HANDLE_PROGRESS_BAR()
    ELSE 
    PIXEL_SCROLL=5
    END IF
    
    
    DRAW_MOUSE_POINTER (MP_LOC_X,MP_LOC_Y,2)

    PTC_UPDATE@BUFFER(0)
    GET_INPUT()
    SLEEP 1
    CYC=CYC+((TIMER-OLD)*250)
    
WEND

'-------------------------------------------------------------------------------
'   PROGRAM END
'-------------------------------------------------------------------------------

  MiniFmod_Stop()
  MiniFmod_Free()
  PTC_CLOSE()
  EXITPROCESS(0)


END


SUB PLAYMUSIC1()
    
  MiniFmod_Stop()
  MiniFmod_Free()
  MiniFmod_Init(@music1.xm(0), MUSSIZE1)  
  MiniFmod_Play()
  channels = MiniFmod_GetChannels()

END SUB

SUB PLAYMUSIC2()
    
  MiniFmod_Stop()
  MiniFmod_Free()
  MiniFmod_Init(@music2.xm(0), MUSSIZE2)  
  MiniFmod_Play()
  channels = MiniFmod_GetChannels()

END SUB

SUB PLAYMUSIC3()
    
  MiniFmod_Stop()
  MiniFmod_Free()
  MiniFmod_Init(@music3.xm(0), MUSSIZE3) 
  MiniFmod_Play()
  channels = MiniFmod_GetChannels()

END SUB

SUB PLAYMUSIC4()
    
  MiniFmod_Stop()
  MiniFmod_Free()
  MiniFmod_Init(@music4.xm(0), MUSSIZE4) 
  MiniFmod_Play()
  channels = MiniFmod_GetChannels()

END SUB



SUB BLANKLEFT()
    
    DIM AS INTEGER LFT,TOP,HGT,XX1,XX2,IL1,IL2,RHT
    DIM AS INTEGER PTR PP1,PP2
    
    LFT=20
    TOP=192
    IF SKIN_SELECTED=1 THEN
    HGT=377
    ELSE
    HGT=378
    END IF

    XX2=747
    WHILE XX1<747
        OLD=TIMER
        KEEP_IT_ON()
        RHT=767
        FOR IL1=0 TO XX1 STEP 2
            PP1=@BUFFER(IL1+LFT+(TOP*XRES))
            PP2=@BUFFER(RHT+(TOP*XRES))
            
            FOR IL2=0 TO HGT
                *PP1=&H000000
                *PP2=&H000000
                PP1+=XRES
                PP2+=XRES
            NEXT
            RHT=RHT-2
        NEXT
        PTC_UPDATE@BUFFER(0)
        SLEEP 1
        CYC=CYC+((TIMER-OLD)*250)
        XX1=XX1+10
    WEND
    
END SUB






SUB BLANKRIGHT()
    
    DIM AS INTEGER LFT,TOP,HGT,XX1,XX2,IL1,IL2,RHT
    DIM AS INTEGER PTR PP1,PP2
    
    LFT=20
    TOP=192
    IF SKIN_SELECTED=1 THEN
    HGT=377
    ELSE
    HGT=378
    END IF


    XX1=747
    XX2=747
    WHILE XX1>0
        OLD=TIMER
        KEEP_IT_ON()
        RHT=767
        FOR IL1=0 TO XX1 STEP 2
            PP1=@BUFFER(IL1+LFT+(TOP*XRES))
            PP2=@BUFFER(RHT+(TOP*XRES))
            
            FOR IL2=0 TO HGT
                *PP1=&H000000
                *PP2=&H000000
                PP1+=XRES
                PP2+=XRES
            NEXT
            RHT=RHT-2
        NEXT
        PTC_UPDATE@BUFFER(0)
        SLEEP 1
        CYC=CYC+((TIMER-OLD)*250)
        XX1=XX1-10
    WEND
    
END SUB











SUB KEEP_IT_ON()

    DRAW_IMAGE_FAST()
    DRAW_BUTTONS()
    DRAW_CPANEL()
    DRAW_BREAKS(SCROLL_POS)
    DRAW_PAGE(SCROLL_POS)
    if BUTTON_SL(6)=0 THEN HANDLE_SOUND()
    SONG_SCROLLER()
    
    
END SUB




'-------------------------------------------------------------------------------
'  DRAW THE PROGRESS BAR; 386
'-------------------------------------------------------------------------------

SUB PROGRESS()
    
DIM AS INTEGER PMINUS
DIM AS DOUBLE PXPERLINE

        PXPERLINE=(361)/(PAGE_SIZE-33)
        PMINUS=PXPERLINE*SCROLL_POS
        IF SKIN_SELECTED=1 THEN
        IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(779,PMINUS+195,8,19,80,100,150,250)
        IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(779,PMINUS+195,8,19,PB_FADE,100,125,200)
        ELSE
        IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(783,PMINUS+195,9,19,80,50,150,250)
        IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(783,PMINUS+195,9,19,PB_FADE,100,150,250)        
        END IF
         

END SUB






SUB DRAW_BREAKS(BYVAL PAGE_OFFSET AS INTEGER)
DIM AS INTEGER Y,PY
PY=175+PIXEL_SCROLL

FOR Y=0 TO 32    
    'IF PAGE_LINE(Y+PAGE_OFFSET,PAGE_NUMBER) <> 0 THEN
    IF PY+6>192 AND PY+6<569 THEN
    DRAWBREAK(PY+6,20,750,VAL(BREAKMAP(Y+PAGE_OFFSET)))
    END IF
    'END IF
    PY=PY+12
    
    
NEXT


END SUB
'-------------------------------------------------------------------------------
' DRAW THE CURRENT PAGE.
'-------------------------------------------------------------------------------

SUB DRAW_PAGE (BYVAL PAGE_OFFSET AS INTEGER)
DIM AS INTEGER Y,PY,X,TV,CV
DIM CG AS STRING

    PY=175+PIXEL_SCROLL
    
    FOR Y=0 TO 32    
        if Y+PAGE_OFFSET<PAGE_SIZE THEN
        FOR X=0 TO 80
                TV=FONTMAP(Y+PAGE_OFFSET,X)
                CV=COLMAP(Y+PAGE_OFFSET,X)
        IF Y>0 AND Y<31 AND BREAKMAP(Y+PAGE_OFFSET) ="0" THEN
        'TXTL2(MID(TEXTMAP(Y+PAGE_OFFSET),X,1),35+((X-1)*9),PY,TV,CV)        
        TXTLP2(TEXTMAP(Y+PAGE_OFFSET,X),32+((X-1)*9),PY,TV,CV)        
        ELSE
        IF SKIN_SELECTED=1 THEN
        TXTLP (TEXTMAP(Y+PAGE_OFFSET,X),32+((X-1)*9),PY,0,800,193,569,TV,CV)        
        ELSE
        TXTLP (TEXTMAP(Y+PAGE_OFFSET,X),32+((X-1)*9),PY,0,800,193,570,TV,CV)        
        END IF
        END IF
  
    NEXT
    END IF
        PY=PY+12        
    NEXT
    
END SUB



 


SUB SONG_SCROLLER()
    DIM SCYY AS INTEGER
    IF SKIN_SELECTED=1 THEN 
        SCYY=0
    ELSE
        SCYY=1
    END IF
    
    TXTL(MID(SONG_NOTES(SONG_PLAYING),SONG_SCROLL_POINTER,58),146-INT(SONG_SPOS),123+SCYY ,146,649,40,145,2,2)
    SONG_SPOS=SONG_SPOS+1
    IF SONG_SPOS>9 THEN
        SONG_SCROLL_POINTER=SONG_SCROLL_POINTER+1
        IF SONG_SCROLL_POINTER>LEN(SONG_NOTES(SONG_PLAYING)) THEN
        SONG_SCROLL_POINTER=1
        END IF
    SONG_SPOS=SONG_SPOS-9
    END IF
END SUB


SUB PROCESS_MENU2()
    
'BUTTONS AND CORRESPONDING:

    DIM AS INTEGER C1,C2,C3,C4,C5,C6,C7,C8,C9,CA
    DIM AS INTEGER XP,YP
    
IF MENU_NUMBER=1 THEN C1=1:C2=2:C3=3:C4=4:C5=5:C6=6:C7=7:C8=8:C9=9:CA=21
IF MENU_NUMBER=2 THEN C1=11:C2=13:C3=14:C4=15:C5=16:C6=17:C7=18:C8=19:C9=20:CA=21

IF MP_LEFTS<>0 AND MP_HELD<>1 THEN
    MP_HELD=1
        
    XP=146
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>60 AND MP_LOC_Y<72 THEN 
    IF MENU_ACTIVE(C1) = 1 AND MENU_SELECTED(C1)=0 THEN
        
        CLEAR_SELECTIONS()    
        MENU_SELECTED(C1)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0
        
        BLANKLEFT()
        LOAD_PAGE(C1)
        BLANKRIGHT()
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>72 AND MP_LOC_Y<84 THEN 
    IF MENU_ACTIVE(C2) = 1 AND MENU_SELECTED(C2)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C2)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0        
        
        BLANKLEFT()
        LOAD_PAGE(C2)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>84 AND MP_LOC_Y<96 THEN 
    IF MENU_ACTIVE(C3) = 1 AND MENU_SELECTED(C3)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C3)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0
        
        BLANKLEFT()
        LOAD_PAGE(C3)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>96 AND MP_LOC_Y<108 THEN 
    IF MENU_ACTIVE(C4) = 1 AND MENU_SELECTED(C4)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C4)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0        

        BLANKLEFT()
        LOAD_PAGE(C4)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>108 AND MP_LOC_Y<120 THEN     
    IF MENU_ACTIVE(C5) = 1 AND MENU_SELECTED(C5)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C5)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0        
            
        BLANKLEFT()            
        LOAD_PAGE(C5)
        BLANKRIGHT()        
    END IF
    END IF

    XP=400
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>60 AND MP_LOC_Y<72 THEN 
    IF MENU_ACTIVE(C6) = 1 AND MENU_SELECTED(C6)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C6)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0     

        BLANKLEFT()
        LOAD_PAGE(C6)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>72 AND MP_LOC_Y<84 THEN 
    IF MENU_ACTIVE(C7) = 1 AND MENU_SELECTED(C7)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C7)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0      

        BLANKLEFT()
        LOAD_PAGE(C7)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>84 AND MP_LOC_Y<96 THEN 
    IF MENU_ACTIVE(C8) = 1 AND MENU_SELECTED(C8)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C8)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0      

        BLANKLEFT()
        LOAD_PAGE(C8)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>96 AND MP_LOC_Y<108 THEN 
    IF MENU_ACTIVE(C9) = 1 AND MENU_SELECTED(C9)=0 THEN
        CLEAR_SELECTIONS()
        MENU_SELECTED(C9)=1
        BUTTON_SL(4)=0
        BUTTON_SL(5)=0
        
        BLANKLEFT()        
        LOAD_PAGE(C9)
        BLANKRIGHT()        
    END IF
    END IF
    IF MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>104 AND MP_LOC_Y<120 THEN 
        BUTTON_SL(2)=0
        BUTTON_SL(3)=0
         MENU_NUMBER=MENU_NUMBER+1
         IF MENU_NUMBER>2 THEN MENU_NUMBER=1
    END IF



END IF

END SUB


SUB CLEAR_SELECTIONS()
    DIM AS INTEGER L
    FOR L=1 TO 21
        MENU_SELECTED(L)=0
    NEXT
END SUB

SUB DRAW_CPANEL()
    DIM TXT_MD=(400-((LEN(CHART_TITLE)*9)/2))+4
    'HIGHLIGHT_ZONE(146,40,503,105,80,100,100,200)
    TXTL(CHART_TITLE,TXT_MD,42,146,649,40,145,1,25)
    
    DIM AS INTEGER L,YP,XP,EXTRA_HIGHLIGHT
    
    '
    '
    '
    
    IF MENU_NUMBER=1 THEN
        
        XP=148
       
        IF MENU_ACTIVE(1) = 1 THEN TXTL(MENU_TITLES(1),XP,60 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(2) = 1 THEN TXTL(MENU_TITLES(2),XP,72 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(3) = 1 THEN TXTL(MENU_TITLES(3),XP,84,146,649,40,145,1,2)
        IF MENU_ACTIVE(4) = 1 THEN TXTL(MENU_TITLES(4),XP,96,146,649,40,145,1,2)
        IF MENU_ACTIVE(5) = 1 THEN TXTL(MENU_TITLES(5),XP,108,146,649,40,145,1,2)

        YP=61
        FOR L=1 TO 5        
        EXTRA_HIGHLIGHT=0
        
        IF MP_HELD=0 AND MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>YP AND MP_LOC_Y<YP+10 THEN 
            EXTRA_HIGHLIGHT=65
            MP_SI=2
        END IF
        HIGHLIGHT_ZONE(XP,YP,245,10,60+EXTRA_HIGHLIGHT,100,100,100+(EXTRA_HIGHLIGHT*.5))
        YP=YP+12
        NEXT
    
        IF MENU_SELECTED(1) = 1 THEN HIGHLIGHT_ZONE(XP,60,245,10,90,200,100,100)
        IF MENU_SELECTED(2) = 1 THEN HIGHLIGHT_ZONE(XP,72,245,10,90,200,100,100)
        IF MENU_SELECTED(3) = 1 THEN HIGHLIGHT_ZONE(XP,84,245,10,90,200,100,100)
        IF MENU_SELECTED(4) = 1 THEN HIGHLIGHT_ZONE(XP,96,245,10,90,200,100,100)
        IF MENU_SELECTED(5) = 1 THEN HIGHLIGHT_ZONE(XP,108,245,10,90,200,100,100)

        XP=402
     
        IF MENU_ACTIVE(6) = 1 THEN TXTL(MENU_TITLES(6),XP,60 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(7) = 1 THEN TXTL(MENU_TITLES(7),XP,72 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(8) = 1 THEN TXTL(MENU_TITLES(8),XP,84,146,649,40,145,1,2)
        IF MENU_ACTIVE(9) = 1 THEN TXTL(MENU_TITLES(9),XP,96,146,649,40,145,1,2)
        TXTL("> Articles Menu",XP,108,146,649,40,145,1,1)

        YP=61
        FOR L=1 TO 5
        EXTRA_HIGHLIGHT=0
        
        IF MP_HELD=0 AND MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>YP AND MP_LOC_Y<YP+10 THEN 
            EXTRA_HIGHLIGHT=65
            MP_SI=2
        END IF            
        HIGHLIGHT_ZONE(XP,YP,245,10,60+EXTRA_HIGHLIGHT,100,100,100+(EXTRA_HIGHLIGHT*.5))
        YP=YP+12
        NEXT

        IF MENU_SELECTED(6) = 1 THEN HIGHLIGHT_ZONE(XP,60,245,10,90,200,100,100)
        IF MENU_SELECTED(7) = 1 THEN HIGHLIGHT_ZONE(XP,72,245,10,90,200,100,100)
        IF MENU_SELECTED(8) = 1 THEN HIGHLIGHT_ZONE(XP,84,245,10,90,200,100,100)
        IF MENU_SELECTED(9) = 1 THEN HIGHLIGHT_ZONE(XP,96,245,10,90,200,100,100)
       IF MENU_SELECTED(21) = 1 THEN HIGHLIGHT_ZONE(XP,108,245,10,90,200,100,100)

    END IF
    

    IF MENU_NUMBER=2 THEN
        
        XP=148
       
        IF MENU_ACTIVE(11) = 1 THEN TXTL(MENU_TITLES(11),XP,60 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(13) = 1 THEN TXTL(MENU_TITLES(13),XP,72 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(14) = 1 THEN TXTL(MENU_TITLES(14),XP,84,146,649,40,145,1,2)
        IF MENU_ACTIVE(15) = 1 THEN TXTL(MENU_TITLES(15),XP,96,146,649,40,145,1,2)
        IF MENU_ACTIVE(16) = 1 THEN TXTL(MENU_TITLES(16),XP,108,146,649,40,145,1,2)

        YP=61
        FOR L=1 TO 5
        EXTRA_HIGHLIGHT=0
        
        IF MP_HELD=0 AND MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>YP AND MP_LOC_Y<YP+10 THEN 
            EXTRA_HIGHLIGHT=65
            MP_SI=2
        END IF
        HIGHLIGHT_ZONE(XP,YP,245,10,60+EXTRA_HIGHLIGHT,100,100,100+(EXTRA_HIGHLIGHT*.5))
        YP=YP+12        
        NEXT

        IF MENU_SELECTED(11) = 1 THEN HIGHLIGHT_ZONE(XP,60,245,10,90,200,100,100)
        IF MENU_SELECTED(13) = 1 THEN HIGHLIGHT_ZONE(XP,72,245,10,90,200,100,100)
        IF MENU_SELECTED(14) = 1 THEN HIGHLIGHT_ZONE(XP,84,245,10,90,200,100,100)
        IF MENU_SELECTED(15) = 1 THEN HIGHLIGHT_ZONE(XP,96,245,10,90,200,100,100)
        IF MENU_SELECTED(16) = 1 THEN HIGHLIGHT_ZONE(XP,108,245,10,90,200,100,100)


        XP=402
     
        IF MENU_ACTIVE(17) = 1 THEN TXTL(MENU_TITLES(17),XP,60 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(18) = 1 THEN TXTL(MENU_TITLES(18),XP,72 ,146,649,40,145,1,2)
        IF MENU_ACTIVE(19) = 1 THEN TXTL(MENU_TITLES(19),XP,84,146,649,40,145,1,2)
        IF MENU_ACTIVE(20) = 1 THEN TXTL(MENU_TITLES(20),XP,96,146,649,40,145,1,2)
        TXTL("> Charts Menu",XP,108,146,649,40,145,1,1)

        YP=61
        FOR L=1 TO 5
        EXTRA_HIGHLIGHT=0
        
        IF MP_HELD=0 AND MP_LOC_X>XP AND MP_LOC_X<XP+245 AND MP_LOC_Y>YP AND MP_LOC_Y<YP+10 THEN 
            EXTRA_HIGHLIGHT=65
            MP_SI=2
        END IF            
        HIGHLIGHT_ZONE(XP,YP,245,10,60+EXTRA_HIGHLIGHT,100,100,100+(EXTRA_HIGHLIGHT*.5))

        YP=YP+12
        NEXT
        IF MENU_SELECTED(17) = 1 THEN HIGHLIGHT_ZONE(XP,60,245,10,90,200,100,100)
        IF MENU_SELECTED(18) = 1 THEN HIGHLIGHT_ZONE(XP,72,245,10,90,200,100,100)
        IF MENU_SELECTED(19) = 1 THEN HIGHLIGHT_ZONE(XP,84,245,10,90,200,100,100)
        IF MENU_SELECTED(20) = 1 THEN HIGHLIGHT_ZONE(XP,96,245,10,90,200,100,100)
        IF MENU_SELECTED(21) = 1 THEN HIGHLIGHT_ZONE(XP,108,245,10,90,200,100,100)




    END IF


        
    DRAWBREAK(57,144,507,8)
    DRAWBREAK(122,144,507,8)
    
END SUB


'-------------------------------------------------------------------------------
'   THIS SUB MAKES THE MAIN BUTTONS WORK SO WE CAN CLICK ON THEM.
'-------------------------------------------------------------------------------

SUB PROCESS_BUTTONS()
    
    
    IF GETASYNCKEYSTATE(VK_F1)= -32767 THEN SKIN_SELECTED=1
    IF GETASYNCKEYSTATE(VK_F2)= -32767 THEN SKIN_SELECTED=2
    
    DIM AS INTEGER LEFTST,TOPST,WIDTHH,HEIGHTT
    
    
    
    DIM AS INTEGER L,M
    
    'PROCESS THE FIRST 5 BUTTONS (NOT THE MUSIC OR MUTE ONES)
IF MP_LEFTS<>0 AND MP_HELD<>1 THEN    
    FOR L=1 TO 5
    IF BUTTON_SL(L)=0 THEN
        
    IF SKIN_SELECTED=1 THEN
        
        LEFTST  = BUTTON_XP (L)
        TOPST   = BUTTON_YP (L)       
        WIDTHH  = BUTTON_XP (L) + BUTTON_XW(L)
        HEIGHTT = BUTTON_YP (L) + BUTTON_YH(L)
        
    ELSE

        LEFTST  = BUTTON_XP2(L)
        TOPST   = BUTTON_YP2(L)       
        WIDTHH  = BUTTON_XP2(L) + BUTTON_XW2(L)
        HEIGHTT = BUTTON_YP2(L) + BUTTON_YH2(L)

    END IF
        
        
    IF MP_LOC_X > LEFTST AND MP_LOC_X < WIDTHH THEN
    IF MP_LOC_Y > TOPST AND MP_LOC_Y < HEIGHTT THEN
'        MP_SI=2
        MP_HELD=1
        FOR M=1 TO 5
            BUTTON_SL(M)=0
        NEXT
        BUTTON_SL(L)=1
        IF L=1 THEN QUITSTATE=1
        IF L=2 THEN MENU_NUMBER=1
        IF L=3 THEN MENU_NUMBER=2
        if L=4 or L=5 THEN 
            IF L=4 THEN BLANKLEFT(): LOAD_PAGE(12) : BLANKRIGHT()
            IF L=5 THEN BLANKLEFT(): LOAD_PAGE(10) : BLANKRIGHT()
            CLEAR_SELECTIONS()
        end if
        
        'IF BUTTON_IN(L)>125 THEN BUTTON_IN(L)=125
    END IF
    END IF
    END IF
    NEXT    
END IF
    'PROCESS THE MUTE BUTTON
IF MP_LEFTS<>0 AND MP_HELD<>1 THEN    
    L=6

    IF SKIN_SELECTED=1 THEN
        
        LEFTST  = BUTTON_XP (L)
        TOPST   = BUTTON_YP (L)       
        WIDTHH  = BUTTON_XP (L) + BUTTON_XW(L)
        HEIGHTT = BUTTON_YP (L) + BUTTON_YH(L)
        
    ELSE

        LEFTST  = BUTTON_XP2(L)
        TOPST   = BUTTON_YP2(L)       
        WIDTHH  = BUTTON_XP2(L) + BUTTON_XW2(L)
        HEIGHTT = BUTTON_YP2(L) + BUTTON_YH2(L)

    END IF

    IF BUTTON_SL(L)=0 THEN
    IF MP_LOC_X > LEFTST AND MP_LOC_X < WIDTHH THEN
    IF MP_LOC_Y > TOPST AND MP_LOC_Y < HEIGHTT THEN        
        MP_HELD=1
        MiniFmod_Stop()
        BUTTON_SL(L)=0   
        BUTTON_SL(L)=1    
    END IF
    END IF
    END IF
'    NEXT    
END IF
IF MP_LEFTS<>0 AND MP_HELD<>1 THEN    
    L=6
    IF SKIN_SELECTED=1 THEN
        
        LEFTST  = BUTTON_XP (L)
        TOPST   = BUTTON_YP (L)       
        WIDTHH  = BUTTON_XP (L) + BUTTON_XW(L)
        HEIGHTT = BUTTON_YP (L) + BUTTON_YH(L)
        
    ELSE

        LEFTST  = BUTTON_XP2(L)
        TOPST   = BUTTON_YP2(L)       
        WIDTHH  = BUTTON_XP2(L) + BUTTON_XW2(L)
        HEIGHTT = BUTTON_YP2(L) + BUTTON_YH2(L)

    END IF

    IF BUTTON_SL(L)=1 THEN
    IF MP_LOC_X > LEFTST AND MP_LOC_X < WIDTHH THEN
    IF MP_LOC_Y > TOPST AND MP_LOC_Y < HEIGHTT THEN
        MP_HELD=1
        MiniFmod_play()
        BUTTON_SL(L)=0
        BUTTON_SL(L)=0
    END IF
    END IF
    END IF
'    NEXT    
END IF

    'PROCESS THE LAST 4 BUTTONS (MUSIC).
IF MP_LEFTS<>0 AND MP_HELD<>1 THEN    
    FOR L=7 TO 10

    IF SKIN_SELECTED=1 THEN
        
        LEFTST  = BUTTON_XP (L)
        TOPST   = BUTTON_YP (L)       
        WIDTHH  = BUTTON_XP (L) + BUTTON_XW(L)
        HEIGHTT = BUTTON_YP (L) + BUTTON_YH(L)
        
    ELSE

        LEFTST  = BUTTON_XP2(L)
        TOPST   = BUTTON_YP2(L)       
        WIDTHH  = BUTTON_XP2(L) + BUTTON_XW2(L)
        HEIGHTT = BUTTON_YP2(L) + BUTTON_YH2(L)

    END IF


    IF BUTTON_SL(L)=0 THEN
    IF MP_LOC_X > LEFTST AND MP_LOC_X < WIDTHH THEN
    IF MP_LOC_Y > TOPST AND MP_LOC_Y < HEIGHTT THEN

'        MP_SI=2
        MP_HELD=1
        FOR M=7 TO 10
            BUTTON_SL(M)=0
        NEXT
        BUTTON_SL(6)=0
        BUTTON_SL(L)=1
        SONG_SCROLL_POINTER=1
        SONG_PLAYING       =L-6        
        
        IF L-6=1 THEN PLAYMUSIC1()
        IF L-6=2 THEN PLAYMUSIC2()
        IF L-6=3 THEN PLAYMUSIC3()
        IF L-6=4 THEN PLAYMUSIC4()
        
        'IF BUTTON_IN(L)>125 THEN BUTTON_IN(L)=125
    END IF
    END IF
    END IF
    NEXT    
END IF


IF MENU_NUMBER=1 THEN BUTTON_SL(2)=1
IF MENU_NUMBER=2 THEN BUTTON_SL(3)=1

END SUB



SUB DRAW_BUTTONS()

    DIM AS INTEGER L
    DIM AS INTEGER LEFTST,TOPST,WIDTHH,HEIGHTT
MP_SI=1
FOR L=1 TO MAX_BUTTONS
    

    IF SKIN_SELECTED=1 THEN
        
        LEFTST  = BUTTON_XP (L)
        TOPST   = BUTTON_YP (L)       
        WIDTHH  = BUTTON_XP (L) + BUTTON_XW(L)
        HEIGHTT = BUTTON_YP (L) + BUTTON_YH(L)
        
    ELSE

        LEFTST  = BUTTON_XP2(L)
        TOPST   = BUTTON_YP2(L)       
        WIDTHH  = BUTTON_XP2(L) + BUTTON_XW2(L)
        HEIGHTT = BUTTON_YP2(L) + BUTTON_YH2(L)

    END IF
    
    

    IF BUTTON_IN(L)>0 THEN 
        BUTTON_IN(L)=BUTTON_IN(L)-3
        IF BUTTON_IN(L)<0 THEN BUTTON_IN(L)=0
    END IF
    IF BUTTON_SL(L)<>1 THEN
    IF SKIN_SELECTED=1 THEN
    HIGHLIGHT_ZONE(BUTTON_XP(L),BUTTON_YP(L),BUTTON_XW(L),BUTTON_YH(L),BUTTON_IN(L),30,50,125)    
    ELSE    
    HIGHLIGHT_ZONE(BUTTON_XP2(L),BUTTON_YP2(L),BUTTON_XW2(L),BUTTON_YH2(L),BUTTON_IN(L),50,100,250)    
    END IF

    IF MP_LOC_X > LEFTST AND MP_LOC_X < WIDTHH THEN
    IF MP_LOC_Y > TOPST AND MP_LOC_Y < HEIGHTT THEN

        MP_SI=2
        IF MP_HELD=0 THEN BUTTON_IN(L)=BUTTON_IN(L)+10
        IF BUTTON_IN(L)>125 THEN BUTTON_IN(L)=125
    END IF
    END IF
    
    ELSE    
    IF SKIN_SELECTED=1 THEN
    HIGHLIGHT_ZONE(BUTTON_XP(L),BUTTON_YP(L),BUTTON_XW(L),BUTTON_YH(L),125,125,70,20)        
    ELSE
    HIGHLIGHT_ZONE(BUTTON_XP2(L),BUTTON_YP2(L),BUTTON_XW2(L),BUTTON_YH2(L),95,100,150,250)        
    END IF
    END IF

NEXT
END SUB



SUB HANDLE_PROGRESS_BAR()
    
DIM AS INTEGER PMINUS,CALCPOS
DIM AS DOUBLE PXPERLINE
DIM AS INTEGER OVER
IF SKIN_SELECTED=1 THEN 
    OVER = 0
        ELSE
    OVER = 5
            END IF
        PXPERLINE=(PAGE_SIZE-32)/(352)
        PMINUS=PXPERLINE*SCROLL_POS
'        IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(779,PMINUS+195,8,20,80,250,150,100)

    
    
    'IF PAGE_SIZE>33 THEN HIGHLIGHT_ZONE(779,PMINUS+195,8,20,PB_FADE,150,200,250)
    IF MP_LEFTS = FALSE THEN PROG_HELD=0
    
    IF MP_LOC_X>775+OVER AND MP_LOC_X<791+OVER AND MP_LOC_Y> 200 AND MP_LOC_Y< 561 OR PROG_HELD=1 THEN
            IF PAGE_SIZE> 32 THEN MP_SI=2
            IF MP_LEFTS=TRUE OR PROG_HELD=1 THEN MP_SI=1
            IF MP_LEFTS=TRUE THEN
                PROG_HELD=1
                
                CALCPOS= ((MP_LOC_Y-200)*PXPERLINE)
                IF CALCPOS<0 THEN CALCPOS=0
                IF CALCPOS>PAGE_SIZE-33 THEN CALCPOS=PAGE_SIZE-33
                SCROLL_POS=CALCPOS
                
            END IF

    
    IF PB_FADE<125 THEN PB_FADE=PB_FADE+5
    ELSE
    IF PB_FADE>0 THEN PB_FADE=PB_FADE-5
    END IF
    
END SUB


'-------------------------------------------------------------------------------
'   ALL INPUTS (MOUSE, KEYS ETC)
'-------------------------------------------------------------------------------

SUB GET_INPUT()
    
    IF PTC_GETLEFTBUTTON=0 AND MP_HELD=1 THEN
        MP_HELD=0
    END IF
    
    
    MP_LOC_X=PTC_GETMOUSEX()
    MP_LOC_Y=PTC_GETMOUSEY()
    
    MP_LEFTS=PTC_GETLEFTBUTTON()
    
    IF MP_LOC_X<1 THEN MP_LOC_X=1
    IF MP_LOC_X>XRES-11 THEN MP_LOC_X=XRES-11
    IF MP_LOC_Y>YRES-11 THEN MP_LOC_Y=YRES-11
    IF MP_LOC_Y<1 THEN MP_LOC_Y=1
    


    '---------------------------------------------------------------------------
    ' IS PAGE UP PRESSED?
    '---------------------------------------------------------------------------
    IF(GETASYNCKEYSTATE(VK_PRIOR)= -32767)  THEN
        IF SCROLL_POS>0 THEN 
                SCROLL_POS=SCROLL_POS-33
                IF SCROLL_POS<0 THEN SCROLL_POS=0
        END IF        
    END IF

    '---------------------------------------------------------------------------
    ' IS PAGE DOWN PRESSED?
    '---------------------------------------------------------------------------
    IF(GETASYNCKEYSTATE(VK_NEXT)= -32767)  THEN
        IF SCROLL_POS<PAGE_SIZE-33 THEN
                SCROLL_POS=SCROLL_POS+33
                IF SCROLL_POS>PAGE_SIZE-33  THEN SCROLL_POS=PAGE_SIZE-33
        END IF        
    END IF

    '---------------------------------------------------------------------------
    ' IS PAGE END PRESSED?
    '---------------------------------------------------------------------------
    IF(GETASYNCKEYSTATE(VK_END)= -32767)  THEN
        'IF SCROLL_POS>0 THEN 
                SCROLL_POS=PAGE_SIZE-33
                IF SCROLL_POS<0 THEN SCROLL_POS=0
'        END IF        
    END IF

    '---------------------------------------------------------------------------
    ' IS HOME PRESSED?
    '---------------------------------------------------------------------------
    IF(GETASYNCKEYSTATE(VK_HOME)= -32767)  THEN
        SCROLL_POS=0
                'SCROLL_POS=SCROLL_POS+33
                'IF SCROLL_POS>PAGE_SIZE-33  THEN SCROLL_POS=PAGE_SIZE-33
        'END IF        
    END IF

END SUB


    
'-------------------------------------------------------------------------------
'   DRAW THE MOUSE POINTER.
'-------------------------------------------------------------------------------

SUB DRAW_MOUSE_POINTER ( BYVAL MP_XPOS AS INTEGER, BYVAL MP_YPOS AS INTEGER, BYVAL MP_TYPE AS INTEGER )
    DIM AS INTEGER L1,L2
    DIM AS UINTEGER PTR PP1,PP2
    IF MP_SI=1 THEN
    FOR L1=0 TO MP_Y-1
        
        PP1=@MP_IMAGES(L1*(MP_X))
        PP2=@BUFFER(MP_XPOS+((MP_YPOS+L1)*XRES))
        
        FOR L2=0 TO MP_X-1
        IF *PP1<>0 AND MP_YPOS>0 AND MP_YPOS<YRES-8 AND MP_XPOS>0 AND MP_XPOS<XRES-8 THEN *PP2=*PP1
        PP1+=1
        PP2+=1
        NEXT
        
    NEXT
    ELSE
    FOR L1=0 TO MP_Y-1
        
        PP1=@MP_IMAGEH(L1*(MP_X))
        PP2=@BUFFER(MP_XPOS+((MP_YPOS+L1)*XRES))
        '
        FOR L2=0 TO MP_X-1
        IF *PP1<>0 AND MP_YPOS>0 AND MP_YPOS<YRES-8 AND MP_XPOS>0 AND MP_XPOS<XRES-8 THEN *PP2=*PP1
        PP1+=1
        PP2+=1
        NEXT
        
    NEXT
    END IF

END SUB


'-------------------------------------------------------------------------------
'
' DRAW_IMAGE BY SHOCKWAVE^CODIGOS
'
' USAGE :  DRAWIMAGE ( X1 , Y1 , WIDTH , HEIGHT , SCREENX , SCREENY )
'
' THIS FUNCTION DOES NOT CHECK WHERE YOU ARE COPYING FROM.
' IF YOU TRY TO COPY FROM AN AREA OUTSIDE YOUR TEMPLATE, IT WILL CRASH.
' IT IS DONE THIS WAY FOR SPEED.
' 
' THIS FUNCTION DOES CLIP THE IMAGE TO THE DISPLAY SCREEN.
' IT IS SAFE TO DRAW PARTLY OR COMPLETELY OFF THE DISPLAY SCREEN.
'
'-------------------------------------------------------------------------------

SUB DRAW_IMAGE(BYVAL X1 AS INTEGER , BYVAL Y1 AS INTEGER, BYVAL W AS INTEGER, BYVAL H AS INTEGER, BYVAL SX AS INTEGER , BYVAL SY AS INTEGER )
    DIM AS INTEGER X,Y,XX,YY,PIXEL
    DIM AS UINTEGER PTR PP1,PP2,PP3,PP4
    YY=SY
    FOR Y=Y1 TO Y1+H
        XX=SX
        PP1=@IMG_RAW(X1+(Y*IMGX))
        PP3=@IMG_RAW2(X1+(Y*IMGX))
        
        PP2=@BUFFER2(XX+(YY*XRES))
        PP4=@BUFFER3(XX+(YY*XRES))
        'if  YY>0 AND YY<YRES then
        FOR X=X1 TO X1+W                
        'IF XX>0 AND XX<XRES THEN
            'PIXEL=*PP1
            'IF PIXEL>0 THEN *PP2=IMG_COLOURS(PIXEL)
            *PP2=IMG_COLOURS(*PP1)
            *PP4=IMG_COLOURS2(*PP3)
            PP2+=1
            PP1+=1            
            PP3+=1
            PP4+=1            
            
        'END IF
        'XX=XX+1
        NEXT
        'end if
        YY=YY+1
    NEXT    
END SUB


SUB DRAW_IMAGE_FAST()
DIM AS UINTEGER L
DIM AS UINTEGER PTR PP1,PP2
IF SKIN_SELECTED=1 THEN
PP2=@BUFFER2(0)
PP1=@BUFFER(0)
ELSE
PP2=@BUFFER3(0)
PP1=@BUFFER(0)
    
END IF

FOR L=0 TO (XRES*YRES)-1
    *PP1=*PP2
    PP2+=1
    PP1+=1
NEXT
    
END SUB


SUB LOAD_IMAGE()
    
DIM AS INTEGER L,RR,GG,BB


'-------------------------------------------------------------------------------
' SKIN 1
'-------------------------------------------------------------------------------

'-------------------------------------------------------------------------------
' PALETTE FIRST..
'-------------------------------------------------------------------------------

    RR=0
    GG=1
    BB=2
    
    FOR L=0 TO 255
        
        IMG_COLOURS(L)=RGB(skin.bmp.pal(RR),skin.bmp.pal(GG),skin.bmp.pal(BB))
        RR=RR+3
        GG=GG+3
        BB=BB+3
    NEXT
    
'-------------------------------------------------------------------------------
' RAW DATA NEXT..
'-------------------------------------------------------------------------------

    FOR L=0 TO (IMGX*IMGY)-1
        IMG_RAW(L)=skin.bmp.raw(L)
    NEXT


'-------------------------------------------------------------------------------
' SKIN 2
'-------------------------------------------------------------------------------

'-------------------------------------------------------------------------------
' PALETTE FIRST..
'-------------------------------------------------------------------------------

    RR=0
    GG=1
    BB=2
    
    FOR L=0 TO 255
        
        IMG_COLOURS2(L)=RGB(skinb.bmp.pal(RR),skinb.bmp.pal(GG),skinb.bmp.pal(BB))
        RR=RR+3
        GG=GG+3
        BB=BB+3
    NEXT
    
'-------------------------------------------------------------------------------
' RAW DATA NEXT..
'-------------------------------------------------------------------------------

    FOR L=0 TO (IMGX*IMGY)-1
        IMG_RAW2(L)=skinb.bmp.raw(L)
    NEXT

END SUB


'-------------------------------------------------------------------------------
' GENERAL PURPOSE ROUTINE USED TO HIGHLIGHT ANY RECTANGULAR AREA OF THE SCREEN
' WITH ANY COLOUR AND USER DEFINED ALPHA.
'-------------------------------------------------------------------------------

SUB HIGHLIGHT_ZONE(BYVAL ZX AS INTEGER,BYVAL ZY AS INTEGER,BYVAL WX AS INTEGER,BYVAL WY AS INTEGER,BYVAL BR AS INTEGER,BYVAL RR AS INTEGER , BYVAL GG AS INTEGER, BYVAL BB AS INTEGER)

DIM AS INTEGER XXZ ,YYZ,CV
CV=RGBA(RR,GG,BB,BR)
DIM AS UINTEGER PTR PP

FOR YYZ=0 TO WY
    PP=@BUFFER(ZX+(ZY*XRES))
    FOR XXZ=0 TO WX
        *PP = ALPHAA ( CV, *PP)
        PP+=1
    NEXT
    ZY=ZY+1
NEXT


END SUB




'-------------------------------------------------------------------------------
'   READ IN THE BUTTONS (POSITIONS, WIDTH AND INITIAL STATUS)
'-------------------------------------------------------------------------------


SUB SETUP_BUTTONS()

    DIM AS INTEGER L
    '===========================================================================
    ' SKIN 1
    '===========================================================================
    FOR L=1 TO MAX_BUTTONS
        READ BUTTON_XP(L),BUTTON_YP(L),BUTTON_XW(L),BUTTON_YH(L),BUTTON_SL(L),BUTTON_IN(L)
    NEXT
    '===========================================================================
    ' SKIN 2
    '===========================================================================
    FOR L=1 TO MAX_BUTTONS
        READ BUTTON_XP2(L),BUTTON_YP2(L),BUTTON_XW2(L),BUTTON_YH2(L)
    NEXT


END SUB
'-------------------------------------------------------------------------------
'   READ IN THE MOUSE POINTER GRAPHIC.
'-------------------------------------------------------------------------------


SUB READ_MOUSE_POINTER ()
    DIM AS INTEGER L,R,C,T
    
'    FOR L=1 TO 2
        FOR R=0 TO ((MP_X) * (MP_Y))-1
            
        READ C        
        SELECT CASE C
        CASE 1
        T=&H111133
        CASE 2
        T=&H8888AA
        CASE 3
        T=&HCCCCEE
        CASE 4
        T=&H555577
        CASE ELSE
        T=0
        END SELECT
        MP_IMAGES(R) = T

        SELECT CASE C
        CASE 1
        T=&H221100
        CASE 2
        T=&HDDBB77
        CASE 3
        T=&HFFEEaa
        CASE 4
        T=&H995522
        CASE ELSE
        T=0
        END SELECT
        MP_IMAGEH(R) = T
        
        NEXT
 '   NEXT


END SUB



SUB DRAWBREAK(BYVAL YP AS INTEGER, BYVAL XP AS INTEGER, BYVAL WD AS INTEGER, BYVAL BS AS INTEGER)

    DIM AS INTEGER TC,X,SLICE
    DIM AS UINTEGER PTR PP,PP2,PP3

    PP=@BUFFER((YP*XRES)+XP)
    PP2=@BUFFER(((YP-1)*XRES)+XP)
    PP3=@BUFFER(((YP+1)*XRES)+XP)
    
    SELECT CASE BS
    '---------------------------------------------------------------------------
    ' STYLE 1 : WHITE BAR
    '---------------------------------------------------------------------------
    CASE 1    
        TC=&HFFFFFF
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H888888
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
        
    '---------------------------------------------------------------------------
    ' STYLE 2 : RED BAR
    '---------------------------------------------------------------------------

    CASE 2
        TC=&HFF0000
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H880000
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
        
    '---------------------------------------------------------------------------
    ' STYLE 3 : GREEN BAR
    '---------------------------------------------------------------------------
        
    CASE 3
        TC=&H00FF00
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H008800
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
        
    '---------------------------------------------------------------------------
    ' STYLE 4 : BLUE BAR
    '---------------------------------------------------------------------------
        
    CASE 4
        TC=&H0000FF
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H000088
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
        
    '---------------------------------------------------------------------------
    ' STYLE 5 : YELLOW BAR
    '---------------------------------------------------------------------------
        
    CASE 5
        TC=&HFFFF00
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H888800
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
        
    '---------------------------------------------------------------------------
    ' STYLE 6 : CYAN BAR
    '---------------------------------------------------------------------------
        
    CASE 6

        TC=&H00FFFF
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H008888
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   
    CASE 7
    '---------------------------------------------------------------------------
    ' STYLE 7 : PURPLE BAR
    '---------------------------------------------------------------------------


        TC=&HFF00FF
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP]
            rep stosd
        end asm   
        TC=&H880088
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP2]
            rep stosd
        end asm   
        SLICE=WD        
        asm
            mov eax,dword ptr[TC]
            mov ecx, [SLICE]
            mov edi, [PP3]
            rep stosd
        end asm   

    CASE 8        
        
        FOR X=0 TO WD
            TC=RGB(125+124*SIN((CYC+X)*.01),125+124*SIN((CYC+X+80)*.012),125+124*SIN((CYC+X+190)*.013))
            *PP=TC
            TC=RGB(65+64*SIN((CYC+X)*.01),65+64*SIN((CYC+X+80)*.012),65+64*SIN((CYC+X+190)*.013))
            *PP2=TC
            *PP3=TC
            PP+=1
            PP2+=1
            PP3+=1
        NEXT
        
    END SELECT
    
END SUB    



SUB TXTL(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)    
    DIM AS INTEGER XX,YY,L
    DIM AS STRING TT
    
    XX=XP
    YY=YP
    
    FOR L=1 TO LEN(TS)
        
        TEXT(MID(TS,L,1),XX,YY,CLIPL,CLIPR,CLIPT,CLIPB,FT,TC )
        XX=XX+9
        
    NEXT

END SUB

SUB TXTLP(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)    
    DIM AS INTEGER XX,YY,L
    DIM AS STRING TT
    
    XX=XP
    YY=YP
    
    'FOR L=1 TO LEN(TS)
        
        TEXT(TS,XX,YY,CLIPL,CLIPR,CLIPT,CLIPB,FT,TC )
    '    XX=XX+9
        
    'NEXT

END SUB

SUB TXTLP2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)    
    DIM AS INTEGER XX,YY,L
    DIM AS STRING TT
    
    XX=XP
    YY=YP
    
    'FOR L=1 TO LEN(TS)
        
        TEXTR(TS,XX,YY,FT,TC )
    '    XX=XX+9
        
    'NEXT

END SUB

SUB TXTL2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)    
    DIM AS INTEGER XX,YY,L
    DIM AS STRING TT
    
    XX=XP
    YY=YP
    
    FOR L=1 TO LEN(TS)
        
        TEXT2(MID(TS,L,1),XX,YY,FT,TC )
        XX=XX+9
        
    NEXT

END SUB


SUB TEXT2(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
'-------------------------------------------------------------------------------
'   DRAWS ONE LETTER.
'   TEXT COMMAND. USAGE:
'   TEXT ( "A" , XPOS , YPOS , CLIPL , CLIPR, CLIPT, CLIPB
'   FONT (1 OR 2) , COLOUR (1 TO 21) ) EG:
'   TEXT ("A",100,100,1,10)
'-------------------------------------------------------------------------------


    DIM AS INTEGER YOFF,XOFF: ' YOFF CHANGES TO SELECT FONT, XOFF IS X OFFSET IN FONT
    DIM AS INTEGER CH       : ' ASCII VALUE
    DIM AS INTEGER LPX,LPY,CUNNIS
    DIM AS UINTEGER PTR PTX,CUN
    
    '---------------------------------------------------------------------------
    'IF STRING NOT EMPTY AND FONT VALID AND COLOUR VALID THEN PROCESS AND DRAW
    '---------------------------------------------------------------------------
    
    IF LEN(TS)>0 AND (FT>=1 AND FT<=2) AND (TC>=1 AND TC<=31) THEN
        
        IF FT=1 THEN YOFF=0
        IF FT=2 THEN YOFF=14
        
        CH=(ASC(MID(TS,1,1))-32)
        
        XOFF=(CH*9)+1
        'if CH>0 AND CH <FONT_SW THEN
        if xoff>0 AND xoff <FONT_SW THEN    
        FOR LPY=0 TO 11
            PTX=@BUFFER(XP+((YP+LPY)*XRES))
            CUN=@FONT_DAT(xoff+((LPY+YOFF)*FONT_SW))
            FOR LPX=0 TO 8
                *PTX=FONT_PAL(*CUN , TC )            
                PTX+=1
                CUN+=1
            NEXT        
        NEXT
        end if
    END IF
    
END SUB






SUB TEXT(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL CLIPL AS INTEGER,BYVAL CLIPR AS INTEGER,BYVAL CLIPT AS INTEGER,BYVAL CLIPB AS INTEGER, BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
'-------------------------------------------------------------------------------
'   DRAWS ONE LETTER.
'   TEXT COMMAND. USAGE:
'   TEXT ( "A" , XPOS , YPOS , CLIPL , CLIPR, CLIPT, CLIPB
'   FONT (1 OR 2) , COLOUR (1 TO 21) ) EG:
'   TEXT ("A",100,100,1,10)
'-------------------------------------------------------------------------------


    DIM AS INTEGER YOFF,XOFF: ' YOFF CHANGES TO SELECT FONT, XOFF IS X OFFSET IN FONT
    DIM AS INTEGER CH       : ' ASCII VALUE
    DIM AS INTEGER LPX,LPY,CUNNIS
    DIM AS UINTEGER PTR PTX,FTX
    
    '---------------------------------------------------------------------------
    'IF STRING NOT EMPTY AND FONT VALID AND COLOUR VALID THEN PROCESS AND DRAW
    '---------------------------------------------------------------------------
    
    IF LEN(TS)>0 AND (FT>=1 AND FT<=2) AND (TC>=1 AND TC<=31) THEN
        
        IF FT=1 THEN YOFF=0
        IF FT=2 THEN YOFF=14
        
        CH=(ASC(MID(TS,1,1))-32)
        XOFF=(CH*9)+1
        
        'if CH>0 AND CH <FONT_SW THEN
        if xoff>0 AND xoff <FONT_SW THEN
        FOR LPY=0 TO 11
            IF YP+LPY>=CLIPT AND YP+LPY<=CLIPB THEN
            PTX=@BUFFER(XP+((YP+LPY)*XRES))
            FTX=@FONT_DAT(xoff+((LPY+YOFF)*FONT_SW))
            FOR LPX=0 TO 8
                IF *ftx<>0 then
                IF XP+LPX>=CLIPL AND XP+LPX<=CLIPR THEN
                *PTX=FONT_PAL(*FTX , TC )            
                END IF
                END IF
                PTX+=1
                ftx+=1
            NEXT
            END IF
        
        NEXT
        end if
    
    END IF
    
END SUB



SUB TEXTR(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
'-------------------------------------------------------------------------------
'   DRAWS ONE LETTER.
'   TEXT COMMAND. USAGE:
'   TEXT ( "A" , XPOS , YPOS , CLIPL , CLIPR, CLIPT, CLIPB
'   FONT (1 OR 2) , COLOUR (1 TO 21) ) EG:
'   TEXT ("A",100,100,1,10)
'-------------------------------------------------------------------------------


    DIM AS INTEGER YOFF,XOFF: ' YOFF CHANGES TO SELECT FONT, XOFF IS X OFFSET IN FONT
    DIM AS INTEGER CH       : ' ASCII VALUE
    DIM AS INTEGER LPX,LPY,CUNNIS
    DIM AS UINTEGER PTR PTX,FTX
    
    '---------------------------------------------------------------------------
    'IF STRING NOT EMPTY AND FONT VALID AND COLOUR VALID THEN PROCESS AND DRAW
    '---------------------------------------------------------------------------
    
    IF LEN(TS)>0 AND (FT>=1 AND FT<=2) AND (TC>=1 AND TC<=31) THEN
        
        IF FT=1 THEN YOFF=0
        IF FT=2 THEN YOFF=14
        
        CH=(ASC(MID(TS,1,1))-32)
        XOFF=(CH*9)+1
        if CH>0 AND CH <FONT_SW THEN
        FOR LPY=0 TO 11
            IF YP+LPY>=193 AND YP+LPY<=569 THEN
            PTX=@BUFFER(XP+((YP+LPY)*XRES))
            FTX=@FONT_DAT(xoff+((LPY+YOFF)*FONT_SW))
            FOR LPX=0 TO 8
                'IF *ftx>1 then
                'IF XP+LPX>=CLIPL AND XP+LPX<=CLIPR THEN
                *PTX=FONT_PAL(*FTX , TC )            
                'END IF
                'END IF
                PTX+=1
                ftx+=1
            NEXT
            END IF
        
        NEXT
        end if
    END IF
    
END SUB


'-------------------------------------------------------------------------------
'   "LOAD" FONT AND GENERATE THE COLOUR PALETTES FOR IT.
'-------------------------------------------------------------------------------

SUB LOADFONT()
    
    DIM AS INTEGER LP,CV,CI:'        LOOP, SHADE, COLOUR VALUE, COLOUR INDEX
    DIM AS DOUBLE RD,GR,BL,SH:'            RED, GREEN, BLUE
    '---------------------------------------------------------------------------
    'LOAD THE STRUCTURE FIRST
    '---------------------------------------------------------------------------
    
        FOR LP=0 TO (FONT_SW * FONT_SH)-1
            FONT_DAT(LP) = font8c.bmp.raw(LP)        
        NEXT
        
    '---------------------------------------------------------------------------
    'NOW THE PALETTES.
    '---------------------------------------------------------------------------
    '   WHITE  1  2  3   
    '   RED    4  5  6
    '   GREEN  7  8  9
    '   BLUE   10 11 12
    '   YELLOW 13 14 15
    '   CYAN   16 17 18
    '   PURPLE 19 20 21
    '---------------------------------------------------------------------------
    ' 3 SHADES OF WHITE
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=1 TO 3
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT

    '---------------------------------------------------------------------------
    ' 3 SHADES OF RED
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=4 TO 6
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            'GR=((font8c.bmp.pal((LP*3)+1))/SH)
            'BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT

    '---------------------------------------------------------------------------
    ' 3 SHADES OF GREEN
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=7 TO 9
        
        FOR LP=0 TO 255
            
            'RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            'BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT

    '---------------------------------------------------------------------------
    ' 3 SHADES OF BLUE
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=10 TO 12
        
        FOR LP=0 TO 255
            
            'RD=((font8c.bmp.pal((LP*3)+0))/SH)
            'GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT

    '---------------------------------------------------------------------------
    ' 3 SHADES OF YELLOW
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=13 TO 15
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            'BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT
    
    '---------------------------------------------------------------------------
    ' 3 SHADES OF CYAN
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=16 TO 18
        
        FOR LP=0 TO 255
            
            'RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT    

    '---------------------------------------------------------------------------
    ' 3 SHADES OF PURPLE
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=19 TO 21
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            'GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR),INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT    

    '---------------------------------------------------------------------------
    ' 3 SHADES OF ORANGE
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=22 TO 24
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD),INT(GR)*.7,INT(BL)*.3) 
            
        NEXT
        
        SH=SH+.5
    NEXT   

    '---------------------------------------------------------------------------
    ' 3 SHADES OF LILAC
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=25 TO 27
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD)*.3,INT(GR)*.7,INT(BL)) 
            
        NEXT
        
        SH=SH+.5
    NEXT   
    '---------------------------------------------------------------------------
    ' 3 SHADES OF LIGHT GREEN
    '---------------------------------------------------------------------------
    
    RD=0.0 : GR=0.0 : BL=0.0    
    SH=1:'BRIGHTNESS DIVISOR
    FOR CI=28 TO 30
        
        FOR LP=0 TO 255
            
            RD=((font8c.bmp.pal((LP*3)+0))/SH)
            GR=((font8c.bmp.pal((LP*3)+1))/SH)
            BL=((font8c.bmp.pal((LP*3)+2))/SH)
            
            FONT_PAL(LP , CI) = RGB(INT(RD)*.7,INT(GR),INT(BL)*.7) 
            
        NEXT
        
        SH=SH+.5
    NEXT   

END SUB


'-------------------------------------------------------------------------------
' LOADS THE PAGE "PAGE_NUMBER" INTO THE DISPLAY MEMORY.
'-------------------------------------------------------------------------------

SUB LOAD_PAGE(BYVAL PAGE_NUMBER AS INTEGER)
    DIM AS STRING STRR
    DIM AS INTEGER Y,X
 
    PAGE_SIZE=4999
    FOR Y=0 TO 4999     
        IF MID(TEXT_LINE(Y,PAGE_NUMBER),1,5 )="<END>"THEN        
        PAGE_SIZE=Y
        ELSE        
        FOR X=0 TO 80
                    'TV=VAL(MID(FONTMAP(Y+PAGE_OFFSET),X,1))
            'CG=(MID(COLMAP(Y+PAGE_OFFSET),X,1))     
        TEXTMAP(Y,X)=MID(TEXT_LINE(Y,PAGE_NUMBER),X,1)
        STRR=(MID(COL_LINE(Y,PAGE_NUMBER),X,1))
        SELECT CASE STRR
        CASE "1"
        COLMAP(Y,X) =1
        CASE "2"
        COLMAP(Y,X) =2
        CASE "3"
        COLMAP(Y,X) =3
        CASE "4"        
        COLMAP(Y,X) =4
        CASE "5"
        COLMAP(Y,X) =5        
        CASE "6"
        COLMAP(Y,X) =6
        CASE "7"
        COLMAP(Y,X) =7
        CASE "8"
        COLMAP(Y,X) =8
        CASE "9"        
        COLMAP(Y,X) =9
        CASE "A"
        COLMAP(Y,X) =10
        CASE "B"
        COLMAP(Y,X) =11
        CASE "C"
        COLMAP(Y,X) =12
        CASE "D"
        COLMAP(Y,X) =13
        CASE "E"
        COLMAP(Y,X) =14
        CASE "F"
        COLMAP(Y,X) =15
        CASE "G"
        COLMAP(Y,X) =16
        CASE "H"
        COLMAP(Y,X) =17
        CASE "I"
        COLMAP(Y,X) =18
        CASE "J"
        COLMAP(Y,X) =19
        CASE "K"
        COLMAP(Y,X) =20
        CASE "L"
        COLMAP(Y,X) =21
        CASE "M"
        COLMAP(Y,X) =22
        CASE "N"
        COLMAP(Y,X) =23
        CASE "O"
        COLMAP(Y,X) =24
        CASE "P"
        COLMAP(Y,X) =25
        CASE "Q"
        COLMAP(Y,X) =26
        CASE "R"
        COLMAP(Y,X) =27
        CASE "S"
        COLMAP(Y,X) =28
        CASE "T"
        COLMAP(Y,X) =29
        CASE "U"
        COLMAP(Y,X) =30
        CASE "V"
        COLMAP(Y,X) =31
        CASE ELSE
        COLMAP(Y,X) =1
        END SELECT
'        COLMAP(Y,X) =VAL(MID(COL_LINE(Y,PAGE_NUMBER),X,1)) :'COL_LINE(Y,PAGE_NUMBER)
        FONTMAP(Y,X)=VAL(MID(FONT_LINE(Y,PAGE_NUMBER),X,1)) :'FONT_LINE(Y,PAGE_NUMBER)
        NEXT
        BREAKMAP(Y)=PAGE_LINE(Y,PAGE_NUMBER)
        END IF
    
    NEXT

    PIXEL_SCROLL = 0
    SCROLL_POS   = 0
END SUB















SUB HANDLE_SOUND()
    MONITOR_SOUND()
    DECREASE_PEAKS()
END SUB


SUB MONITOR_SOUND()
    
    DIM L AS INTEGER
    L=0
    FOR L=0 TO CHANNELS
    inst_note = MiniFmod_GetSynch(L)
    note = inst_note and &hff
    NOTE=INT(NOTE)-45
    IF NOTE >0 and note< ABARS-1 THEN        
        PEAKS(NOTE)=PEAKS(NOTE)-4
        PEAKS(NOTE-1)=PEAKS(NOTE-1)-3
        PEAKS(NOTE+1)=PEAKS(NOTE+1)-3
    END IF
    NEXT
END SUB


SUB SET_STUFF()
DIM L AS INTEGER
    FOR L=0 TO ABARS-1
        PEAKS(L)=BOTTOM_EQU
    NEXT

END SUB

SUB DECREASE_PEAKS()    
    DIM AS INTEGER L,P,L2,Y,YC,TC,Q,T2,OY
    
    P=157
    IF SKIN_SELECTED=1 THEN 
        OY=0
    ELSE
        OY=2    
    END IF
    
    FOR L=0 TO ABARS-1
        if PEAKS(L)<bottom_equ-16 then PEAKS(L)=bottom_equ-16
        Q=Q+1
        IF Q>1 THEN Q=0
        IF PEAKS(L)<=bottom_equ THEN PEAKS(L)=PEAKS(L)+2                        
        IF SKIN_SELECTED=1 THEN 
        FOR Y=INT(PEAKS(L)) TO bottom_equ
            YC=(Y+OY)*XRES            
            T2=((BOTTOM_EQU-PEAKS(L))*3)+50
                FOR L2=1 TO BWDTH-1        
                BUFFER((P+L2)+YC)=EQUBARS(Y)
                NEXT
                
            
        NEXT
        P+=BWDTH
        ELSE
        FOR Y=INT(PEAKS(L)) TO bottom_equ
            YC=(Y+OY)*XRES            
            T2=((BOTTOM_EQU-PEAKS(L))*3)+50
                FOR L2=1 TO BWDTH-1        
                BUFFER((P+L2)+YC)=EQUBARSB(Y)
                NEXT
                
            
        NEXT
        P+=BWDTH
        END IF
    NEXT
END SUB


'-------------------------------------------------------------------------------
'   MOUSE POINTERAGE ;-)
'-------------------------------------------------------------------------------

' 16 * 16

DATA 1,1,1,1,1,1,1,1,1,0,0
DATA 1,2,3,3,3,3,3,1,0,0,0
DATA 1,4,2,2,2,2,1,0,0,0,0
DATA 1,4,2,2,2,2,3,1,0,0,0
DATA 1,4,2,2,2,2,2,3,1,0,0
DATA 1,4,2,2,2,2,2,2,3,1,0
DATA 1,4,1,4,2,2,2,2,2,3,1
DATA 1,1,0,1,4,2,2,2,2,1,0
DATA 1,0,0,0,1,4,2,2,1,0,0
DATA 0,0,0,0,0,1,4,1,0,0,0
DATA 0,0,0,0,0,0,1,0,0,0,0

'DATA 1,1,1,1,1,1,1,1,0
'DATA 1,2,3,3,3,3,2,0,0
'DATA 1,4,2,2,2,1,0,0,0
'DATA 1,4,2,2,2,3,1,0,0
'DATA 1,4,2,2,2,2,3,1,0
'DATA 1,4,1,4,2,2,2,3,1
'DATA 1,1,0,1,4,2,2,1,0
'DATA 1,0,0,0,1,4,1,0,0
'DATA 0,0,0,0,0,1,0,0,0


'    DIM SHARED AS INTEGER BUTTON_XP(MAX_BUTTONS)
'    DIM SHARED AS INTEGER BUTTON_YP(MAX_BUTTONS)
'    DIM SHARED AS INTEGER BUTTON_XW(MAX_BUTTONS)
'    DIM SHARED AS INTEGER BUTTON_YH(MAX_BUTTONS)
'    DIM SHARED AS INTEGER BUTTON_SL(MAX_BUTTONS)
'    DIM SHARED AS INTEGER BUTTON_IN(MAX_BUTTONS)

'-------------------------------------------------------------------------------
'   BUTTON STUFF;
'   XPOS,YPOS,WIDTH,HEIGHT,SELECTED,ALPHA
'
'-------------------------------------------------------------------------------

'===============================================================================
' SKIN 1
'===============================================================================

'QUIT
DATA 35,40,88,19,0,0
'CHARTS
DATA 35,65,88,19,0,0
'ARTICLES (SELECTED BY DEFAULT)
DATA 35,90,88,19,1,0
'RULES
DATA 672,65,88,19,0,0
'HELP
DATA 672,90,88,19,0,0
'MUTE 
DATA 672,40,88,19,0,0
'MUSIC1 (SELECTED BY DEFAULT)
DATA 9,132,57,19,1,0
'MUSIC2
DATA 73,132,57,19,0,0
'MUSIC3
DATA 665,132,57,19,0,0
'MUSIC4
DATA 729,132,57,19,0,0

'===============================================================================
' SKIN 2
'===============================================================================

'QUIT
DATA 25,49,76,19
'CHARTS
DATA 25,73,76,19
'ARTICLES (SELECTED BY DEFAULT)
DATA 25,97,76,19


'RULES
DATA 698,73,76,19
'HELP
DATA 698,97,76,19
'MUTE 
DATA 698,49,76,19


'MUSIC1 (SELECTED BY DEFAULT)
DATA 18,137,43,8
'MUSIC2
DATA 79,137,44,8
'MUSIC3
DATA 669,137,44,8
'MUSIC4
DATA 733,137,43,8






SUB I_BARWAVE()

DIM AS INTEGER I_L

FOR I_L=1 TO 7
I_COPPER_BAR(I_L*2,(375+100*SIN(((I_L*4)+I_TIME)*3.14/90)))
I_COPPER_BAR(I_L,(595+(-80*SIN(((I_L*4)+I_TIME)*3.14/90))))

NEXT

END SUB

 
SUB I_COPPER_BAR (BYVAL I_C AS INTEGER , BYVAL I_Y AS INTEGER)

        DIM AS INTEGER I_SLICE,I_TC,I_LY,I_COLOUR
        DIM AS UINTEGER PTR I_PP
        I_COLOUR=0
        FOR I_LY=0 TO 31 
            IF I_LY<16 THEN
                I_COLOUR=I_COLOUR+I_C
            ELSE
                I_COLOUR=I_COLOUR-I_C
            END IF
            IF I_LY+I_Y<YRES THEN
            I_TC=RGB(0,0,I_COLOUR)
            I_SLICE=XRES
            I_PP=@BUFFER((I_LY+I_Y)*XRES)            
            asm
                mov eax,dword ptr[I_TC]
                mov ecx, [I_SLICE]
                mov edi, [I_PP]
                rep stosd
            end asm              
            END IF
        NEXT

END SUB
 
 
 
 
 
 
 
 
SUB I_DECRUNCH()
DIM AS DOUBLE TIMING
TIMING=TIMER+.5
DIM AS INTEGER I_SLICE,I_TC,I_LY,I_TWO
DIM AS UINTEGER PTR I_PP
WHILE TIMER<TIMING

        FOR I_LY=0 TO YRES-1 STEP 10
        I_TC=RGB(RND(1)*255,RND(1)*255,RND(1)*255)
        FOR I_TWO=0 TO 9
        I_SLICE=XRES
        I_PP=@BUFFER((I_LY+I_TWO)*XRES)            
        asm
            mov eax,dword ptr[I_TC]
            mov ecx, [I_SLICE]
            mov edi, [I_PP]
            rep stosd
        end asm    
        NEXT
        NEXT
        PTC_UPDATE@BUFFER(0)
        SLEEP 1
WEND
end sub


SUB I_DECRUNCH2()
DIM AS DOUBLE TIMING
TIMING=TIMER+.5
DIM AS INTEGER I_SLICE,I_TC,I_LY,I_TWO
DIM AS UINTEGER PTR I_PP

WHILE TIMER<TIMING

        FOR I_LY=0 TO YRES-1 STEP 2
        I_TC=RGB(RND(1)*255,RND(1)*255,RND(1)*255)
        FOR I_TWO=0 TO 1
        I_SLICE=XRES
        I_PP=@BUFFER((I_LY+I_TWO)*XRES)            
        asm
            mov eax,dword ptr[I_TC]
            mov ecx, [I_SLICE]
            mov edi, [I_PP]
            rep stosd
        end asm    
        NEXT
        NEXT
        PTC_UPDATE@BUFFER(0)
        SLEEP 1
WEND



END SUB



SUB I_SWITCHSONG(BYVAL I_TUNE AS INTEGER)
    sid_sound_server_replay_stop()
    SELECT CASE I_TUNE
    CASE 1
    sid_sound_server_replay_init(@rh1(0), S1, I_ST1)
    sid_sound_server_replay_play()
    CASE 2
    sid_sound_server_replay_init(@rh2(0), S2, I_ST2)
    sid_sound_server_replay_play()    
    CASE 3
    sid_sound_server_replay_init(@rh3(0), S3, I_ST3)
    sid_sound_server_replay_play()
    CASE 4
    sid_sound_server_replay_init(@rh4(0), S4, I_ST4)
    sid_sound_server_replay_play()    
    CASE 5
    sid_sound_server_replay_init(@rh5(0), S5, I_ST5)
    sid_sound_server_replay_play()    
    CASE 6
    sid_sound_server_replay_init(@rh6(0), S6, I_ST6)
    sid_sound_server_replay_play()    
    CASE 7
    sid_sound_server_replay_init(@rh7(0), S7, I_ST7)
    sid_sound_server_replay_play()    
    CASE 8
    sid_sound_server_replay_init(@rh8(0), S8, I_ST8)
    sid_sound_server_replay_play()    
    CASE 9
    sid_sound_server_replay_init(@rh9(0), S9, I_ST9)
    sid_sound_server_replay_play()    
    CASE 10
    sid_sound_server_replay_init(@rh10(0), S10, I_ST10)
    sid_sound_server_replay_play()    
    CASE 11
    sid_sound_server_replay_init(@rh11(0), S11, I_ST11)
    sid_sound_server_replay_play()
    CASE 12
    sid_sound_server_replay_init(@rh12(0),  S12, I_ST12)
    sid_sound_server_replay_play()    
    END SELECT

END SUB




SUB I_PREPSTARS()

        'DIM SHARED AS UINTEGER I_STNM = 300    
        'DIM SHARED AS DOUBLE I_STRX(I_STNM)
        'DIM SHARED AS DOUBLE I_STRY(I_STNM)  
    DIM AS INTEGER AA
    
    FOR AA= 1 TO I_STNM
        I_STRX(AA)=RND(1)*XRES
        I_STRY(AA)=(RND(1)*(YRES-130))+22
    NEXT
    
    
END SUB
 
SUB I_DRAWSTARS()

    DIM AS INTEGER AA,TX,TY,TC,TC2,TC3
    DIM AS DOUBLE II1,II2,II3
    II1=I_DELTA*.6
    II2=I_DELTA*1.2
    II3=I_DELTA*1.8
    
    
    FOR AA= 1 TO I_STNM
        
        TX=INT(I_STRX(AA))
        TY=INT(I_STRY(AA))

            SELECT CASE AA
            CASE 1 TO 100
                TC =&H222222
                TC2=&H111111
                TC3=&H111111
                I_STRX(AA)=I_STRX(AA)+II1
            CASE 101 TO 200
                TC =&H444444
                TC2=&H222222
                TC3=&H222222

                
                I_STRX(AA)=I_STRX(AA)+II2
            CASE 201 TO 300
                TC =&H999999
                TC2=&H444444
                TC3=&H333333
            
                I_STRX(AA)=I_STRX(AA)+II3
            END SELECT
    

        IF TX>4 AND TX<XRES-4 THEN
            
            BUFFER(TX+(TY*XRES)) = TC
            BUFFER(TX+1+(TY*XRES)) = TC
            BUFFER(TX+((TY+1)*XRES)) = TC
            BUFFER(TX+1+((TY+1)*XRES)) = TC


            BUFFER(TX+2+((TY)*XRES)) = TC2
            BUFFER(TX+2+((TY+1)*XRES)) = TC2

            BUFFER(TX-1+((TY)*XRES)) = TC2
            BUFFER(TX-1+((TY+1)*XRES)) = TC2

            BUFFER(TX+((TY-1)*XRES)) = TC2
            BUFFER(TX+1+((TY-1)*XRES)) = TC2

            BUFFER(TX+((TY+2)*XRES)) = TC2
            BUFFER(TX+1+((TY+2)*XRES)) = TC2

        END IF
        IF I_STRX(AA)>XRES THEN
        I_STRX(AA)= I_STRX(AA)-xres
        END IF
'        I_STRX(AA)=RND(1)*XRES
'        I_STRY(AA)=(RND(1)*YRES-142)+22
    NEXT


END SUB





SUB I_SCROLLER()
    DIM AS DOUBLE SCMV
    SCMV=I_DELTA
    IF SCMV>5 THEN SCMV=5    
    if timer>I_SPAUSE THEN I_SCP=I_SCP-SCMV
    IF I_SCP<-32 THEN
        I_TP1=I_TP1+1
        IF MID(intro_SCT,I_TP1,1)="a" then I_SPAUSE=TIMER+4
        
        IF I_TP1>LEN(intro_SCT) THEN I_TP1=1
        I_SCP=I_SCP+32
    END IF
    I_SINE_TEXT(MID(intro_SCT,I_TP1,28),INT(I_SCP))
    
    
END SUB    




SUB I_SINE_TEXT(BYVAL I_T AS STRING  , BYVAL I_X AS INTEGER)
    DIM AS INTEGER I_PNT,I_CHR,I_LL
    IF LEN(I_T)>0 THEN
        
    
    FOR I_LL=1 TO LEN(I_T)
        if MID(I_T,I_LL,1)<>"a" then
        I_CHR=(ASC(UCASE(MID(I_T,I_LL,1)))-32)*32
        else
        I_CHR=0
        end if
            IF I_CHR>=0 AND I_CHR<I_FONTX THEN
                
                I_SINE_LETTER(I_CHR , I_X)
                I_X += I_FONTY
            END IF
        
        I_PNT=I_PNT+I_FONTY
    NEXT

    END IF
    
END SUB








SUB I_BUFFER_CLEAR()
DIM AS INTEGER I_LY,I_TC,I_SLICE,VV
VV=150
DIM AS UINTEGER PTR I_PP
FOR I_LY=0 TO YRES-1
        SELECT CASE I_LY

        CASE 1 TO 50
        I_TC=RGB(0,0,VV)
        VV=VV-3
        CASE YRES-18 TO YRES-1
        I_TC=RGB(vv,vv*.5,VV*.25)
        'VV=VV-4
    
        CASE 19,20,YRES-20,YRES-19
            I_TC=&HFFFFFF
            I_TC=&H000000
        CASE 21 TO YRES-100
            I_TC=&H000000
        CASE YRES-99 TO YRES-21
            I_TC=&h000000
            
        CASE ELSE
            I_TC=&H000000
        END SELECT

        I_SLICE=XRES
        I_PP=@BUFFER((I_LY)*XRES)            
        asm
            mov eax,dword ptr[I_TC]
            mov ecx, [I_SLICE]
            mov edi, [I_PP]
            rep stosd
        end asm    
NEXT




END SUB


SUB I_DRAW_TITLES()
    DIM AS INTEGER I_COUNT
    FOR I_COUNT=1 TO 9
        
        I_CENTER_TEXT(I_TITLES(I_COUNT),(I_COUNT*33)+60)
        
    NEXT
END SUB

SUB I_CENTER_TEXT(BYVAL I_T AS STRING  , BYVAL I_Y AS INTEGER)
    DIM AS INTEGER I_PNT,I_CHR,I_LL,I_PS
    IF LEN(I_T)>0 THEN
        
    I_PS= 400-(LEN(I_T) * 16)
    
    FOR I_LL=1 TO LEN(I_T)
        
        I_CHR=(ASC(UCASE(MID(I_T,I_LL,1)))-32)*32
        
            IF I_CHR>=0 AND I_CHR<I_FONTX THEN
                
                I_BLIT_LETTER(I_CHR , I_PS , I_Y )
                I_PS+=I_FONTY
            END IF
        
        I_PNT=I_PNT+I_FONTY
    NEXT

    END IF
    
END SUB

SUB I_SINE_LETTER(BYVAL I_S AS INTEGER , BYVAL I_X AS INTEGER)
    DIM AS UINTEGER PTR I_P , I_B
    DIM AS INTEGER I_LX,I_LY,PIXEL,I_SHADOW,I_Y
    I_SHADOW=1


FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_B(I_X+I_LX)
    I_B=@BUFFER(I_X+I_LX+((I_Y+I_SHADOW)*XRES)+I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX+(31*I_FONTX))
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 AND I_LY+I_Y<YRES-2 THEN 
        *I_B=I_COP_COLOURS_C(I_LY+I_Y+20)
        END IF
    I_B += XRES    
    I_P -= I_FONTX
    NEXT
    END IF
NEXT

FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_B(I_X+I_LX)    
    I_B=@BUFFER(I_X+I_LX+((I_Y-I_SHADOW)*XRES)-I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX+(31*I_FONTX))
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 AND I_LY+I_Y<YRES-2 THEN 
        *I_B=I_COP_COLOURS_C(I_LY+I_Y-20)
        END IF
    I_B += XRES    
    I_P -= I_FONTX
    NEXT
    END IF
NEXT    

FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_B(I_X+I_LX)    
    I_B=@BUFFER(I_X+I_LX+((I_Y)*XRES))
    I_P=@I_FONT_BUFFER(I_S+I_LX+(31*I_FONTX))
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 AND I_LY+I_Y<YRES-2 THEN 
        *I_B=I_COP_COLOURS_C(I_LY+I_Y)
        END IF
    I_B += XRES    
    I_P -= I_FONTX
    NEXT
    END IF
NEXT    
 








FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_A(I_X+I_LX)
    I_B=@BUFFER(I_X+I_LX+((I_Y+I_SHADOW)*XRES)+I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
        *I_B=&H444444
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF
NEXT

FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_A(I_X+I_LX)    
    I_B=@BUFFER(I_X+I_LX+((I_Y-I_SHADOW)*XRES)-I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
        *I_B=&HFFFFFF
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF
NEXT    

FOR I_LX=0 TO I_FONTY-1    
    I_Y=I_SINETABLE_A(I_X+I_LX)
    I_B=@BUFFER(I_X+I_LX+(I_Y*XRES))
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES-1 THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
'        *I_B=PIXEL
        *I_B=I_COP_COLOURS_B(I_LY+I_Y)
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF
NEXT
    
END SUB

SUB I_BLIT_LETTER(BYVAL I_S AS INTEGER , BYVAL I_X AS INTEGER , BYVAL I_Y AS INTEGER)
    DIM AS UINTEGER PTR I_P , I_B
    DIM AS INTEGER I_LX,I_LY,PIXEL,I_SHADOW
    I_SHADOW=1
FOR I_LX=0 TO I_FONTY-1    
    I_B=@BUFFER(I_X+I_LX+((I_Y+I_SHADOW)*XRES)+I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
        *I_B=&H444444
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF
NEXT
FOR I_LX=0 TO I_FONTY-1    
    I_B=@BUFFER(I_X+I_LX+((I_Y-I_SHADOW)*XRES)-I_SHADOW)
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
        *I_B=&hffffff
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF 
NEXT    
FOR I_LX=0 TO I_FONTY-1    
    I_B=@BUFFER(I_X+I_LX+(I_Y*XRES))
    I_P=@I_FONT_BUFFER(I_S+I_LX)
    IF I_X+I_LX>0 AND I_X+I_LX<XRES THEN
    FOR I_LY=0 TO I_FONTY-1
        PIXEL=I_FONT_COLOURS( *I_P )
        IF PIXEL<>0 THEN 
        '*I_B=PIXEL
        *I_B=I_COP_COLOURS_A(I_LY+I_Y)
        END IF
    I_B += XRES    
    I_P += I_FONTX
    NEXT
    END IF
NEXT
END SUB



SUB I_SINE_WAVES()
    DIM AS INTEGER L,LLL,LLC
    dim as double MMM
    DIM AS DOUBLE R2D
    R2D=(3.143/360)
    LLC=0
    FOR L=0 TO XRES
        LLC=LLC+1
        IF LLC>1 THEN 
            LLL=LLL+1
            LLC=0
        END IF
        I_SINETABLE_A(L)=  ((100*SIN((LLL-(I_TIME*2.5))*(R2D*1.5)))+(73*SIN((LLL-(I_TIME*4))*R2D))) +310
        I_SINETABLE_B(L)=(-((30*SIN((LLL-(I_TIME*2.5))*(R2D*1.5)))+(48*SIN((LLL-(I_TIME*4))*R2D))))+592
    NEXT
    
    R2D=(3.143/30)
    DIM AS INTEGER I_CV,IR1,IG1,IB1
    MMM=1
    FOR L=0 TO YRES+30
        I_CV=150+100*SIN((L+I_TIME)*(R2D*.25))
        
        IR1=125+90*SIN((L+I_TIME)*(R2D*.25))
        IG1=125+90*SIN((L+20+I_TIME)*(R2D*.25))
        IB1=125+90*SIN((L+40+I_TIME)*(R2D*.25))
        
        I_COP_COLOURS_A(L)=RGB(IR1,IG1,IB1)

        IR1=150+100*SIN((L)*(R2D*.25))
        IG1=150+100*SIN((L+50)*(R2D*.25))
        IB1=150+100*SIN((L+100)*(R2D*.25))
        
        I_CV=150+100*SIN((L+I_TIME)*R2D)
        'I_COP_COLOURS_B(L)=RGB(I_CV*.125,I_CV*.125,I_CV)
        I_COP_COLOURS_B(L)=RGB(IR1,IG1,IB1)
        I_CV=150+100*SIN((L-I_TIME)*R2D)
        IR1=int((100+50*SIN((-L-10)*(R2D*.25)))*MMM)
        IG1=int((100+50*SIN((-L-90)*(R2D*.25)))*MMM)
        IB1=int((100+50*SIN((-L-170)*(R2D*.25)))*MMM)
        IF L>520 THEN MMM=MMM-.015
        if mmm<0 then mmm=0
        I_COP_COLOURS_C(L)=RGB(IR1,IG1,IB1)
        'I_COP_COLOURS_C(L)=RGB(I_CV*.0125,I_CV*.0125,I_CV*.5)
    NEXT

END SUB


SUB I_LOADFONT()
    
    dim as integer l,m
    '---------------------------------------------------------------------------
    ' LOAD IMAGE PIXELMAP;
    '---------------------------------------------------------------------------

    FOR L=0 TO ((I_FONTX*I_FONTY)-1)
        I_FONT_BUFFER(L) = sinefont.bmp.raw (L)
    NEXT    
    '---------------------------------------------------------------------------
    ' LOAD COLOUR PALETTE;
    '---------------------------------------------------------------------------
    FOR L=0 TO 255
        I_FONT_COLOURS(L)=RGB(int (sinefont.bmp.pal (L*3)),int (sinefont.bmp.pal (L*3+1)),int (sinefont.bmp.pal (L*3+2)))
    NEXT

    
END SUB




