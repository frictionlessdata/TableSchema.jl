"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
"""

mutable struct Constraints
    required::Bool
    unique::Bool
    minLength::Nullable{Integer}
    maxLength::Nullable{Integer}
    # minimum::Integer
    # maximum::Integer
    # pattern
    # enum

    function Constraints(d::Dict)
        # Defaults
        c = new(
            false, # required::Bool
            false, # unique::Bool
            nothing, # minlength::Integer
            nothing, # maxlength::Integer
            # nothing, # minimum::Integer
            # nothing, # maximum::Integer
                # pattern
                # enum
        )
        # Map from dictionary
        for fld in fieldnames(c)
            if haskey(d, String(fld))
                setfield!(c, fld, d[String(fld)])
            end
        end
        return c
    end

    Constraints() = Constraints(Dict())
end

type ConstraintError <: Exception
    name::String
    value
    expected
end

function checkrow(c::Constraints, val, column::Array=[])
    c.required && (val == "" || val == nothing) &&
        throw(ConstraintError("required", val, nothing))

    c.unique && in(val, column) &&
        throw(ConstraintError("unique", val, nothing))

    if typeof(val) == String

        !isnull(c.minLength) && c.minLength > -1 &&
            length(val) < c.minLength &&
                throw(ConstraintError("minLength", val, c.minLength))

        !isnull(c.maxLength) && c.maxLength > -1 &&
            length(val) > c.maxLength &&
                throw(ConstraintError("maxLength", val, c.maxLength))

    end

    # c.minimum > -1 && val < c.minimum &&
    #     throw(ConstraintError("minimum", val, c.minimum))
    #
    # c.maximum > -1 && val > c.maximum &&
    #     throw(ConstraintError("maximum", val, c.maximum))

    return true
end
