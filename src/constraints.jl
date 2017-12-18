"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
"""

mutable struct Constraints
    required::Bool
    unique::Bool
    minlength::Integer
    maxlength::Integer
    minimum::Integer
    maximum::Integer
    # pattern
    # enum

    function Constraints()
        new(
            false, # required::Bool
            false, # unique::Bool
            -1,    # minlength::Integer
            -1,    # maxlength::Integer
            -1,    # minimum::Integer
            -1,    # maximum::Integer
                # pattern
                # enum
        )
    end

    function Constraints(d::Dict)
        c = new()
        for fld in fieldnames(c)
            if haskey(d, String(fld))
                setfield!(c, fld, d[String(fld)])
            end
        end
        return c
    end
end

type ConstraintException <: Exception
    name::String
    value
    expected

    # message =
    #     'Field "{field.name}" has constraint "{name}" '
    #     'which is not satisfied for value "{value}"'
    #     ).format(field=self, name=name, value=value))
end

function check(c::Constraints, val, all_vals::Array=[])
    c.required && (val == "" || val == nothing) &&
        throw(ConstraintException("required", val, nothing))

    c.unique && length(all_vals) > 0 && in(val, all_vals) &&
        throw(ConstraintException("unique", val, nothing))

    c.minlength > -1 && length(val) < c.minlength &&
        throw(ConstraintException("minLength", val, c.minlength))

    c.maxlength > -1 && length(val) > c.maxlength &&
        throw(ConstraintException("maxLength", val, c.maxlength))

    c.minimum > -1 && val < c.minimum &&
        throw(ConstraintException("minimum", val, c.minimum))

    c.maximum > -1 && val > c.maximum &&
        throw(ConstraintException("maximum", val, c.maximum))

    return true
end
