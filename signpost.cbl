      *    Written By:  Jo-Jo-Bean   
      *    Created On:  2026-05-07
      *    Last Edited: 2026-05-08
      *    Purpose: My attempt to rewrite Simon Tatham's Signpost puzzle
      *        from scratch in COBOL!
      *
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIGNPOST.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.
           01 FIELD-SIZE PIC 9 VALUE IS 5.
           01 FIELD.
               05 FIELD-X OCCURS 9 TIMES.
                   10 FIELD-Y OCCURS 9 TIMES.
                       15 ARROW-TRUE PIC 9.
                       15 ARROW-SET PIC 9 VALUE IS 9.
                       15 SEQ PIC 99.
                       15 PATH PIC X.
    
           01 ARROW-TABLE-DATA.
               05 FILLER PIC X(2) VALUE IS 'N '.
               05 FILLER PIC X(2) VALUE IS 'NE'.
               05 FILLER PIC X(2) VALUE IS 'E '.
               05 FILLER PIC X(2) VALUE IS 'SE'.
               05 FILLER PIC X(2) VALUE IS 'S '.
               05 FILLER PIC X(2) VALUE IS 'SW'.
               05 FILLER PIC X(2) VALUE IS 'W '.
               05 FILLER PIC X(2) VALUE IS 'NW'.
               05 FILLER PIC X(2) VALUE IS '--'.

           01 ARROW-TABLE REDEFINES ARROW-TABLE-DATA.
               05 ARROW-MAP OCCURS 9 TIMES PIC X(2).
           01 ARROW-MAP-SIZE PIC 9 VALUE IS 9.
    
           01 X PIC 99.
           01 Y PIC 99.
           01 COL-X PIC 9.
           01 COL-Y PIC 9.                                                 
    
           
           01 REPLAY PIC X.
           01 GAME-DONE PIC 9.

           01 SEED PIC 9(3).
           01 RAND PIC 9V9(3).
           01 NOW.
               05 SECONDS PIC 99.
               05 CS PIC 99.

      *
       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           PERFORM BUILD-FIELD.
           PERFORM GAME UNTIL GAME-DONE EQUALS 1.
           PERFORM NEW-GAME.
           STOP RUN.

       BUILD-FIELD.
           MOVE FUNCTION CURRENT-DATE(13:16) TO NOW.
           COMPUTE SEED = SECONDS * CS.
           COMPUTE RAND = FUNCTION RANDOM(SEED).
           MOVE 1 TO Y
           PERFORM UNTIL Y > FIELD-SIZE
               MOVE 1 TO X
                   PERFORM UNTIL X > FIELD-SIZE
                       COMPUTE SEQ(X, Y) = X + ((Y - 1) * FIELD-SIZE)
                       COMPUTE RAND = FUNCTION RANDOM
                       MULTIPLY RAND BY ARROW-MAP-SIZE 
                           GIVING ARROW-SET(X, Y)
                           ROUNDED MODE IS TOWARD-GREATER
                       ADD 1 TO X
                   END-PERFORM
               ADD 1 TO Y
           END-PERFORM.

       GAME.
           PERFORM PRINT-GAME.
           MOVE 1 TO GAME-DONE.
       
       PRINT-GAME.
           MOVE 1 TO Y
           PERFORM UNTIL Y > FIELD-SIZE
               SUBTRACT Y -1 FROM FIELD-SIZE GIVING COL-Y
               DISPLAY COL-Y " " WITH NO ADVANCING
               MOVE 1 TO X
               PERFORM UNTIL X > FIELD-SIZE
                   DISPLAY SEQ(X,Y) "  " WITH NO ADVANCING     
                   ADD 1 TO X
               END-PERFORM
               DISPLAY " "
               DISPLAY "  " WITH NO ADVANCING
               MOVE 1 TO X
               PERFORM UNTIL X > FIELD-SIZE
                   DISPLAY ARROW-MAP(ARROW-SET(X,Y)) "  "
                       WITH NO ADVANCING    
                   ADD 1 TO X
               END-PERFORM
               DISPLAY " "
               ADD 1 TO Y
           END-PERFORM.
           DISPLAY " ".
           MOVE 1 TO X.
           PERFORM UNTIL X > ARROW-MAP-SIZE
               DISPLAY ARROW-MAP(X) " " WITH NO ADVANCING
               ADD 1 TO X
           END-PERFORM.

       NEW-GAME.
           DISPLAY ' '.
           DISPLAY "Do you wish to play again? (y/n): "
               WITH NO ADVANCING.
           ACCEPT REPLAY.
           DISPLAY ' '.
           IF REPLAY EQUALS 'y' OR REPLAY EQUALS 'Y'
               MOVE 0 TO GAME-DONE
               PERFORM RESET-FIELD
               PERFORM MAIN-PROGRAM
           END-IF.

       RESET-FIELD.
           MOVE 1 TO Y
           PERFORM UNTIL Y > FIELD-SIZE
               MOVE 1 TO X
                   PERFORM UNTIL X > FIELD-SIZE
                       MOVE 9 TO ARROW-SET(X,Y)
                       ADD 1 TO X
                   END-PERFORM
               ADD 1 TO Y
           END-PERFORM.
