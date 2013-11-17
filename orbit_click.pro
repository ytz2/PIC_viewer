;Click the mouse and get the line arrays


PRO ORBIT_CLICK,xvalue=xvalue,yvalue=yvalue

!mouse.button=1
xx=[] & yy=[]
CURSOR,X1,Y1,/down
xx=[xx,X1]
yy=[yy,y1]
PRINT, 'Draw Orbit'
PRINT,'Position:',x1,y1
WHILE(!MOUSE.BUTTON NE 4) DO BEGIN
   CURSOR,X,Y,WAIT,/down
   IF !MOUSE.BUTTON EQ 1 THEN $
      PRINT,'Position:',x,y       
   plots,[X1,X],[Y1,Y]
   xx=[xx,X]
   yy=[yy,y]
   x1=x
   y1=y        
ENDWHILE

xvalue=xx
yvalue=yy
print,xvalue
print,yvalue
END


