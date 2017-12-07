"""
Table Schema generic data structure
https://github.com/frictionlessdata/tableschema-jl#table
"""

mutable struct Table
    source::Array{Any}
    headers::Array{String}
    schema::Schema

    function Table(csv_blob::String, schema::Schema)
        source = readcsv(csv_blob)
        schema = schema
        headers = [ String(s) for s in source[1,:] ]
        new(source, headers, schema)
    end
    function Table(csv_blob::String)
        schema = Schema()
        Table(csv_blob, schema)
    end

    function read(keyed=false, extended=false, cast=true, relations=false, limit=nothing)
        throw(ErrorException("Not implemented"))
    end
    function infer(limit=100::Int16)
        schema && schema.descriptor || throw(ErrorException("Not implemented"))
    end
    function save(target::String)
        throw(ErrorException("Not implemented"))
    end
end

type TableValidationException <: Exception
    var::String
end

function validate(t::Table)
    is_empty(t.schema) &&
        throw(TableValidationException("No schema available"))
    throw(ErrorException("Not implemented"))
end

Base.start(t::Table) = 1
Base.done(t::Table, i) = i > length(t.source)
Base.next(t::Table, i) = t.source[i,:], i+1
