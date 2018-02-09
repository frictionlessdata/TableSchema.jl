using TableSchema

t = Table("data/data_types.csv")
tr = TableSchema.read(t) # 5x5 Array{Any,2}

println( "The length is ", length(tr[:,1]) ) # 5
println( "Sum of column 2 is ", sum([ row[2] for row in t ]) ) # 51.0

s = Schema("data/schema_valid_missing.json")
if validate(s); println("A valid Schema is ready"); end

t.schema = s
if validate(t); println("The table is valid"); end

t2 = Table("data/data_constraints.csv", s)
if validate(t2) == false; println("This other table is not valid"); end
for err in t2.errors
    println(string(err.field.name, " has error: ", err.name))
end
