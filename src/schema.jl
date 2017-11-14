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

type Field
    descriptor::Descriptor
end

type Schema
    fields::Array{Field}
    primaryKey::Array{String}
    foreignKeys::Array{Dict}
    missingValues::Array{String}

    function Schema(fields::Array{Field})
        new(fields, [], [], [])
    end
end


function load(ts::Dict)
    fields = [ Field(Descriptor(f)) for f in ts["fields"] ]
    Schema(fields)
end

using JSON

function load(ts_json::String)
    dict = JSON.parse(ts_json)
    load(dict)
end


end # module Tableschema
