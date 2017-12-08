"""
Table Schema generic data structure
https://github.com/frictionlessdata/tableschema-jl#table
"""

mutable struct Table
    source
    headers::Array{String}
    schema::Schema

    function Table(csvfilename::String, schema::Schema)
        schema = schema
        source = readcsv(csvfilename)
        headers = [ String(s) for s in source[1,:] ]
        source = source[2:end,:] # clear the headers
        new(source, headers, schema)
    end
    Table(csvfilename::String) = Table(csvfilename, Schema())
end

function read(t::Table, keyed=false, extended=false, cast=true, relations=false, limit=nothing)
    if typeof(t.source) == Array{Any,2}; return t.source; end
    throw(ErrorException("Not implemented"))
end
function infer(t::Table, limit=100::Int16)
    t.schema && t.schema.descriptor || throw(ErrorException("Not implemented"))
end
function save(t::Table, target::String)
    throw(ErrorException("Not implemented"))
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
