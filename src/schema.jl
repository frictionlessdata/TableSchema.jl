"""
Table Schema
https://github.com/frictionlessdata/tableschema-jl#schema
"""

type Schema
    fields::Array{Field}
    primaryKey::Array{String}
    foreignKeys::Array{Dict}
    missingValues::Array{String}

    function Schema(fields::Array{Field})
        new(fields, [], [], [])
    end

    function Schema(ts::Dict)
        fields = [ Field(Descriptor(f)) for f in ts["fields"] ]
        Schema(fields)
    end

    function Schema(ts_json::String)
        dict = JSON.parse(ts_json)
        Schema(dict)
    end
end
