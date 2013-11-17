FUNCTION BOX_AVERAGE,arr,DATA,BIN=BIN

if not keyword_set(bin) then bin=5.

avg=[]

nn=long(ceil(arr[n_elements(arr)-1]/bin))

for i=1,nn-1 do begin
   ind=where((arr ge (i-1)*bin) and (arr lt i*bin) )
   avg=[avg,mean(data(ind))]
endfor

RETURN,AVG
END
