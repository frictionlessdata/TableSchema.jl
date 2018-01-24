using TableSchema
using Base.Test

include("data.jl")

@testset "Read a Table Schema descriptor" begin
    @testset "Minimal from dictionary" begin
        s = Schema(DESCRIPTOR_MIN)
        @test length(s.fields) == 2
        f1 = s.fields[1]
        @test f1.name == "id"
        @test f1.typed == "string"
        f2 = s.fields[2]
        @test f2.typed == "integer"
        @test !f2.constraints.required
    end
    @testset "Parsed from a JSON string" begin
        s = Schema(DESCRIPTOR_MIN_JSON)
        @test length(s.fields) == 2
        @test s.fields[1].name == "id"
        @test !s.fields[2].constraints.required
    end
    @testset "Full descriptor from JSON" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        @test length(s.fields) == 5
        @test length(s.primary_key) == 1
        @test length(s.missing_values) == 3
        @test s.fields[1].constraints.required
        @test !(s.fields[1].constraints.unique)
    end
end

@testset "Validating a Table Schema" begin
    @testset "Read in from JSON and validate" begin
        s = Schema(DESCRIPTOR_MIN_JSON)
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
        # s = Schema(DESCRIPTOR_MAX_JSON)
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

@testset "Loading a Table" begin
    @testset "Read data from a file" begin
        t = Table("data/data_numeric.csv")
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
        @test_throws TableValidationException validate(t)
    end
    @testset "Read data from memory" begin
        t = Table(IOBuffer(TABLE_MIN_DATA_CSV))
        tr = TableSchema.read(t)
        # check the headers
        @test length(t.headers) == 5
        @test t.headers[2] == "height"
        # check the number of rows
        @test length(tr[:,1]) == 5
        # check the bottom left index
        @test tr[5,1] == 5
        # iterate over the rows
        @test sum([ row[2] for row in t ]) == 51
        # no schema, hence exception
        @test_throws TableValidationException validate(t)
    end
    @testset "Infer the Schema" begin
        t = Table(IOBuffer(TABLE_MIN_DATA_CSV))
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
    end
    @testset "Save the Table" begin
    end
end

@testset "Validating Table schema" begin
    @testset "Check constraints" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        @test s.fields[1].constraints.required
        t = Table(IOBuffer(TABLE_MIN_DATA_CSV))
        tr = TableSchema.read(t)
        @test TableSchema.checkrow(s.fields[1], tr[1,1])
        @test TableSchema.checkrow(s.fields[2], tr[2,2])
        @test TableSchema.checkrow(s.fields[3], tr[3,3])
        @test_throws ConstraintError TableSchema.checkrow(s.fields[1], "")
    end
    @testset "Handle errors" begin
        s = Schema(DESCRIPTOR_MAX_JSON)
        t = Table(IOBuffer(TABLE_BAD_DATA_CSV), s)
        validate(t)
        err = t.errors
        @test length(err) == 1
        @test err[1].name == "required"
    end
end
