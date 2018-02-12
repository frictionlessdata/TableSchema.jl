"""
Common exceptions
https://github.com/frictionlessdata/tableschema-jl#exceptions
"""

struct ConstraintError <: Exception
    message::String
    field::Field
    value
    expected

    ConstraintError(m::String, f::Field, v, e) = new(m, f, v, e)
    ConstraintError(m::String, f::Field, v) = new(m, f, v, nothing)
    ConstraintError(m::String, v, e) = new(m, nothing, v, e)
    ConstraintError(m::String, v) = new(m, nothing, v, nothing)
end

type FieldError <: Exception
    message::String
    # key::String
    # line::Int16
end

struct SchemaError <: Exception
    message::String
    key::Nullable{String}
    line::Nullable{Int16}

    SchemaError(m::String, k::String, l::Int16) = new(m, k, l)
    SchemaError(m::String, k::String) = new(m, k, nothing)
    SchemaError(m::String) = new(m, nothing, nothing)
    SchemaError(f::FieldError) = new(f.message, nothing, nothing)
end

struct TableValidationException <: Exception
    var::String
end
