# Copyright (c) 2025 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

__λ(x, y, z) = x^2 + y^2 + z^2 - 2 * x * y - 2 * y * z - 2 * z * x # Källén triangle function

function __read_Mathematica_output(file::String)
    @assert isfile(file)

    Mathemematica_replace_dict = Dict{Union{Char, String}, Union{Char, String}}(
        '[' => '(', ']' => ')',
        "Log" => "log",
        "Polylog" => "polylog",
        "PolyLog" => "polylog",
        "Sqrt" => "sqrt",
        "Pi" => "pi"
    )

    output_str = read(file, String)
    for (key, value) in Mathemematica_replace_dict
        output_str = replace(output_str, key => value)
    end

    return output_str
end

include("run_FORM.jl")
