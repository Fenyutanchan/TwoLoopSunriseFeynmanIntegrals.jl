** Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
** 
** This software is released under the MIT License.
** https://opensource.org/licenses/MIT


*** 最一般情况，此时在进行IBP计算时涉及到的矩阵行列式的逆det(A)=m2^2*Delta(m1,m2,m3)
*** 所以只要求m2不为0，m1,m3取值任意因此可以包含1/2个传播子质量为0的情况
#procedure GeneralTwoLoopRecursion
    
*** 无标度积分直接等于0
    id F(a1?, a2?, a3?, 0, 0, 0) = 0;

*** 如果m2的位置为0将其他位置的质量替换到m2的位置，真空Sunset积分对于传播子有对称性
*** F(a1,a2,a3,m1,m2,m3) = F(a2,a1,a3,m2,m1,m3) = F(a3,a2,a1,m3,m2,m1)
    id F(a1?, a2?, a3?, m1?, 0, m3?) = F(a1, a3, a2, m1, m3, 0);

    id F(a1?, a2?, a3?, 0, 0, m3?) = F(a1, a3, a2, 0, m3, 0);
    id F(a1?, a2?, a3?, m1?, 0, 0) = F(a2, a1, a3, 0, m1, 0);
*** InvDelta都一样，且每次都做匹配速度比较慢，可以先提出来，而每次IBP中增加的幂次用Symbol invdelta标记，在函数最后在做替换
    id F(a1?,a2?,a3?,m1?,m2?,m3?) = F(a1,a2,a3,m1,m2,m3)*InvDelta(m1,m2,m3);


*** 每次IBP都将a1+a2+a3=nt变为nt-1，所以对nt从大到小进行循环，每个循环中对所有可能的a1,a2,a3的组合进行IBP
*** a1+a2+a3 = nt = N-n = N->4
    #do n = 0,{'N'-4}

*** a2+1=i(2->N-n-2) a1=j(1->N-n-i-1) a3=N-n-i-j
        #do i = 2,{'N'-'n'-2}
            #do j = 1,{'N'-'n'-'i'-1}
                id F('j', 'i', {'N'-'n'-'i'-'j'}, m1?, m2?, m3?) = invdelta /(('i'-1)*m2^2) *(
                    ( 'j'*(m2^2-m3^2)*(m2^2-m1^2+m3^2)+{'N'-'n'-'i'-'j'}*(m2^2-m1^2)*(m1^2+m2^2-m3^2)+D*m2^2*(-m2^2+m1^2+m3^2) ) * F('j', 'i'-1, {'N'-'n'-'i'-'j'}, m1, m2, m3)
                    + 'j'*m1^2*(m2^2-m1^2+m3^2) * ( F('j'+1, 'i'-1, {'N'-'n'-'i'-'j'}-1, m1, m2, m3)-F('j'+1, 'i'-2, {'N'-'n'-'i'-'j'}, m1, m2, m3) )
                    + {'N'-'n'-'i'-'j'}*m3^2*(m1^2+m2^2-m3^2) * ( F('j'-1, 'i'-1, {'N'-'n'-'i'-'j'}+1, m1, m2, m3)-F('j', 'i'-2, {'N'-'n'-'i'-'j'}+1, m1, m2, m3) ) )
                    - F('j', 'i'-1, {'N'-'n'-'i'-'j'}, m1, m2, m3)/m2^2;
            #enddo
            .sort
        #enddo

*** a2=1 a1+1=i(2->N-n-1-1) a3=N-n-i-1
        #do i = 2,{'N'-'n'-2}
            id F('i', 1, {'N'-'n'-'i'-1},m1?, m2?, m3?) = invdelta/('i'-1) *(
                ( 2*{'N'-'n'-'i'-1}*(m1^2-m2^2)+('i'-1)*(m1^2-m2^2-3*m3^2)+D*(m2^2-m1^2+m3^2) ) * F('i'-1, 1, {'N'-'n'-'i'-1}, m1, m2, m3)
                + 2*{'N'-'n'-'i'-1}*m3^2 * ( F('i'-1, 0, {'N'-'n'-'i'-1}+1, m1, m2, m3)-F('i'-2, 1, {'N'-'n'-'i'-1}+1, m1, m2, m3) )
                + ('i'-1)*(m1^2-m2^2+m3^2) * ( F('i', 1, {'N'-'n'-'i'-1}-1, m1, m2, m3)-F('i', 0, {'N'-'n'-'i'-1}, m1, m2, m3) )
            );
        #enddo

*** a1=a2=1 a3>=2
        id F(1, 1, a3?Pos2ToN, m1?, m2?, m3?) = invdelta /(a3-1) *(
            ( (-3*(a3-1)+D)*m1^2 + (-(a3-1)+D-2)*(m2^2-m3^2) )*F(1, 1, a3-1, m1, m2, m3)
            + (a3-1)*(m1^2-m2^2+m3^2) * ( F(0, 1, a3, m1, m2, m3)-F(1, 0, a3, m1, m2, m3) )
            + 2*m1^2 * ( F(2, 0, a3-1, m1, m2, m3)-F(2, 1, a3-2, m1, m2, m3) ) 
        );
    #enddo

*** 将InvDelta替换为表达式
    repeat;
        id InvDelta(m1?, m2?, m3?)*invdelta = InvDelta(m1, m2, m3)/( 2*(m1^2*m2^2+m1^2*m3^2+m2^2*m3^2) - (m1^4+m2^4+m3^4) );
    endrepeat;
    id InvDelta(m1?, m2?, m3?) = 1;
    .sort
#endprocedure


*** 三个传播子都不为0，collinear情况 m1+m2=m3
*** 文章 Recursion-free solution for two-loop vacuum integrals with “collinear” masses 中(2.4)式
*** 由于文章中传播子定义为 1/(k^2+m^2) 每次递推传播子的总幂次会减一，所以文章中递推公式与本程序差一负号
*** 文章中公式设定m3=m1+m2，使用时需将m1+m2替换到第三个位置即F(a1,a2,a3,m1,m2,m1+m2)的形式，程序中没有给出该替换
#procedure NonEqZeroCollinearTwoLoopRecursion
*** a1,a2,a3>=1
    #do i = 1,'N'
        id F(a1?pos_, a2?pos_, a3?pos_, m1?, m2?, m3?) =
            (  (m1*(D+2-a1-a2-a3)+m2*a3-m3*a2) *F(a1-1,a2,a3,m1,m2,m3)
               +(m1*a3+m2*(D+2-a1-a2-a3)-m3*a1) *F(a1,a2-1,a3,m1,m2,m3)
               +(m1*a2+m2*a1-m3*(D+2-a1-a2-a3)) *F(a1,a2,a3-1,m1,m2,m3)
            )  /( 2*m1*m2*m3*(D+3-2*a1-2*a2-2*a3) );
        .sort
    #enddo
#endprocedure



*** m1=0, m2=m3=m
*** 文章 Recursion-free solution for two-loop vacuum integrals with “collinear” masses 中(2.15)式
*** 由于文章中传播子定义为 1/(k^2+m^2) 每次递推传播子的总幂次会减一，所以文章中递推公式与本程序差一负号
*** 文章第一个传播子质量等于0，m2=m3=m
#procedure OneEqZeroCollinearTwoLoopRecursion
*** 将第一个质量设为0
    id F(a1?, a2?, a3?, m1?, 0, m1?) = F(a2, a1, a3, 0, m1, m1);
    id F(a1?, a2?, a3?, m1?, m1?, 0) = F(a3, a2, a1, 0, m1, m1);

*** 只对a1做降阶 a1>=1
    #do i = 1,'N'
        id F(a1?pos_, a2?, a3?, 0, m2?, m2?) = (D-2*(a1-1)-2*a2) *(D-2*(a1-1)-2*a3) *(D-(a1-1)-a2-a3) *F(a1-1, a2, a3, 0, m2, m2) /(
            2*m2^2 *(D-2-2*(a1-1)) *(D-1-2*(a1-1)-a2-a3) *(D-2*(a1-1)-a2-a3));
        .sort
    #enddo
#endprocedure



*** 将两个传播子的两圈积分F(a1,a2,0,m1,m2,m3)变为两个单传播子的乘积F(a1,m1)*F(a2,m2)，并利用单传播子IBP
#procedure OneLoopRecursion
    id F(a1?, a2?, 0, m1?, m2?, m3?) = F(a1, m1)*F(a2, m2);
    id F(a1?, 0, a3?, m1?, m2?, m3?) = F(a1, m1)*F(a3, m3);
    id F(0, a2?, a3?, m1?, m2?, m3?) = F(a2, m2)*F(a3, m3);
*** 无标度积分直接等于0
    id F(a1?, 0) = 0;
    .sort

*** 单传播子IBP  n1=N-n=N->2
    #do n = 0,{'N'-2}
        id F({'N'-'n'}, m1?) = (D-2*{'N'-'n'-1})*F({'N'-'n'-1}, m1)/(2*{'N'-'n'-1}*m1^2);
        .sort
    #enddo
#endprocedure





