*** 这个函数可以直接做IBP但速度慢
*** 第一个替换 a1>=2, a2,a3>=1 第二个替换 a2>=2, a1,a3>=1 第三个替换 a3>=2, a1,a2>=1 
#procedure Recursion
    id F(a1?,a2?,a3?,m1?,m2?,m3?) = F(a1,a2,a3,m1^2,m2^2,m3^2);

    repeat;
        id F(a1?Pos2ToN, a2?pos_, a3?pos_, m12?, m22?, m32?) = InvDelta(m12, m22, m32) /((a1-1)*m12) * (
            ( a2*(m12-m32)*(m12-m22+m32) +a3*(m12-m22)*(m12+m22-m32) +D*m12*(-m12+m22+m32) ) *F(a1-1, a2, a3, m12, m22, m32)
            +a2*m22*(m12-m22+m32)*(F(a1-1, a2+1, a3-1, m12, m22, m32)-F(a1-2, a2+1, a3, m12, m22, m32))
            +a3*m32*(m12+m22-m32)*(F(a1-1, a2-1, a3+1, m12, m22, m32)-F(a1-2, a2, a3+1, m12, m22, m32))
            ) -F(a1-1,a2,a3,m12,m22,m32)/m12;

        id F(a1?pos_, a2?Pos2ToN, a3?pos_, m12?, m22?, m32?) = InvDelta(m12, m22, m32) /((a2-1)*m22) * (
            ( a1*(m22-m32)*(m22-m12+m32) +a3*(m22-m12)*(m12+m22-m32) +D*m22*(-m22+m12+m32) ) *F(a1, a2-1, a3, m12, m22, m32)
            +a1*m12*(m22-m12+m32)*(F(a1+1, a2-1, a3-1, m12, m22, m32)-F(a1+1, a2-2, a3, m12, m22, m32))
            +a3*m32*(m12+m22-m32)*(F(a1-1, a2-1, a3+1, m12, m22, m32)-F(a1, a2-2, a3+1, m12, m22, m32))
            ) -F(a1,a2-1,a3,m12,m22,m32)/m22;

        id F(a1?pos_, a2?pos_, a3?Pos2ToN, m12?, m22?, m32?) = InvDelta(m12, m22, m32) /((a3-1)*m32) * (
            ( a2*(m32-m12)*(m32-m22+m12) +a1*(m32-m22)*(m32+m22-m12) +D*m32*(-m32+m22+m12) ) *F(a1, a2, a3-1, m12, m22, m32)
            +a2*m22*(m32-m22+m12)*(F(a1-1, a2+1, a3-1, m12, m22, m32)-F(a1, a2+1, a3-2, m12, m22, m32))
            +a1*m12*(m32+m22-m12)*(F(a1+1, a2-1, a3-1, m12, m22, m32)-F(a1+1, a2, a3-2, m12, m22, m32))
            ) -F(a1,a2,a3-1,m12,m22,m32)/m32;
    endrepeat;
    .sort

    repeat;
        id InvDelta(m12?, m22?, m32?)=1/( 2*(m12*m22+m12*m32+m22*m32) - (m12^2+m22^2+m32^2) );
    endrepeat;
    .sort
#endprocedure


*** 这个函数中的IBP关系式与上面Recursion中一样，只需要把对应a1,a2,a3替换为循环变量
#procedure GeneralTwoLoopRecursion
*** InvDelta(m12,m22,m32)都一样，且每次都做匹配速度比较慢，可以先提出来，而每次IBP中增加的幂次用Symbol invdelta标记，在函数最后在做替换
    id F(a1?,a2?,a3?,m1?,m2?,m3?) = F(a1,a2,a3,m1^2,m2^2,m3^2)*InvDelta(m1,m2,m3);
    .sort

*** a1+a2+a3 = nt = N-n = N->4
    #do n = 0,{'N'-4}

*** a1=i(2->N-n-2) a2=j(1->N-n-i-1) a3=N-n-i-j
        #do i = 2,{'N'-'n'-2}
            #do j = 1,{'N'-'n'-'i'-1}
                id F('i', 'j', {'N'-'n'-'i'-'j'}, m12?, m22?, m32?) = invdelta /(('i'-1)*m12) * (
                    ( 'j'*(m12-m32)*(m12-m22+m32) +{'N'-'n'-'i'-'j'}*(m12-m22)*(m12+m22-m32) +D*m12*(-m12+m22+m32) ) *F('i'-1, 'j', {'N'-'n'-'i'-'j'}, m12, m22, m32)
                    +'j'*m22*(m12-m22+m32)*(F('i'-1, 'j'+1, {'N'-'n'-'i'-'j'}-1, m12, m22, m32)-F('i'-2, 'j'+1, {'N'-'n'-'i'-'j'}, m12, m22, m32))
                    +{'N'-'n'-'i'-'j'}*m32*(m12+m22-m32)*(F('i'-1, 'j'-1, {'N'-'n'-'i'-'j'}+1, m12, m22, m32)-F('i'-2, 'j', {'N'-'n'-'i'-'j'}+1, m12, m22, m32))
                    ) -F('i'-1,'j',{'N'-'n'-'i'-'j'},m12,m22,m32)/m12;
                .sort
            #enddo
        #enddo

*** a1=1 a2=i(2->N-n-1-1) a3=N-n-i-1
        #do i = 2,{'N'-'n'-2}
            id F(1, 'i', {'N'-'n'-'i'-1}, m12?, m22?, m32?) = invdelta /(('i'-1)*m22) *(
                (1*(m22-m32)*(m22-m12+m32)+{'N'-'n'-'i'-1}*(m22-m12)*(m12+m22-m32)+D*m22*(-m22+m12+m32))*F(1,{'i'-1},{'N'-'n'-'i'-1},m12,m22,m32)
                +1*m12*(m22-m12+m32)*(F(1+1,'i'-1,{'N'-'n'-'i'-1}-1,m12,m22,m32)-F(1+1,'i'-2,{'N'-'n'-'i'-1},m12,m22,m32))
                +{'N'-'n'-'i'-1}*m32*(m12+m22-m32)*(F(1-1,'i'-1,{'N'-'n'-'i'-1}+1,m12,m22,m32)-F(1,'i'-2,{'N'-'n'-'i'-1}+1,m12,m22,m32)))-F(1,'i'-1,{'N'-'n'-'i'-1},m12,m22,m32)/m22;
        #enddo

*** a1=a2=1 a3>=2
        id F(1, 1, a3?Pos2ToN, m12?, m22?, m32?) = invdelta /((a3-1)*m32) *(
            ( 1*(m32-m12)*(m32-m22+m12)+1*(m32-m22)*(m32+m22-m12)+D*m32*(-m32+m22+m12))*F(1,1,a3-1,m12,m22,m32)
            +1*m22*(m32-m22+m12)*(F(1-1,1+1,a3-1,m12,m22,m32)-F(1,1+1,a3-2,m12,m22,m32))
            +1*m12*(m32+m22-m12)*(F(1+1,1-1,a3-1,m12,m22,m32)-F(1+1,1,a3-2,m12,m22,m32))
            ) -F(1,1,a3-1,m12,m22,m32)/m32;

    #enddo

*** 将InvDelta替换为表达式
    repeat;
        id InvDelta(m1?, m2?, m3?)*invdelta = InvDelta(m1, m2, m3)/( 2*(m1^2*m2^2+m1^2*m3^2+m2^2*m3^2) - (m1^4+m2^4+m3^4) );
    endrepeat;
    id InvDelta(m1?, m2?, m3?) = 1;
    .sort
#endprocedure



#procedure CollinearTwoLoopRecursion
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

    id F(a1?, a2?, 0, m1?, m2?, m3?) = F(a1, m1)*F(a2, m2);
    id F(a1?, 0, a3?, m1?, m2?, m3?) = F(a1, m1)*F(a3, m3);
    id F(0, a2?, a3?, m1?, m2?, m3?) = F(a2, m2)*F(a3, m3);
    .sort

    repeat;
        id F(a1?Pos2ToN, m1?) = (D-2*(a1-1)) *F(a1-1,m1) /(2*(a1-1)*m1^2);
    endrepeat;
#endprocedure



*** 将单圈F(a1,a2,0)变为F(a1,m1)*F(a2,m2)，并利用单传播子IBP
#procedure OneLoopRecursion
    id F(a1?, a2?, 0, m12?, m22?, m32?) = F(a1, m12)*F(a2, m22);
    id F(a1?, 0, a3?, m12?, m22?, m32?) = F(a1, m12)*F(a3, m32);
    id F(0, a2?, a3?, m12?, m22?, m32?) = F(a2, m22)*F(a3, m32);
    .sort

    repeat;
        id F(a1?Pos2ToN, m12?) = (D-2*(a1-1)) *F(a1-1,m12) /(2*(a1-1)*m12);
    endrepeat;
    .sort
#endprocedure


