# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function generate_random_ν_list!(
    max_ν::Int=4,
    exisiting_ν_lists::Vector{Vector{Int}}=Vector{Vector{Int}}()
)
    ν_list = rand(1:max_ν, 3)
    while ν_list ∈ exisiting_ν_lists
        ν_list = rand(1:max_ν, 3)
    end

    push!(exisiting_ν_lists, ν_list)

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

    ν_lists = Vector{Vector{Int}}()
    total_num = parsed_args["max-ν"]^3
    # total_num = (parsed_args["max-ν"] + 1)^3
    num = min(parsed_args["n"], total_num)
    ν_max = parsed_args["max-ν"]

    all_ν_lists = (collect ∘ multiset_permutations)(vcat(1:ν_max, 1:ν_max, 1:ν_max), 3)
    # all_ν_lists = (collect ∘ multiset_permutations)(vcat(0:ν_max, 0:ν_max, 0:ν_max), 3)
    while num > 0
        index = rand(1:total_num)
        push!(ν_lists, popat!(all_ν_lists, index))
        total_num -= 1
        num -= 1
    end

    jldopen(parsed_args["output-file"], "w+") do file
        file["ν_lists"] = ν_lists
    end
end

if @isdefined test_parsed_args
    main(test_parsed_args["others"])
else
    rethrow()
    main()
end
