function __general_form_script(
    integral::Basic,
    num_do_loop::Int
)
    return """
    #include $(__reduction_head_file)

    format nospaces;
    format maple;

    #define N "$(num_do_loop)"

    CFunction F, InvDelta;
    Symbol a1, a2, a3, m1, m2, m3, m12, m22, m32, D, invdelta;

    set Pos2ToN: 2,...,$(num_do_loop);

    Off Statistics;

    *** 测试函数
    Local I = $(integral);

    #call TwoLoopRecursion
    #call OneLoopRecursion

    .sort
    #write "%E" I

    .end

    """
end
