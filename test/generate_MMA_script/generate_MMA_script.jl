# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function generate_MMA_script(
    q₁, q₂,
    ν₁, ν₂, ν₃,
    m₁, m₂, m₃,
    MMA_script_path,
    output_path
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
    rslt = AlphaToFeynman @ AlphaReduce @ AlphaParametrize[FI, Method->1];

    Export["$(output_path)", rslt];
    """

    write(MMA_script_path, script_content)
end
