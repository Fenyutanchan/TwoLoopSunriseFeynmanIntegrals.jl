# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function __general_form_script(
    integral::Basic,
    num_do_loop::Int
)
    return """
    #-
    #include $(__reduction_head_file)

    format maple;
    format nospaces;

    #define N "$(num_do_loop)"

    CFunction F, InvDelta;
    Symbol a1, a2, a3, m1, m2, m3, D, invdelta;

    set Pos2ToN: 2,...,$(num_do_loop);

    Off Statistics;

    Local I = $(integral);
    *** 对所有非Collinear情况都适用，允许其中一个或两个传播子质量为0
    #call GeneralTwoLoopRecursion
    #call OneLoopRecursion
    .sort

    #write "%E" I
    .sort

    .end
    """
end

function __collinear_form_script(
    integral::Basic,
    num_do_loop::Int
)
    return """
    #-
    #include $(__reduction_head_file)

    format maple;
    format nospaces;

    #define N "$(num_do_loop)"

    CFunction F, InvDelta;
    Symbol a1, a2, a3, m1, m2, m3, D, invdelta;

    set Pos2ToN: 2,...,$(num_do_loop);

    Off Statistics;

    Local I = $(integral);

    *** 两个 Collinear 情况不冲突, 可同时调用, 只需要判断是否是 Collinear 情况
    *** 其中一个质量为0另外两个质量相等 Collinear 情况
    #call OneEqZeroCollinearTwoLoopRecursion

    *** 三个质量均不为0Collinear情况, 在调用时需要将函数翻译成 F(a1, a2, a3, m1, m2, m1 + m2) 的形式
    #call NonEqZeroCollinearTwoLoopRecursion
    #call OneLoopRecursion
    .sort

    #write "%E" I
    .sort

    .end
    """
end
