using TableSchema
using Base.Test

include("data.jl")

@testset "Loading a Schema" begin
    @testset "Minimal from dictionary" begin
        s = Schema(DESCRIPTOR_MIN)
        @test length(s.fields) == 2
        d1 = s.fields[1].descriptor
        @test d1._name == "id"
        @test d1._type == "string"
        d2 = s.fields[2].descriptor
        @test d2._type == "integer"
        @test !d2.constraints.required
    end
    @testset "Parsed from a JSON string" begin
        s = Schema(DESCRIPTOR_MIN_JSON)
        @test length(s.fields) == 2
        d1 = s.fields[1].descriptor
        @test d1._name == "id"
        d2 = s.fields[2].descriptor
        @test !d2.constraints.required
    end
    @testset "Full descriptor from JSON" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        @test length(s.fields) == 5
        @test length(s.primary_key) == 1
        @test length(s.missing_values) == 3
        d1 = s.fields[1].descriptor
        @test d1.constraints.required
    end
end

@testset "Validating a Schema" begin
    @testset "Create a schema from scratch" begin
        f = Field()
        f.descriptor._name = "width"
        f.descriptor._type = "integer"
        s = Schema()
        TableSchema.add_field(s, f)
        @test length(s.fields) == 1
    end
    @testset "Check any constraints" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        d1 = s.fields[1].descriptor
        @test d1.constraints.required
        @test !d1.constraints.unique
    end
    # @testset "Check foreign keys" begin
    #     s = Schema(DESCRIPTOR_MAX_JSON)
    #     d1 = s.fields[1].descriptor
    #     @test length(s.foreignKeys) == 1
    # end
    # @testset "Handle errors" begin
    #     s = Schema(BAD_SCHEMA)
    #     err = s.errors
    #     ...
    # end
end

@testset "Loading a Table" begin
    @testset "Read a simple CSV" begin
        t = Table(TABLE_MIN_CSV_FILE)
        # check the headers
        @test length(t.headers) == 5
        @test t.headers[2] == "height"
        # check the number of rows
        @test length(TableSchema.read(t)[:,1]) == 5
        # check the bottom left index
        @test TableSchema.read(t)[5,1] == 5
        # no schema, hence exception
        @test_throws TableValidationException TableSchema.validate(t)
    end
    @testset "Infer the Schema" begin
    end
    @testset "Save the Table" begin
    end
    @testset "Validate with Schema" begin
        # s = Schema(DESCRIPTOR_MAX_JSON)
        # t = Table(TABLE_MIN_CSV_FILE, s)
        # TableSchema.validate(t)
    end
    @testset "Handle errors" begin
        # t = Table(TABLE_BAD_CSV_FILE)
        # err = t.errors
        # ...
    end
end
