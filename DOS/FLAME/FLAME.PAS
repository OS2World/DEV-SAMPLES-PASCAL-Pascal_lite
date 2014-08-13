{*******************************************************}
{                                                       }
{       Copyright (C) 1996    T M T   Corporation       }
{                                                       }
{*******************************************************}

{ this exaple demonstrate direct access to video memory }
{ and I/O port						}

{$r-,q-}
{ DOS version of this program has been posted to          }
{ COMP.LANG.PASCAL newsgroup. Here is slightly changed    }
{ original version with author comments.                  }

USES USE32;

var a000:dword;

var c, x, y, z : Word;
procedure setrgb( c, r, g, b : byte );
begin
  port[$3c8] := c;   { g'day, this is a probably the most simple version   }
  port[$3c9] := r;   { of fire that you will ever see in pascal. i wrote   }
  port[$3c9] := g;   { the code in pascal so it's slow and choppy, i have  }
  port[$3c9] := b;   { another version in asm. and it's faster. anyways if }
end;                 { you have any critics or question on this code, just }
                     { e-mail me at ekd0840@bosoleil.ci.umoncton.ca. or    }
begin                {              9323767@info.umoncton.ca               }
  a000 := $a0000 +_zero;
  randomize;         {  note : I have code for all kinds of stuff (that I  }
  asm   mov ax, 13h  {         wrote of course), if you want something     }
        int 10h      {         e-mail me (i never get mail), maybe i have  }
  end;               {         what you want.                              }
  for x := 1 to 32 do{                               keith degrÅce         }
  begin              {                               moncton, n.-b. canada }
    setrgb(x,   x*2-1, 0,     0    );
    setrgb(x+32, 63,   x*2-1, 0    );
    setrgb(x+64, 63,   63,    x*2-1);
    setrgb(x+96, 63,   63,    63   );
  end;
  repeat
   x := 0;
   repeat
     y := 60;
     repeat
       c := (mem[a000+y * 320 + x]+
             mem[a000+y * 320 + x + 2]+
             mem[a000+y * 320 + x - 2]+
             mem[a000+(y+2) * 320 + x + 2]) shr 2; --div 4;
       if c <> 0 then dec(c);
       memw[a000+(y-2) * 320 + x] := (c shl 8) + c;
       memw[a000+(y-1) * 320 + x] := (c shl 8) + c;
       Inc(Y,2);
     until y > 202;
     Dec(y,2);
     mem[a000+y * 320 + x] := random(2) * 160;
     Inc(X,2);
    until x >= 320;
  until port[$60] < $80;
  asm  mov ax, 3
       int 10h
  end;
end.
