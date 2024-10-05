function TSI_reduction(ν₁, ν₂, ν₃, m₁, m₂, m₃)
    return __TSI_reduction(Val(:General), ν₁, ν₂, ν₃, m₁, m₂, m₃)
end

function __TSI_reduction(::Val{:General}, ν₁, ν₂, ν₃, m₁, m₂, m₃)
    num_do_loop = ν₁ + ν₂ + ν₃
    integral = SymFunction("F")(ν₁, ν₂, ν₃, m₁, m₂, m₃)

    script = __general_form_script(integral, num_do_loop)
    result = (Basic ∘ __run_FORM_content)(script, multithreading_flag=true)

    return result
end
