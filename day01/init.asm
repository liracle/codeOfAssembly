; Pea OS pea操作系统
; TAB=4
    ;org   0x7c00       ; 程序被装载到内存中的地址,伪指令
; 一下这段是标准FAT12格式软盘专用的代码
    db    0xeb, 0x4e, 0x90
    db    "HelloPea"    ; 启动扇区名称（8字节）
    dw    512        ; 每个扇区（sector）大小（必须512字节）
    db    1        ; 簇（cluster）大小（必须为1个扇区）
    dw    1        ; FAT起始位置（一般为第一个扇区）
    db    2        ; FAT个数（必须为2）
    dw    224        ; 根目录大小（一般为224项）
    dw    2880        ; 该磁盘大小（必须为2880扇区1440*1024/512）
    db    0xf0        ; 磁盘类型（必须为0xf0）
    dw    9        ; FAT的长度（必须是9扇区）
    dw    18        ; 一个磁道（track）有几个扇区（必须为18）
    dw    2        ; 磁头数（必须是2）
    dd    0        ; 不使用分区，必须是0
    dd    2880        ; 重写一次磁盘大小
    db    0,0,0x29    ; 意义不明（固定）
    dd    0xffffffff    ; （可能是）卷标号码
    db    "HELLO-OS   "    ; 磁盘的名称（必须为11字节，不足填空格）
    db    "FAT12   "    ; 磁盘格式名称（必须是8字节，不足填空格）
    resb    18        ; 先空出18字节

; 程序主体
; 初始化寄存器
    mov ax, cs
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov bx, msg+0x7c00
    mov bp, bx         ; [es:bp]字符串偏移量

    ;mov ax, 0x02       ; 设置光标位置
    ;mov bh, 0          ; 设置页码
    ;mov dh, 20         ; 设置行
    ;mov dl, 10         ; 设置列
    ;int 0x10           ; 实模式下视频服务

    mov ah, 0x13       ; 写字符串模式
    mov al, 0x01       ; AL＝0，表示目标字符串仅仅包含字符，属性在BL中包含，不移动光标 ;AL＝1，表示目标字符串仅仅包含字符，属性在BL中包含，移动光标;
    ;AL＝2，表示目标字符串包含字符和属性，不移动光标;AL＝3，表示目标字符串包含字符和属性，移动光标
    mov bh, 0          ; 页码
    mov bl, 10100100b       ; 
    mov dh, 10         ; 设置行
    mov dl, 30         ; 设置列
    mov cx, msgEnd-msg ; 字符串长度
    int 0x10
loop:
    hlt
    jmp loop
; 信息显示部分
msg:
    ;db    0x0a, 0x0a                  ; 换行两次
    db    "Welcome to HelloPea OS!"
    ;db    0x0a                        ; 换行
    ;db    0

msgEnd:
    resb    0x1fe-($-$$)        ; 填写0x00直到0x001fe

    db    0x55, 0xaa

; 启动扇区以外部分输出

    db    0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    resb    4600
    db    0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    resb    1469432