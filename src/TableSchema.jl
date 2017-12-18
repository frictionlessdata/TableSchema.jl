"""
TableSchema module
https://github.com/frictionlessdata/tableschema-jl
"""
module TableSchema

export Table
export Schema
export Field
# export validate
# export infer

export TableValidationException

using Base.Iterators: filter
using Base.Iterators: Repeated, repeated

using JSON
# using CSV

DEFAULT_TYPE = "string"
DEFAULT_FORMAT = "default"

include("constraints.jl")
include("field.jl")
include("schema.jl")
include("table.jl")

end # module
