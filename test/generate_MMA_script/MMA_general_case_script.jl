# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

include("generate_MMA_script.jl")

function main(args=ARGS)
    s = ArgParseSettings(description = "Usage of MMA_general_case_script.jl")
    @add_arg_table! s begin
        "--ν-lists"
            help = "The JLD2 file containing the ν lists."
            arg_type = String
            default = "random_ν_list.jld2"
        "--output-directory", "--output-dir", "--out-dir", "-o"
            help = "The output directory."
            arg_type = String
            default = @__DIR__
    end
    parsed_args = parse_args(args, s)

    @info """
    Generating MMA scripts with arguments:
      $(
        join(
            ["$k: $v" for (k, v) ∈ parsed_args],
            "\n  "
        )
      )
    """

    @vars q1 q2 m1 m2 m3

    run_MMA_reduction_script_path = joinpath(parsed_args["output-directory"], "run_MMA_general_case_reduction_script.sh")
    run_MMA_comparison_script_path = joinpath(parsed_args["output-directory"], "run_MMA_general_case_comparison_script.sh")
    ν_lists = load(parsed_args["ν-lists"], "ν_lists")

    for ν_list ∈ ν_lists
        ν₁, ν₂, ν₃ = ν_list
        MMA_reduction_script_path = joinpath(parsed_args["output-directory"], "MMA_general_case_script_$(ν₁)-$(ν₂)-$(ν₃).wls")
        MMA_comparison_script_path = joinpath(parsed_args["output-directory"], "MMA_general_case_comparison_script_$(ν₁)-$(ν₂)-$(ν₃).wls")

        MMA_result_path = "MMA_general_case_output_$(ν₁)-$(ν₂)-$(ν₃).wls"
        julia_result_path = "julia_general_case_output_$(ν₁)-$(ν₂)-$(ν₃).wls"

        generate_MMA_reduction_script(
            q1, q2,
            ν₁, ν₂, ν₃,
            m1, m2, m3,
            MMA_reduction_script_path,
            MMA_result_path
        )
        generate_MMA_comparison_script(
            julia_result_path,
            MMA_result_path,
            MMA_comparison_script_path
        )
        open(run_MMA_reduction_script_path, "a+") do io
            write(io, "wolframscript -file $(basename(MMA_reduction_script_path))\n")
            # write(io, "wolframscript -file $(basename(MMA_comparison_script_path))\n")
        end
        open(run_MMA_comparison_script_path, "a+") do io
            write(io, "wolframscript -file $(basename(MMA_comparison_script_path))\n")
        end
    end
end

if @isdefined test_parsed_args
    main(test_parsed_args["others"])
else
    main()
end
