# TableSchema.jl

[![Travis](https://travis-ci.org/frictionlessdata/tableschema-jl.svg?branch=master)](https://travis-ci.org/frictionlessdata/tableschema-jl)
[![Coveralls](http://img.shields.io/coveralls/frictionlessdata/tableschema-jl.svg?branch=master)](https://coveralls.io/r/frictionlessdata/tableschema-jl?branch=master)
[![PyPi](https://img.shields.io/pypi/v/tableschema.svg)](https://pypi.python.org/pypi/tableschema)
[![SemVer](https://img.shields.io/badge/versions-SemVer-brightgreen.svg)](http://semver.org/)
[![Gitter](https://img.shields.io/gitter/room/frictionlessdata/chat.svg)](https://gitter.im/frictionlessdata/chat)

A library for working with [Table Schema](http://specs.frictionlessdata.io/table-schema/) in Julia:

> Table Schema is a simple language- and implementation-agnostic way to declare a schema for tabular data. Table Schema is well suited for use cases around handling and validating tabular data in text formats such as CSV, but its utility extends well beyond this core usage, towards a range of applications where data benefits from a portable schema format.

:construction: This package is pre-release and under heavy development. Please see [DESIGN.md](DESIGN.md) and visit the [issues page](https://github.com/frictionlessdata/tableschema-jl/issues) to contribute.

## Features

- `Table` class for working with data and schema
- `Schema` class for working with schemata
- `Field` class for working with schema fields
- `validate` function for validating schema descriptors
- `infer` function that creates a schema based on a data sample


# Usage

## Schema

```Julia
using TableSchema

filestream = os.open("schema.json")
schema = Schema(filestream)
err = schema.errors # handle errors
```

## Table

```Julia
filestream = os.open("data.csv")
table = Table(filestream)
err = table.errors # handle errors
...
```

## Field

Add fields to create or expand your schema like this:

```Julia
descriptor = Descriptor()
descriptor._name = "A column"
descriptor._type = "Integer"
schema.add_field(descriptor)
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
