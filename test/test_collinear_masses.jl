# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

@testset "Collinear mass" begin
    MI_list = Set{Basic}()
    for _ ∈ 1:100
        ν_list = rand(1:4, 3)

        independent_mass_list = rand([m1, m2, m3], rand(1:2))
        unique!(independent_mass_list)
        mass_list = collect(rand(1:10, (3, length(independent_mass_list))) * independent_mass_list)

        try
            result = TSI_reduction(:Collinear, ν_list..., mass_list...)
            union!(MI_list, function_symbols(result))
            @test true
        catch
            open("collinear_masses.err", "a+") do io
                println(io, "ν_list = $ν_list, mass_list = $mass_list.")
            end
            @test false
        end
    end
    @show MI_list
end
