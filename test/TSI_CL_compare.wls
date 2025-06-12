#!/usr/bin/env wolframscript
(* ::Package:: *)


(* Copyright (c) 2025 Quan-feng WU <wuquanfeng@ihep.ac.cn> *)
(* This software is released under the MIT License. *)
(* https://opensource.org/licenses/MIT *)


workingDirectory = DirectoryName @ If[$FrontEnd === Null,
    $InputFileName,
    NotebookFileName[]
];


mmaResults = Get @ FileNameJoin[{workingDirectory, "TSI_CL_results_mma.m"}];
jlResults = Get @ FileNameJoin[{workingDirectory, "TSI_CL_results_jl.m"}];


{a1, a2, a3} = Table[RandomInteger[4], 3];
Print["Random parameters: ", {a1, a2, a3}];
j[TSICL, a1, a2, a3] // N @ Normal @ Series[{# /. jlResults, # /. mmaResults}, {eps, 0, 0}] & // Print;
