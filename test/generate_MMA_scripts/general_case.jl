using SymEngine

@vars q1 q2 m1 m2 m3

include("generate_MMA_script.jl")

function generate_script_general_case(num_file::Int)
    @assert num_file > 0
    existed_ν_lists = Vector{Int}()
    for ii ∈ 1:num_file
        MMA_script_path = "general_MMA_script_$(ii).wls"
        output_path = "general_output_$(ii).txt"
        ν_list = rand(1:5, 3)
        while ν_list ∈ existed_ν_lists
            ν_list = rand(1:5, 3)
        end

        generate_MMA_script(
            q1, q2,
            ν_list...,
            m1, m2, m3,
            MMA_script_path,
            output_path
        )
        open("run_general_scripts.sh", "a+") do io
            write(io, "wolframscript -file $(MMA_script_path)\n")
        end
    end
end

(generate_script_general_case ∘ parse)(Int, ARGS[1])
