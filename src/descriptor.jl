"""
Table Schema descriptor
https://github.com/frictionlessdata/tableschema-jl#descriptor
"""

type Descriptor
    _name::String
    _type::String
    _format::String
    _required::Bool
    # _constraints::Array

    function Descriptor(dict::Dict)
        _name = dict["name"]
        _type = haskey(dict, "type") ?
            dict["type"] : DEFAULT_TYPE
        _format = haskey(dict, "format") ?
            dict["format"] : DEFAULT_FORMAT
        _required = haskey(dict, "required") ?
            dict["required"] : false
        # _constraints = Array()
        new(_name, _type, _format, _required) #, _constraints)
    end
end
