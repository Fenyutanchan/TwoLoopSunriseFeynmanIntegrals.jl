# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using JLD2

function generate_random_ν_list!(
    max_ν::Int=4,
    exisiting_ν_list::Vector{Vector{Int}}=Vector{Vector{Int}}()
)
    ν_list = rand(1:max_ν, 3)
    while ν_list ∈ exisiting_ν_list
        ν_list = rand(1:max_ν, 3)
    end

    push!(exisiting_ν_list, ν_list)

    return ν_list
end

function main(args=ARGS)
    s = ArgParseSettings(description = "Usage of random_ν_list.jl")

    @add_arg_table! s begin
        "-n"
            help = "The number of ν lists to generate."
            arg_type = Int
            default = 100
        "--max-ν"
            help = "The maximum value of ν."
            arg_type = Int
            default = 4
        "--output-file", "-o"
            help = "The output file."
            arg_type = String
            default = "random_ν_list.jld2"
    end

    parsed_args = parse_args(args, s)

    @info """
    Generating random ν lists with arguments:
      $(
        join(
            ["$k: $v" for (k, v) ∈ parsed_args],
            "\n  "
        )
      )
    """

    exisiting_ν_list = Vector{Vector{Int}}()
    num = min(parsed_args["n"], parsed_args["max-ν"]^3)
    for _ ∈ 1:num
        ν_list = generate_random_ν_list!(
            parsed_args["max-ν"],
            exisiting_ν_list
        )
    end

    jldopen(parsed_args["output-file"], "w+") do file
        file["ν_list"] = exisiting_ν_list
    end
end

try
    main(test_parsed_args["others"])
catch
    rethrow()
    main()
end
