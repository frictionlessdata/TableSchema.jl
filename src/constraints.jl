"""
Table Schema field constraints
https://github.com/frictionlessdata/tableschema-jl#constraints
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
