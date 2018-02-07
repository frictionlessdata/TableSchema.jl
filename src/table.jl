"""
Table Schema generic data structure
https://github.com/frictionlessdata/tableschema-jl#table
"""

mutable struct Table
    source
    headers::Array{String}
    schema::Schema
    errors::Array{ConstraintError}

    function get_headers(source)
        headers = [ String(s) for s in source[1,:] ]
        source = source[2:end,:] # clear the headers
        headers, source
    end
    function Table(csvfilename::String, schema::Schema=Schema())
        source = readcsv(csvfilename)
        headers, source = get_headers(source)
        new(source, headers, schema, [])
    end
    function Table(csvdata::Base.AbstractIOBuffer, schema::Schema=Schema())
        source = readcsv(csvdata)
        headers, source = get_headers(source)
        new(source, headers, schema, [])
    end
    function Table(source, headers::Array{String}, schema::Schema=Schema())
        new(source, headers, schema, [])
    end
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
    # !valid(t.schema) &&
    #     throw(TableValidationException("Schema not valid"))
    tr = TableSchema.read(t)
    for r = 1:size(tr, 2)
        row = tr[r,:]
        for fld in t.schema.fields
            ix = findin(t.headers, [fld.name])
            if length(ix) != 1
                # TODO: shouldn't this just cause a ConstraintError?
                throw(TableValidationException(string("Missing field defined in Schema: ", fld.name)))
            end
            try
                checkrow(fld, row[ix[1]])
            catch ex
                if isa(ex, ConstraintError)
                    ex.field = fld
                    push!(t.errors, ex)
                end
            end
        end
    end
    # message =
    #     'Field "{field.name}" has constraint "{name}" '
    #     'which is not satisfied for value "{value}"'
    #     ).format(field=self, name=name, value=value))
    return length(t.errors) == 0
end

Base.length(t::Table) = size(t.source, 1)
Base.start(t::Table) = 1
Base.done(t::Table, i) = i > size(t.source, 1)
Base.next(t::Table, i) = t.source[i,:], i+1
