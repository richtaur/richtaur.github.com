'旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
'�                                Q B M P                                   �
'�                                                                          �
'�                Revised addition by its orignal creator                   �
'�                          Matt Hackett  1996                              �
'�                                                                          �
'읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

DEFINT A-Z

DECLARE FUNCTION GetInput$ (gx, gy, length, gerase$)

DECLARE SUB Options ()
DECLARE SUB Change ()
DECLARE SUB ClearScreen ()
DECLARE SUB BackSave ()
DECLARE SUB ExitThis ()
DECLARE SUB Earase ()
DECLARE SUB ShowFiles ()
DECLARE SUB Help ()
DECLARE SUB Undo ()
DECLARE SUB getch ()
DECLARE SUB Save ()
DECLARE SUB Load ()
DECLARE SUB PutPaint ()
DECLARE SUB cursor (crdo)
DECLARE SUB Init ()
DECLARE SUB Main ()
DECLARE SUB DrawScreen ()

ON ERROR GOTO ErrCatch
SCREEN 13

CONST TRUE% = 1
CONST FALSE% = 0
CONST SIZE% = 5
CONST IMG% = 32

DIM SHARED x(IMG, IMG), y(IMG, IMG), clr(IMG, IMG)
DIM SHARED File$, crx, cry, drop
DIM SHARED UK$, DK$, LK$, RK$, EK$, SK$

Init
Main

ErrCatch:
BEEP
COLOR 15: LOCATE 1, 1
ass = ERR
SELECT CASE ass
CASE 53:
 PRINT "旼컴컴컴컴컴컴컴컴컴컴�"
 PRINT "쿑ile not found...    �"
 PRINT "읕컴컴컴컴컴컴컴컴컴컴�"
CASE ELSE:
 PRINT "旼컴컴컴컴컴컴컴컴컴컴�"
 PRINT "�        ERROR        �"
 PRINT USING "쿐rror Code:###       �"; ass
 PRINT "읕컴컴컴컴컴컴컴컴컴컴�"
END SELECT
getch
CLS
RESUME Resumer

Resumer:
Main

SUB BackSave

 COLOR 9: Undo

 LOCATE 23, 1: PRINT "BSAVE:"
 File$ = GetInput(23, 7, 20, "_")
 IF File$ = "ESCAPE" THEN File$ = "UNTITLED": DrawScreen: EXIT SUB

 File$ = File$ + ".BIG": Undo

 OPEN File$ FOR OUTPUT AS #1
  FOR a = 1 TO IMG
   FOR d = IMG TO 1 STEP -1
    PRINT #1, clr(a, d)
 NEXT: NEXT: CLOSE

 OPEN File$ FOR INPUT AS #1
  FOR a = 1 TO IMG
   FOR d = 1 TO IMG
    INPUT #1, clr(a, d)
 NEXT: NEXT: CLOSE

END SUB

SUB Change
LOCATE 1, 1: INPUT "ToChange:", ToChange
LOCATE 1, 1: INPUT "ChangeTo:", ChangeTo
FOR a = 1 TO IMG
FOR d = 1 TO IMG
IF clr(a, d) = ToChange THEN clr(a, d) = ChangeTo
NEXT: NEXT
END SUB

SUB ClearScreen
BEEP
COLOR 15: LOCATE 1, 1: PRINT "CLEAR SCREEN?"
DO
kbhit$ = INKEY$
IF kbhit$ <> "" THEN
IF kbhit$ = "y" THEN
FOR a = 1 TO IMG
FOR d = 1 TO IMG
clr(a, d) = drop
NEXT: NEXT
File$ = "Untitled"
END IF
EXIT DO
END IF
LOOP
END SUB

SUB cursor (crdo)

 SELECT CASE crdo
  CASE FALSE:
   LINE ((crx * SIZE) + 1, (cry * SIZE) + 1)-((crx * SIZE) + 4, (cry * SIZE) + 4), clr(cry, crx), BF
   IF clr(cry, crx) = 0 THEN PSET ((crx * SIZE) + 2, (cry * SIZE) + 2), 19
   IF clr(cry, crx) = 999 THEN PSET ((crx * SIZE) + 3, (cry * SIZE) + 3), 0
   PSET (SIZE, (cry * SIZE) + 3), 15
   PSET ((crx * SIZE) + 3, SIZE), 15
  CASE TRUE:
   CIRCLE (crx * SIZE + 2, cry * SIZE + 2), 1, drop
   PSET (SIZE, (cry * SIZE) + 3), 0
   PSET ((crx * SIZE) + 3, SIZE), 0
 END SELECT

END SUB

SUB DrawScreen

 File$ = UCASE$(File$): Undo

 LOCATE 23, 1: PRINT "FILE: "; File$

 LOCATE 5, 34: PRINT "旼컴커"
 LOCATE 6, 33: PRINT "�    �"
 FOR i = 7 TO 16
  LOCATE i, 34: PRINT "�    �"
 NEXT: LOCATE 17, 34: PRINT "읕컴켸"

 PutPaint

 FOR a = 1 TO IMG
  FOR d = 1 TO IMG
   LINE (y(a, d) + 1, x(a, d) + 1)-(y(a, d) + 4, x(a, d) + 4), clr(a, d), BF
   IF clr(a, d) = 0 THEN PSET (y(a, d) + 2, x(a, d) + 2), 19
   IF clr(a, d) = 999 THEN PSET (y(a, d) + 2, x(a, d) + 2), 0
   PSET (d + 200, a + 10), clr(a, d)
 NEXT: NEXT

 LINE (y(1, 1), x(1, 1))-(y(IMG, IMG) + SIZE, x(IMG, IMG) + SIZE), 15, B
 LINE (200, 10)-(233, 43), 15, B

END SUB

SUB Earase

 COLOR 9: Undo

 LOCATE 23, 1: PRINT "KILL:"
 File$ = GetInput(23, 6, 8, "_")
 IF File$ = "ESCAPE" THEN File$ = "UNTITLED": DrawScreen: EXIT SUB

 File$ = File$ + ".BIG": Undo

 KILL File$

 File$ = "Untitled"

END SUB

SUB ExitThis

 OPEN "QBMP32.QBM" FOR OUTPUT AS #1
  FOR a = 1 TO IMG
   FOR d = 1 TO IMG
    PRINT #1, clr(a, d)
 NEXT: NEXT: CLOSE

 COLOR drop
 ERASE x, y, clr
 SCREEN 9
 SCREEN 0
 SYSTEM

END SUB

SUB getch
DO: LOOP WHILE INKEY$ = ""
END SUB

FUNCTION GetInput$ (gx, gy, length, gerase$)

 LOCATE gx, gy: PRINT STRING$(length, gerase$)

 DO
  kbhit$ = INKEY$
  IF kbhit$ <> "" THEN
   SELECT CASE ASC(kbhit$)
    CASE 27: GetInput$ = "ESCAPE": EXIT FUNCTION
    CASE 13: EXIT DO
    CASE 8:
     IF LEN(a$) > 0 THEN a$ = LEFT$(a$, LEN(a$) - 1): LOCATE gx, gy + LEN(a$): PRINT gerase$
    CASE 48 TO 122:
     IF LEN(a$) < length THEN a$ = a$ + UCASE$(kbhit$)
   END SELECT
   LOCATE gx, gy: PRINT a$
  END IF
 LOOP

 GetInput$ = a$

END FUNCTION

SUB Help

 CLS : IF drop > 0 THEN COLOR drop:  ELSE COLOR 15

 PRINT "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커"
 PRINT "�                  QBMP                �"
 PRINT "�               Editor v2.0            �"
 PRINT "�                                      �"
 PRINT "�              Matt Hackett            �"
 PRINT "�                May 1996              �"
 PRINT "�                                      �"
 PRINT "�                                      �"
 PRINT "쿜BMP was created by request of Jim    �"
 PRINT "쿘acDonald for the purpose of creating �"
 PRINT "쿪 drawing program specifically for    �"
 PRINT "쿜BASIC.                               �"
 PRINT "�                                      �"
 PRINT "쿔t's format is quite simple - it uses �"
 PRINT "쿶nput and print to store data in the  �"
 PRINT "쿲iven type of file and then it can be �"
 PRINT "퀅sed in other QBASIC programs for     �"
 PRINT "퀅se with get and put graphics         �"
 PRINT "쿯unctions.                            �"
 PRINT "�                                      �"
 PRINT "�                                      �"
 PRINT "� -Matt Hackett 1996                   �"
 PRINT "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸"

 getch

 CLS : DrawScreen

END SUB

SUB Init

 ON ERROR GOTO ErrCatch

 CHDIR "C:\DRAGON"

 File$ = "Untitled"

 drop = 1
 crx = 1
 cry = 1
 UK$ = CHR$(0) + "H"
 DK$ = CHR$(0) + "P"
 LK$ = CHR$(0) + "K"
 RK$ = CHR$(0) + "M"
 SK$ = CHR$(32)
 EK$ = CHR$(13)

 FOR i = 1 TO 63
  PALETTE i + 192, i
 NEXT

 FOR a = 1 TO IMG
  FOR d = 1 TO IMG
   x(a, d) = a * SIZE
   y(a, d) = d * SIZE
 NEXT: NEXT

 OPEN "QBMP32.QBM" FOR INPUT AS #1
  FOR a = 1 TO IMG
   FOR d = 1 TO IMG
    INPUT #1, clr(a, d)
 NEXT: NEXT: CLOSE

END SUB

SUB Load

 COLOR 9: Undo

 LOCATE 23, 1: PRINT "LOAD:"
 File$ = GetInput$(23, 6, 20, "_")
 IF File$ = "ESCAPE" THEN File$ = "UNTITLED": DrawScreen: EXIT SUB

 File$ = File$ + ".BIG": Undo

 OPEN File$ FOR INPUT AS #1
  FOR a = 1 TO IMG
   FOR d = 1 TO IMG
    INPUT #1, clr(a, d)
 NEXT: NEXT: CLOSE

END SUB

SUB Main

 crx = 1
 cry = 1

 cursor (FALSE): cursor (TRUE)

 DrawScreen

 DO
  kbhit$ = INKEY$
  IF kbhit$ <> "" THEN
   cursor (FALSE)
   SELECT CASE UCASE$(kbhit$)
    CASE CHR$(27): ExitThis
    CASE DK$: IF cry < IMG THEN cry = cry + 1
    CASE UK$: IF cry > 1 THEN cry = cry - 1
    CASE LK$: IF crx > 1 THEN crx = crx - 1
    CASE RK$: IF crx < IMG THEN crx = crx + 1
    CASE SK$: clr(cry, crx) = drop: DrawScreen
    CASE "9": clr(cry, crx) = 999: DrawScreen
    CASE EK$: drop = POINT(crx + 275, cry + SIZE): PutPaint
    CASE "8": IF drop > 0 THEN drop = drop - 1: PutPaint
    CASE "2": IF drop < 255 THEN drop = drop + 1: PutPaint
    CASE "0": drop = 0: PutPaint
    CASE "F": ShowFiles
    CASE "H": Help
    CASE "`": Options
   END SELECT
   cursor (TRUE)
  END IF
 LOOP

END SUB

SUB Options
COLOR 9: LOCATE 1, 1
PRINT "旼컴컴컴컴컴컴컴컴컴컴�"
PRINT "�       OPTIONS       �"
PRINT "� Change              �"
PRINT "� Save                �"
PRINT "� Load                �"
PRINT "� BackSave            �"
PRINT "� Erase               �"
PRINT "� Clean Canvas        �"
PRINT "읕컴컴컴컴컴컴컴컴컴컴�"
cry = 3
COLOR 14: LOCATE cry, 2: PRINT ""
DO
kbhit$ = INKEY$
IF kbhit$ <> "" THEN
COLOR 0: LOCATE cry, 2: PRINT ""
SELECT CASE kbhit$
CASE UK$: IF cry > 3 THEN cry = cry - 1 ELSE cry = 8
CASE DK$: IF cry < 8 THEN cry = cry + 1 ELSE cry = 3
CASE EK$:
COLOR 9
SELECT CASE cry
CASE 3: Change
CASE 4: Save
CASE 5: Load
CASE 6: BackSave
CASE 7: Earase
CASE 8: ClearScreen
END SELECT
EXIT DO
CASE CHR$(27): EXIT DO
END SELECT
COLOR 14: LOCATE cry, 2: PRINT ""
END IF
LOOP
CLS
DrawScreen
END SUB

SUB PutPaint

 ass = 6

 FOR i = drop TO drop + 10
  IF i > 255 THEN EXIT FOR
  LOCATE ass, 35: COLOR i: PRINT USING "###"; i
  ass = ass + 1
 NEXT

END SUB

SUB Save

 COLOR 9: Undo

 LOCATE 23, 1: PRINT "SAVE:"
 File$ = GetInput(23, 6, 20, "_")
 IF File$ = "ESCAPE" THEN File$ = "UNTITLED": DrawScreen: EXIT SUB

 File$ = File$ + ".BIG": Undo

 OPEN File$ FOR OUTPUT AS #1
  FOR a = 1 TO IMG
   FOR d = 1 TO IMG
    PRINT #1, clr(a, d)
 NEXT: NEXT: CLOSE

END SUB

SUB ShowFiles

 CLS : INPUT "Directory:", Dir$

 IF Dir$ <> "" THEN CHDIR Dir$

 INPUT "Files:", fl$

 IF fl$ = "" THEN fl$ = "*.BIG"

 FILES fl$: getch

 CLS : DrawScreen

END SUB

SUB Undo
LOCATE 23, 1: PRINT "                                        "
END SUB

