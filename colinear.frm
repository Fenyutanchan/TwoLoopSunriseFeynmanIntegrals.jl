#include proc.h

#define N "20"
***N>a1+a2+a3

Format mathematica;
Off Statistics;

CFunction F, Inv;
Symbol a1, a2, a3, m1, m2, m3, D;
set Pos2ToN: 2,...,100;

Local I=F(5,2,3,m1,m2,m1+m2);

#call ColinearTwoLoopRecursion
#call OneLoopRecursion

.sort
#write <1.out> "%e" I
.end