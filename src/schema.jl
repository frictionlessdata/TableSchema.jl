"""
Table Schema main type
https://github.com/frictionlessdata/tableschema-jl#schema
"""

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
        validate(s, strict)
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

function validate(s::Schema, strict::Bool=false)
    if isempty(s.descriptor)
        push!(s.errors, SchemaError("Missing Descriptor"))
    end
    if length(s.fields) == 0
        push!(s.errors, SchemaError("No Fields specified"))
    end
    if strict && length(s.errors)>0
        throw(s.errors[1])
    end

    # for fld in s.fields
    #     try
    #         validate(fld)
    #     catch ex::FieldError

    return true
end

function guess_type(value)
    if isa(value, Int)
        return "integer"
    elseif isa(value, Number)
        return "number"
    elseif isa(value, Bool)
        return "boolean"
    elseif isa(value, AbstractString)
        try
            df = DateFormat("YYYY-MM-DDThh:mm:ssZ")
            dd = DateTime(value, df)
            return "datetime"
        end
        try
            df = DateFormat("HH:MM:SS")
            dd = DateTime(value, df)
            return "time"
        end
        try
            df = DateFormat("y-m-d")
            dd = Date(value, df)
            return "date"
        end
        gp = split(value, ",")
        if length(gp) == 2
            try
                lon = float(gp[1])
                lat = float(gp[2])
                if lon <= 180 && lon >= -180 &&
                    lat <= 90 && lat >= -90
                        return "geopoint"
                end
            end
        end
        try
            obj = JSON.parse(value)
            if isa(obj, Array)
                return "array"
            elseif isa(obj, Dict)
                return "object"
            end
        end
        return "string"
    else
        return nothing
    end
end

function infer(s::Schema, rows::Array{Any}, headers::Array{String})
    for (c, header) in enumerate(headers)
        if has_field(s, header)
            continue
        end
        type_match = Dict()
        col = view(rows, :, c)
        for (r, val) in enumerate(col)
            guess = guess_type(val)
            if guess == nothing
                @printf("Could not guess type at (%d, %d)\n", r, c)
            else
                if !haskey(type_match, guess)
                    type_match[guess] = 0
                end
                type_match[guess] = type_match[guess] + 1
                # @printf("Guessed %s at (%d, %d)\n", guess, r, c)
            end
            # print(val)
            # print("\n")
        end
        f = Field(header)
        if length(type_match)>0
            sorted = sort(collect(type_match), by=x->x[2], rev=true)
            f.typed = sorted[1][1]
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
