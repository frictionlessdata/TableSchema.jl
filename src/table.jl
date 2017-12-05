"""
Table Schema generic data structure
https://github.com/frictionlessdata/tableschema-jl#table
"""

mutable struct Table
    source::Array{Any}
    # stream:: stream
    schema::Schema
    headers::Array{Any}
    # storage::
    # strict::Bool

    function Table(csv_blob::String, schema::Schema)
        source = readcsv(csv_blob)
        schema = schema
        headers = source[1,:]
        new(source, schema, headers)
    end
    function Table(csv_blob::String)
        schema = Schema()
        Table(csv_blob, schema)
    end
end

function validate(t::Table)
    !isempty(t.schema) || throw(ErrorException("No schema available for table"))
    throw(ErrorException("Not implemented"))
end
