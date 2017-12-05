"""
Table Schema main type
https://github.com/frictionlessdata/tableschema-jl#schema
"""

mutable struct Schema
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

    function Schema()
        new([], [], [], [])
    end
end

add_field(s::Schema, f::Field) = push!(s.fields, f)
