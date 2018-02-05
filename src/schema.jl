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
        fls = haskey(d, "fields") ? [ Field(f) for f in d["fields"] ] : []
        pk = haskey(d, "primaryKey") ? d["primaryKey"] : []
        mvs = haskey(d, "missingValues") ? d["missingValues"] : []
        fks = [] # TODO
        err = []
        s = new(err, d, pk, fks, mvs, fls)
        strict && validate(s)
        s
    end

    function Schema(filename::String, strict::Bool=false)
        dict = JSON.parsefile(filename)
        Schema(dict, strict)
    end

    function Schema(strict::Bool=false)
        Schema(Dict(), strict)
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

function guess_type(value)
    if isa(value, AbstractString)
        return "string"
    elseif isa(value, Int)
        return "integer"
    elseif isa(value, Number)
        return "number"
    else
        return nothing
    end
end

function infer(s::Schema, rows::Array{Any}, headers=1)
    # TODO: get headers if missing
    for (c, header) in enumerate(headers)
        if has_field(s, header)
            continue
        end
        type_match = nothing
        col = view(rows, :, c)
        for (r, val) in enumerate(col)
            guess = guess_type(val)
            if guess == nothing
                @printf("Could not guess type at (%d, %d)\n", r, c)
            elseif type_match == nothing
                type_match = guess
                # @printf("Guessed %s at (%d, %d)\n", guess, r, c)
            elseif type_match != guess
                # TODO: log and continue
                @printf("Guess %s conflicts with %s at (%d, %d)\n", guess, type_match, r, c)
            end
            # print(val)
            # print("\n")
        end
        f = Field(header)
        if type_match != nothing
            f.typed = type_match
        end
        add_field(s, f)
    end
end

field_names(s::Schema) = [ f.descriptor.name for f in s.fields ]
get_field(s::Schema, name::String) = [ f for f in s.fields if f.name == name ][1] || throw(ErrorException("Not found"))
has_field(s::Schema, name::String) = length([ true for f in s.fields if f.name == name ]) > 0
add_field(s::Schema, d::Dict) = push!(s.fields, Field(d))
add_field(s::Schema, f::Field) = push!(s.fields, f)
remove_field(s::Schema, name::String) = pop!(s.fields, get_field(s, name))
cast_row(s::Schema, row::Array{Any}) = throw(ErrorException("Not implemented"))
# infer(s::Schema, rows::Array{Any}, headers=1) = throw(ErrorException("Not implemented"))
commit(s::Schema, strict=nothing) = throw(ErrorException("Not implemented"))
save(s::Schema, target::String) = throw(ErrorException("Not implemented"))

is_empty(s::Schema) = Base.isempty(s.fields)
