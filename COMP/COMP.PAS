UNIT Comp;

INTERFACE

    TYPE CReal = Extended;

    TYPE Complex = RECORD re, im: CReal END;

    FUNCTION Compl_RR (CONST re, im: CReal): Complex;
    FUNCTION Compl_R  (CONST re    : CReal): Complex;
    OVERLOAD Complex = Compl_RR;
    OVERLOAD Complex = Compl_R ;
    FUNCTION Conj  (CONST z: Complex): Complex;

    FUNCTION add_cc (CONST a: Complex; CONST b: Complex): Complex; OVERLOAD +  = add_cc;
    FUNCTION add_cr (CONST a: Complex; CONST b: CReal  ): Complex; OVERLOAD +  = add_cr;
    FUNCTION add_rc (CONST a: CReal  ; CONST b: Complex): Complex; OVERLOAD +  = add_rc;
    FUNCTION sub_cc (CONST a: Complex; CONST b: Complex): Complex; OVERLOAD -  = sub_cc;
    FUNCTION sub_cr (CONST a: Complex; CONST b: CReal  ): Complex; OVERLOAD -  = sub_cr;
    FUNCTION sub_rc (CONST a: CReal  ; CONST b: Complex): Complex; OVERLOAD -  = sub_rc;
    FUNCTION mul_cc (CONST a: Complex; CONST b: Complex): Complex; OVERLOAD *  = mul_cc;
    FUNCTION mul_cr (CONST a: Complex; CONST b: CReal  ): Complex; OVERLOAD *  = mul_cr;
    FUNCTION mul_rc (CONST a: CReal  ; CONST b: Complex): Complex; OVERLOAD *  = mul_rc;

    PROCEDURE addab_cc (VAR a: Complex; CONST b: Complex); OVERLOAD +:=  = addab_cc;
    PROCEDURE addab_cr (VAR a: Complex; CONST b: CReal  ); OVERLOAD +:=  = addab_cr;
    PROCEDURE subab_cc (VAR a: Complex; CONST b: Complex); OVERLOAD -:=  = subab_cc;
    PROCEDURE subab_cr (VAR a: Complex; CONST b: CReal  ); OVERLOAD -:=  = subab_cr;
    PROCEDURE mulab_cc (VAR a: Complex; CONST b: Complex); OVERLOAD *:=  = mulab_cc;
    PROCEDURE mulab_cr (VAR a: Complex; CONST b: CReal  ); OVERLOAD *:=  = mulab_cr;

    FUNCTION  eq_cc (CONST a: Complex; CONST b: Complex): Boolean; OVERLOAD =  =  eq_cc;
    FUNCTION  eq_cr (CONST a: Complex; CONST b: CReal  ): Boolean; OVERLOAD =  =  eq_cr;
    FUNCTION  eq_rc (CONST a: CReal  ; CONST b: Complex): Boolean; OVERLOAD =  =  eq_rc;
    FUNCTION  ne_cc (CONST a: Complex; CONST b: Complex): Boolean; OVERLOAD <> =  ne_cc;
    FUNCTION  ne_cr (CONST a: Complex; CONST b: CReal  ): Boolean; OVERLOAD <> =  ne_cr;
    FUNCTION  ne_rc (CONST a: CReal  ; CONST b: Complex): Boolean; OVERLOAD <> =  ne_rc;

IMPLEMENTATION

    FUNCTION Compl_RR;
        BEGIN
            result.re := re;
            result.im := im
        END;
        

    FUNCTION Compl_R;
        BEGIN
            result.re := re;
            result.im := 0
        END;
        
    FUNCTION Conj;
        WITH result DO BEGIN
            re := z.re;
            im :=-z.im
        END;

    FUNCTION add_cc;
        WITH result DO BEGIN
            re := b.re + a.re;
            im := a.im + b.im
        END;

    FUNCTION add_cr;
        WITH result DO BEGIN
            re := b + a.re;
            im :=     a.im;
        END;

    FUNCTION add_rc;
        WITH result DO BEGIN
            re := a + b.re;
            im :=     b.im;
        END;

    FUNCTION sub_cc;
        WITH result DO BEGIN
            re := a.re - b.re;
            im := a.im - b.im
        END;

    FUNCTION sub_cr;
        WITH result DO BEGIN
            re := a.re - b;
            im := a.im;
        END;

    FUNCTION sub_rc;
        WITH result DO BEGIN
            re := a - b.re;
            im :=   - b.im;
        END;

    FUNCTION mul_cc;
        WITH result DO BEGIN
            re := a.re*b.re - a.im*b.im;
            im := a.re*b.im + a.im*b.re
        END;

    FUNCTION mul_cr;
        WITH result DO BEGIN
            re := b * a.re;
            im := b * a.im;
        END;

    FUNCTION mul_rc;
        WITH result DO BEGIN
            re := a * b.re;
            im := a * b.im;
        END;


    PROCEDURE addab_cc;
        WITH a DO BEGIN
            re +:= b.re;
            im +:= b.im
        END;

    PROCEDURE addab_cr; a.re +:= b;

    PROCEDURE subab_cc;
        WITH a DO BEGIN
            re -:= b.re;
            im -:= b.im
        END;

    PROCEDURE subab_cr; a.re -:= b;

    PROCEDURE mulab_cc;
        VAR c: Complex;
        WITH c DO BEGIN
            re := a.re*b.re - a.im*b.im;
            im := a.re*b.im + a.im*b.re;
            a := c
        END;

    PROCEDURE mulab_cr;
        WITH a DO BEGIN
            re *:= b;
            im *:= b;
        END;

    FUNCTION eq_cc; result := (a.re  = b.re) AND (a.im =  b.im);
    FUNCTION eq_cr; result := (a.re  = b   ) AND (a.im =     0);
    FUNCTION eq_rc; result := (a     = b.re) AND (b.im =     0);
    FUNCTION ne_cc; result := (a.re <> b.re) OR  (a.im <> b.im);
    FUNCTION ne_cr; result := (a.re <> b   ) OR  (a.im <>    0);
    FUNCTION ne_rc; result := (a    <> b.re) OR  (b.im <>    0);

END.