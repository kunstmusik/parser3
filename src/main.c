#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "csound_orcparse.h"

extern int csound_orcparse(void);
extern int csound_orcdebug;

int main(int argc, char** argv) {
  extern FILE *csound_orcin;
  csound_orcdebug = 1;
  if(argc > 1 && (csound_orcin = fopen(argv[1], "r")) == NULL) {
    perror(argv[1]);
    exit(1);
  }

  if(!csound_orcparse())
    printf("Csound ORC parse worked\n");
  else
    printf("Csound ORC parse failed\n");
}
