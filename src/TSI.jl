# Copyright (c) 2025 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function TSI_reduction_NC(ν₁::Int, ν₂::Int, ν₃::Int, m₁, m₂, m₃)
    @assert all(≥(0), [ν₁, ν₂, ν₃])
    @assert (!iszero ∘ expand ∘ Basic ∘ __λ)(m₁^2, m₂^2, m₃^2)

    count(iszero, [ν₁, ν₂, ν₃]) ≥ 2 && return zero(Basic)
    any(iszero, [ν₁, ν₂, ν₃]) && return TSI_head(ν₁, ν₂, ν₃, m₁, m₂, m₃)
    ν₁ == ν₂ == ν₃ == 1 && return TSI_head(ν₁, ν₂, ν₃, m₁, m₂, m₃)

    max_ν = max(ν₁, ν₂, ν₃)

    expr = if max_ν == ν₁
        a1, a2, a3 = ν₁ - 1, ν₂, ν₃

        replace_rule = Dict{Basic, Any}(
            Basic("a1") => a1, Basic("a2") => a2, Basic("a3") => a3,
            Basic("m1") => m₁, Basic("m2") => m₂, Basic("m3") => m₃
        )

        subs(Basic(__ibp_nc_invAdotB_1_1_str), replace_rule) * TSI_reduction_NC(a1, a2, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_1_2_str), replace_rule) * TSI_reduction_NC(a1, a2 + 1, a3 - 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_1_3_str), replace_rule) * TSI_reduction_NC(a1, a2 - 1, a3 + 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_1_4_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2 + 1, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_1_5_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2, a3 + 1, m₁, m₂, m₃)
    elseif max_ν == ν₂
        a1, a2, a3 = ν₁, ν₂ - 1, ν₃

        replace_rule = Dict{Basic, Any}(
            Basic("a1") => a1, Basic("a2") => a2, Basic("a3") => a3,
            Basic("m1") => m₁, Basic("m2") => m₂, Basic("m3") => m₃
        )

        subs(Basic(__ibp_nc_invAdotB_2_1_str), replace_rule) * TSI_reduction_NC(a1, a2, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_2_2_str), replace_rule) * TSI_reduction_NC(a1, a2 + 1, a3 - 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_2_3_str), replace_rule) * TSI_reduction_NC(a1, a2 - 1, a3 + 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_2_4_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2 + 1, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_2_5_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2, a3 + 1, m₁, m₂, m₃)
    else
        a1, a2, a3 = ν₁, ν₂, ν₃ - 1

        replace_rule = Dict{Basic, Any}(
            Basic("a1") => a1, Basic("a2") => a2, Basic("a3") => a3,
            Basic("m1") => m₁, Basic("m2") => m₂, Basic("m3") => m₃
        )

        subs(Basic(__ibp_nc_invAdotB_3_1_str), replace_rule) * TSI_reduction_NC(a1, a2, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_3_2_str), replace_rule) * TSI_reduction_NC(a1, a2 + 1, a3 - 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_3_3_str), replace_rule) * TSI_reduction_NC(a1, a2 - 1, a3 + 1, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_3_4_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2 + 1, a3, m₁, m₂, m₃) +
            subs(Basic(__ibp_nc_invAdotB_3_5_str), replace_rule) * TSI_reduction_NC(a1 - 1, a2, a3 + 1, m₁, m₂, m₃)
    end

    return __eps_series_cut(expr)
end

function TSI_evaluation_NC(ν₁::Int, ν₂::Int, ν₃::Int, m₁, m₂, m₃; λ_gt_0_flag::Bool=true)
    @assert all(≥(0), [ν₁, ν₂, ν₃])
    @assert (!iszero ∘ expand ∘ Basic ∘ __λ)(m₁^2, m₂^2, m₃^2)

    count(iszero, [ν₁, ν₂, ν₃]) ≥ 2 && return zero(Basic)
    if any(iszero, [ν₁, ν₂, ν₃])
        output = one(Basic)
        for ii ∈ findall(!iszero, [ν₁, ν₂, ν₃])
            νᵢ = [ν₁, ν₂, ν₃][ii]
            mᵢ = [m₁, m₂, m₃][ii]

            expr_rule = Dict(
                Basic("a") => νᵢ,
                Basic("m") => mᵢ,
            )

            output *= if νᵢ == 1
                (expand ∘ subs)(Basic(__one_loop_1_str), expr_rule)
            elseif νᵢ == 2
                (expand ∘ subs)(Basic(__one_loop_2_str), expr_rule)
            else
                (expand ∘ subs)(Basic(__one_loop_gt_2_str), expr_rule)
            end
        end
        return __eps_series_cut(output; max_eps_order=0)
    end
    ν₁ == ν₂ == ν₃ == 1 && return TSI_evaluation_111_NC(m₁, m₂, m₃, λ_gt_0_flag)

    expr_reduction = TSI_reduction_NC(ν₁, ν₂, ν₃, m₁, m₂, m₃)
    all_TSIs = function_symbols(expr_reduction)
    filter!(==("TSI") ∘ SymEngine.get_name, unique!(all_TSIs))
    TSI_rules = Dict{Basic, Basic}()
    for one_TSI ∈ all_TSIs
        TSI_args = SymEngine.get_args(one_TSI)
        ν_list = map(Int, TSI_args[1:3])
        m_list = TSI_args[4:6]
        TSI_rules[one_TSI] = TSI_evaluation_NC(ν_list..., m_list...; λ_gt_0_flag=λ_gt_0_flag)
    end

    return __eps_series_cut(subs(expr_reduction, TSI_rules); max_eps_order=0)
end

function TSI_evaluation_111_NC(m₁, m₂, m₃, λ_gt_0_flag::Bool)
    @vars x, y, m1, m2, eps

    counter_vanishing_mass = sum(iszero, [m₁, m₂, m₃])

    all_rules = Dict{Basic, Any}(
        x => m₂^2 / m₁^2,
        y => m₃^2 / m₁^2,
        m1 => m₁,
        m2 => m₂,
    )

    if iszero(counter_vanishing_mass)
        # if λ_gt_0_flag
        #     return subs(Basic(__TSI111_nc_case1_str), all_rules)
        # else
        #     all_rules[Basic("ξxy")] = -__λ(1, x, y) / (4 * x * y)
        #     all_rules[Basic("ξx")] = -__λ(1, x, 0) / (4 * x)
        #     all_rules[Basic("ξy")] = -__λ(1, 0, y) / (4 * y)

        #     return subs(Basic(__TSI111_nc_case2_str), all_rules)
        # end
        return subs(Basic(
            λ_gt_0_flag ? __TSI111_nc_case1_str : __TSI111_nc_case2_str
        ), all_rules)
    elseif counter_vanishing_mass == 1
        return subs(Basic(__TSI111_nc_one_vanishing_str), all_rules)
    elseif counter_vanishing_mass == 2
        return subs(Basic(__TSI111_nc_two_vanishing_str), all_rules)
    else
        @assert counter_vanishing_mass == 3
        return zero(Basic)
    end
end

function TSI_reduction_CL(ν₁::Int, ν₂::Int, ν₃::Int, m₂, m₃)
    @assert all(≥(0), [ν₁, ν₂, ν₃])

    count(iszero, [ν₁, ν₂, ν₃]) ≥ 2 && return zero(Basic)
    any(iszero, [ν₁, ν₂, ν₃]) && return TSI_head(ν₁, ν₂, ν₃, m₂ + m₃, m₂, m₃)

    replace_rule = Dict{Basic, Any}(
        Basic("a1") => ν₁, Basic("a2") => ν₂, Basic("a3") => ν₃,
        Basic("m1") => m₂ + m₃, Basic("m2") => m₂, Basic("m3") => m₃
    )

    expr = subs(Basic(__ibp_cl_coeff_1_str), replace_rule) * TSI_reduction_CL(ν₁ - 1, ν₂, ν₃, m₂, m₃) +
        subs(Basic(__ibp_cl_coeff_2_str), replace_rule) * TSI_reduction_CL(ν₁, ν₂ - 1, ν₃, m₂, m₃) +
        subs(Basic(__ibp_cl_coeff_3_str), replace_rule) * TSI_reduction_CL(ν₁, ν₂, ν₃ - 1, m₂, m₃)

    return __eps_series_cut(expr)
end

function TSI_evaluation_CL(ν₁::Int, ν₂::Int, ν₃::Int, m₂, m₃)
    @assert all(≥(0), [ν₁, ν₂, ν₃])

    count(iszero, [ν₁, ν₂, ν₃]) ≥ 2 && return zero(Basic)
    if any(iszero, [ν₁, ν₂, ν₃])
        output = one(Basic)
        for ii ∈ findall(!iszero, [ν₁, ν₂, ν₃])
            νᵢ = [ν₁, ν₂, ν₃][ii]
            mᵢ = [m₂ + m₃, m₂, m₃][ii]

            expr_rule = Dict(
                Basic("a") => νᵢ,
                Basic("m") => mᵢ,
            )

            output *= if νᵢ == 1
                (expand ∘ subs)(Basic(__one_loop_1_str), expr_rule)
            elseif νᵢ == 2
                (expand ∘ subs)(Basic(__one_loop_2_str), expr_rule)
            else
                (expand ∘ subs)(Basic(__one_loop_gt_2_str), expr_rule)
            end
        end
        return __eps_series_cut(output; max_eps_order=0)
    end

    expr_reduction = TSI_reduction_CL(ν₁, ν₂, ν₃, m₂, m₃)
    all_TSIs = function_symbols(expr_reduction)
    filter!(==("TSI") ∘ SymEngine.get_name, unique!(all_TSIs))
    TSI_rules = Dict{Basic, Basic}()
    for one_TSI ∈ all_TSIs
        TSI_args = SymEngine.get_args(one_TSI)
        ν_list = map(Int, TSI_args[1:3])
        m_list = TSI_args[5:6]
        TSI_rules[one_TSI] = TSI_evaluation_CL(ν_list..., m_list...)
    end

    return __eps_series_cut(subs(expr_reduction, TSI_rules); max_eps_order=0)
end
