#---------------------------参数配置----------------------------
BUILD_DIR = ./build
ENTRY_POINT = 0xc0001500
IMAGE_NAME = master.img
VMDK_NAME = master.vmdk
IMAGE_SIZE = 64
SLAVE = hd80.img
SLAVE_SIZE= 80	
AS = nasm
CC = gcc
LD = ld
LIB = -I lib/ -I lib/kernel/ -I lib/user/ -I kernel/ -I device/ -I thread/ -I userprog/ -I lib/user/ -I fs/ -I shell/
ASFLAGS = -f elf
CFLAGS = -m32 -fno-stack-protector -Wall $(LIB) -c -fno-builtin -W -Wstrict-prototypes -Wmissing-prototypes -Wno-implicit-fallthrough
LDFLAGS = -m elf_i386 -Ttext $(ENTRY_POINT) -e main -Map $(BUILD_DIR)/kernel.map
#LDFLAGS_T = -m elf_i386 -Ttext $(ENTRY_POINT) -e main -o $(BUILD_DIR)/kernel.bin  #生成kernel.bin文件
OBJS = $(BUILD_DIR)/main.o $(BUILD_DIR)/init.o $(BUILD_DIR)/interrupt.o \
      $(BUILD_DIR)/timer.o $(BUILD_DIR)/kernel.o $(BUILD_DIR)/print.o \
      $(BUILD_DIR)/debug.o $(BUILD_DIR)/memory.o $(BUILD_DIR)/bitmap.o \
      $(BUILD_DIR)/string.o $(BUILD_DIR)/thread.o $(BUILD_DIR)/list.o \
	  $(BUILD_DIR)/switch.o $(BUILD_DIR)/console.o $(BUILD_DIR)/sync.o \
	  $(BUILD_DIR)/keyboard.o $(BUILD_DIR)/ioqueue.o $(BUILD_DIR)/tss.o \
	  $(BUILD_DIR)/process.o $(BUILD_DIR)/syscall.o $(BUILD_DIR)/syscall-init.o \
	  $(BUILD_DIR)/stdio.o $(BUILD_DIR)/ide.o $(BUILD_DIR)/stdio-kernel.o \
	  $(BUILD_DIR)/fs.o $(BUILD_DIR)/inode.o $(BUILD_DIR)/file.o $(BUILD_DIR)/dir.o \
	  $(BUILD_DIR)/shell.o $(BUILD_DIR)/assert.o $(BUILD_DIR)/buildin_cmd.o 
	 

#--------------编译并启动bochs-------------------
.PHONY:bochs
bochs:$(BUILD_DIR)/$(IMAGE_NAME)
	cd build/ && bochs -q -f bochsrc

#--------------编译并启动bochs-------------------
.PHONY:bochs-gdb
bochs-gdb:$(BUILD_DIR)/$(IMAGE_NAME)
	cd build/ && bochs -q -f bochs-gdb

#------------编译---------------------
.PHONY:compile
compile:$(BUILD_DIR)/$(IMAGE_NAME)
	@echo "Compilation Successful!"

#------------------------写入磁盘--------------------------------
$(BUILD_DIR)/$(IMAGE_NAME):$(BUILD_DIR)/mbr.bin  $(BUILD_DIR)/loader.bin $(BUILD_DIR)/kernel.bin
ifeq ("$(wildcard $(IMAGE_NAME))","")
	bximage -q -hd=$(IMAGE_SIZE) -func=create -sectsize=512 -imgmode=flat $@  
#如果 bochs版本在2.7以下使用这条命令	
#bximage -q -hd=$(IMAGE_SIZE) -mode=create -sectsize=512 -imgmode=flat $@  
#	bximage -q -hd=$(SLAVE_SIZE) -mode=create -sectsize=512 -imgmode=flat $(BUILD_DIR)/$(SLAVE)
endif
	#bximage -q -hd=$(IMAGE_SIZE) -mode=create -sectsize=512 -imgmode=flat $@
	dd if=$(BUILD_DIR)/mbr.bin of=build/master.img bs=512 count=1 conv=notrunc
	dd if=$(BUILD_DIR)/loader.bin of=build/master.img bs=512 count=4 seek=2 conv=notrunc
	dd if=$(BUILD_DIR)/kernel.bin of=build/master.img bs=512 count=200 seek=9 conv=notrunc 

#--------------- mbr and loader 编译-----------------------------
$(BUILD_DIR)/%.bin:boot/%.S
	nasm -I boot/include/ $< -o $@ 

#--------------------c代码编译-----------------------------------
$(BUILD_DIR)/main.o: kernel/main.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/init.o: kernel/init.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/interrupt.o: kernel/interrupt.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/timer.o: device/timer.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/debug.o: kernel/debug.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/string.o: lib/string.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/bitmap.o: lib/kernel/bitmap.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/memory.o: kernel/memory.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/thread.o: thread/thread.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/list.o: lib/kernel/list.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/console.o: device/console.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/sync.o: thread/sync.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/keyboard.o: device/keyboard.c 
	$(CC) $(CFLAGS) $< -o $@
	
$(BUILD_DIR)/ioqueue.o: device/ioqueue.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/tss.o: userprog/tss.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/process.o: userprog/process.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/syscall.o: lib/user/syscall.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/syscall-init.o: userprog/syscall-init.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/stdio.o: lib/stdio.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/ide.o: device/ide.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/stdio-kernel.o: lib/kernel/stdio-kernel.c 
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/fs.o: fs/fs.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/inode.o: fs/inode.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/file.o: fs/file.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/dir.o: fs/dir.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/shell.o: shell/shell.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/assert.o: lib/user/assert.c
	$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/buildin_cmd.o: shell/buildin_cmd.c
	$(CC) $(CFLAGS) $< -o $@
#--------------------------汇编代码编译 --------------------------
$(BUILD_DIR)/kernel.o: kernel/kernel.S
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/print.o: lib/kernel/print.S
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/switch.o: thread/switch.S
	$(AS) $(ASFLAGS) $< -o $@



#--------------------------- 链接文件-----------------------------------
$(BUILD_DIR)/kernel.bin: $(BUILD_DIR)/elf_kernel.bin
	objcopy -O binary $^ $@

$(BUILD_DIR)/elf_kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@


#路径
#ata0-master: type="disk",path="master.img",mode="flat"
#ata0-slave: type="disk",path="hd80M.img",mode="flat"

#---------------清理---------------------------
.PHONY:clean
clean:
	rm -rf $(BUILD_DIR)/*.o
	rm -rf $(BUILD_DIR)/master.img
	rm -rf $(BUILD_DIR)/*.bin
	rm -rf $(BUILD_DIR)/*.map
	rm -rf $(BUILD_DIR)/*.lock
	rm -rf $(BUILD_DIR)/*.vmdk


#-------------------------------
.PHONY:wcp
wcp:$(BUILD_DIR)/$(IMAGE_NAME)
	cp build/master.img build/hd80M.img /mnt/d/OS