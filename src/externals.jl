# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

__reduction_head_file = joinpath((dirname ∘ dirname ∘ pathof)(@__MODULE__), "ext", "reduction.h")
