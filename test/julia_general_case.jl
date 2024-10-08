# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function main(args=ARGS)
    s = ArgParseSettings(description = "Usage of julia_general_case.jl")
    @add_arg_table! s begin
        "--ν-lists"
            help = "The JLD2 file containing the ν lists."
            arg_type = String
            default = "random_ν_list.jld2"
        "--output", "-o"
            help = "The output file."
            arg_type = String
            default = "julia_general_case.jld2"
    end
    parsed_args = parse_args(args, s)

    @info """
    Running the general case test with arguments:
      $(
        join(
            ["$k: $v" for (k, v) ∈ parsed_args],
            "\n  "
        )
      )
    """

    ν_lists = load(parsed_args["ν-lists"], "ν_lists")
    results = Vector{Basic}(undef, length(ν_lists))

    @vars m1 m2 m3

    MI_list = Set{Basic}()
    push!(MI_list, SymFunction("F")(1, m1))
    push!(MI_list, SymFunction("F")(1, m2))
    push!(MI_list, SymFunction("F")(1, m3))
    push!(MI_list, SymFunction("F")(1, 1, 1, m1, m2, m3))

    error_dict = Dict{Tuple{Int, Int, Int}, Vector{Basic}}()

    @testset for (ii, ν_list) ∈ enumerate(ν_lists)
        ν₁, ν₂, ν₃ = ν_list

        results[ii] = result = TSI_reduction(ν₁, ν₂, ν₃, m1, m2, m3)
        this_MI_list = function_symbols(result)

        MI_diff = setdiff(this_MI_list, MI_list)
        if !isempty(MI_diff)
            haskey(error_dict, (ν₁, ν₂, ν₃)) || (tmp_dict[(ν₁, ν₂, ν₃)] = MI_diff)

            @test false
            continue
        end

        @test true
    end

    isempty(error_dict) ||
        for (k, v) ∈ error_dict
            println(k, " => ", v)
        end

    jldopen(parsed_args["output"], "w+") do file
        file["results"] = results
    end
end

if @isdefined test_parsed_args
    main(test_parsed_args["others"])
else
    main()
end
