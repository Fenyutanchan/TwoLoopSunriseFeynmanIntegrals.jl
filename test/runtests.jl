# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using SymEngine
using Test
using TwoLoopSunriseFeynmanIntegrals

@vars m1 m2 m3

include("test_collinear_masses.jl")
include("test_num_do_loop.jl")
