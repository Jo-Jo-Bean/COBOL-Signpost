      *    Written By:  Jo-Jo-Bean   
      *    Created On:  2026-05-07
      *    Last Edited: 2026-05-07
      *    Purpose:
      *    My attempt to rewrite Simon Tatham's Signpost puzzle from
      *    scratch in COBOL! I don't understand enough about C to read
      *    the code on his GitHub, but I think I got enough from the
      *    comments in the code there to work the rest out myself.
      *    Here goes nothing!
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
                   15 ARROW-SET PIC 9.
                   15 SEQ PIC 99.
                   15 PATH PIC X.

       01 X PIC 9.
       01 Y PIC 9.

       
       01 REPLAY PIC X.
       01 GAME-DONE PIC 9.

      *
       PROCEDURE DIVISION.
       MAIN-PROGRAM.
           PERFORM BUILD-FIELD.
           PERFORM GAME UNTIL GAME-DONE EQUALS 1.
           PERFORM NEW-GAME.
           STOP RUN.

       BUILD-FIELD.
           MOVE 1 TO Y
           PERFORM UNTIL Y > FIELD-SIZE
               MOVE 1 TO X
                   PERFORM UNTIL X > FIELD-SIZE
                       MOVE Y TO ARROW-SET(X,Y) ARROW-TRUE(X,Y)
                                 SEQ(X,Y) PATH(X,Y) 
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
               MOVE 1 TO X
                   PERFORM UNTIL X > FIELD-SIZE
                       DISPLAY ARROW-SET(X,Y) " " ARROW-TRUE(X,Y) " "
                               SEQ(X,Y) " " PATH(X,Y) " " 
                       WITH NO ADVANCING     
                       ADD 1 TO X
                   END-PERFORM
               DISPLAY " "
               ADD 1 TO Y
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
                       MOVE 0 TO ARROW-SET(X,Y) ARROW-TRUE(X,Y)
                                 SEQ(X,Y) PATH(X,Y)
                       ADD 1 TO X
                   END-PERFORM
               ADD 1 TO Y
           END-PERFORM.
