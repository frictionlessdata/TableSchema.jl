module TableSchema

using JSON

export Schema

DEFAULT_TYPE = "string"
DEFAULT_FORMAT = "default"

include("descriptor.jl")
include("field.jl")
include("schema.jl")

end # module
