using TableSchema
using Base.Test

include("data.jl")

@testset "Loading a Table" begin
    @testset "Read data from a file" begin
        t = Table(TABLE_MIN_FILE_CSV)
        # check the headers
        @test length(t.headers) == 5
        @test t.headers[2] == "height"
        # check the number of rows
        @test length(TableSchema.read(t)[:,1]) == 5
        # check the bottom left index
        @test TableSchema.read(t)[5,1] == 5
        # iterate over the rows
        @test sum([ row[2] for row in t ]) == 51
        # no schema, hence exception
        @test_throws TableValidationException TableSchema.validate(t)
    end
    @testset "Read data from memory" begin
        t = Table(IOBuffer(TABLE_MIN_DATA_CSV))
        # check the headers
        @test length(t.headers) == 5
        @test t.headers[2] == "height"
        # check the number of rows
        @test length(TableSchema.read(t)[:,1]) == 5
        # check the bottom left index
        @test TableSchema.read(t)[5,1] == 5
        # iterate over the rows
        @test sum([ row[2] for row in t ]) == 51
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

@testset "Loading a Schema" begin
    @testset "Minimal from dictionary" begin
        s = Schema(DESCRIPTOR_MIN)
        @test length(s.fields) == 2
        f1 = s.fields[1]
        @test f1.name == "id"
        @test f1.of_type == "string"
        f2 = s.fields[2]
        @test f2.of_type == "integer"
        @test !f2.required
    end
    @testset "Parsed from a JSON string" begin
        s = Schema(DESCRIPTOR_MIN_JSON)
        @test length(s.fields) == 2
        @test s.fields[1].name == "id"
        @test !s.fields[2].required
    end
    @testset "Full descriptor from JSON" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        @test length(s.fields) == 5
        @test length(s.primary_key) == 1
        @test length(s.missing_values) == 3
        @test s.fields[1].required
    end
end

@testset "Validating a Schema" begin
    @testset "Create a schema from scratch" begin
        f = Field("width")
        f.of_type = "integer"
        f.required = true
        s = Schema()
        TableSchema.add_field(s, f)
        @test length(s.fields) == 1
        @test s.fields[1].required
    end
    @testset "Check any constraints" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        c1 = s.fields[1].constraints
        @test c1.required
        @test !c1.unique
    end
    # @testset "Check foreign keys" begin
    #     s = Schema(DESCRIPTOR_MAX_JSON)
    #     d1 = s.fields[1]
    #     @test length(s.foreignKeys) == 1
    # end
    # @testset "Handle errors" begin
    #     s = Schema(BAD_SCHEMA)
    #     err = s.errors
    #     ...
    # end
end
