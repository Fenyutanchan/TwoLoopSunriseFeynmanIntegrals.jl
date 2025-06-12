# Copyright (c) 2025 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

__λ(x, y, z) = x^2 + y^2 + z^2 - 2 * x * y - 2 * y * z - 2 * z * x # Källén triangle function

function __read_Mathematica_output(file::String)
    @assert isfile(file)

    Mathematica_replace_dict = Dict{Union{Char, String}, Union{Char, String}}(
        '[' => '(', ']' => ')',
        "Euler" => "euler",
        "Gamma" => "gamma",
        "Log" => "log",
        "Pi" => "pi",
        "Poly" => "poly",
        "Sqrt" => "sqrt",
        "Zeta" => "zeta",
    )

    output_str = read(file, String)
    for (key, value) in Mathematica_replace_dict
        output_str = replace(output_str, key => value)
    end

    return output_str
end

function __export_Mathematica_output(expr::Union{String, Basic})::String
    expr_str = string(expr)

    Mathematica_replace_dict = Dict{Union{Char, String}, Union{Char, String}}(
        "euler" => "Euler",
        "gamma" => "Gamma",
        "log" => "Log",
        "pi" => "Pi",
        "poly" => "Poly",
        "sqrt" => "Sqrt",
        "zeta" => "Zeta",
    )

    for (key, value) ∈ Mathematica_replace_dict
        expr_str = replace(expr_str, key => value)
    end

    new_expr = Basic(expr_str)
    expr_str = string(new_expr)
    function_names = map(get_name, function_symbols(new_expr))
    for function_name ∈ function_names
        positions = findall(function_name, expr_str)
        for position ∈ positions
            ii = last(position) + 1
            expr_str[ii] == '[' && continue
            @assert expr_str[ii] == '('

            counter = 0
            while true
                if expr_str[ii] ∈ ['(', '[']
                    counter += 1
                elseif expr_str[ii] ∈ [')', ']']
                    counter -= 1
                end

                counter == 0 && break
                ii += 1
            end

            expr_str = replace(expr_str,
                expr_str[first(position):ii] =>
                    expr_str[position] * '[' * expr_str[last(position)+2:ii-1] * ']'
            )
        end
    end

    expr_str = replace(expr_str, "eulergamma" => "EulerGamma", "im" => "I")

    return expr_str
end

function __eps_series_cut(expr::Basic; max_eps_order::Int=2)::Basic
    eps = Basic("eps")

    expr = expand(expr)

    new_expr = sum(ii -> coeff(expr, eps, Basic(ii)) * eps^ii, -2:max_eps_order)

    return new_expr
end
