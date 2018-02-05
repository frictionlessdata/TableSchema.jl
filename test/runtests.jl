using TableSchema
using Base.Test

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

TABLE_MIN = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
3,10.2,3,string3,2014-06-15 02:00:00
4,10.3,4,string4,2015-06-15 03:00:00
5,10.4,5,string5,2016-06-15 04:00:00
"""

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
        t = Table(IOBuffer(TABLE_MIN))
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
        t = Table(IOBuffer(TABLE_MIN))
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
    end
    @testset "Save the Table" begin
    end
end

@testset "Validating Table schema" begin
    @testset "Check constraints" begin
        s = Schema("data/schema_valid_missing.json")
        @test s.fields[1].constraints.required
        t = Table(IOBuffer(TABLE_MIN))
        tr = TableSchema.read(t)
        @test TableSchema.checkrow(s.fields[1], tr[1,1])
        @test TableSchema.checkrow(s.fields[2], tr[2,2])
        @test TableSchema.checkrow(s.fields[3], tr[3,3])
        @test_throws ConstraintError TableSchema.checkrow(s.fields[1], "")
    end
    TABLE_BAD = """id,height,age,name,occupation
    1,10.0,1,string1,2012-06-15 00:00:00
    2,10.1,2,string2,2013-06-15 01:00:00
    ,10.2,3,string3,2014-06-15 02:00:00
    4,yikes,4,string4,2015-06-15 03:00:00
    5,10.4,not good,1234,5678
    """
    @testset "Handle errors" begin
        s = Schema("data/schema_valid_missing.json")
        t = Table(IOBuffer(TABLE_BAD), s)
        validate(t)
        err = t.errors
        @test length(err) == 1
        @test err[1].name == "required"
    end
end
