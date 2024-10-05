function __run_FORM_file(
    script_file_path::String;
    multithreading_flag::Bool=false
)::String
    result_io = IOBuffer()
    exec = pipeline(
        multithreading_flag ?
            `$(FORM_jll.tform()) -w$(Threads.nthreads()) -q $(script_file_path)` :
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
    multithreading_flag::Bool=false
)::String
    result_io = IOBuffer()
    exec = pipeline(
        multithreading_flag ?
            `$(FORM_jll.tform()) -w$(Threads.nthreads()) -q -` :
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
