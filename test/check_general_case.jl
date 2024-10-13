# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function main(args=ARGS)
    s = ArgParseSettings(description = "Usage of check_general_case.jl")
    @add_arg_table! s begin
        "--ν-lists"
            help = "The JLD2 file containing the ν lists."
            arg_type = String
            default = "random_ν_list.jld2"
        "--julia-results"
            help = "The JLD2 file containing the Julia results."
            arg_type = String
            default = "julia_general_case.jld2"
        "--MMA-results"
            help = "The path to the MMA results."
            arg_type = String
            default = @__DIR__
    end
    parsed_args = parse_args(args, s)

    @info """
    Checking with arguments:
      $(
        join(
            ["$k: $v" for (k, v) ∈ parsed_args],
            "\n  "
        )
      )
    """

    ν_lists = load(parsed_args["ν-lists"], "ν_lists")
    julia_results = load(parsed_args["julia-results"], "results")
    
    for (ν_list, julia_result_str) ∈ zip(ν_lists, julia_results)
        ν₁, ν₂, ν₃ = ν_list
        julia_result = Basic(julia_result_str)
        MMA_result = (Basic ∘ read)(joinpath(parsed_args["MMA-results"], "MMA_general_case_output_$(ν₁)-$(ν₂)-$(ν₃).out"), String)
        result_diff = expand(julia_result - MMA_result)
        iszero(result_diff) ||
            @warn "The difference between the Julia result and the MMA result for ν₁ = $(ν₁), ν₂ = $(ν₂), ν₃ = $(ν₃) is expected to be zero, but it is $(result_diff)."
        @test iszero(result_diff)
    end
end

@testset "check_general_case.jl" begin
    if @isdefined test_parsed_args
        main(test_parsed_args["others"])
    else
        main()
    end
end
