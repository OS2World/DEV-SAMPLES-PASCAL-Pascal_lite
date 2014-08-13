{*******************************************************}
{                                                       }
{       Vesa Interface Unit                             }
{                                                       }
{       Copyright (C) 1996    T M T Development Corp.   }
{                                                       }
{*******************************************************}

Unit Vesa;

Interface

Var Error: Byte;

Procedure SetVbeMode; external '_SETVBEMODE';
Function CheckVbeMode (mode: Word): Pointer;
Procedure VbeSetBank (bank: byte);
Procedure VbeSetStart;

Implementation

Function CheckVbeMode; Assembler;
    Procedure _CheckVbeMode; external;
Asm
    Movzx EAX, mode
    Mov   Error, 0
    Call _CheckVbeMode
    Jnc   @@ret
    Mov   Error, Dl
@@ret:
End;

Procedure  _Current_Bank; external;
Procedure    _VbeSetBank; external;
Procedure __BankSetTable; external;
Procedure   _VbeSetStart; external;
Procedure     _VbeFunc06; external;

Procedure VbeSetBank; Assembler;
Asm
    mov  dl, bank
    cmp  byte [_current_bank], dl
    je   @@setnew
    and  edx, 01Fh
    mov  byte [_current_bank], dl
    shl  edx, 2                       { sorry, but now this         }
    mov  edx,__banksettable [edx{*4}] { addressing mode unsupported }
    push ebx
    xor  ebx, ebx
    call dword ptr [_vbesetbank]
    pop  ebx
@@setnew:
End;

Function VbeFunc06 (fun: byte; w: Word; Var bpl, ppl, maxscan: word): Word; Assembler;
Asm
    Mov bl, fun
    Mov cx, w
    Call _VbeFunc06
    Mov esi,     bpl; Mov [esi], bx
    Mov esi,     ppl; Mov [esi], cx
    Mov esi, maxscan; Mov [esi], dx
    MovZx eax, ax
End;

Procedure VbeSetStart; Assembler;
Asm
    call   [_VbeSetStart]
End;

{$l vesa}

End.
