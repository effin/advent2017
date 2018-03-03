LET l = 100000
DIM tape(l), x
LET c = 12994925
LET p = l / 2
LET n = 0

FOR x = 0 TO l STEP 1
    tape(x) = 0
NEXT x

StateA:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 1
    p = p + 1
    GOTO StateB
ELSE
    tape(p) = 0
    p = p - 1
    GOTO StateF
END IF

StateB:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 0
    p = p + 1
    GOTO StateC
ELSE
    tape(p) = 0
    p = p + 1
    GOTO StateD
END IF

StateC:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 1
    p = p - 1
    GOTO StateD
ELSE
    tape(p) = 1
    p = p + 1
    GOTO StateE
END IF

StateD:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 0
    p = p - 1
    GOTO StateE
ELSE
    tape(p) = 0
    p = p - 1
    GOTO StateD
END IF

StateE:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 0
    p = p + 1
    GOTO StateA
ELSE
    tape(p) = 1
    p = p + 1
    GOTO StateC
END IF

StateF:
IF n = c THEN GOTO PrintSum
LET n = n + 1
IF tape(p) = 0 THEN
    tape(p) = 1
    p = p - 1
ELSE
    tape(p) = 1
    p = p + 1
END IF
GOTO StateA

PrintSum:
LET s = 0
FOR x = 0 TO l STEP 1
    s = s + tape(x)
NEXT x
PRINT "summa ", s



