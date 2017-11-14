using Base.Test
using Tableschema

include("data.jl")

@testset "Loading a minimal schema" begin
    s = Tableschema.load(DESCRIPTOR_MIN)
    @test length(s.fields) == 2
    d1 = s.fields[1].descriptor
    @test d1._name == "id"
    @test d1._type == "string"
    d2 = s.fields[2].descriptor
    @test d2._type == "integer"
    @test d2._required == false
end

@testset "Loading a schema from JSON" begin
    s = Tableschema.load(DESCRIPTOR_MIN_JSON)
    @test length(s.fields) == 2
    d1 = s.fields[1].descriptor
    @test d1._name == "id"
    d2 = s.fields[2].descriptor
    @test d2._required == false
end

@testset "Loading a complex schema" begin
    s = Tableschema.load(DESCRIPTOR_MAX_JSON)
    @test length(s.fields) == 5
    @test length(s.primaryKey) == 1
    @test length(s.foreignKeys) == 1
    @test length(s.missingValues) == 3
end
