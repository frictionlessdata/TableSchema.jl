# TableSchema.jl

[![Travis](https://travis-ci.org/frictionlessdata/tableschema-jl.svg?branch=master)](https://travis-ci.org/frictionlessdata/tableschema-jl)
[![Coveralls](http://img.shields.io/coveralls/frictionlessdata/tableschema-jl.svg?branch=master)](https://coveralls.io/r/frictionlessdata/tableschema-jl?branch=master)
[![SemVer](https://img.shields.io/badge/versions-SemVer-brightgreen.svg)](http://semver.org/)
[![Gitter](https://img.shields.io/gitter/room/frictionlessdata/chat.svg)](https://gitter.im/frictionlessdata/chat)

[![Julia Pkg](http://pkg.julialang.org/badges/JSON_0.6.svg)](http://pkg.julialang.org/?pkg=tableschema&ver=0.6)

A library for working with [Table Schema](http://specs.frictionlessdata.io/table-schema/) in Julia:

> Table Schema is a simple language- and implementation-agnostic way to declare a schema for tabular data. Table Schema is well suited for use cases around handling and validating tabular data in text formats such as CSV, but its utility extends well beyond this core usage, towards a range of applications where data benefits from a portable schema format.

### Features

- `Table` class for working with data and schema
- `Schema` class for working with schemata
- `Field` class for working with schema fields
- `validate` function for validating schema descriptors
- `infer` function that creates a schema based on a data sample

### Status

:construction: This package is pre-release and under heavy development. Please see [DESIGN.md](DESIGN.md) for a detailed overview of our goals, and visit the [issues page](https://github.com/frictionlessdata/tableschema-jl/issues) to contribute and make suggestions. For questions that need to a real time response, reach out via [Gitter](https://gitter.im/frictionlessdata/chat). Thanks! :construction:

# Usage

We aim to make this library compatible with all widely used approaches to work with tabular data in Julia.

Please visit [our wiki](https://github.com/frictionlessdata/datapackage-jl/wiki) for a list of related projects that we are tracking, and contibute use cases there or as enhancement [issues](https://github.com/frictionlessdata/tableschema-jl/issues).

See `examples` folder and unit tests in [runtests.jl](test/runtests.jl) for current usage.

## Table

```Julia
filestream = os.open("cities.csv")
table = Table(filestream)
table.headers
# ['city', 'location']
table.read(keyed=True)
# [
#   {city: 'london', location: '51.50,-0.11'},
#   {city: 'paris', location: '48.85,2.30'},
#   {city: 'rome', location: 'N/A'},
# ]
rows = table.source
# 6×5 Array{Any,2}:
#   "id"    "height"   "age"  "name"     "occupation"         
#  1      10.0        1       "string1"  "2012-06-15 00:00:00"
#  2      10.1        2       "string2"  "2013-06-15 01:00:00"
# ...
err = table.errors # handle errors
...
```

## Schema

```Julia
using TableSchema

filestream = os.open("schema.json")
schema = Schema(filestream)
schema.fields
# <Field1, Field2...>
err = schema.errors # handle errors
```

## Field

Add fields to create or expand your schema like this:

```Julia
schema = Schema()
field = Field()
field.descriptor._name = "A column"
field.descriptor.typed = "Integer"
add_field(schema, field)
```

## Installation

:construction: Work In Progress. The following documentation is relevant only after package release.

The package use semantic versioning, meaning that major versions could include breaking changes. It is highly recommended to specify a version range in your `REQUIRE` file e.g.:

```
v"1.0-" <= TableSchema < v"2.0-"
```

At the Julia REPL, install the package as usual with:

```Julia
Pkg.add("TableSchema")
```

Code examples here require Julia 0.6+.

## Development

Clone this repository, then see the *test* folder for test sources and mock data.

From your console, you can run the unit tests with:

`julia -L src/TableSchema.jl test/runtests.jl`

You should see a test summary displayed.

Alternatively, put `include("src/TableSchema.jl")` in your IDE's console before running `runtests.jl`.
