{*******************************************************}
{                                                       }
{       Pascal/Lite Runtime Library                     }
{       Vesa Unit Demo                                  }
{                                                       }
{       Copyright (C) 1996    T M T   Corporation       }
{                                                       }
{*******************************************************}

program vesademo;
uses vesa, crt;

var    buf:pchar;
      mode:integer;
         i:integer;

const nbanks: array [1..3] of byte = (4, 8, 12);
const  modes: array [1..3] of word = ($100, $103, $105);

begin
    If paramcount <> 1 Then Begin
        Writeln ('Copyright (C) 1996, TMT Development Corporation');
        Writeln ('Vesa interface demonstration');
        Writeln ('Usage: VesaDemo <mode>');
        Writeln ('   <mode> = 1 - 640*480*256');
        Writeln ('   <mode> = 2 - 800*600*256');
        Writeln ('   <mode> = 3 -1024*768*256');
        Halt;
    End;
    val (paramstr (1), mode, i);
    If not (mode in [1..3]) then begin
        WriteLn ('Invalid mode number');
        Halt;
    end;
    VbeSetStart;
    VbeSetBank (1);
    buf:=CheckVbeMode (modes [mode]);
    if vesa.error <> 0 then begin
        writeln ('This mode not supported by your hardware');
        halt;
    end;
    SetVbeMode;
    for i := 0 to nbanks [mode] - 1 do begin
        VbeSetBank (i);
        fillchar (buf^, $10000, (i+2)*$12);
    end;

    gotoxy (20+mode*10, 8+mode*4);
    textcolor (lightred);
    writeln ('Press any key');
    repeat until keypressed;
end.
