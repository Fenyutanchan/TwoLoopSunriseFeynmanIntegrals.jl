# Copyright (c) 2024 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

using ArgParse
using Combinatorics
using JLD2
using SymEngine
using Test
using TwoLoopSunriseFeynmanIntegrals

test_arg_parser = ArgParseSettings(description = "Usage of runtests.jl")

@add_arg_table! test_arg_parser begin
    "--test-type"
        arg_type = String
        help = "The type of test to run."
    "others"
        help = "Other arguments begin with `--`."
        nargs = 'R'
end

test_parsed_args = parse_args(ARGS, test_arg_parser)

type_script_dict = Dict{String, String}(
    "random-ν-list" => "random_ν_list.jl",
    "julia-general-case" => "julia_general_case.jl",
    "MMA-general-case-script" => "generate_MMA_script/MMA_general_case_script.jl"
)

if haskey(type_script_dict, test_parsed_args["test-type"])
    include(type_script_dict[test_parsed_args["test-type"]])
end

# using SymEngine
# using Test
# using TwoLoopSunriseFeynmanIntegrals

# @vars m1 m2 m3

# include("test_collinear_masses.jl")
# include("test_num_do_loop.jl")
