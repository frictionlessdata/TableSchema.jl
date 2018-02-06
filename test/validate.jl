@testset "Validating a Table Schema" begin
    @testset "Read in from JSON and validate" begin
        s = Schema("data/schema_valid_simple.json")
        @test length(s.fields) == 2
        @test s.fields[1].name == "id"
        @test !s.fields[2].constraints.required
        @test validate(s)
    end
    @testset "Created from scratch" begin
        f = Field("width")
        f.typed = "integer"
        f.constraints.required = true
        s = Schema()
        TableSchema.add_field(s, f)
        @test length(s.fields) == 1
        @test s.fields[1].constraints.required
        @test_throws SchemaError validate(s)
    end
    @testset "Check foreign keys" begin
        # s = Schema("data/schema_valid_full.json")
        # d1 = s.fields[1]
        # @test length(s.foreignKeys) == 1
    end
    @testset "Handle schema errors" begin
        @test_throws SchemaError Schema("data/schema_invalid_empty.json", true)
        # s = Schema(BAD_SCHEMA)
        # @test !validate(s)
        # err = s.errors
        # ...
    end
end
