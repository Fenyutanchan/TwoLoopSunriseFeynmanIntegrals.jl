# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

module TwoLoopSunriseFeynmanIntegrals

using SpecialFunctions
using SymEngine

import FORM_jll

export TSI_reduction

include("utils.jl")

include("basics.jl")
include("externals.jl")

include("TSI.jl")
include("run_FORM.jl")

# include("FORM_scripts.jl")
# include("externals.jl")
# include("reductions.jl")
# include("trivials.jl")

end # module TwoLoopSunriseFeynmanIntegrals
