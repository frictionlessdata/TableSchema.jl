TABLE_MIN = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
3,10.2,3,string3,2014-06-15 02:00:00
4,10.3,4,string4,2015-06-15 03:00:00
5,10.4,5,string5,2016-06-15 04:00:00
"""

TABLE_BAD = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
,10.2,3,string3,2014-06-15 02:00:00
4,yikes,4,string4,2015-06-15 03:00:00
5,10.4,not good,1234,5678
"""

TABLE_WEIRD = """
a_dict,an_array,a_geopoint,a_date,a_time
{"test":3},"[1\,2\,3]","45.2\,26.1","2014-06-15","02:00:00"
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
    @testset "Infer a minimal Schema" begin
        t = Table(IOBuffer(TABLE_MIN))
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "integer"
        @test s.fields[2].typed == "number"
        @test s.fields[3].typed == "integer"
        @test s.fields[4].typed == "string"
        @test s.fields[5].typed == "string" # TODO: date
    end
    @testset "Infer from a bad Table" begin
        t = Table(IOBuffer(TABLE_BAD))
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "integer"
        @test s.fields[2].typed == "number"
        @test s.fields[3].typed == "integer"
        @test s.fields[4].typed == "string"
        @test s.fields[5].typed == "string"
    end
    @testset "Infer a weird Table" begin
        t = Table(IOBuffer(TABLE_WEIRD))
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "object"
        @test s.fields[2].typed == "array"
        @test s.fields[3].typed == "geopoint"
        @test s.fields[4].typed == "date"
        @test s.fields[5].typed == "time"
    end
    @testset "Infer from a file" begin
        t = Table("data/data_infer.csv")
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "integer"
        @test s.fields[2].typed == "integer"
        @test s.fields[3].typed == "string"
    end
    @testset "Infer from a UTF8 file" begin
        t = Table("data/data_infer_utf8.csv")
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "integer"
        @test s.fields[2].typed == "integer"
        @test s.fields[3].typed == "string"
    end
    @testset "Infer from a ISO-8859-7 file" begin
        t = Table("data/data_infer_iso-8859-7.csv")
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "integer"
        @test s.fields[2].typed == "integer"
        @test s.fields[3].typed == "string"
    end
    @testset "Infer from row limit file" begin
        t = Table("data/data_infer_row_limit.csv")
        tr = TableSchema.read(t)
        s = Schema()
        TableSchema.infer(s, tr, t.headers)
        @test s.fields[1].typed == "string"
        @test s.fields[2].typed == "string"
        @test s.fields[3].typed == "string"
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
    @testset "Handle errors" begin
        s = Schema("data/schema_valid_missing.json")
        t = Table(IOBuffer(TABLE_BAD), s)
        validate(t)
        err = t.errors
        @test length(err) == 1
        @test err[1].name == "required"
    end
end
