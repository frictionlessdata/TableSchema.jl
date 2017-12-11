"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
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

mutable struct Field
    descriptor::Dict
    name::String
    of_type::String
    format::String
    required::Bool
    constraints::Constraints

    function Field(dict::Dict)
        name = haskey(dict, "name") ?
            dict["name"] : ""
        of_type = haskey(dict, "type") ?
            dict["type"] : DEFAULT_TYPE
        format = haskey(dict, "format") ?
            dict["format"] : DEFAULT_FORMAT
        cons = haskey(dict, "constraints") ?
            Constraints(dict["constraints"]) : Constraints()
        reqd = cons.required
        new(dict, name, of_type, format, reqd, cons)
    end

    function Field(name::String)
        new(Dict( "name" => name ))
    end
end

# cast_value = NullException()
# test_value = NullException()
