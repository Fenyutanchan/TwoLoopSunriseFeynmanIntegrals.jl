# Copyright (c) 2025 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using SymEngine
using TwoLoopSunriseFeynmanIntegrals

m₁ = Basic(100)
m₂ = Basic(70)
m₃ = Basic(30)

@assert (iszero ∘ TwoLoopSunriseFeynmanIntegrals.__λ)(m₁^2, m₂^2, m₃^2)

open("TSI_CL_results_jl.m", "w+") do io
    write(io, "{\n")
    for λ₁ ∈ 0:4, λ₂ ∈ 0:4, λ₃ ∈ 0:4

        result = (
            TwoLoopSunriseFeynmanIntegrals.__export_Mathematica_output ∘
            TwoLoopSunriseFeynmanIntegrals.TSI_evaluation_CL
        )(λ₁, λ₂, λ₃, m₂, m₃)

        write(io, "    j[TSICL, $λ₁, $λ₂, $λ₃] -> $result,\n")
    end
    write(io, "    Nothing\n}\n")
end
