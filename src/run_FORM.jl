# Copyright (c) 2024 Wen-Di Li and Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function __run_FORM_file(
    script_file_path::String;
    multithreading_flag::Bool=false,
    num_threads::Int=Threads.nthreads()
)::String
    result_io = IOBuffer()
    exec = pipeline(
        multithreading_flag ?
            `$(FORM_jll.tform()) -w$(num_threads) -q $(script_file_path)` :
            `$(FORM_jll.form()) -q $(script_file_path)`;
        stdin=open(script_file_path, "r"),
        stdout=result_io
    )

    try
        run(exec)
    catch
        @warn "Please check the file of $(script_file_path)!"
        rethrow()
    end

    return (String ∘ take!)(result_io)
end

function __run_FORM_content(
    script_str::String;
    debug_filename::String="debug",
    multithreading_flag::Bool=false,
    num_threads::Int=Threads.nthreads()
)::String
    result_io = IOBuffer()
    exec = pipeline(
        multithreading_flag ?
            `$(FORM_jll.tform()) -w$(num_threads) -q -` :
            `$(FORM_jll.form()) -q -`;
        stdin=IOBuffer(script_str),
        stdout=result_io
    )

    try
        run(exec)
    catch
        write("$debug_filename.frm", script_str)
        @warn "Please check the file of $(joinpath(pwd(), "$debug_filename.frm"))!"
        rethrow()
    end

    return (String ∘ take!)(result_io)
end
