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
	;prologue
	push ebp
	mov ebp,esp
	push edi
	push esi

	;int Mean( int *array, int size, int *mean)
	mov edi, [ebp+8]			; loop initialization : Store array address to edi
	mov esi, 0					; loop initialization : Select esi as the loop counte and initialize it
	mov eax, 0					; loop initialization : Select eax as accumulator and initialize it
	jmp cond
lp: 
	add ax, [edi + 2*esi]		; loop body : add current array element to the sum
	inc esi						; step		: increament loop counter
cond: cmp esi, [ebp+12]			; condition : compare loop counter with the length of the array
	  jl lp						; condition : continue iteration if counter is less than length of array 

	; division : we select the 32-bit version of the idiv instruction i.e. the
	; one that takes a 32-bit divisor as operand. Thus we will need to use the 
	; EDX:EAX combination to store the divident
	movsx eax,ax				; we sign extend the ax into eax register 
	cdq							; we sign extend the eax into the edx register
	idiv SDWORD PTR [ebp+12]	; we execute the 32-bit version of idiv instruction

	; return mean into the pass by reference parameter
	mov edi, [ebp+16]			; store the address of the pass by reference variable into edi
	mov [edi],eax				; store the mean value into the address of the pass by reference parameter 

	;epilogue
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret 12
mean ENDP

variance PROC
	push ebp
	mov ebp,esp
	push edi
	push esi
	push ebx
	push edx

	;int Variance(int *array, int size, int mean,int *variance)
	mov edi, [ebp+8]		; loop initialization : Store array address to edi
	mov esi, 0				; loop initialization : Select esi as the loop counte and initialize it
	mov eax, 0				; loop initialization : Select eax as accumulator and initialize it
	mov ebx, [ebp+16]		; loop initialization : Store the mean value passed as argument to ebx register 
	jmp cond
lp:
	movsx edx, SWORD PTR [edi+esi*2]	;loop body :fetch the array element for current iteration into edx register
	sub edx,ebx							;loop body :subtract the mean value from the value of the currentl array element
	imul edx,edx						;loop body :evaluate the square of the difference
	add eax,edx							;loop body :add the square of difference to the sum of squares of differences
	inc esi								; step		: increament loop counter
cond : cmp esi, [ebp+12]	; condition : compare loop counter with the length of the array
		jl lp				; condition : continue iteration if counter is less than length of array 

	; division : we select the 32-bit version of the idiv instruction i.e. the
	; one that takes a 32-bit divisor as operand. Thus we will need to use the 
	; EDX:EAX combination to store the divident
	cdq							; we sign extend the eax into the edx register
	idiv SDWORD PTR [ebp+12]	; we execute the 32-bit version of idiv instruction

	mov edi,[ebp+20]		; store the address of the pass by reference variable into edi
	mov [edi], eax			; store the variance value into the address of the pass by reference parameter

	pop edx
	pop ebx
	pop esi
	pop edi
	mov esp,ebp
	pop ebp
	ret	16
variance ENDP

main PROC
	; prologue
	push ebp
	mov ebp,esp
	sub esp,8
	mov [ebp-4], DWORD PTR 0	; initialize m local variable
	mov [ebp-8], DWORD PTR 0	; initialize v local variable

	;int Mean( int *array, int size, int *mean)
	lea edi, [ebp-4]			; store the m variable address into edi
	push edi					; push the m variable's address into the stack frame
	push LENGTHOF array			; push the length of the array into the stack frame
	push OFFSET array			; push the address of the array into the stack frame
	call mean					; call mean function 

	; print the result to the screen
	mov edx, OFFSET meanmessage 
	call WriteString
	call WriteInt
	call Crlf


	;mov eax,...
	;int Variance(int *array, int size, int mean,int *variance)

	lea edi, [ebp-8]			; store the v variable address into edi
	push edi					; push the v variable's address into the stack frame
	;push eax
	push SDWORD PTR [ebp-4]		; push the m variable's value into the stack frame
	push LENGTHOF array			; push the length of the array into the stack frame
	push OFFSET array			; push the address of the array into the stack frame
	call variance				; call variance function

	; print the result to the screen
	mov edx, OFFSET variancemessage
	call WriteString
	call WriteInt
	call Crlf


exit
main ENDP
END main 