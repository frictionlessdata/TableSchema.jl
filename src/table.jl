"""
Table Schema generic data structure
https://github.com/frictionlessdata/tableschema-jl#table
"""

mutable struct Table
    source
    headers::Array{String}
    schema::Schema
    errors::Array{ConstraintError}

    function Table(csvfilename::String, schema::Schema=Schema())
        m = match(r"http[s]://", csvfilename)
        if typeof(m) != Void && m.offset == 1
            throw(ErrorException("Please use a library like Requests to download HTTP resources"))
        else
            source = readcsv(csvfilename)
        end
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
    function Table()
        new(Void, [], Schema(), [])
    end
end

function get_headers(source::Array)
    headers = [ String(s) for s in source[1,:] ]
    source = source[2:end,:] # clear the headers
    headers, source
end

function read(t::Table ; data=nothing, keyed=false, extended=false, cast=true, relations=false, limit=nothing)
    (keyed == false && extended == false && relations == false && limit == nothing) || throw(ErrorException("Not implemented"))
    if data != nothing
        if typeof(data) == Array{Any, 2}
            t.headers, t.source = get_headers(data)
        else
            throw(ErrorException("Data must be a 2-dimensional array"))
        end
    end
    if cast
        if !is_valid(t.schema)
            throw(ErrorException("Schema must be valid to cast Table"))
        end
        newtable = Void
        for row in t
            newrow = cast_row(t.schema, row, false, false)
            if newtable == Void
                newtable = newrow
            else
                vcat(newtable, newrow)
            end
        end
        # println(t.source, typeof(t.source))
        t.source = newtable
        # println(t.source, typeof(t.source))
    end
    t.source
end
function infer(t::Table, limit=100::Int16)
    t.schema && t.schema.descriptor || throw(ErrorException("Not implemented"))
end
function save(t::Table, target::String)
    throw(ErrorException("Not implemented"))
end

function validate(t::Table)
    is_empty(t.schema) &&
        throw(TableValidationException("No schema available"))
    # TODO: should we check the schema too?
    # !valid(t.schema) &&
    #     throw(TableValidationException("Schema not valid"))
    tr = t.source
    for fld in t.schema.fields
        ix = findin(t.headers, [fld.name])
        if length(ix) != 1
            # TODO: shouldn't this just cause a ConstraintError?
            throw(TableValidationException(string("Missing field defined in Schema: ", fld.name)))
        end
        try
            column = tr[:,ix]
            for r = 1:size(tr, 2)
                row = tr[r,:]
                checkrow(fld, row[ix[1]], column)
            end
        catch ex
            if isa(ex, ConstraintError)
                push!(t.errors, ex)
            end
        end
    end
    # foreach(r -> println(r.message,"-",r.value,"-",r.field.name), t.errors)
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
