#include "print.h"
#include "init.h"
#include "thread.h"
#include "interrupt.h"
#include "console.h"
#include "process.h"
#include "syscall-init.h"
#include "syscall.h"
#include "stdio.h"
#include "memory.h"
#include "dir.h"
#include "fs.h"
#include "assert.h"
#include "shell.h"
void init(void);

int main(void)
{
   put_str("I am kernel\n");
   init_all();
   cls_screen();
   console_put_str("[TM@localhost /]$ ");

   while (1)
      ;
   return 0;
}

/* init进程 */
void init(void)
{
   my_shell();
   panic("init: should not be here");
}
