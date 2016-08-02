.586P
.MODEL FLAT, stdcall
include graph2.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\gdi32.lib
includelib C:\masm32\lib\gdiplus.lib

_DATA SEGMENT
	schet	DD 0
	funX	real4	899.0
	funXX	dd 800
	FFX	dd 0
	FFY dd 0
	funY	dd	0
	funX1	dd 800
	funY1	dd	0
	bbf		dd	0
	buff	real4	0.0
	buff2	real4	0.0
	buff3	real4	0.0
	buf		real4	-12.0
	buf1	real4	5.0
	buf2	real4	23.0
	buf3	real4	15.0
	buf4	real4	7.0
	buf5	real4	13.0
	buff5	real4	10.0
	schet1	real4	-0.29
	sbros	real4	-0.29
	const1	real4	0.01
	TEXT1	DB ' ',0
	TEXT2	DB 'MESSAGE111',0
	NEWHWND	DWORD 0
	MSG	MSGSTRUCT <?>
	WC	WNDCLASS <?>
	PNT	PAINTSTR <?>
	HINST	DD 0
	TITLENAME DB 'Kontrolnaya Kashtanov N.N. Var 1',0
	NAM	DB 'CLASS32',0
	CPBUT	DB 'start',0
	CLSBUTN DB 'BUTTON',0
	HDC	DD ?	
	HWNDBTN DWORD 0
	GDIPLUS1 DD 1
		DD 0
		DD 0
		DD 0
	GDIPLUS2 DD 0
	VAR1	DD 0
	VAR2	DD 0
	VAR3	DD 0
		DD 0
	VAR4	DD 0
	VAR5	DD 0
	FL	DD 0.3e1
	NFILE	db 62h, 0, 6Fh, 0, 6Fh, 0, 6Bh, 0
		    db 2Eh, 0, 6Ah, 0, 70h, 0, 67h, 0, 0, 0
_DATA ENDS

_TEXT SEGMENT
START:
	PUSH 0
	PUSH OFFSET GDIPLUS1
	PUSH OFFSET GDIPLUS2
	CALL GdiplusStartup@12
	PUSH 0
	CALL GetModuleHandleA@4
	MOV HINST, EAX
REG_CLASS:
	MOV WC.CLSSTYLE,stylcl
;message
	MOV WC.CLSLPFNWNDPROC, OFFSET WNDPROC
	MOV WC.CLSCBCLSEXTRA,0
	MOV WC.CLSCBCLSEXTRA,0
	MOV EAX,HINST
	MOV WC.CLSHINSTANCE,EAX
;pinc wind
	PUSH IDI_APPLICATION
	PUSH 0
	CALL LoadIconA@8
	MOV [WC.CLSHICON],EAX
;----
	PUSH IDC_CROSS
	PUSH 0
	CALL LoadCursorA@8
	MOV WC.CLSHCURSOR,EAX
;-----
	PUSH RGBW
	CALL CreateSolidBrush@4
	MOV WC.CLSHBRBACKGROUND,EAX
	MOV DWORD PTR WC.MENNAME,0
	MOV DWORD PTR WC.CLSNAME, OFFSET NAM
	PUSH OFFSET WC
	CALL RegisterClassA@4
;create wind class
	PUSH 0
	PUSH HINST
	PUSH 0
	PUSH 0
	PUSH DY0	;HIGT WIND
	PUSH DX0
	PUSH 100
	PUSH 200
	PUSH WS_OVERLAPPEDWINDOW
	PUSH OFFSET TITLENAME
	PUSH OFFSET NAM
	PUSH 0
	CALL CreateWindowExA@48
	CMP EAX,0
	JZ _ERR
	MOV NEWHWND, EAX
;-----
	PUSH SW_SHOWNORMAL
	PUSH NEWHWND
	CALL ShowWindow@8
;------
	PUSH NEWHWND
	CALL UpdateWindow@4
;
MSG_LOOP:
	PUSH 0
	PUSH 0
	PUSH 0
	PUSH OFFSET MSG
	CALL GetMessageA@16
	CMP AX,0
	JE END_LOOP
	PUSH OFFSET MSG
	CALL TranslateMessage@4
	PUSH OFFSET MSG
	CALL DispatchMessageA@4
	JMP MSG_LOOP
END_LOOP:
;
PUSH GDIPLUS2
CALL GdiplusShutdown@4
PUSH MSG.MSWPARAM
CALL ExitProcess@4
_ERR:
JMP END_LOOP
;
WNDPROC PROC
	PUSH EBP
	MOV EBP,ESP
	PUSH EBX
	PUSH ESI
	PUSH EDI
	CMP DWORD PTR [EBP+0CH],WM_DESTROY
	JE WMDESTROY
	CMP DWORD PTR [EBP+0CH],WM_CREATE
	JE WMCREATE
	CMP DWORD PTR [EBP+0CH],WM_PAINT
	JE WMPAINT
	CMP DWORD PTR [EBP+0CH],WM_COMMAND
	JE WMCOMMAND		
	JMP DEFWNDPROC
WMCOMMAND:
	CALL GDIPLUSPAINT
	finit
	mov schet,0
	mov funXX,800
	mov funY,0
	mov funX1,800
	mov funY1,0
	fld sbros
	fstp schet1
	MOV EAX,0
	JMP FINISH
WMPAINT:
	MOV EAX,0
	JMP FINISH
WMCREATE:
;;;;;;
	PUSH 0
	PUSH [HINST]
	PUSH 0
	PUSH DWORD PTR [EBP+08H]
	PUSH 20
	PUSH 60
	PUSH 10
	PUSH 10
	PUSH STYLBTN
	PUSH OFFSET CPBUT
	PUSH OFFSET CLSBUTN
	PUSH 0
	CALL CreateWindowExA@48
	MOV HWNDBTN,EAX	
;;;;;;;;;	
	PUSH DWORD PTR [EBP+08H]
	CALL GetDC@4
	MOV HDC,EAX
	MOV EAX,0
	JMP FINISH
DEFWNDPROC:
	PUSH DWORD PTR [EBP+14H]
	PUSH DWORD PTR [EBP+10H]
	PUSH DWORD PTR [EBP+0CH]
	PUSH DWORD PTR [EBP+08H]
	CALL DefWindowProcA@16
	JMP FINISH
WMDESTROY:
	PUSH HDC
	PUSH DWORD PTR [EBP+08H]
	CALL ReleaseDC@8
	PUSH 0
	CALL PostQuitMessage@4
	MOV EAX,0
FINISH:
	POP EDI
	POP ESI
	POP EBX
	POP EBP
	RET 16
WNDPROC ENDP

;GDI+
GDIPLUSPAINT PROC
ME:
cmp schet, 58
jge m11
	PUSH OFFSET VAR1
	PUSH HDC
	CALL GdipCreateFromHDC@8
;pero
	MOV ECX,FL
	PUSH OFFSET VAR2
	PUSH 0
	PUSH ECX
	push 0CC000099h ;color per
	CALL GdipCreatePen1@16
;;;;;;;;
;;;;;;;	
PUSH OFFSET VAR3
PUSH 0FF00F0FFh
CALL GdipCreateSolidFill@8
;;;;;;;;
mov eax,funY
sub eax,4
mov FFY,eax
mov eax,funXX
sub eax,4
mov FFX,eax
;;;;;;
PUSH 11
PUSH 11
PUSH FFX
PUSH FFY
PUSH VAR3
PUSH VAR1
CALL GdipFillEllipseI@24
;;;;;;;;;
;;;;;;;;;
;line paint
	PUSH funXX ;X
	PUSH funY ;Y 
	PUSH funX1
	PUSH funY1
	PUSH VAR2	;descrip pen
	PUSH VAR1	; indef obj GDI
	CALL GdipDrawLineI@24
;;;;;;;;
mov eax,funXX
mov funX1,eax
mov eax,funY
mov funY1,eax
add funY,20
;;;;;;;
finit
;;;;;;;
fld schet1
fmul schet1
fmul schet1
fmul schet1
fmul buf
fstp buff
;;;;;;;;
fld schet1
fmul schet1
fmul schet1
fmul buf1
fstp buff2
;;;;;;;;;
fld buff
fadd buff2
fsub buf2
fstp buff
;;;;;;;;;
fld schet1
fmul buf5
fstp buff2
fld schet1
fmul schet1
fmul schet1
fstp buff3
fld buff2
fsub buff3
fstp buff2
;;;;;; ? ? ??????? ?
  fld     buff2
   fldl2e
   fmul
   fld     st
   frndint
   fsub    st(1), st
   fxch    st(1)
   f2xm1
   fld1
   fadd
   fscale
   fstp    buff2
;;;;;;;
fld buff
fdiv buff2
fstp buff
;;;;;;;
fld schet1
fmul schet1
fstp buff2
;;;;log
	fldlg2
	fld buff2
	fyl2x
	fstp    buff2
;;;;;;;
fldpi
fmul buf3
fdiv buf4
fstp buff3
;;;;;;;
fld buff2
fsub buff3
fstp buff2
;;;;;; cos
 fld     buff2
 fcos
 fstp buff2
;;;;;
fld buff
fmul buff2
frndint
fstp funX
;;;;;;
fld funX
fmul buf1
fistp dword ptr funXX
;;;;;
mov eax,500
sub eax,funXX
mov funXX,eax
;;;;;
inc schet
fld const1
fadd schet1
fstp schet1


PUSH OFFSET VAR4
PUSH OFFSET NFILE
CALL GdipLoadImageFromFile@8
PUSH 10
PUSH 500
PUSH VAR4
PUSH VAR1
CALL GdipDrawImageI@16
; destroy elem
PUSH VAR4
CALL GdipDisposeImage@4
PUSH VAR3
CALL GdipDeleteBrush@4
	PUSH VAR2
	CALL GdipDeletePen@4
	PUSH VAR1
	CALL GdipDeleteGraphics@4	
cmp schet, 58
jle ME
m11:
RET
GDIPLUSPAINT ENDP
_TEXT ENDS
END START