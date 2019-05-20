       IDENTIFICATION DIVISION.
       PROGRAM-ID. cob05.
      * A GnuCOBOL program
      * On: 11/12/2017
      * By: Bill Blasingim      
      *
      * Read EBCDIC input file created by '*nix dd'
      * Convert to ASCII and write.
      *
      *  Things to note...
      *     ORGANIZATION IS BINARY SEQUENTIAL...
      *        because the '*nix dd' translated the normal ASCII
      *        EOL char which is a LF to a EBCDIC LF
      *
      * This program reads and writes fixed length records
      * Use "Line Sequential" on output to handle ending control 
      * character common on PC files. For example *nix uses a CR (x'0A) 
      * at line end.
      *
      * Useful for very old or big files where a programmer is trying to 
      * save space. On *nix...1,000,000 records would save 1,000,000
      * bytes. Savings of 2,000,000 on Windows where lines end in CR/LF
      * Note: A text editor might have problems loading a 1,000,000 
      * character line.
      *        
      * 03/11/2019 - Added line-feed to output record.
      *              Strictly speaking not needed or common for fixed 
      *              length records in the COBOL world. 
      *              I added so I could easily open/view with a regular 
      *              text editor.
      * 03/17/2019 Added code to allow writing EBCDIC output.
      *            Simply comment out the INSPECT to write the default
      *            ASCII.
      *
       Environment Division.      
       Input-Output Section.
       File-Control.
       Select InFile Assign to
         "/home/bill/Mystuff/COBOL/data/customer-fixed3.ebc"
           ORGANIZATION IS BINARY SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL.         
      *   Line Sequential.
       Select OutFile Assign to
         "./customer.out".
      *   Line Sequential.
       Data Division.
       File Section.
       FD InFile.
         01 InRec.
           05 Account		pic x(18).
           05 Filler		pic x(2).
           05 Gender		pic x.
           05 Name.
             10 I-First		pic x(15).
             10 I-Middle	pic x(15).
             10 I-Last		pic x(20).           
           05 Birthday.
              10 yyyy		pic x(4).
              10 Filler		pic x.
              10 mm			pic x(2).
              10 Filler		pic x.              
              10 dd			pic x(2).              
            05 I-Address    pic x(25).
            05 City		    pic x(20).
            05 State	    pic x(2).
            05 Zip		    pic x(5). 
            05 I-EOL       	pic x.                                              

       FD OutFile.
         01 OutRec.
           05 O-Name.         
             10 O-First			pic x(15).
             10 O-Middle		pic x(15).
             10 O-Last			pic x(20).           
           05 O-Birthday.
              10 o-yyyy			pic x(4).
              10 o-mm			pic x(2).
              10 o-dd          pic x(2). 
            05 o-eol           pic x.
                     
       Working-Storage Section.
         01 Misc.
           05        Pic X
             Value "N".
           88 EOF     Value "Y".    
      *    Linux end of line [line feed]
           05 eol    BINARY-CHAR UNSIGNED value 10. 
      *     05 eol    PIC X VALUE SPACE.           
           05 RECOUT       PIC S9(5) COMP VALUE +0.             
           78 ASCII   value 
          "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" &
          "0123456789 !" & '"' & "#$%&'()*+,-./:;<=>?@[\]^_`{|}~"&
          x'0A'.
           78 EBCDIC  value 
        X'818283848586878889919293949596979899A2A3A4A5A6A7A8A9' &
        X'C1C2C3C4C5C6C7C8C9D1D2D3D4D5D6D7D8D9E2E3E4E5E6E7E8E9' & 
        X'F0F1F2F3F4F5F6F7F8F9405A7F' &
        X'7B5B6C507D4D5D5C4E6B604B617A5E4C7E6E6F7CADE0BDB06D798B4F9BA1'&
        x'25'.            
       PROCEDURE DIVISION.
         DISPLAY "Program Start!"
         Perform Init
         Perform Until EOF
           Read InFile
             At End
               Set EOF to True
             Not At End
               move spaces to OutRec
               Move Name to O-Name
               Move yyyy to o-yyyy
               Move mm to o-mm
               Move dd to o-dd
               MOVE I-eol to o-eol                

               INSPECT OutRec CONVERTING EBCDIC TO ASCII
               Write OutRec
               add +1 to RECOUT
           End-Read
         End-Perform       
         Close InFile, OutFile.
         DISPLAY RECOUT.
         STOP RUN.
       Init. 
	     Open Input InFile.
	     Open Output OutFile.
