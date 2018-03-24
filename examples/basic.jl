include("../src/TableSchema.jl")
using TableSchema

# Either import the functions, or use TableSchema.read(<Table>) in the code
import TableSchema: read, is_valid, validate

t = Table()
source = readcsv("../data/data_types.csv")
tr = read(t, source) # 5x5 Array{Any,2}
println( "The length is ", length(tr[:,1]) ) # 5
println( "Sum of column 2 is ", sum([ row[2] for row in t ]) ) # 51.0

s = Schema("../data/schema_invalid_empty.json")
if is_valid(s) == false; println("An invalid Schema was found"); end

s = Schema("../data/schema_valid_missing.json")
if is_valid(s); println("A valid Schema is ready"); end

t.schema = s
if validate(t); println("The table is valid according to the Schema"); end

t2 = Table("../data/data_constraints.csv", s)
if validate(t2) == false; println("This other table is not valid"); end
for err in t2.errors
    println(string(err.field.name, " has error: ", err.message))
end
