using TableSchema
using Base.Test

import TableSchema: read, validate, infer, save

include("read.jl")
include("validate.jl")
include("infer.jl")
include("save.jl")
