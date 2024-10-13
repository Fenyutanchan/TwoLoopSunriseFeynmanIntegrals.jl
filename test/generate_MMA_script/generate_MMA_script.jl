# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function generate_MMA_reduction_script(
    q₁, q₂,
    ν₁, ν₂, ν₃,
    m₁, m₂, m₃,
    MMA_reduction_script_path,
    MMA_result_path
)
    script_content = """
    Import @ FileNameJoin[{"ampred-main", "AmpRed", "AmpRed.m"}];

    FI = TI[
        {$(q₁), $(q₂)},
        {
            {$(q₁), $(m₁), $(ν₁)},
            {$(q₂), $(m₂), $(ν₂)},
            {$(q₁) + $(q₂), $(m₃), $(ν₃)}
        }
    ];
    rslt = AlphaToFeynman @ AlphaReduce @ AlphaParametrize[FI, Method -> 1];
    rslt = rslt /. {
        TensorInt[{LoopMomentum[1], LoopMomentum[2]}, {{Momentum[LoopMomentum[1]], m1, 1}, {Momentum[LoopMomentum[2]], m2, 1}}, {}, 1, Dimensions -> D] -> T1 * T2,
        TensorInt[{LoopMomentum[1], LoopMomentum[2]}, {{Momentum[LoopMomentum[1]], m1, 1}, {Momentum[LoopMomentum[1]] + Momentum[LoopMomentum[2]], m3, 1}}, {}, 1, Dimensions -> D] -> T1 * T3,
        TensorInt[{LoopMomentum[1], LoopMomentum[2]}, {{Momentum[LoopMomentum[2]], m2, 1}, {Momentum[LoopMomentum[1]] + Momentum[LoopMomentum[2]], m3, 1}}, {}, 1, Dimensions -> D] -> T2 * T3,
        TensorInt[{LoopMomentum[1], LoopMomentum[2]}, {{Momentum[LoopMomentum[1]], m1, 1}, {Momentum[LoopMomentum[2]], m2, 1}, {Momentum[LoopMomentum[1]] + Momentum[LoopMomentum[2]], m3, 1}}, {}, 1, Dimensions -> D] -> T123
    };
    rslt = Expand[rslt];

    Export["$(MMA_result_path)", rslt];
    """

    write(MMA_reduction_script_path, script_content)
end

function generate_MMA_comparison_script(
    julia_result_script_path,
    MMA_result_script_path,
    MMA_comparison_script_path
)
    script_content = """
    juliaResult = Import["$(julia_result_script_path)"];
    MMAResult = Import["$(MMA_result_script_path)"];
    difference = FullSimplify[juliaResult - MMAResult];

    If[difference === 0,
        Print["Test passed!"];
        Exit[0],
        Print["Test failed for $(julia_result_script_path) and $(MMA_result_script_path)!"];
        Print["The julia result is " <> ToString[juliaResult, InputForm]];
        Print["The Mathematica result is " <> ToString[MMAResult, InputForm]];
        Print["The difference is: " <> ToString[difference, InputForm]];
        Exit[1]
    ];
    """

    write(MMA_comparison_script_path, script_content)
end
