"""
Table Schema main type
https://github.com/frictionlessdata/tableschema-jl#schema
"""

mutable struct Schema
    descriptor::Dict
    primary_key::Array{String}
    foreign_keys::Array{Dict}
    missing_values::Array{String}
    fields::Array{Field}

    function Schema(d::Dict, strict::Bool=false)
        strict && throw(ErrorException("Not implemented"))
        fields = [ Field(Descriptor(f)) for f in d["fields"] ]
        pk = haskey(d, "primaryKey") ? d["primaryKey"] : []
        fks = []
        mvs = haskey(d, "missingValues") ? d["missingValues"] : []
        new(d, pk, fks, mvs, fields)
    end

    function Schema(ts_json::String)
        dict = JSON.parse(ts_json)
        Schema(dict)
    end

    function Schema()
        new(Dict(), [], [], [], [])
    end
end

valid(s::Schema) = throw(ErrorException("Not implemented"))
errors(s::Schema) = throw(ErrorException("Not implemented"))
field_names(s::Schema) = [ f.descriptor.name for f in s.fields ]
get_field(s::Schema, name::String) = [ f for f in s.fields if f.name == name ][1] || throw(ErrorException("Not found"))
add_field(s::Schema, d::Dict) = push!(s.fields, Field(Descriptor(d)))
add_field(s::Schema, f::Field) = push!(s.fields, f)
remove_field(s::Schema, name::String) = pop!(s.fields, get_field(s, name))
cast_row(s::Schema, row::Array{Any}) = throw(ErrorException("Not implemented"))
infer(s::Schema, rows::Array{Any}, headers=1) = throw(ErrorException("Not implemented"))
commit(s::Schema, strict=nothing) = throw(ErrorException("Not implemented"))
save(s::Schema, target::String) = throw(ErrorException("Not implemented"))

is_empty(s::Schema) = Base.isempty(s.fields)
