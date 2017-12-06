"""
Table Schema descriptor
https://github.com/frictionlessdata/tableschema-jl#descriptor
"""

type Constraints
    required::Bool
    unique::Bool
    # minLength:Integer
    # maxLength:Ineger
    # minimum
    # maximum
    # pattern
    # enum

    function Constraints(dict::Dict)
        required = haskey(dict, "required") ?
            dict["required"] : false
        unique = haskey(dict, "unique") ?
            dict["unique"] : false
        new(required, unique)
    end

    function Constraints()
        new(false, false)
    end
end

type Descriptor
    _name::String
    _type::String
    _format::String
    constraints::Constraints

    function Descriptor(dict::Dict)
        _name = dict["name"]
        _type = haskey(dict, "type") ?
            dict["type"] : DEFAULT_TYPE
        _format = haskey(dict, "format") ?
            dict["format"] : DEFAULT_FORMAT
        if haskey(dict, "constraints")
            constraints = Constraints(dict["constraints"])
        else
            constraints = Constraints()
        end
        new(_name, _type, _format, constraints)
    end

    function Descriptor()
        new("", "", "", Constraints())
    end
end
