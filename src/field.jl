"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
"""

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
