using SymEngine
using Test
using TwoLoopSunriseFeynmanIntegrals

@vars m1 m2 m3

MI_list = Set{Basic}()
push!(MI_list, SymFunction("F")(1, m1^2))
push!(MI_list, SymFunction("F")(1, m2^2))
push!(MI_list, SymFunction("F")(1, m3^2))
push!(MI_list, SymFunction("F")(1, 1, 1, m1^2, m2^2, m3^2))

@testset "Test num_do_loop = ν₁ + ν₂ + ν₃" begin
    tmp_dict = Dict{Tuple{Int, Int, Int}, Vector{Basic}}()
    tmp_lock = Threads.SpinLock()
    for ii ∈ 1:100
        ν₁, ν₂, ν₃ = rand(1:5, 3)

        result = TSI_reduction(ν₁, ν₂, ν₃, m1, m2, m3)
        this_MI_list = function_symbols(result)

        MI_diff = setdiff(this_MI_list, MI_list)
        if !isempty(MI_diff)
            lock(tmp_lock) do
                haskey(tmp_dict, (ν₁, ν₂, ν₃)) || (tmp_dict[(ν₁, ν₂, ν₃)] = MI_diff)
            end

            @test false
            continue
        end

        @test true
    end

    if !isempty(tmp_dict)
        for (k, v) ∈ tmp_dict
            println(k, " => ", v)
        end
    end
end