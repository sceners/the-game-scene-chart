' (C) Widowmaker 2009
'-------------------------------------------------------------------------------

'---------------------------------------
'  Freebasic TinySID v1.0 Generic Replay
'---------------------------------------

    #include "windows.bi"

    #INCLUDE "TINYPTC_EXT.BI"
    #INCLUDE "WINDOWS.BI"

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


    #INCLUDE "sinefontraw.bas"
    #INCLUDE "sinefontpal.bas"
    
    OPTION STATIC
    OPTION EXPLICIT
    
    CONST   XRES    =    800
    CONST   YRES    =    600    

    CONST I_FONTX=1888
    CONST I_FONTY=32
    
'-------------------------------------------------------------------------------
'   FONT LOADING AND STORAGE STUFF
'-------------------------------------------------------------------------------

    DECLARE SUB I_LOADFONT()    
    DIM SHARED I_FONT_COLOURS ( 256 ) AS INTEGER
    DIM SHARED I_FONT_BUFFER  ( I_FONTX * I_FONTY ) AS INTEGER     
    DIM SHARED AS UINTEGER BUFFER ( XRES * YRES )
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

    DIM SHARED AS STRING intro_SCT
    DIM SHARED AS INTEGER I_TP1=1
    DIM SHARED AS DOUBLE I_SCP=0
    DIM SHARED AS DOUBLE I_SPAUSE=0
    DIM SHARED AS UINTEGER I_SONG_SEL=1
    intro_SCT="                                                        "
    
    DIM SHARED AS UINTEGER I_SINETABLE_A(XRES):' TOP ONE
    DIM SHARED AS UINTEGER I_SINETABLE_B(XRES):' REFLECTION
    DIM SHARED AS DOUBLE I_TIME,I_OLD,I_DELTA
    DIM SHARED AS STRING I_TITLES(9)
    I_TITLES(1)="***********************"
    I_TITLES(2)="*THE GAME SCENE CHARTS*"
    I_TITLES(3)="***********************"
    I_TITLES(4)=""
    I_TITLES(5)="issue number 31"
    I_TITLES(6)="Released on"
    I_TITLES(7)="00-00-0000"
    I_TITLES(8)=""
    I_TITLES(9)="= TRY F01 TO F12 ="


    intro_SCT=intro_SCT+"a     ** WELCOME **        ---------------------------------------------- "
    intro_SCT=intro_SCT+"aTHE GAME SCENE CHART 31 "    
    intro_SCT=intro_SCT+" ------------------ RELEASED BY THE GAME SCENE CHARTS STAFF ------------------ "
    intro_SCT=intro_SCT+"INTRO CREDITS ----- MUSIC BY: "
    intro_SCT=intro_SCT+"a     *ROB HUBBARD!*      "   
    intro_SCT=intro_SCT+"PROGRAMMING BY: "
    intro_SCT=intro_SCT+"a      *WIDOWMAKER*       "   
    intro_SCT=intro_SCT+"SID REPLAY ROUTINE BY: "
    intro_SCT=intro_SCT+"a     *STORMBRINGER*      "   

    intro_SCT=intro_SCT+" PLEASE PRESS THE -LEFT MOUSE- BUTTON OR -ESCAPE- TO BEGIN   ----   WE HOPE YOU ENJOY IT   "
    intro_SCT=intro_SCT+"   *******************************************************"
    

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
'   SET UP THE SCREEN.
'-------------------------------------------------------------------------------
  
   
    PTC_ALLOWCLOSE(0)
    PTC_SETDIALOG(1,"THE GAME SCENE CHARTS PREVIEW"+CHR$(13)+"FULL SCREEN?",0,1)               
    IF (PTC_OPEN("CODED BY ?! :-)",XRES,YRES)=0) THEN
    END-1
    END IF    
    DIM SHARED AS INTEGER PHIDE
    PHIDE=SHOWCURSOR(0)
    
        
    I_PREPSTARS()
    SLEEP 150
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
    I_DECRUNCH2()
    SLEEP 10
    EXITPROCESS(0)
END

 
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
TIMING=TIMER+1
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
    sid_sound_server_replay_init(@rh1(0), 4094, 0)
    sid_sound_server_replay_play()
    CASE 2
    sid_sound_server_replay_init(@rh2(0), 7614, 1)
    sid_sound_server_replay_play()    
    CASE 3
    sid_sound_server_replay_init(@rh3(0), 4478, 0)
    sid_sound_server_replay_play()
    CASE 4
    sid_sound_server_replay_init(@rh4(0), 5246, 11)
    sid_sound_server_replay_play()    
    CASE 5
    sid_sound_server_replay_init(@rh5(0), 4734, 0)
    sid_sound_server_replay_play()    
    CASE 6
    sid_sound_server_replay_init(@rh6(0), 4222, 0)
    sid_sound_server_replay_play()    
    CASE 7
    sid_sound_server_replay_init(@rh7(0), 5544, 0)
    sid_sound_server_replay_play()    
    CASE 8
    sid_sound_server_replay_init(@rh8(0), 4771, 0)
    sid_sound_server_replay_play()    
    CASE 9
    sid_sound_server_replay_init(@rh9(0), 3454, 0)
    sid_sound_server_replay_play()    
    CASE 10
    sid_sound_server_replay_init(@rh10(0), 8062, 0)
    sid_sound_server_replay_play()    
    CASE 11
    sid_sound_server_replay_init(@rh11(0), 3251, 0)
    sid_sound_server_replay_play()
    CASE 12
    sid_sound_server_replay_init(@rh6(0), 4222, 1)
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



