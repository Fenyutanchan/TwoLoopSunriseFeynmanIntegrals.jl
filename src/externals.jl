# Copyright (c) 2025 Wen-Di Li <liwendi23@mails.ucas.ac.cn> and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

const __ext_path = joinpath((dirname ∘ dirname ∘ pathof)(@__MODULE__), "ext")

const __ibp_nc_path = joinpath(__ext_path, "ibp_nc")
const __ibp_nc_invAdotB_1_1_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_1_1")
const __ibp_nc_invAdotB_1_2_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_1_2")
const __ibp_nc_invAdotB_1_3_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_1_3")
const __ibp_nc_invAdotB_1_4_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_1_4")
const __ibp_nc_invAdotB_1_5_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_1_5")
const __ibp_nc_invAdotB_2_1_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_2_1")
const __ibp_nc_invAdotB_2_2_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_2_2")
const __ibp_nc_invAdotB_2_3_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_2_3")
const __ibp_nc_invAdotB_2_4_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_2_4")
const __ibp_nc_invAdotB_2_5_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_2_5")
const __ibp_nc_invAdotB_3_1_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_3_1")
const __ibp_nc_invAdotB_3_2_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_3_2")
const __ibp_nc_invAdotB_3_3_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_3_3")
const __ibp_nc_invAdotB_3_4_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_3_4")
const __ibp_nc_invAdotB_3_5_str = (__read_Mathematica_output ∘ joinpath)(__ibp_nc_path, "invAdotB_3_5")

const __ibp_cl_path = joinpath(__ext_path, "ibp_cl")
const __ibp_cl_coeff_1_str = (__read_Mathematica_output ∘ joinpath)(__ibp_cl_path, "coeff_1")
const __ibp_cl_coeff_2_str = (__read_Mathematica_output ∘ joinpath)(__ibp_cl_path, "coeff_2")
const __ibp_cl_coeff_3_str = (__read_Mathematica_output ∘ joinpath)(__ibp_cl_path, "coeff_3")

const __one_loop_path = joinpath(__ext_path, "one_loop")
const __one_loop_1_str = (__read_Mathematica_output ∘ joinpath)(__one_loop_path, "one_loop_1")
const __one_loop_2_str = (__read_Mathematica_output ∘ joinpath)(__one_loop_path, "one_loop_2")
const __one_loop_gt_2_str = (__read_Mathematica_output ∘ joinpath)(__one_loop_path, "one_loop_gt_2")

const __TSI111_nc_path = joinpath(__ext_path, "TSI111_nc")
const __TSI111_nc_case1_str = (__read_Mathematica_output ∘ joinpath)(__TSI111_nc_path, "case_1")
const __TSI111_nc_case2_str = (__read_Mathematica_output ∘ joinpath)(__TSI111_nc_path, "case_2")
const __TSI111_nc_one_vanishing_str = (__read_Mathematica_output ∘ joinpath)(__TSI111_nc_path, "one_vanishing")
