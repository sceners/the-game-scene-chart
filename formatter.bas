
'-------------------------------------------------------------------------------
' INCLUDE LIBRARIES
'-------------------------------------------------------------------------------

    #INCLUDE "TINYPTC_EXT.BI"
    #INCLUDE "WINDOWS.BI"

'-------------------------------------------------------------------------------
'   FONT:
'-------------------------------------------------------------------------------

    #INCLUDE "mag_gfx/font8craw.bas"
    #INCLUDE "mag_gfx/font8cpal.bas"
    
'-------------------------------------------------------------------------------
'   FIXED ARRAYS VARIABLES MUST ALL BE DECLARED.
'-------------------------------------------------------------------------------

    OPTION STATIC
    OPTION EXPLICIT
    
    CONST XRES=800
    CONST YRES=600
    
'-------------------------------------------------------------------------------
'   Colour Palette
'   BRIGHT 0  o  . 
'-------------------------------------------------------------------------------

'   WHITE  1  2  3   
'   RED    4  5  6
'   GREEN  7  8  9
'   BLUE   10 11 12
'   YELLOW 13 14 15
'   CYAN   16 17 18
'   PURPLE 19 20 21

'-------------------------------------------------------------------------------

    DIM SHARED AS INTEGER FONT_SW = 2048: '             FONT SCREEN WIDTH.
    DIM SHARED AS INTEGER FONT_SH = 28:'                FONT SCREEN HEIGHT.
    DIM SHARED AS INTEGER FONT_PAL(256 , 30):'          256 COLOURS , 27 HUES.
    DIM SHARED AS INTEGER FONT_DAT(FONT_SW * FONT_SH):' FONT DATA STORAGE.
    
    DECLARE SUB DRAWBREAK(BYVAL YP AS INTEGER,BYVAL XP AS INTEGER,BYVAL WD AS INTEGER, BYVAL BS AS INTEGER)
    DECLARE SUB LOADFONT()
    DECLARE SUB TEXT(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DECLARE SUB TXTL(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    LOADFONT()


'-------------------------------------------------------------------------------
'   MOUSE CONTROL:
'-------------------------------------------------------------------------------

    DIM SHARED AS INTEGER MOUSEX,MOUSEY,PHIDE,MOUSEL,MOUSER
        
'-------------------------------------------------------------------------------
'   LAYOUT:
'-------------------------------------------------------------------------------

    DECLARE SUB DRAW_LAYOUT()

'-------------------------------------------------------------------------------
'   MENU CONTROL:
'-------------------------------------------------------------------------------

    DECLARE SUB PROCESS_MENU()
    DIM SHARED AS DOUBLE CLICKTIME
    CLICKTIME=TIMER
'-------------------------------------------------------------------------------

    DECLARE SUB BOX(BYVAL BX1 AS INTEGER, BYVAL BY1 AS INTEGER, BYVAL BW1 AS INTEGER, BYVAL BH1 AS INTEGER, BYVAL BXC AS INTEGER)
    DECLARE SUB READMOUSE()
    
    DECLARE SUB DRAWPOINTER(BYVAL PX AS INTEGER ,BYVAL PY AS INTEGER)
    
    DIM SHARED AS UINTEGER MPOINTER ( 9 * 9 )
    DIM Q AS INTEGER
    
    FOR Q=0 TO 9*9
        READ MPOINTER(Q)
    NEXT
    
    
'-------------------------------------------------------------------------------
' PAGE DEFINITIONS AND INCLUSIONS;
'-------------------------------------------------------------------------------

    DIM SHARED AS INTEGER LINES,PAGES
    
    LINES=5000
    PAGES=20
    
    DIM SHARED AS STRING TEXT_LINE(LINES,PAGES)' <- HOLDS THE LETTERS.
    DIM SHARED AS STRING TEMP_LINE(LINES,PAGES)' <- HOLDS THE LETTERS.
    DIM SHARED AS STRING  COL_LINE(LINES,PAGES)' <- HOLDS THE COLOURMAP.
    DIM SHARED AS STRING FONT_LINE(LINES,PAGES)' <- HOLDS THE TEXT STYLE.
    DIM SHARED AS STRING PAGE_LINE(LINES,PAGES)' <- HOLDS PAGEBREAKS.

'-------------------------------------------------------------------------------
' INCLUDE THE CONVERTED PAGES.
'-------------------------------------------------------------------------------

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
    DECLARE SUB GENERATE_FILE(BYVAL FILEOUT AS STRING, BYVAL TICK AS INTEGER, BYVAL N AS INTEGER)
    
    
'-------------------------------------------------------------------------------
' STATE MACHINE VARIABLES;
'-------------------------------------------------------------------------------

   DIM SHARED AS INTEGER SCROLL_POS = 0 :' POSITION IN TEXT FILE.
   DIM SHARED AS INTEGER MAX_LINES  = 0 :' HOW MANY LINES IN PAGE?

   DIM SHARED AS INTEGER PAGE_NUMBER= 1 :' 
   DIM SHARED AS INTEGER FONT_NUMBER= 2 :' 1 OR 2
   DIM SHARED AS INTEGER TEXT_COLOUR= 1 :' 1 TO 21
   DIM SHARED AS INTEGER PAGE_BREAK = 1 :' 1 TO 10   
   DIM SHARED AS INTEGER FORMAT_MODE= 1 :' 1=LETTER  2=WORD 
                                         ' 3=LINE    4=LEFT 
                                         ' 5=RIGHT
                                         
   DIM SHARED AS INTEGER GX,GY          :' Mouse Pos On Grid.
  
   DIM SHARED AS DOUBLE NEWMOUSEWHEEL,OLDMOUSEWHEEL
   NEWMOUSEWHEEL=0
   OLDMOUSEWHEEL=0


'-------------------------------------------------------------------------------    
'   TEXT DISPLAY CONTROL.
'-------------------------------------------------------------------------------

    DECLARE SUB DRAW_PAGE (BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB PROCESS_PAGE(BYVAL PGNUM AS INTEGER)
    DECLARE SUB FIND_GRID_POS()
    DECLARE SUB HANDLE_PAGEBREAKS(BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB HANDLE_PAGEROTATE(BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB HANDLE_JLINE(BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB DRAW_BREAKS(BYVAL PAGE_OFFSET AS INTEGER)
    DECLARE SUB JUSTIFY_LINE(BYVAL LNM AS INTEGER ,BYVAL PGE AS INTEGER )
    DECLARE SUB FORMAT_WHOLE()
    
    DECLARE SUB DRAW_GUIDES()
    
'-------------------------------------------------------------------------------    
'   SCREEN SETUP;    
'-------------------------------------------------------------------------------
    
    DIM SHARED AS UINTEGER BUFFER ( XRES * YRES )
    
    PTC_ALLOWCLOSE(0)
    PTC_SETDIALOG(0,"TEXT FORMATTER"+CHR$(13)+"FULL SCREEN?",0,0)               
    IF (PTC_OPEN("CODED BY ?! :-)",XRES,YRES)=0) THEN
    END-1
    END IF    

    PHIDE=SHOWCURSOR(0)
'-------------------------------------------------------------------------------
    DIM SHARED CYC AS INTEGER
    PROCESS_PAGE(1)
    DIM SHARED AS INTEGER KILLSTATE
    KILLSTATE=0
    DIM SHARED AS DOUBLE ROTATE_TIME 
    ROTATE_TIME=TIMER
WHILE(GETASYNCKEYSTATE(VK_ESCAPE)<> -32767 AND KILLSTATE=0)  
    
    CYC=CYC+1
    
            READMOUSE()
            IF MOUSEL<>0 AND TIMER>CLICKTIME THEN PROCESS_MENU()            
            DRAW_LAYOUT()            
'            DRAW_GUIDES()            
            DRAW_BREAKS(SCROLL_POS)                        
            DRAW_PAGE (SCROLL_POS)
            IF FONT_NUMBER<>1 AND FONT_NUMBER<>2 THEN FONT_NUMBER=1
            
            
            
            HANDLE_JLINE(SCROLL_POS)
            HANDLE_PAGEBREAKS(SCROLL_POS)
            IF TIMER>ROTATE_TIME THEN HANDLE_PAGEROTATE(SCROLL_POS)
            FIND_GRID_POS()
            DRAWPOINTER(MOUSEX,MOUSEY)
            
    PTC_UPDATE@BUFFER(0)
    SLEEP 1
    ERASE BUFFER
    
    'BERASE()

    
WEND

'-------------------------------------------------------------------------------
' SPIT OUT SOME TEMPORARY FILES AND QUIT;
'-------------------------------------------------------------------------------

GENERATE_FILE("w1.txt",0,1)
GENERATE_FILE("w2.txt",0,2)
GENERATE_FILE("w3.txt",0,3)
GENERATE_FILE("w4.txt",0,4)
GENERATE_FILE("w5.txt",0,5)
GENERATE_FILE("w6.txt",0,6)
GENERATE_FILE("w7.txt",0,7)
GENERATE_FILE("w8.txt",0,8)
GENERATE_FILE("w9.txt",0,9)
GENERATE_FILE("w10.txt",0,10)
GENERATE_FILE("w11.txt",0,11)
GENERATE_FILE("w12.txt",0,12)
GENERATE_FILE("w13.txt",0,13)
GENERATE_FILE("w14.txt",0,14)
GENERATE_FILE("w15.txt",0,15)
GENERATE_FILE("w16.txt",0,16)
GENERATE_FILE("w17.txt",0,17)
GENERATE_FILE("w18.txt",0,18)
GENERATE_FILE("w19.txt",0,19)
GENERATE_FILE("w20.txt",0,20)

'-------------------------------------------------------------------------------
SLEEP 50

END
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------



SUB FORMAT_WHOLE()
    DIM AS INTEGER LOOP_X,LOOP_Y
    DIM AS STRING CS
    
    SELECT CASE TEXT_COLOUR
    CASE 1
        CS="1"
    CASE 2
        CS="2"
    CASE 3
        CS="3"
    CASE 4
        CS="4"
    CASE 5
        CS="5"
    CASE 6
        CS="6"
    CASE 7
        CS="7"
    CASE 8
        CS="8"
    CASE 9
        CS="9"
    CASE 10
        CS="A"
    CASE 11
        CS="B"
    CASE 12
        CS="C"
    CASE 13
        CS="D"
    CASE 14
        CS="E"
    CASE 15
        CS="F"
    CASE 16
        CS="G"
    CASE 17
        CS="H"
    CASE 18
        CS="I"
    CASE 19
        CS="J"
    CASE 20
        CS="K"
    CASE 21
        CS="L"
    CASE 22
        CS="M"
    CASE 23
        CS="N"
    CASE 24
        CS="O"
    CASE 25
        CS="P"
    CASE 26
        CS="Q"
    CASE 27
        CS="R"
    CASE 28
        CS="S"
    CASE 29
        CS="T"
    CASE 30
        CS="U"
    END SELECT
    
    

    FOR LOOP_Y=0 TO MAX_LINES-1
        FOR LOOP_X=0 TO LEN(TEXT_LINE(LOOP_Y,PAGE_NUMBER))
            
            MID(FONT_LINE(LOOP_Y,PAGE_NUMBER),LOOP_X,1)=STR(FONT_NUMBER)
            MID(COL_LINE(LOOP_Y,PAGE_NUMBER),LOOP_X,1)=CS
            
        NEXT
    NEXT    
    
END SUB




SUB HANDLE_PAGEROTATE(BYVAL PAGE_OFFSET AS INTEGER)
    
        DIM GY AS INTEGER    
        DIM RL AS INTEGER
        DIM TEMPSHIFT(80)  AS STRING
        DIM TEMPHOLDER AS STRING
        
IF MOUSEX>35 AND MOUSEX<45 AND MOUSEY>160 AND MOUSEY<600 THEN
        GY=(INT((MOUSEY-160)/12))
        IF MOUSEL<>0 AND GY+PAGE_OFFSET< MAX_LINES THEN                    
        FOR RL=0 TO 79
            TEMPSHIFT(RL)=" "
            TEMPSHIFT(RL)=MID(TEXT_LINE(GY+PAGE_OFFSET,PAGE_NUMBER),RL+1,1)
            IF TEMPSHIFT(RL)="" THEN TEMPSHIFT(RL)=" "
        NEXT
'       KILL CURRENT ARRAY ELEMENT;            
        TEXT_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)=TEMPSHIFT(79)
        FOR RL=0 TO 79
            TEXT_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)=TEXT_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)+TEMPSHIFT(rl)
            
        NEXT
        ROTATE_TIME=TIMER+.05
        END IF

END IF
END SUB






'
' DRAW SOME PAGE GUIDES SO THAT THE MIDDLE OF THE PAGE IS MORE EASILY VISIBLE.
'
SUB DRAW_GUIDES()
    BOX (44,160,720,430,&H66AAFF)
    BOX (44,160,351,430,&H66AAFF)
    BOX (44,160,369,430,&H66AAFF)
END SUB




SUB HANDLE_JLINE(BYVAL PAGE_OFFSET AS INTEGER)
        DIM GY AS INTEGER    
IF MOUSEX>770 AND MOUSEX<800 AND MOUSEY>160 AND MOUSEY<600 THEN
        GY=(INT((MOUSEY-160)/12))
        
        IF MOUSEL<>0 THEN
            JUSTIFY_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)        
        END IF
        IF MOUSER<>0 THEN
                TEXT_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)=TEMP_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)
        END IF


END IF
END SUB



SUB JUSTIFY_LINE(BYVAL LNM AS INTEGER ,BYVAL PGE AS INTEGER )
DIM AS STRING TEMPWORK,BUILDIT,BUILDIT2
DIM AS INTEGER X,SPACES,WORDS,ONWORD,CSTAT,ADDON,PADDING,SPACEY
TEMPWORK=TEXT_LINE(LNM,PAGE_NUMBER)
CSTAT=0
ONWORD=0
FOR X=1 TO LEN(TEMPWORK)
    ADDON=0
    IF MID(TEMPWORK,X,1)<>" " THEN 
        ONWORD=1
        ADDON=1
    END IF    
    
    IF CSTAT<>1 AND ONWORD=1 THEN 
        CSTAT=1
        WORDS=WORDS+1
    END IF
    IF CSTAT<>2 AND MID(TEMPWORK,X,1)=" " THEN 
        ADDON=1
    END IF
    IF MID(TEMPWORK,X,1)=" " THEN 
        ONWORD=0
        CSTAT=2
    END IF
    IF ADDON=1 THEN BUILDIT=BUILDIT+MID(TEMPWORK,X,1)
NEXT
'-------------------------------------------------------------------
' ADD A BLANK SPACE AT THE BEGINNING IF THERE IS SPACE TO DO SO;
'-------------------------------------------------------------------
IF MID(BUILDIT,1,1)<>" " AND LEN(BUILDIT) <=79 THEN 
    BUILDIT2=" "+BUILDIT
    BUILDIT=BUILDIT2
END IF
'
' HOW MANY SPACES LEFT NEEDED TO FILL THE LINE?
'
PADDING=(79-LEN(BUILDIT))
'
' IF IT'S LESS THAN THE THRESHHOLD THEN WE CAN PAD THE STRING;
'

IF PADDING<20 AND WORDS>1 THEN
DIM SPADD AS INTEGER
DIM ZZ AS INTEGER
IF WORDS>1 THEN
SPADD=(PADDING/(WORDS-1))
BUILDIT2=""

ONWORD=0
FOR X=1 TO LEN(BUILDIT)
    BUILDIT2=BUILDIT2+MID(BUILDIT,X,1)    
    IF X>1 AND MID(BUILDIT,X,1)=" " THEN
        'FOR ZZ=1 TO SPADD
        IF PADDING>0 THEN 
            BUILDIT2=BUILDIT2+" "
            PADDING=PADDING-1
        END IF
        'NEXT
    END IF
    
NEXT

END IF
    BUILDIT=BUILDIT2
END IF

'    DRAW_TEXT(0,0,STR(WORDS),0,XRES,0,YRES,2)

    TEXT_LINE(LNM,PAGE_NUMBER)=BUILDIT
'    CURRENT(LNM)=BUILDIT
'    SELECTIONS(LNM,PGE)=BUILDIT
END SUB


SUB HANDLE_PAGEBREAKS(BYVAL PAGE_OFFSET AS INTEGER)
        DIM GY AS INTEGER    
IF MOUSEX>0 AND MOUSEX<32 AND MOUSEY>160 AND MOUSEY<600 THEN
        GY=(INT((MOUSEY-160)/12))
        
        IF MOUSEL<>0 THEN
                PAGE_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)=STR(PAGE_BREAK)            
        END IF
        IF MOUSER<>0 THEN
                PAGE_LINE(GY+PAGE_OFFSET,PAGE_NUMBER)="0"            
        END IF


END IF
END SUB


SUB DRAW_BREAKS(BYVAL PAGE_OFFSET AS INTEGER)
DIM AS INTEGER Y,PY
PY=160

FOR Y=0 TO 35
    'IF PAGE_LINE(Y+PAGE_OFFSET,PAGE_NUMBER) <> 0 THEN
    DRAWBREAK(PY+6,45,719,VAL(PAGE_LINE(Y+PAGE_OFFSET,PAGE_NUMBER)))
    'END IF
    PY=PY+12
    
    
NEXT


END SUB










SUB FIND_GRID_POS()   
    DIM TC AS INTEGER
    
    
    DIM AS INTEGER LP,RP:' HOLD LEFT AND RIGHT FOR "WORD" MODE
    DIM AS INTEGER GX2,GY2
    DIM AS STRING CS
    
    SELECT CASE TEXT_COLOUR
    CASE 1
        CS="1"
    CASE 2
        CS="2"
    CASE 3
        CS="3"
    CASE 4
        CS="4"
    CASE 5
        CS="5"
    CASE 6
        CS="6"
    CASE 7
        CS="7"
    CASE 8
        CS="8"
    CASE 9
        CS="9"
    CASE 10
        CS="A"
    CASE 11
        CS="B"
    CASE 12
        CS="C"
    CASE 13
        CS="D"
    CASE 14
        CS="E"
    CASE 15
        CS="F"
    CASE 16
        CS="G"
    CASE 17
        CS="H"
    CASE 18
        CS="I"
    CASE 19
        CS="J"
    CASE 20
        CS="K"
    CASE 21
        CS="L"
    CASE 22
        CS="M"
    CASE 23
        CS="N"
    CASE 24
        CS="O"
    CASE 25
        CS="P"
    CASE 26
        CS="Q"
    CASE 27
        CS="R"
    CASE 28
        CS="S"
    CASE 29
        CS="T"
    CASE 30
        CS="U"
    END SELECT
        
        
    
    TC=RGB(125+124*SIN(CYC*.12), 125+124*SIN(CYC*.12),125+124*SIN(CYC*.12))
    IF MOUSEX>45 AND MOUSEX<765 AND MOUSEY>160 AND MOUSEY<595 THEN
        BOX(32,155,736,439,&H0000FF)

        GX=(INT((MOUSEX-35)/9))
        GY=(INT((MOUSEY-160)/12))

        GX2=(INT((MOUSEX-35)/9)*9)+35
        GY2=(INT((MOUSEY-160)/12)*12)+160

        '-----------------------------------------------------------------------
        ' GRAB
        '-----------------------------------------------------------------------

            DIM CG AS STRING
            IF MOUSER<>0 THEN
            FONT_NUMBER = VAL(MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1))
            PAGE_BREAK= VAL(PAGE_LINE(GY+SCROLL_POS,PAGE_NUMBER))

            CG=(MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1))                        
            SELECT CASE CG
            CASE "1"
                TEXT_COLOUR=1
            CASE "2"
                TEXT_COLOUR=2
            CASE "3"
                TEXT_COLOUR=3
            CASE "4"
                TEXT_COLOUR=4
            CASE "5"
                TEXT_COLOUR=5
            CASE "6"
                TEXT_COLOUR=6
            CASE "7"
                TEXT_COLOUR=7
            CASE "8"
                TEXT_COLOUR=8
            CASE "9"
                TEXT_COLOUR=9
            CASE "A"
                TEXT_COLOUR=10
            CASE "B"
                TEXT_COLOUR=11
            CASE "C"
                TEXT_COLOUR=12
            CASE "D"
                TEXT_COLOUR=13
            CASE "E"
                TEXT_COLOUR=14
            CASE "F"
                TEXT_COLOUR=15
            CASE "G"
                TEXT_COLOUR=16
            CASE "H"
                TEXT_COLOUR=17
            CASE "I"
                TEXT_COLOUR=18
            CASE "J"
                TEXT_COLOUR=19
            CASE "K"
                TEXT_COLOUR=20
            CASE "L"
                TEXT_COLOUR=21
            CASE "M"
                TEXT_COLOUR=22
            CASE "N"
                TEXT_COLOUR=23
            CASE "O"
                TEXT_COLOUR=24
            CASE "P"
                TEXT_COLOUR=25
            CASE "Q"
                TEXT_COLOUR=26
            CASE "R"
                TEXT_COLOUR=27
            CASE "S"
                TEXT_COLOUR=28
            CASE "T"
                TEXT_COLOUR=29
            CASE "U"
                TEXT_COLOUR=30
            END SELECT


            END IF
        
        

        '-----------------------------------------------------------------------
        ' LETTER
        '-----------------------------------------------------------------------
        
        IF FORMAT_MODE=1 THEN
            IF MOUSEL<>0 THEN
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1)=CS
            END IF
        BOX(GX2,GY2,9,12,TC)
        END IF
        
        '-----------------------------------------------------------------------
        ' WORD
        '-----------------------------------------------------------------------
        
        IF FORMAT_MODE=2 THEN
                
        IF MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1) <> "" THEN

        LP=GX
        WHILE MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1) <> "" AND LP>0

        IF MOUSEL<>0 THEN
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=CS
        END IF
        
        LP=LP-1        
        WEND
    
    
        RP=GX
        WHILE MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1) <> "" AND RP<81

        IF MOUSEL<>0 THEN
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1)=CS
        END IF

        RP=RP+1
        WEND
        
        
        GX2=((LP+1)*9)+35
        
        
        BOX(GX2,GY2,9*((RP-LP)-1),12,TC)
        END IF
        
        
        END IF



        '-----------------------------------------------------------------------
        ' LINE
        '-----------------------------------------------------------------------
        
        IF FORMAT_MODE=3 THEN
            GX2=45
            IF MOUSEL<>0 THEN
            FOR LP=0 TO 80
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=CS
            NEXT
            END IF
        BOX(GX2,GY2,80*9,12,TC)
        END IF


        '-----------------------------------------------------------------------
        ' LEFT
        '-----------------------------------------------------------------------
        
        IF FORMAT_MODE=4 THEN
            GX2=35
            IF MOUSEL<>0 THEN
            FOR LP=0 TO GX
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=CS
            NEXT
            END IF
        BOX(GX2,GY2,(GX+1)*9,12,TC)
        END IF

        '-----------------------------------------------------------------------
        ' RIGHT
        '-----------------------------------------------------------------------
        
        IF FORMAT_MODE=5 THEN
            GX2=(81-GX)*9
            IF MOUSEL<>0 THEN
            FOR LP=GX TO 80
            MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=STR(FONT_NUMBER)
            MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=CS
            NEXT
            END IF
        BOX((GX+4)*9,GY2,GX2,12,TC)
        END IF

        '-----------------------------------------------------------------------
        ' CLONE LINE
        '-----------------------------------------------------------------------

        IF FORMAT_MODE=6 THEN
            DIM GRABBER AS STRING
            DIM THROUGH AS INTEGER
            GX2=45
            IF MOUSEL<>0 THEN
                            GRABBER=TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER)            
            FOR THROUGH=0 TO MAX_LINES
                
                
                IF THROUGH<>GY+SCROLL_POS THEN                    
                    IF TEXT_LINE(THROUGH,PAGE_NUMBER) = GRABBER THEN                        
                       FONT_LINE(THROUGH,PAGE_NUMBER) = FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER)
                        COL_LINE(THROUGH,PAGE_NUMBER) = COL_LINE(GY+SCROLL_POS,PAGE_NUMBER)
                        
                    END IF                    
                END IF                        
                
            NEXT                 
            END IF
        BOX(GX2,GY2,80*9,12,TC)
        END IF

        '-----------------------------------------------------------------------
        ' CLONE WORD
        '-----------------------------------------------------------------------
        
        
        
        IF FORMAT_MODE=7 THEN
        DIM AS INTEGER L_OFFSET,W_WIDTH :'LEFT OFFSET WORD WIDTH
        DIM AS STRING WORD_STORE
        DIM AS INTEGER ZAPEM
        ZAPEM=0

        IF MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),GX,1) <> "" THEN
        LP=GX
        WHILE MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1) <> "" AND LP>0

            IF MOUSEL<>0 THEN
                ZAPEM=1
                'MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=STR(FONT_NUMBER)
                'MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),LP,1)=CS
            END IF        
            LP=LP-1        
            
        WEND
        
        RP=GX
        
        WHILE MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1) <> " " AND MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1) <> "" AND RP<81

            IF MOUSEL<>0 THEN
            ZAPEM=1
                'MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1)=STR(FONT_NUMBER)
                'MID(COL_LINE(GY+SCROLL_POS,PAGE_NUMBER),RP,1)=CS
            
            END IF

        RP=RP+1
        
        WEND
        
        
        GX2=((LP+1)*9)+35
        
        
        BOX(GX2,GY2,9*((RP-LP)-1),12,TC)
        
        '-----------------------------------------------------------------------
        ' REPLACE FORMATTING OF ALL WORD!
        '-----------------------------------------------------------------------
        
    '===================================================================
    IF ZAPEM<>0 THEN
        
            DIM AS INTEGER LOOP_Y,LOOP_X
            L_OFFSET=LP+1
            W_WIDTH=(RP-LP)-1
            WORD_STORE=UCASE(MID(TEXT_LINE(GY+SCROLL_POS,PAGE_NUMBER),L_OFFSET,W_WIDTH))
            
            
        
        FOR LOOP_Y=0 TO MAX_LINES                    
        FOR LOOP_X=0 TO 80                       
        IF UCASE (MID(TEXT_LINE(LOOP_Y,PAGE_NUMBER),LOOP_X,W_WIDTH))=WORD_STORE THEN
                           
MID(FONT_LINE(LOOP_Y,PAGE_NUMBER),LOOP_X,W_WIDTH)=MID(FONT_LINE(GY+SCROLL_POS,PAGE_NUMBER),L_OFFSET,W_WIDTH)
MID(COL_LINE (LOOP_Y,PAGE_NUMBER),LOOP_X,W_WIDTH)=MID(COL_LINE (GY+SCROLL_POS,PAGE_NUMBER),L_OFFSET,W_WIDTH)
                                         
         END IF
                       
        NEXT                    
        NEXT
        
        
    END IF
    '===================================================================
        
        END IF
        END IF


        
        
    ELSE
        BOX(32,155,736,439,&H000044)
    END IF        
END SUB

SUB PROCESS_PAGE(BYVAL PGNUM AS INTEGER)
    DIM Y AS INTEGER
    MAX_LINES=5000
    
    FOR Y=0 TO 4999     
        TEMP_LINE(Y,PGNUM)=TEXT_LINE(Y,PGNUM)
        IF MID(TEXT_LINE(Y,PGNUM),1,5 )="<END>"THEN        
        MAX_LINES=Y
        END IF
    
    NEXT
    
END SUB

'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------

SUB DRAW_PAGE (BYVAL PAGE_OFFSET AS INTEGER)
DIM AS INTEGER Y,PY,X,TV,CV
DIM CG AS STRING

    PY=160
    
    FOR Y=0 TO 35    
        FOR X=1 TO 80
            TV=VAL(MID(FONT_LINE(Y+PAGE_OFFSET,PAGE_NUMBER),X,1))
            CG=(MID(COL_LINE(Y+PAGE_OFFSET,PAGE_NUMBER),X,1))                        
            SELECT CASE CG
            CASE "1"
                CV=1
            CASE "2"
                CV=2
            CASE "3"
                CV=3
            CASE "4"
                CV=4
            CASE "5"
                CV=5
            CASE "6"
                CV=6
            CASE "7"
                CV=7
            CASE "8"
                CV=8
            CASE "9"
                CV=9
            CASE "A"
                CV=10
            CASE "B"
                CV=11
            CASE "C"
                CV=12
            CASE "D"
                CV=13
            CASE "E"
                CV=14
            CASE "F"
                CV=15
            CASE "G"
                CV=16
            CASE "H"
                CV=17
            CASE "I"
                CV=18
            CASE "J"
                CV=19
            CASE "K"
                CV=20
            CASE "L"
                CV=21
            CASE "M"
                CV=22
            CASE "N"
                CV=23
            CASE "O"
                CV=24
            CASE "P"
                CV=25
            CASE "Q"
                CV=26
            CASE "R"
                CV=27
            CASE "S"
                CV=28
            CASE "T"
                CV=29
            CASE "U"
                CV=30
            END SELECT
                
        IF Y+PAGE_OFFSET<MAX_LINES THEN TXTL (MID(TEXT_LINE(Y+PAGE_OFFSET,PAGE_NUMBER),X,1),45+((X-1)*9),PY,TV,CV)        
    NEXT
    
        PY=PY+12        
    NEXT
    
END SUB

'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------

SUB READMOUSE()

    OLDMOUSEWHEEL=NEWMOUSEWHEEL
    NEWMOUSEWHEEL=PTC_GETMOUSEWHEEL()

    IF NEWMOUSEWHEEL<OLDMOUSEWHEEL AND SCROLL_POS<MAX_LINES-33 THEN
        SCROLL_POS=SCROLL_POS+INT((OLDMOUSEWHEEL-NEWMOUSEWHEEL)*4)
        IF SCROLL_POS>=MAX_LINES-33 THEN SCROLL_POS=MAX_LINES-33
        
    END IF

    IF NEWMOUSEWHEEL>OLDMOUSEWHEEL AND SCROLL_POS>0 THEN
        SCROLL_POS=SCROLL_POS-INT((NEWMOUSEWHEEL-OLDMOUSEWHEEL)*4)
        IF SCROLL_POS<0 THEN SCROLL_POS=0
    END IF

    IF (GETASYNCKEYSTATE(VK_DOWN)<> -32767) THEN
        SCROLL_POS=SCROLL_POS-1
        IF SCROLL_POS<=0 THEN SCROLL_POS=0
    END IF

    IF (GETASYNCKEYSTATE(VK_UP)<> -32767) THEN
        SCROLL_POS = SCROLL_POS+1
        IF SCROLL_POS+36 > MAX_LINES THEN SCROLL_POS = SCROLL_POS-1
        
    END IF


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
        IF SCROLL_POS<MAX_LINES-33 THEN
                SCROLL_POS=SCROLL_POS+33
                IF SCROLL_POS>MAX_LINES-33  THEN SCROLL_POS=MAX_LINES-33
        END IF        
    END IF


    MOUSEX=PTC_GETMOUSEX()
    MOUSEY=PTC_GETMOUSEY()
    MOUSEL=PTC_GETLEFTBUTTON()
    MOUSER=PTC_GETRIGHTBUTTON()

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
            TC=RGB(125+124*SIN((CYC+X)*.02),125+124*SIN((CYC+X+80)*.02),125+124*SIN((CYC+X+190)*.02))
            *PP=TC
            TC=RGB(65+64*SIN((CYC+X)*.02),65+64*SIN((CYC+X+80)*.02),65+64*SIN((CYC+X+190)*.02))
            *PP2=TC
            *PP3=TC
            PP+=1
            PP2+=1
            PP3+=1
        NEXT
        
    END SELECT
    
END SUB    

'-------------------------------------------------------------------------------
'   SCREEN CLEAR ROUTINE.
'-------------------------------------------------------------------------------

SUB BOX(BYVAL BX1 AS INTEGER, BYVAL BY1 AS INTEGER, BYVAL BW1 AS INTEGER, BYVAL BH1 AS INTEGER, BYVAL BXC AS INTEGER)
    DIM AS INTEGER TC,Y,SLICE
    DIM AS UINTEGER PTR PP
       
    PP = @BUFFER((BY1*XRES)+BX1)   
    SLICE=BW1
    asm
        mov eax,dword ptr[BXC]
        mov ecx, [slice]
        mov edi, [PP]
        rep stosd
    end asm    

    PP = @BUFFER(((BY1+BH1)*XRES)+BX1)   
    SLICE=BW1
    asm
        mov eax,dword ptr[BXC]
        mov ecx, [slice]
        mov edi, [PP]
        rep stosd
    end asm    

    PP = @BUFFER((BY1*XRES)+BX1)   
    FOR Y=0 TO BH1
        *PP=BXC
    PP+=XRES
    NEXT

    PP = @BUFFER((BY1*XRES)+BX1+BW1)   
    FOR Y=0 TO BH1
        *PP=BXC
    PP+=XRES
    NEXT

END SUB

'-------------------------------------------------------------------------------
'   DRAW THE MOUSE POINTER.
'-------------------------------------------------------------------------------

SUB DRAWPOINTER(BYVAL PX AS INTEGER ,BYVAL PY AS INTEGER)
    DIM AS INTEGER XX,YY,TX,QQ
    
    FOR YY=0 TO 8
    TX=PX
        IF PY>=0 AND PY<YRES THEN
        
            FOR XX=0 TO 8
                QQ=MPOINTER ((YY*9)+XX)
                IF TX>0 AND TX<XRES AND QQ>0 THEN                
                BUFFER(TX+(PY*XRES))=&H444455*QQ
                END IF
            TX=TX+1
            NEXT
        END IF
    
    PY=PY+1
    
    NEXT

END SUB



'-------------------------------------------------------------------------------
'  DRAW A STRING OF TEXT. STRING,STARTX,STARTY,FONT(1 OR 2),COLOUR NUMBER.
'-------------------------------------------------------------------------------

SUB TXTL(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)
    DIM AS INTEGER XX,YY,L
    DIM AS STRING TT
    
    XX=XP
    YY=YP
    
    FOR L=1 TO LEN(TS)
        
        TEXT(MID(TS,L,1),XX,YY,FT,TC )
        XX=XX+9
        
    NEXT

END SUB


SUB TEXT(BYVAL TS AS STRING , BYVAL XP AS INTEGER , BYVAL YP AS INTEGER , BYVAL FT AS INTEGER , BYVAL TC AS INTEGER)

'-------------------------------------------------------------------------------
'   DRAWS ONE LETTER.
'   TEXT COMMAND. USAGE:
'   TEXT ( "A" , XPOS , YPOS , FONT (1 OR 2) , COLOUR (1 TO 21) ) EG:
'   TEXT ("A",100,100,1,10)
'-------------------------------------------------------------------------------


    DIM AS INTEGER YOFF,XOFF: ' YOFF CHANGES TO SELECT FONT, XOFF IS X OFFSET IN FONT
    DIM AS INTEGER CH       : ' ASCII VALUE
    DIM AS INTEGER LPX,LPY,CUNNIS
    DIM AS UINTEGER PTR PTX
    
    '---------------------------------------------------------------------------
    'IF STRING NOT EMPTY AND FONT VALID AND COLOUR VALID THEN PROCESS AND DRAW
    '---------------------------------------------------------------------------
    
    IF LEN(TS)>0 AND (FT>=1 AND FT<=2) AND (TC>=1 AND TC<=31) THEN
        
        IF FT=1 THEN YOFF=0
        IF FT=2 THEN YOFF=13
        
        CH=(ASC(MID(TS,1,1))-32)
        
        if CH>0 AND CH <FONT_SW THEN
        XOFF=(CH*9)+1
        
        FOR LPY=0 TO 12
            PTX=@BUFFER(XP+((YP+LPY)*XRES))
            FOR LPX=0 TO 8
                CUNNIS=FONT_DAT(xoff+LPX+((LPY+YOFF)*FONT_SW))
                IF CUNNIS>1 THEN
                *PTX=FONT_PAL(CUNNIS , TC )                
                END IF
                PTX+=1
            NEXT
        NEXT
        END IF
        
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


'-------------------------------------------------------------------------------
'   DRAW SCREEN LAYOUT.
'-------------------------------------------------------------------------------

SUB DRAW_LAYOUT()

DIM AS INTEGER PX,X,Y,PY

PY=160
FOR Y=0 TO 35
    if mousex>34 and mousex<44 and mousey>PY and mousey<py+12 then
    DRAW_GUIDES()
    TXTL (chr(174),34,PY,2,1)
    else
    TXTL (chr(174),34,PY,2,5)
    end if
    if mousex>5 and mousex<33 and mousey>PY and mousey<py+12 then
    TXTL ("BK>",5,PY,1,1)
    else
    TXTL ("BK>",5,PY,1,25)
    end if
    if mousex>770 and mousex<800 and mousey>PY and mousey<py+12 then
    TXTL ("<JY",770,PY,1,1)
    ELSE
    TXTL ("<JY",770,PY,1,25)
    END IF
    PY=PY+12
NEXT



PX=520
FOR X=1 TO 30
    TXTL ("?",PX,50,1,X)    
    TXTL ("?",PX,62,1,X)    
    TXTL ("?",PX,74,1,X)    
    TXTL ("?",PX,86,1,X)    
    TXTL ("?",PX,98,1,X)    
    TXTL ("?",PX,110,1,X)    
    PX=PX+9    
NEXT

TXTL ("QUIT + SAVE!",5,4,2,28)    
TXTL ("COLOUR PAGE!",686,4,2,28)    

TXTL ("<- PREV PAGE",  5,134,2,25)    
TXTL ("NEXT PAGE ->",686,134,2,25)    
TXTL ("USE ARROWS TO SCROLL, RIGHT CLICK TO GRAB ATTRIBUTE OR UNDO",135,134,2,1)    

TXTL ("THE GAME SCENE CHARTS TEXT FORMATTER - PLEASE DO NOT SPREAD",140,5,1,1)    

    TXTL ("NOW SELECTED:                            LEFT CLICK TO SELECT:",50,35,1,25)    
    TXTL ("      COLOUR:",10,50,1,28)    
    TXTL ("  PAGE BREAK:",10,65,1,28)    
    TXTL ("        MODE:",10,80,1,28)    
    TXTL ("        FONT:",10,95,1,28)    
    TXTL ("CURRENT PAGE:",10,110,1,28)      

    TXTL ("????????",130,50,1,TEXT_COLOUR) 

'
'PAGE BREAK HERE:
'
DRAWBREAK(70,130,72,PAGE_BREAK)

'TXTL ("--------",130,65,1,22)    

SELECT CASE FORMAT_MODE
    CASE 1
    TXTL ("LETTER",130,80,2,22)        
    CASE 2
    TXTL ("WORD",130,80,2,22)    
    CASE 3
    TXTL ("LINE",130,80,2,22)    
    CASE 4
    TXTL ("LEFT",130,80,2,22)    
    CASE 5
    TXTL ("RIGHT",130,80,2,22)    
    CASE 6
    TXTL ("CLONE LN",130,80,2,22)    
    CASE 7
    TXTL ("CLONE WD",130,80,2,22)    
    
    CASE ELSE
    TXTL ("!ERROR!",130,80,2,4)    
END SELECT
SELECT CASE FONT_NUMBER
    CASE 1
    TXTL ("FONT 1",130,95,1,22)    
    CASE 2
    TXTL ("FONT 2",130,95,2,22)    
    CASE ELSE
    TXTL ("!ERROR!",130,95,2,4)    
END SELECT

TXTL ("PAGE "+STR(PAGE_NUMBER),130,110,2,22)    

BOX(140,2,530,16,&HFF8833)
BOX(5,30,790,100,&HFFFFFF)
BOX(210,30,585,100,&HFFFFFF)
DRAWBREAK(150,0,799,8)


    TXTL ("-CLNE-",220,35,2,25)    
    TXTL ("-CWRD-",320,35,2,25)    
    
    
    TXTL ("-LTTR-",220,50,2,26)    
    TXTL ("-WORD-",220,65,2,25)    
    TXTL ("-LINE-",220,80,2,26)    
    TXTL ("-LEFT-",220,95,2,25)    
    TXTL ("-RIGT-",220,110,2,26)      

    TXTL ("FONT 1",320,50,1,26)    
    TXTL ("FONT 2",320,65,2,25)    
    DRAWBREAK(86,320,54,1)
    DRAWBREAK(101,320,54,2)
    DRAWBREAK(116,320,54,3)

    DRAWBREAK(56,420,54,4)
    DRAWBREAK(71,420,54,5)
    DRAWBREAK(86,420,54,6)
    DRAWBREAK(101,420,54,7)
    DRAWBREAK(116,420,54,8)


END SUB

'-------------------------------------------------------------------------------
' PROCESS THE MENU.. IE MAKE ALL THE BUTTONS AT THE TOP WORK.
'-------------------------------------------------------------------------------

SUB PROCESS_MENU()
    
 'QUIT AND SAVE
 IF MOUSEX>5 AND MOUSEX<110 AND MOUSEY>5 AND MOUSEY<17 THEN
     KILLSTATE=1
 END IF
 
 'QUIT NO SAVE
 IF MOUSEX>685 AND MOUSEX<790 AND MOUSEY>5 AND MOUSEY<17 THEN
     'KILLSTATE=1
     FORMAT_WHOLE()
 END IF
 
 'PREV PAGE
 IF MOUSEX>5 AND MOUSEX<110 AND MOUSEY>134 AND MOUSEY<146 THEN     
     PAGE_NUMBER=PAGE_NUMBER-1
     CLICKTIME=TIMER+.15
     IF PAGE_NUMBER<1 THEN PAGE_NUMBER=1    
     PROCESS_PAGE(PAGE_NUMBER)
     SCROLL_POS=0
 END IF 

 'NEXT PAGE
 IF MOUSEX>685 AND MOUSEX<790 AND MOUSEY>134 AND MOUSEY<146 THEN     
     PAGE_NUMBER=PAGE_NUMBER+1
     CLICKTIME=TIMER+.15
     IF PAGE_NUMBER>PAGES THEN PAGE_NUMBER=PAGES     
     PROCESS_PAGE(PAGE_NUMBER)
     SCROLL_POS=0
 END IF 

' TXTL ("NEXT PAGE ->",686,134,2,25)   

 'CLONE LINE
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>35 AND MOUSEY<47 THEN
     FORMAT_MODE=6
 END IF 
 'CLONE WORD
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>35 AND MOUSEY<47 THEN
     FORMAT_MODE=7
 END IF  
 'LETTER
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>50 AND MOUSEY<62 THEN
     FORMAT_MODE=1
 END IF
 'WORD
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>65 AND MOUSEY<77 THEN
     FORMAT_MODE=2
 END IF
 'LINE
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>80 AND MOUSEY<92 THEN
     FORMAT_MODE=3
 END IF
 'LEFT
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>95 AND MOUSEY<107 THEN
     FORMAT_MODE=4
 END IF
 'RIGHT
 IF MOUSEX>220 AND MOUSEX<275 AND MOUSEY>110 AND MOUSEY<122 THEN
     FORMAT_MODE=5
 END IF


 'FONT1
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>50 AND MOUSEY<62 THEN
     FONT_NUMBER=1
 END IF
 'FONT2
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>65 AND MOUSEY<77 THEN
     FONT_NUMBER=2
 END IF
 'BREAK1
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>80 AND MOUSEY<92 THEN
     PAGE_BREAK=1
 END IF
 'BREAK2
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>95 AND MOUSEY<107 THEN
     PAGE_BREAK=2
 END IF
 'BREAK3
 IF MOUSEX>320 AND MOUSEX<375 AND MOUSEY>110 AND MOUSEY<122 THEN
     PAGE_BREAK=3
 END IF


 'FONT1
 IF MOUSEX>420 AND MOUSEX<475 AND MOUSEY>50 AND MOUSEY<62 THEN
     PAGE_BREAK=4
 END IF
 'FONT2
 IF MOUSEX>420 AND MOUSEX<475 AND MOUSEY>65 AND MOUSEY<77 THEN
     PAGE_BREAK=5
 END IF
 'BREAK1
 IF MOUSEX>420 AND MOUSEX<475 AND MOUSEY>80 AND MOUSEY<92 THEN
     PAGE_BREAK=6
 END IF
 'BREAK2
 IF MOUSEX>420 AND MOUSEX<475 AND MOUSEY>95 AND MOUSEY<107 THEN
     PAGE_BREAK=7
 END IF
 'BREAK3
 IF MOUSEX>420 AND MOUSEX<475 AND MOUSEY>110 AND MOUSEY<122 THEN
     PAGE_BREAK=8
 END IF

 DIM AS INTEGER L,X
 
 X=520
 FOR L=1 TO 30
 IF MOUSEX>X AND MOUSEX<X+9 AND MOUSEY>50 AND MOUSEY<122 THEN
     TEXT_COLOUR=L
 END IF
 X=X+9
 NEXT



END SUB


SUB GENERATE_FILE(BYVAL FILEOUT AS STRING, BYVAL TICK AS INTEGER, BYVAL N AS INTEGER)
    DIM AS STRING BOLLOCKS(5000)
    DIM Y AS INTEGER
    TICK=4999    
    FOR Y=0 TO 4999     
        BOLLOCKS(Y)="TEXT_LINE("+STR(Y)+","+STR(N)+")"+"="+CHR$(34)+TEXT_LINE(Y,N)+CHR$(34)+":"+"COL_LINE("+STR(Y)+","+STR(N)+")"+"="+CHR$(34)+COL_LINE(Y,N)+CHR$(34)+":"+"FONT_LINE("+STR(Y)+","+STR(N)+")"+"="+CHR$(34)+FONT_LINE(Y,N)+CHR$(34)+":"+"PAGE_LINE("+STR(Y)+","+STR(N)+")"+"="+CHR$(34)+PAGE_LINE(Y,N)+CHR$(34)+" "+CHR$(13)+CHR$(10)
        

'        BOLLOCKS(TICK)="TEXT_LINE("+STR(TICK)+","+STR(N)+")"+"="+CHR$(34)+INPT+CHR$(34)+":"+"COL_LINE("+STR(TICK)+","+STR(N)+")"+"="+CHR$(34)+"11111111111111111111111111111111111111111111111111111111111111111111111111111111"+CHR$(34)+":"+"FONT_LINE("+STR(TICK)+","+STR(N)+")"+"="+CHR$(34)+"11111111111111111111111111111111111111111111111111111111111111111111111111111111"+CHR$(34)+":"+"PAGE_LINE("+STR(TICK)+","+STR(N)+")"+"="+CHR$(34)+"0"+CHR$(34)+chr$(13)+chr$(10)
        IF MID(TEXT_LINE(Y,N),1,5 )="<END>" THEN        
        TICK=Y
        END IF    
    NEXT
        
'-------------------------------------------------------------------------------        
'         chr$(34) = ""
'        +chr$(13)+chr$(10) = cr
'-------------------------------------------------------------------------------

'-------------------------------------------------------------------------------
' Spit the file out;
'-------------------------------------------------------------------------------
    '---------------------------------------------------------------------------
    '       OPEN OUTPUT FILE
    '---------------------------------------------------------------------------
    
    DIM AS INTEGER F1     
    F1=FREEFILE        
    dim as integer FILEPS,FLO
    
    FILEPS=1
    
    OPEN FILEOUT for BINARY as #F1        
            for FLO=0 to TICK
            PUT #F1,FILEPS,BOLLOCKS(FLO)             
            FILEPS=FILEPS+len(BOLLOCKS(FLO))
            next    
        CLOSE #F1
END SUB




DATA 3,3,3,3,3,3,3,3,0
DATA 1,2,2,2,2,2,2,0,0
DATA 1,2,2,2,2,2,0,0,0
DATA 1,2,2,2,2,3,0,0,0
DATA 1,2,2,2,2,2,3,0,0
DATA 1,2,2,1,2,2,2,3,0
DATA 1,2,0,0,1,2,2,2,3
DATA 1,0,0,0,0,1,2,2,0
DATA 0,0,0,0,0,0,1,0,0
