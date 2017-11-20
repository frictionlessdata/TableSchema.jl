# TableSchema.jl

[![Travis](https://travis-ci.org/frictionlessdata/tableschema-jl.svg?branch=master)](https://travis-ci.org/frictionlessdata/tableschema-jl)
[![Coveralls](http://img.shields.io/coveralls/frictionlessdata/tableschema-jl.svg?branch=master)](https://coveralls.io/r/frictionlessdata/tableschema-jl?branch=master)
[![PyPi](https://img.shields.io/pypi/v/tableschema.svg)](https://pypi.python.org/pypi/tableschema)
[![SemVer](https://img.shields.io/badge/versions-SemVer-brightgreen.svg)](http://semver.org/)
[![Gitter](https://img.shields.io/gitter/room/frictionlessdata/chat.svg)](https://gitter.im/frictionlessdata/chat)

A library for working with [Table Schema](http://specs.frictionlessdata.io/table-schema/) in Julia.

:construction: This package is pre-release and under heavy development. Please see [DESIGN.md](DESIGN.md) and visit the [issues page](https://github.com/frictionlessdata/tableschema-jl/issues) to contribute.

## Features

- `Table` class for working with data and schema
- `Schema` class for working with schemata
- `Field` class for working with schema fields
- `validate` function for validating schema descriptors
- `infer` function that creates a schema based on a data sample

## Getting Started

### Installation

The package use semantic versioning, meaning that major versions could include breaking changes. It is highly recommended to specify a version range in your `REQUIRE` file e.g.:

```
v"1.0-" <= TableSchema < v"2.0-"
```

At the Julia REPL, install the package as usual with:

```Julia
Pkg.add("TableSchema")
```

### Examples

Code examples here require Julia 0.6+.:

```Julia
using TableSchema

filestream = os.open("schema.json")
schema = Schema.read(filestream)
err = schema.errors # handle errors

filestream = os.open("data.csv")
table = Table.read(filestream)
err = table.errors # handle errors

...
```

## Documentation

:construction: Work In Progress.
