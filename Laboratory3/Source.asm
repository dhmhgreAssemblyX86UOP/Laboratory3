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

.code
mean PROC
ret
mean ENDP

variance PROC
ret
variance ENDP

main PROC
exit
main ENDP
END main 