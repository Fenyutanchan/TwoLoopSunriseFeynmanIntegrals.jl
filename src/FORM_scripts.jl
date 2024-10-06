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

    #call CollinearTwoLoopRecursion
    #call OneLoopRecursion
    .sort

    #write "%E" I
    .sort

    .end
    """
end
