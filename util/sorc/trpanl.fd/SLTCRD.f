      SUBROUTINE SLTCRD(ISWTCH,ISLOTA,ISLOTB,IPANA,IPANB,IRLAB,IREM3A,
     1   IREM3B,IREM3C,IREM4A,IREM4B,IAREA3,ISUB,IFLAB,INSET,IREM1A,
     1   IREM1B)
C     ...THIS SUBROUTINE READS IN THE MAP SLOT CARDS AND CHECKS THEM    00255500
C     ...FOR ACCEPTABLE ENTRIES                                         00255600
      COMMON/WEFAX/ IAPT
      DIMENSION IPANC(3,11)
      DIMENSION IAREA(3,26)
      DATA    IAREA/4HCA14,1H ,1,4HCA13,1H ,2,4HCA13,1HI,3,4HNT11,1H ,4,
     1   4HNT11,1HA,5,4HNT11,1HB,6,4HPA13,1H ,7,4HPA14,1H ,8,
     2     4HUS10,1H ,9,4HNT18,1H ,10,4HNT18,1HI,11,4HUS12,1H ,12,
     3     4HVFUL,1HL,13,4HVPAR,1HT,14,4HPA13,1HA,15,4HPA19,1H ,16,
     4      4HAPT3,1H ,17,4HAPT4,1H ,18,4HUS10,1HA,19,4HCA19,1H ,20,
     5      4HCA19,1HI,21,4HAPT5,1H ,22,4HAPT6,1H ,23,4HAPT7,1H ,24,
     6      4HTEST,1H ,25,4HHONO,1H ,26/
      DATA    IPANC/4HP1  ,1H ,1,4HP2  ,1H ,2,4HP3  ,1H ,3,4HP4  ,1H ,4,
     1     4HP1A ,1H ,5,4HP2A ,1H ,6,4HP3A ,1H ,7,4HP4A ,1H ,8,4HI1  ,
     2     1H ,9,4HI2  ,1H ,10,4HB2  ,1H ,11/
      DATA    NPARTS/11/
      DATA    IBCHK/4H    /
      DATA    JU/8/
      DATA   NAREAS /26/
      DATA    IR1/100/
      DATA    IR2/5000/
      DATA    IR3/80/
      DATA    IR4/99/
C                                                                       00257800
C     ...BASIC FAX/VARIAN CONTROLS (EACH MAP SUB-SECTION)               00257900
C                                                                       00258000
C   ICARD2 (A1)=             CARD2 CONTROL                              00258100
C   ISLOTA,B (A4,A1)=        FAX/VARIAN SLOT NO.                        00258200
C   IPANA,B (A4,A1)=         PANEL PART OR REAL INSET PART              00258300
C   IAREA1,2 (A4,A1)=        FAX/VARIAN OUTPUT PIECE                    00258400
C   ISUB (I5)=               SUBSET NO.                                 00258500
C   IFLAB (I5)=              FRONT LABEL INSET NO.                      00258600
C   INSET (I5)=              INSET NO.                                  00258700
C   IRLAB (I5)=              REAR LABEL INSET NO.                       00258800
C   IREM1A,B,C (A4,A4,A2)=   PANEL 2 OR PANEL4 TITLE                    00258900
C   IREM3A,B,C (A4,A4,A2)=   PANEL 1 OR PANEL3 OR SUBSET TITLE          00259000
C                                                                       00259100
       print 1098,(j,(iarea(k,j), k=1,3),j=1,26)
 1098  format(' 9999  iarea= in sltcrd ',i5,1x,3a5)
       IAPT = 0
      IF(ISWTCH.EQ.1) GO TO 8002
      READ 8200, ICARD2,ISLOTA,ISLOTB,IPANA,IPANB,IAREA1,IAREA2,ISUB,
     1   IFLAB,INSET,IRLAB,IREM1A,IREM1B,IREM1C,IREM2A,IREM2B,
     2   IREM3A,IREM3B,IREM3C,IREM4A,IREM4B,IMANOP,IMANOQ
 8200 FORMAT(A1,3(A4,A1),4I5,2A4,A2,4A4,A2,4A4)
      GO TO 8003
 8002 READ (JU,8200) ICARD2,ISLOTA,ISLOTB,IPANA,IPANB,IAREA1,IAREA2,ISUB
     1  ,IFLAB,INSET,IRLAB,IREM1A,IREM1B,IREM1C,IREM2A,IREM2B,
     2   IREM3A,IREM3B,IREM3C,IREM4A,IREM4B,IMANOP,IMANOQ
 8003 CONTINUE
      PRINT 8202, ISLOTA,ISLOTB,IPANA,IPANB,IAREA1,IAREA2,ISUB,IFLAB,
     1   INSET
 8202 FORMAT('0SLOT NO.=  ',A4,A1,'  PANEL/INSET=  ',A4,A1,
     2   'AREA=  ',A4,A1,'  SUBSET NO.=',I5,'  FRONT LABEL INSET NO.=',
     2   I5,'  INSET NO.=',I5)
C                                                                       00260800
C     ...CHECK FOR REASONABLE PANEL PARTS/INSET PARTS                   00260900
C                                                                       00261000
      DO 8215 IK=1,NPARTS
      IF((IPANA.EQ.IBCHK).AND.(IPANB.EQ.IBCHK)) GO TO 8220
      IF((IPANA.NE.IPANC(1,IK)).OR.(IPANB.NE.IPANC(2,IK))) GO TO 8215
      IPAN1=IPANC(3,IK)
      GO TO 8220
 8215 CONTINUE
      PRINT 8216
 8216 FORMAT('0ERROR ON FAX/VARIAN CONTROL INPUT CARD FOR IPAN-FIX THEN
     1RETRY')
       CALL W3TAGE('GRAPH_TRPANL')
      STOP 216
 8220 CONTINUE
C                                                                       00262400
C     ...CHECK FOR REASONABLE AREA REQUESTS                             00262500
C                                                                       00262600
      DO 8235 IK=1,NAREAS
      IF((IAREA1.EQ.IBCHK).AND.(IAREA2.EQ.IBCHK)) GO TO 8225
      IF((IAREA1.NE.IAREA(1,IK)).OR.(IAREA2.NE.IAREA(2,IK))) GO TO 8235
      IAREA3=IAREA(3,IK)
      IF(IAREA3.EQ.17.OR.IAREA3.EQ.18.OR.(IAREA3.GE.22.AND.IAREA3.LE.
     & 24)) IAPT = 1
      GO TO 8240
 8225 PRINT 8226
 8226 FORMAT('0IAREA1,2 WAS BLANK-WILL CONTINUE')
      GO TO 8240
 8235 CONTINUE
      PRINT 8236
 8236 FORMAT('0ERROR ON FAX/VARIAN CONTROL INPUT CARD FOR IAREA1,2-FIX
     1THEN RETRY')
       CALL W3TAGE('GRAPH_TRPANL')
      STOP 236
 8240 CONTINUE
C                                                                       00264600
C     ...CHECK FOR REASONABLE SUBSET/INSET NUMBERS                      00264700
C                                                                       00264800
      IF(ISUB.LT.0) GO TO 8243
      IF(((ISUB.GE.IR1).AND.(ISUB.LE.IR2)).OR.((ISUB.GE.IR3).AND.(ISUB.L
     1E.IR4))) GO TO 8301
      PRINT 8241, ISUB
 8241 FORMAT('0ERROR ON FAX/VARIAN CONTROL INPUT CARD FOR ISUB-FIX THEN
     1RETRY  ',I4)
       CALL W3TAGE('GRAPH_TRPANL')
      STOP 241
 8243 CONTINUE
      PRINT 8244
 8244 FORMAT('0SUBSET NUMBER IS BLANK-WILL CONTINUE')
 8301 CONTINUE
      IF(IFLAB.LE.0) GO TO 8253
      IF(((IFLAB.GE.IR1).AND.(IFLAB.LE.IR2)).OR.((IFLAB.GE.IR3).AND.(IFL
     1AB.LE.IR4))) GO TO 8302
      PRINT 8251
 8251 FORMAT('0ERROR ON FAX/VARIAN CONTROL INPUT CARD FOR IFLAB-FIX THEN
     1 RETRY')
       CALL W3TAGE('GRAPH_TRPANL')
      STOP 251
 8253 CONTINUE
 8302 CONTINUE
      IF(INSET.LE.0) GO TO 8263
      IF(((INSET.GE.IR1).AND.(INSET.LE.IR2)).OR.((INSET.GE.IR3).AND.(INS
     1ET.LE.IR4))) GO TO 8303
      PRINT 8261
 8261 FORMAT('0ERROR ON FAX/VARIAN CONTROL INPUT CARD FOR INSET-FIX THEN
     1 RETRY')
       CALL W3TAGE('GRAPH_TRPANL')
      STOP 261
 8263 CONTINUE
 8303 CONTINUE
      RETURN
      END
