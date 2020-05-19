;int array[10] = {10,20,30,40,50,60,70,80,90,100}
;int Mean( int *array, int size, int *mean){
;    *mean = 0;
;    for (int i=0;i<size; i++){
;        mean+=array[i];
;    }
;    *mean /= size;  
;}
;int Variance(int *array, int size, int mean,int *variance){
;    int diff;
;    for (int i=0;i<size; i++){
;        diff=a[i]-average;
;        diff *=diff;
;        *variance += diff;
;    }
;    *variance /=size;
;}
;void main(){  
;    int m;
;    int v;
;
;    mean(array,10,&m);
;    variance(array,10,m,&v);
;    printf("\nMean : %d",m);
;    printf("\nVariance : %d",v);
;}
TITLE Statistical Processing of Integer Array
INCLUDE Irvine32.inc


.data
array SWORD 10,20,30,40,50,60,70,80,90,100
meanmessage		BYTE "Mean : ",0
variancemessage BYTE "Variance : ",0

.code
mean PROC
ret
mean ENDP

variance PROC
ret
variance ENDP

main PROC
	push ebp
	mov ebp,esp
	sub esp,8
	mov [ebp-4], DWORD PTR 0	; initialize m local variable
	mov [ebp-8], DWORD PTR 0	; initialize v local variable

	;int Mean( int *array, int size, int *mean)
	lea edi, [ebp-4]
	push edi
	push LENGTHOF array
	push OFFSET array
	call mean

	mov edx, OFFSET meanmessage
	call WriteString
	call WriteInt
	call Crlf


	;mov eax,...
	;int Variance(int *array, int size, int mean,int *variance)

	lea edi, [ebp-8]
	push edi
	;push eax
	push SDWORD PTR [ebp-4]
	push LENGTHOF array
	push OFFSET array
	call variance

	mov edx, OFFSET variancemessage
	call WriteString
	call WriteInt
	call Crlf


exit
main ENDP
END main 