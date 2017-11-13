using Base.Test
using Tableschema

include("data.jl")

@testset "Loading a minimal schema" begin
    s = Tableschema.load(DESCRIPTOR_MIN)
    @test length(s.fields) == 2
    @test s.fields[1].descriptor._name == "id"
    @test s.fields[1].descriptor._type == "string"
    @test s.fields[2].descriptor._type == "integer"
    @test s.fields[2].descriptor._required == false
end
