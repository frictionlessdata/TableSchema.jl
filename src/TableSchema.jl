"""
Table Schema
https://github.com/frictionlessdata/tableschema-jl#schema
"""
module TableSchema

using JSON

export Schema

DEFAULT_TYPE = "string"
DEFAULT_FORMAT = "default"

include("descriptor.jl")
include("field.jl")

type Schema
    fields::Array{Field}
    primaryKey::Array{String}
    missingValues::Array{String}
    foreignKeys::Array{Dict}

    function Schema(ts::Dict)
        fields = [ Field(Descriptor(f)) for f in ts["fields"] ]
        pk = haskey(ts, "primaryKey") ? ts["primaryKey"] : []
        mv = haskey(ts, "missingValues") ? ts["missingValues"] : []
        new(fields, pk, mv, [])
    end

    function Schema(ts_json::String)
        dict = JSON.parse(ts_json)
        Schema(dict)
    end
end

end # module
