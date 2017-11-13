using Base.Test
using Tableschema

include("data.jl")

@testset "load min schema" begin
    @test Tableschema.load(DESCRIPTOR_MIN) == "Not implemented"
end
