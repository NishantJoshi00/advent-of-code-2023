       IDENTIFICATION DIVISION.
       PROGRAM-ID. SOLUTION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 STRING-ARRAY.
         05 STRING-ELEMENT OCCURS 3 TIMES.
           10 CHARACTER-ELEMENT PIC X(1) OCCURS 256 TIMES.

       01 I PIC 9(5) VALUE 0.

       01 PTR PIC 9(5) VALUE 0.
       01 READ-NUMBER PIC 1(1) VALUE 0.
       01 CUR PIC 9(5) VALUE 0.
       01 VER-PTR PIC 9(5) VALUE 0.
       01 VER-CUR PIC 9(5) VALUE 0.

       01 TOTAL PIC 9(10) VALUE 0.
       01 TEMP PIC 9(10) VALUE 0.



       PROCEDURE DIVISION.
           MOVE ALL '.' TO STRING-ELEMENT(1).
           MOVE ALL '.' TO STRING-ELEMENT(2).
           MOVE ALL '.' TO STRING-ELEMENT(3).

           ACCEPT STRING-ELEMENT(3).

           PERFORM UNTIL STRING-ELEMENT(3) = SPACE
             PERFORM NUMBER-CRUNCHING

             MOVE STRING-ELEMENT(2) TO STRING-ELEMENT(1)
             MOVE STRING-ELEMENT(3) TO STRING-ELEMENT(2)

             ACCEPT STRING-ELEMENT(3)

           END-PERFORM

           MOVE ALL '.' TO STRING-ELEMENT(3).

           PERFORM NUMBER-CRUNCHING.

           DISPLAY TOTAL.

           STOP RUN.

       NUMBER-CRUNCHING.
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > LENGTH OF
           STRING-ELEMENT(2)


           IF CHARACTER-ELEMENT(2, I) NUMERIC
             IF READ-NUMBER = 1
               MOVE I TO CUR
             ELSE
               MOVE 1 TO READ-NUMBER
               MOVE I TO PTR
               MOVE I TO CUR
             END-IF
           ELSE
             IF READ-NUMBER = 1
               PERFORM VALIDATE-ADD
               MOVE 0 TO READ-NUMBER
               MOVE 0 TO PTR
               MOVE 0 TO CUR
             END-IF
           END-IF

           END-PERFORM

           EXIT.


       VALIDATE-ADD.

           IF PTR = 1
             MOVE PTR TO VER-PTR
           ELSE
             SUBTRACT 1 FROM PTR GIVING VER-PTR 
             IF CHARACTER-ELEMENT(2, VER-PTR) NOT NUMERIC AND
               CHARACTER-ELEMENT(2, VER-PTR) NOT = '.' AND
               CHARACTER-ELEMENT(2, VER-PTR) NOT = SPACE
               PERFORM ADD-TOTAL
               EXIT
             END-IF
           END-IF

           ADD 1 TO CUR GIVING VER-CUR

           IF CHARACTER-ELEMENT(2, VER-CUR) = SPACE
             SUBTRACT 1 FROM VER-CUR
           ELSE 
             IF CHARACTER-ELEMENT(2, VER-CUR) NOT NUMERIC AND
               CHARACTER-ELEMENT(2, VER-CUR) NOT = '.' AND
               CHARACTER-ELEMENT(2, VER-CUR) NOT = SPACE
               PERFORM ADD-TOTAL
               EXIT
             END-IF
           END-IF
           EXIT.

           PERFORM VARYING VER-PTR FROM VER-PTR BY 1 UNTIL VER-PTR > 
             VER-CUR
             IF CHARACTER-ELEMENT(1, VER-PTR) NOT NUMERIC AND
               CHARACTER-ELEMENT(1, VER-PTR) NOT = '.' AND
               CHARACTER-ELEMENT(1, VER-PTR) NOT = SPACE
               PERFORM ADD-TOTAL
               EXIT
             END-IF
           END-PERFORM

           IF PTR = 1
             MOVE PTR TO VER-PTR
           ELSE
             SUBTRACT 1 FROM PTR GIVING VER-PTR 
           END-IF

           ADD 1 TO CUR GIVING VER-CUR.

           IF CHARACTER-ELEMENT(2, VER-CUR) = SPACE
             SUBTRACT 1 FROM VER-CUR
           END-IF
           EXIT.


           PERFORM VARYING VER-PTR FROM VER-PTR BY 1 UNTIL VER-PTR >
             VER-CUR
             IF CHARACTER-ELEMENT(3, VER-PTR) NOT NUMERIC AND
               CHARACTER-ELEMENT(3, VER-PTR) NOT = '.'
               PERFORM ADD-TOTAL
               EXIT
             END-IF
           END-PERFORM

           EXIT.

       ADD-TOTAL.
           MOVE 0 TO TEMP.

           PERFORM VARYING PTR FROM PTR BY 1 UNTIL PTR > CUR
             MULTIPLY TEMP BY 10 GIVING TEMP
             ADD FUNCTION NUMVAL(CHARACTER-ELEMENT(2, PTR)) TO TEMP
           END-PERFORM

           ADD TEMP TO TOTAL.


           EXIT.
