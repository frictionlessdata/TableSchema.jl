"""
TableSchema module
https://github.com/frictionlessdata/tableschema-jl
"""
module TableSchema

export Table
export Schema
export Field

export TableValidationException
export ConstraintError
export SchemaError

using Base.Iterators: filter
using Base.Iterators: Repeated, repeated

using JSON
import HTTP: request

DEFAULT_TYPE = "string"
DEFAULT_FORMAT = "default"

include("constraints.jl")
include("field.jl")
include("exceptions.jl")
include("schema.jl")
include("table.jl")
include("validators.jl")

end # module
