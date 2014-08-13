{ About Dialog Handler }

unit about;
interface

uses Os2Types, os2PmApi;

const

 DB_RAISED     =  $0400;
 DB_DEPRESSED  =  $0800;

procedure DisplayAbout (hwnd: HWND; pszAppName: Pchar {PSZ});

implementation

{ ----------------------  Dialog Function ----------------------- }

function AboutDlgProc conv arg_cdecl (hWnd: HWND; msg: ULONG; mp1, mp2: MPARAM): Mresult;
  var
    bHandled: boolean;
    mReturn: MRESULT;
    ulScrWidth, ulScrHeight: ulong;
    Rectl: os2types.Rectl;
    Swp: os2pmapi.swp;
    hps: os2types.HPS;
begin
    bHandled := TRUE;
    mReturn  := 0;

    case msg of
       WM_INITDLG:
          begin
            { Center dialog on screen }
            ulScrWidth  := WinQuerySysValue (HWND_DESKTOP, SV_CXSCREEN);
            ulScrHeight := WinQuerySysValue (HWND_DESKTOP, SV_CYSCREEN);
            WinQueryWindowRect (hWnd, Rectl);
            WinSetWindowPos (hWnd, HWND_TOP, (ulScrWidth-Rectl.xRight) div 2,
                (ulScrHeight-Rectl.yTop) div 2, 0, 0, SWP_MOVE + SWP_ACTIVATE);

            { Set application title }
            WinSetDlgItemText (hWnd, 10001, Pchar (mp2));
          end;

       WM_PAINT:
          begin
            hps := WinBeginPaint (hWnd,0,nil);
            WinQueryWindowRect (hWnd, Rectl);
            WinFillRect (hps, Rectl, CLR_PALEGRAY);
            WinDrawBorder (hps, Rectl,
                WinQuerySysValue(HWND_DESKTOP,SV_CXDLGFRAME),
                WinQuerySysValue(HWND_DESKTOP,SV_CYDLGFRAME),
                CLR_DARKGRAY, CLR_WHITE, DB_RAISED);
            declare
               var p: pointl;
            begin
               p.x := rectl.xleft;
               p.y := rectl.ybottom;
               GpiMove (hps, p);
            end;
            Inc (Rectl.xRight);
            Inc (Rectl.yTop);
            declare
              var p: pointl;
            begin
              p.x := rectl.xright;
              p.y := rectl.ytop;
              GpiBox (hps, DRO_OUTLINE, p, 0, 0);
            end;
            WinQueryWindowPos (WinWindowFromID (hWnd, 10002), Swp);
            Rectl.xLeft   := Swp.x-1;
            Rectl.yBottom := Swp.y-1;
            Rectl.xRight  := Swp.x + Swp.cx + 1;
            Rectl.yTop    := Swp.y + Swp.cy + 1;
            WinDrawBorder (hps, Rectl, 1, 1,
                CLR_DARKGRAY, CLR_WHITE, DB_DEPRESSED);
            WinQueryWindowPos (WinWindowFromID (hWnd, 10003), Swp);
            Rectl.xLeft    := Swp.x-1;
            Rectl.yBottom  := Swp.y-1;
            Rectl.xRight   := Swp.x + Swp.cx + 1;
            Rectl.yTop     := Swp.y + Swp.cy + 1;
            WinDrawBorder (hps, Rectl, 1, 1,
                CLR_DARKGRAY, CLR_WHITE, DB_DEPRESSED);
            WinEndPaint (hps);
          end;

       WM_COMMAND:
          WinDismissDlg (hWnd, DID_OK);

       else
            bHandled := FALSE;
    end;

    if not bHandled then
        mReturn := WinDefDlgProc (hWnd, msg, mp1, mp2);

    result  := mReturn;
end;

procedure DisplayAbout (hwnd: HWND; pszAppName: Pchar);
begin
    WinDlgBox (HWND_DESKTOP, hWnd, @AboutDlgProc, 0, 10000, pszAppName);
    --return;
end;

end.
