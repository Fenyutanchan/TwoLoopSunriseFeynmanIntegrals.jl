type_script_function_dict = Dict{Symbol, Function}(
    :General => __general_form_script,
    :Collinear => __collinear_form_script
)

function TSI_reduction(ν₁::Integer, ν₂::Integer, ν₃::Integer, m₁, m₂, m₃)
    type = :General # TBA...
    return TSI_reduction(type, ν₁, ν₂, ν₃, m₁, m₂, m₃)
end

function TSI_reduction(type::Symbol, ν₁::Integer, ν₂::Integer, ν₃::Integer, m₁, m₂, m₃)
    num_do_loop = ν₁ + ν₂ + ν₃
    integral = SymFunction("F")(ν₁, ν₂, ν₃, m₁, m₂, m₃)

    script = type_script_function_dict[type](integral, num_do_loop)
    result = (Basic ∘ __run_FORM_content)(script, multithreading_flag=true)

    return result
end
