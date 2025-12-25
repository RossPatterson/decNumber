/* ------------------------------------------------------------------ */
/* decCMS.h -- VM/370 R6 CMS header                                   */
/* ------------------------------------------------------------------ */
/* Copyright (c) Ross Patterson 2026.                                 */
/*                                                                    */
/* This addition to the decNumber library is dedicated to the public  */
/* domain.                                                            */
/* ------------------------------------------------------------------ */
#if !defined(DECCMS)
  #define DECCMS

  #define DECCMSNAME       "DECCMS"                   /* Short name   */
  #define DECCMSTITLE      "VM/370 R6 CMS support"    /* Verbose name */
  #define DECCMSAUTHOR     "Ross Patterson"           /* Who to blame */

  /* CMS requires function names to be unique in the first 8 characters,
   * so we need to rename lots of parts of the decNumber package.
   */
  #include "decShortNames.h"

  #define DECLITEND 0         /* VM/370 is a big-endian system.       */
  #define DECUSE64  0       /* VM/370 C doesn't have 64-bit integers. */
  #if !defined(DECNUMDIGITS)
    #define DECNUMDIGITS 32   /* Seems like plenty, maybe?            */
  #endif
#endif