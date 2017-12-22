"""
Table Schema main type
https://github.com/frictionlessdata/tableschema-jl#schema
"""

type SchemaError <: Exception
    message::String
    # key::String
    # line::Int16
end

mutable struct Schema
    errors::Array{SchemaError}
    descriptor::Dict
    primary_key::Array{String}
    foreign_keys::Array{Dict}
    missing_values::Array{String}
    fields::Array{Field}

    function Schema(d::Dict, strict::Bool=false)
        strict && throw(ErrorException("Not implemented")) # TODO
        fls = haskey(d, "fields") ?
            [ Field(f) for f in d["fields"] ] : []
        pk = haskey(d, "primaryKey") ? d["primaryKey"] : []
        mvs = haskey(d, "missingValues") ? d["missingValues"] : []
        fks = [] # TODO
        err = []
        new(err, d, pk, fks, mvs, fls)
    end

    function Schema(ts_json::String)
        dict = JSON.parse(ts_json)
        Schema(dict)
    end

    function Schema()
        Schema(Dict())
    end
end

function validate(s::Schema)
    if isempty(s.descriptor)
        throw(SchemaError("Missing Descriptor"))
    else
        # TODO: validate each field
    end
    return true
end

field_names(s::Schema) = [ f.descriptor.name for f in s.fields ]
get_field(s::Schema, name::String) = [ f for f in s.fields if f.name == name ][1] || throw(ErrorException("Not found"))
add_field(s::Schema, d::Dict) = push!(s.fields, Field(d))
add_field(s::Schema, f::Field) = push!(s.fields, f)
remove_field(s::Schema, name::String) = pop!(s.fields, get_field(s, name))
cast_row(s::Schema, row::Array{Any}) = throw(ErrorException("Not implemented"))
infer(s::Schema, rows::Array{Any}, headers=1) = throw(ErrorException("Not implemented"))
commit(s::Schema, strict=nothing) = throw(ErrorException("Not implemented"))
save(s::Schema, target::String) = throw(ErrorException("Not implemented"))

is_empty(s::Schema) = Base.isempty(s.fields)
