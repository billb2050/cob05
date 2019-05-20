# cob05

COBOL (GnuCOBOL) 

      * Read EBCDIC input file created by '*nix dd'
      * Convert to ASCII and write.
      *
      *  Things to note...
      *     ORGANIZATION IS BINARY SEQUENTIAL...
      *        because the '*nix dd' translated the normal ASCII
      *        EOL char which is a LF to a EBCDIC LF