org 07c00h ;告诉计算机将代码加载到内存的07c00h
mov ax, cs 
mov ds, ax ;初始化数据段ds
mov es, ax ;初始化附加段寄存器
call DispStr ;调用DispStr来显示字符串
jmp $  ;无限循环
DispStr:
  mov ax, BootMessage ;将字符串地址传给寄存器ax
  mov bp, ax ; 通过ES:BP来指向显示的字符串
  mov bx, MsgLen; 将字符串长度地址加载bx集群器
  mov cx, [bx]; 通过地址加载字符创长度
  mov ax, 01301h ;10h的13号中断，此时通过AH=13传入，AL＝1，表示目标字符串仅仅包含字符，属性在BL中包含，移动光标
  mov bx, 000ch  ;BH表示视频区页数
  mov dl, 0 ;DL表示在第几列显示（0为第一列）
  int 10h ;10H中断
  ret
BootMessage:  db "Hello,Pea OS, Love u 1314!"
MsgLen: db $-BootMessage; 计算字符创长度
times 510-($-$$) db 0  ;用times来创建字节0
dw 0xaa55 ;扇区结尾，写入引导程序标志位
