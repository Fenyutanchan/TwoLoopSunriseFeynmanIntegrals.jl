#!/usr/bin/env wolframscript
(* ::Package:: *)


(* Copyright (c) 2025 Quan-feng WU <wuquanfeng@ihep.ac.cn> *)
(* This software is released under the MIT License. *)
(* https://opensource.org/licenses/MIT *)


workingDirectory = DirectoryName @ If[$FrontEnd === Null,
    $InputFileName,
    NotebookFileName[]
];


mmaResults1 = Get @ FileNameJoin[{workingDirectory, "TSI_NC_results_mma_1.m"}];
jlResults1 = Get @ FileNameJoin[{workingDirectory, "TSI_NC_results_jl_1.m"}];
mmaResults2 = Get @ FileNameJoin[{workingDirectory, "TSI_NC_results_mma_2.m"}];
jlResults2 = Get @ FileNameJoin[{workingDirectory, "TSI_NC_results_jl_2.m"}];


{a1, a2, a3} = Table[RandomInteger[4], 3];
Print["Random parameters: ", {a1, a2, a3}];
j[TSINC1, a1, a2, a3] // N @ Normal @ Series[{# /. jlResults1, # /. mmaResults1}, {eps, 0, 0}] & // Print;
j[TSINC2, a1, a2, a3] // N @ Normal @ Series[{# /. jlResults2, # /. mmaResults2}, {eps, 0, 0}] & // Print;
