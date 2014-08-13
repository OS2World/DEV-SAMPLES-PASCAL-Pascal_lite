{ $r skeleton.res}              {$r-}

uses Os2Types, os2pmApi, About;

type
  FnWp = function conv arg_cdecl (hWnd: HWnd; Msg: ULong; Mp1,Mp2: MParam): MResult;

{$i skeleton.inc}      
{$r skeleton.res} { $r-}

type PMSkeleton = object
                     hab:           hab;
                     hmq:           hmq;
                     flFrameFlags:  ulong;
                     szClientClass: pchar;
                     hWndFrame:     hwnd;
                     hWndClient:    hwnd;
                     qmsg:          qmsg;
                     szTitle:       array [0..64] of char;
                     --pragma Calling_Convention(CallConv.C);
                     ClientWndProc: FnWp; { function (hWnd: hWnd; msg: ulong; mp1: mparam; mp2: mparam): mresult;}
                     --pragma Calling_Convention();

                     constructor Init (flags: ULONG; ClientClass: Pchar; Id: ulong; Cproc: FnWp);
                     procedure   MainLoop; virtual;
                     destructor  Done; virtual;

                  end;

constructor PMSkeleton.Init (flags: ULONG; ClientClass: Pchar; Id: ulong; Cproc: FnWp);
begin
    flFrameFlags := flags;
    hab := WinInitialize (0);
    hmq := WinCreateMsgQueue (hab, 0);
    if hmq = 0 then Halt (1001);
    szClientClass := ClientClass;
    ClientWndProc := Cproc;

    WinRegisterClass (hab, szClientClass, @ClientWndProc, 0, 0);
    WinLoadString (hab, 0, Id, sizeof(szTitle), szTitle);

    hWndFrame := WinCreateStdWindow (HWND_DESKTOP, WS_VISIBLE,
        flFrameFlags, szClientClass, szTitle, 0, 0, Id, hWndClient);
end;

procedure PMSkeleton.MainLoop;
begin
    while WinGetMsg (hab, qmsg, 0, 0, 0) <> 0 do
        WinDispatchMsg (hab, qmsg);
end;

destructor PMSkeleton.Done;
begin
    WinDestroyWindow (hWndFrame);
    WinDestroyMsgQueue (hmq);
    WinTerminate (hab);
    { return (0); }
end;

var Appl: PMSkeleton;

function ClientWndProc conv arg_cdecl (hWnd: hWnd; msg: ulong; mp1, mp2: mparam): mresult;

   var vhps: hps;
       bHandled: boolean;
       mReturn: mresult;
begin
    bHandled := TRUE;
    mReturn  := 0;

    case msg of
       WM_PAINT:
          begin
             vhps := WinBeginPaint (hWnd,0, prectl(0));
             WinEndPaint (vhps);
          end;

       WM_ERASEBACKGROUND:
          mReturn := 1;

       WM_COMMAND:
          if mp1 = IDM_ABOUT then
                 DisplayAbout (hWnd, Appl.szTitle);
       else
          bHandled := FALSE;
    end;

    if not bHandled then
        mReturn := WinDefWindowProc (hWnd, msg, mp1, mp2);

    result := mReturn;
end;

begin
  Appl.Init (FCF_TITLEBAR + FCF_SYSMENU + FCF_SIZEBORDER +
             FCF_MINMAX   + FCF_SHELLPOSITION + FCF_TASKLIST +
             FCF_ICON     + FCF_MENU, 'Client',
             Id_appname,
             ClientWndProc
            );
  Appl.MainLoop;
  Appl.Done;
end.
