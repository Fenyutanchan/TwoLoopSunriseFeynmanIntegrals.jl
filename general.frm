#include proc.h

*** 定义一个较大的数，用于do循环
#define N "20"

*** F(a1,a2,a3,m1,m2,m3) = 1/{[k1^2-m1^2]^a1 *[k2^2-m2^2]^a2 *[(k1+k2)^2-m3^2]^a3}
*** F(a1,m1) = 1/(k^2-m1^2)^a1
*** InvDelta(m1,m2,m3) (对应学长ppt中Delta函数的倒数)

CFunction F, InvDelta;
Symbol a1, a2, a3, m1, m2, m3, D, invdelta;

*** 正整数2到100，用于判断指标是否大于等于二
set Pos2ToN: 2,...,100;

Format Mathematica;
Off Statistics;

*** 测试函数
Local I=F(3,3,4,m1,m2,m3);

#call TwoLoopRecursion
#call OneLoopRecursion

.sort
#write <1.out> "%+e" I
.end