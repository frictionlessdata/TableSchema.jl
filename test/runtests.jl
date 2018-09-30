using TableSchema
using Test

import TableSchema: read, validate, infer, save

import DelimitedFiles: readdlm

include("schema.jl")
include("read.jl")
include("validate.jl")
include("infer.jl")
include("save.jl")
