module Tableschema

DEFAULT_TYPE = "string"
DEFAULT_FORMAT = "default"

type Descriptor
    _name::String
    _type::String
    _format::String
    _required::Bool
    # _constraints::Array

    function Descriptor(dict::Dict)
        _name = dict["name"]
        _type = haskey(dict, "type")         ? dict["type"] : DEFAULT_TYPE
        _format = haskey(dict, "format")     ? dict["format"] : DEFAULT_FORMAT
        _required = haskey(dict, "required") ? dict["required"] : false
        # _constraints = Array()
        new(_name, _type, _format, _required) #, _constraints)
    end
end

type Field
    descriptor::Descriptor
end

type Schema
    fields::Array{Field}
end

function load(x::Dict)
    fields = [ Field(Descriptor(f)) for f in x["fields"] ]
    Schema(fields)
end


end # module Tableschema
