#!/usr/bin/env wolframscript
(* ::Package:: *)


(* Copyright (c) 2025 Quan-feng WU <wuquanfeng@ihep.ac.cn> *)
(* This software is released under the MIT License. *)
(* https://opensource.org/licenses/MIT *)


<< AMFlow`


workingDirectory = DirectoryName @ If[$FrontEnd === Null,
    $InputFileName,
    NotebookFileName[]
];


AMFlowInfo["Family"] = TSICL;
AMFlowInfo["Loop"] = {k1, k2};
AMFlowInfo["Leg"] = {};
AMFlowInfo["Conservation"] = {};
AMFlowInfo["Replacement"] = {};
AMFlowInfo["Propagator"] = {
    k1^2 - m1Sqr, 
    k2^2 - m2Sqr,
    (k1 + k2)^2 - m3Sqr
};
AMFlowInfo["Numeric"] = {m1Sqr -> 100^2, m2Sqr -> 70^2, m3Sqr -> 30^2};
AMFlowInfo["NThread"] = 32;


integrals = Flatten @ Table[j[TSICL, ii, jj, kk], {ii, 0, 4}, {jj, 0, 4}, {kk, 0, 4}];
precision = 20;
epsOrder = 4;
sol = SolveIntegrals[integrals, precision, epsOrder];


Export[FileNameJoin[{workingDirectory, "TSI_CL_results_mma.m"}], sol];
