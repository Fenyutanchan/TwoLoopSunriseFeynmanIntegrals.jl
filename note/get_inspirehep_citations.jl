# get_inspirehep_citations.jl (c) by Quan-feng WU <wuquanfeng@ihep.ac.cn>
# 
# This script is released under the MIT License.
# https://opensource.org/licenses/MIT

import Pkg

Pkg.activate(@__DIR__)
Pkg.resolve()
Pkg.instantiate()

try
    using HTTP
catch
    Pkg.add("HTTP")
    using HTTP
end

try
    using ProgressMeter
catch
    Pkg.add("ProgressMeter")
    using ProgressMeter
end

function get_citation_key_list(tex_file::String)::Vector{String}
    @assert isfile(tex_file) "file not found: $tex_file"

    citation_key_list = String[]

    content = read(tex_file, String)
    content = replace(content, '\n' => "", '\t' => "", ' ' => "")

    for key_range ∈ findall(r"\\cite(\[.*?\])?\{.*?\}", content)
        tmp_string = content[key_range]
        tmp_range = findfirst(r"\{.*?\}", tmp_string)
        key_string = tmp_string[first(tmp_range)+1:last(tmp_range)-1]
        append!(citation_key_list, split(key_string, ","))
    end

    unique!(citation_key_list)
    return citation_key_list
end
get_citation_key_list(tex_file_list::Vector{String})::Vector = union(get_citation_key_list.(tex_file_list)...)

function get_inspirehep_bibtex(key::String)::String
    url = "https://inspirehep.net/api/literature/?q=$(key)&format=bibtex"
    response = HTTP.request("GET", url)
    bibtex_content = String(response.body)
    (isnothing ∘ findfirst)(key, bibtex_content) && return ""
    return bibtex_content
end

function get_inspirehep_bibtex(key_list::Vector{String})::String
    bibtex_contents = Vector{String}(undef, length(key_list))

    p = Progress(length(key_list), 1, "Fetching bibtex from inspirehep.net:")
    counter = Threads.Atomic{Int}(0)
    Threads.@threads for ii ∈ eachindex(key_list)
        bibtex_contents[ii] = get_inspirehep_bibtex(key_list[ii])

        Threads.atomic_add!(counter, 1)
        update!(p, counter[])
    end

    filter!(!isempty, bibtex_contents)

    return join(bibtex_contents, "\n")
end

function main(working_dir=pwd())
    # citation_key_list = String[]
    tex_files = String[]
    for (this_dir, _, containing_files) ∈ walkdir(working_dir)
        tex_files = union!(tex_files, filter(endswith(".tex"), containing_files))
        tex_files = joinpath.(this_dir, tex_files)
    end

    citation_key_list = get_citation_key_list(tex_files)
    @info "There are $(length(citation_key_list)) citation keys in total."
    bibtex_content = get_inspirehep_bibtex(citation_key_list)
    write("from_inspirehep.bib", bibtex_content)
end

main()
