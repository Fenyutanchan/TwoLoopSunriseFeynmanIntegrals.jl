# Copyright (c) 2025 Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using SymEngine
using TwoLoopSunriseFeynmanIntegrals

m₁ = Basic(100)
m₂ = Basic(50)
m₃ = Basic(10)

@assert (!iszero ∘ TwoLoopSunriseFeynmanIntegrals.__λ)(m₁^2, m₂^2, m₃^2)
λ_gt_0_flag = TwoLoopSunriseFeynmanIntegrals.__λ(m₁^2, m₂^2, m₃^2) > 0

open("TSI_NC_results_jl_1.m", "w+") do io
    write(io, "{\n")
    for λ₁ ∈ 0:4, λ₂ ∈ 0:4, λ₃ ∈ 0:4

        result = (
            TwoLoopSunriseFeynmanIntegrals.__export_Mathematica_output ∘
            TwoLoopSunriseFeynmanIntegrals.TSI_evaluation_NC
        )(λ₁, λ₂, λ₃, m₁, m₂, m₃; λ_gt_0_flag=λ_gt_0_flag)

        write(io, "    j[TSINC1, $λ₁, $λ₂, $λ₃] -> $result,\n")
    end
    write(io, "    Nothing\n}\n")
end
