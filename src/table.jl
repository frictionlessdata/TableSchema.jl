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
        if match(r"^https?://", csvfilename) !== nothing
            source = read_remote_csv(csvfilename)
        else
            source = readdlm(csvfilename, ',')
        end
        headers, source = get_headers(source)
        new(source, headers, schema, [])
    end
    function Table(csvdata::Base.GenericIOBuffer, schema::Schema=Schema())
        source = readdlm(csvdata, ',')
        headers, source = get_headers(source)
        new(source, headers, schema, [])
    end
    function Table(source, headers::Array{String}, schema::Schema=Schema())
        new(source, headers, schema, [])
    end
    function Table()
        new(Nothing, [], Schema(), [])
    end
end

function read_remote_csv(url::String)
    req = request("GET", url)
    data = readdlm(req.body, ',')
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
        newtable = Nothing
        for row in t
            newrow = cast_row(t.schema, row, false, false)
            if newtable == Nothing
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

Base.length(iter::Table) = size(iter.source, 1)
Base.eltype(iter::Table) = Table
function Base.iterate(iter::Table, state=(1, 0))
    element, count = state
    if count > size(iter.source, 1)
        return nothing
    end
    return (element, (element.source[count,:], count + 1))
end
# Base.start(t::Table) = 1
# Base.done(t::Table, i) = i > size(t.source, 1)
# Base.next(t::Table, i) = t.source[i,:], i+1
