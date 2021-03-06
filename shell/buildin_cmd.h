#ifndef __SHELL_BUILDIN_CMD_H
#define __SHELL_BUILDIN_CMD_H
#include "stdint.h"
void make_clear_abs_path(char *path, char *wash_buf);
void buildin_clear(uint32_t argc, char **argv);
void buildin_pwd(uint32_t argc, char **argv);
void buildin_ls(uint32_t argc, char **argv);
char *buildin_cd(uint32_t argc, char **argv);
void buildin_ps(uint32_t argc, char **argv);
int32_t buildin_mkdir(uint32_t argc, char **argv);
int32_t buildin_rmdir(uint32_t argc, char **argv);
int32_t buildin_rm(uint32_t argc, char **argv);
int32_t buildin_touch(uint32_t argc, char **argv);
int32_t buildin_write(uint32_t argc, char **argv);
int32_t buildin_cat(uint32_t argc, char **argv);
void buildin_pro(uint32_t argc, char **argv);
void buildin_Help(uint32_t argc, char **argv);
#endif
