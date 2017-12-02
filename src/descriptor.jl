"""
Table Schema descriptor
https://github.com/frictionlessdata/tableschema-jl#descriptor
"""

type Descriptor
    _name::String
    _type::String
    _format::String
    _required::Bool
    _constraints::Dict

    function Descriptor(dict::Dict)
        _name = dict["name"]
        _type = haskey(dict, "type") ?
            dict["type"] : DEFAULT_TYPE
        _format = haskey(dict, "format") ?
            dict["format"] : DEFAULT_FORMAT
        _required = haskey(dict, "required") ?
            dict["required"] : false
        _constraints = Dict()
        if haskey(dict, "constraints")
            _constraints["required"] = haskey(dict["constraints"], "required") ?
                dict["constraints"]["required"] : false
        end
        new(_name, _type, _format, _required, _constraints)
    end

    function Descriptor()
        new("", "", "", false, Dict())
    end
end
