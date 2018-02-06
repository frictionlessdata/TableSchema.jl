@testset "Read a Table Schema descriptor" begin
    @testset "Minimal from dictionary" begin
        MIN_SCHEMA = Dict("fields" => [
            Dict( "name" => "id" ),
            Dict( "name" => "height", "type" => "integer" )
        ])
        s = Schema(MIN_SCHEMA)
        @test length(s.fields) == 2
        f1 = s.fields[1]
        @test f1.name == "id"
        @test f1.typed == "string"
        f2 = s.fields[2]
        @test f2.typed == "integer"
        @test !f2.constraints.required
    end
    @testset "Parsed from a JSON string" begin
        s = Schema("data/schema_valid_simple.json")
        @test length(s.fields) == 2
        @test s.fields[1].name == "id"
        @test !s.fields[2].constraints.required
    end
    @testset "Full descriptor from JSON" begin
        s = Schema("data/schema_valid_full.json")
        @test length(s.fields) == 15
        @test length(s.primary_key) == 4
    end
    @testset "Missing values and constraints" begin
        s = Schema("data/schema_valid_missing.json")
        @test length(s.fields) == 5
        @test length(s.primary_key) == 1
        @test length(s.missing_values) == 3
        @test s.fields[1].constraints.required
        @test !(s.fields[1].constraints.unique)
    end
end
