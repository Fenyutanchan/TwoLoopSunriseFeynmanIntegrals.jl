** Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
** 
** This software is released under the MIT License.
** https://opensource.org/licenses/MIT


*** 对一般情况的两圈Sunset图做IBP
#procedure TwoLoopRecursion
*** InvDelta都一样，且每次都做匹配速度比较慢，可以先提出来，而每次IBP中增加的幂次用Symbol invdelta标记，在函数最后在做替换
    id F(a1?,a2?,a3?,m1?,m2?,m3?) = F(a1,a2,a3,m1,m2,m3)*InvDelta(m1,m2,m3);

*** a1+a2+a3 = nt = N-n = N->4
    #do n = 0,{'N'-4}

*** a1=i(2->N-n-2) a2=j(1->N-n-i-1) a3=N-n-i-j
        #do i = 2,{'N'-'n'-2}
            #do j = 1,{'N'-'n'-'i'-1}
                id F('i', 'j', {'N'-'n'-'i'-'j'}, m1?, m2?, m3?) = invdelta /(('i'-1)*m1^2) * (
                    ( 'j'*(m1^2-m3^2)*(m1^2-m2^2+m3^2) +{'N'-'n'-'i'-'j'}*(m1^2-m2^2)*(m1^2+m2^2-m3^2) +D*m1^2*(-m1^2+m2^2+m3^2) ) *F('i'-1, 'j', {'N'-'n'-'i'-'j'}, m1, m2, m3)
                    +'j'*m2^2*(m1^2-m2^2+m3^2)*(F('i'-1, 'j'+1, {'N'-'n'-'i'-'j'}-1, m1, m2, m3)-F('i'-2, 'j'+1, {'N'-'n'-'i'-'j'}, m1, m2, m3))
                    +{'N'-'n'-'i'-'j'}*m3^2*(m1^2+m2^2-m3^2)*(F('i'-1, 'j'-1, {'N'-'n'-'i'-'j'}+1, m1, m2, m3)-F('i'-2, 'j', {'N'-'n'-'i'-'j'}+1, m1, m2, m3))
                    ) -F('i'-1,'j',{'N'-'n'-'i'-'j'},m1, m2, m3)/m1^2;
                .sort
            #enddo
        #enddo

*** a1=1 a2=i(2->N-n-1-1) a3=N-n-i-1
        #do i = 2,{'N'-'n'-2}
            id F(1, 'i', {'N'-'n'-'i'-1}, m1?, m2?, m3?) = invdelta /( ('i'-1)*m2^2 ) *(
                (1*(m2^2-m3^2)*(m2^2-m1^2+m3^2)+{'N'-'n'-'i'-1}*(m2^2-m1^2)*(m1^2+m2^2-m3^2)+D*m2^2*(-m2^2+m1^2+m3^2))*F(1, {'i'-1}, {'N'-'n'-'i'-1}, m1, m2, m3)
                +1*m1^2*(m2^2-m1^2+m3^2)*(F(1+1, 'i'-1, {'N'-'n'-'i'-1}-1, m1, m2, m3)-F(1+1, 'i'-2, {'N'-'n'-'i'-1}, m1, m2, m3))
                +{'N'-'n'-'i'-1}*m3^2*(m1^2+m2^2-m3^2)*(F(1-1, 'i'-1, {'N'-'n'-'i'-1}+1, m1, m2, m3 )-F(1, 'i'-2, {'N'-'n'-'i'-1}+1, m1, m2, m3 )))-F(1, 'i'-1, {'N'-'n'-'i'-1}, m1, m2, m3)/m2^2;
        #enddo

*** a1=a2=1 a3>=2
        id F(1, 1, a3?Pos2ToN, m1?, m2?, m3?) = invdelta /((a3-1)*m3^2) *(
            ( 1*(m3^2-m1^2)*(m3^2-m2^2+m1^2)+1*(m3^2-m2^2)*(m3^2+m2^2-m1^2)+D*m3^2*(-m3^2+m2^2+m1^2))*F(1, 1, a3-1, m1, m2, m3)
            +1*m2^2*(m3^2-m2^2+m1^2)*(F(1-1, 1+1, a3-1, m1, m2, m3)-F(1, 1+1, a3-2, m1, m2, m3))
            +1*m1^2*(m3^2+m2^2-m1^2)*(F(1+1, 1-1, a3-1, m1, m2, m3)-F(1+1, 1, a3-2, m1, m2, m3))
            ) -F(1, 1, a3-1, m1, m2, m3)/m3^2;

    #enddo

*** 将InvDelta替换为表达式
    repeat;
        id InvDelta(m1?, m2?, m3?)*invdelta = InvDelta(m1, m2, m3)/( 2*(m1^2*m2^2+m1^2*m3^2+m2^2*m3^2) - (m1^4+m2^4+m3^4) );
    endrepeat;
    id InvDelta(m1?, m2?, m3?) = 1;
    .sort
#endprocedure


*** 对colinear情况做IBP
#procedure ColinearTwoLoopRecursion
*** a1,a2,a3>=1
*** 因度规差一负号，所以与PPT中递推关系式也差一负号
    #do i = 1,'N'
        id F(a1?pos_, a2?pos_, a3?pos_, m1?, m2?, m3?) =
            (  (m1*(D+2-a1-a2-a3)+m2*a3-m3*a2) *F(a1-1,a2,a3,m1,m2,m3)
               +(m1*a3+m2*(D+2-a1-a2-a3)-m3*a1) *F(a1,a2-1,a3,m1,m2,m3)
               +(m1*a2+m2*a1-m3*(D+2-a1-a2-a3)) *F(a1,a2,a3-1,m1,m2,m3)
            )  /( 2*m1*m2*m3*(D+3-2*a1-2*a2-2*a3) );
        .sort
    #enddo
#endprocedure


*** 将单圈F(a1,a2,0,m1,m2,m3)变为F(a1,m1)*F(a2,m2)，并利用单传播子IBP
#procedure OneLoopRecursion
    id F(a1?, a2?, 0, m1?, m2?, m3?) = F(a1, m1)*F(a2, m2);
    id F(a1?, 0, a3?, m1?, m2?, m3?) = F(a1, m1)*F(a3, m3);
    id F(0, a2?, a3?, m1?, m2?, m3?) = F(a2, m2)*F(a3, m3);
    .sort

    repeat;
        id F(a1?Pos2ToN, m1?) = (D-2*(a1-1)) *F(a1-1,m1) /(2*(a1-1)*m1^2);
    endrepeat;
    .sort
#endprocedure

