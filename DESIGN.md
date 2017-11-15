# Frictionless Data Julia Libraries - Design Document

Oleg Lavrovsky ~ [@loleg](https://github.com/loleg)
Last updated: *November 2017*

## Overview

[Frictionless Data](http://frictionlessdata.io/) is a set of lightweight standards and tooling to make it effortless to get, share, and validate data.

This design document focuses on functional specification and design of two code libraries written in [Julia](https://julialang.org/): "Table Schema" and "Data Package".  The design must follow the general specification design principles described at [specs.frictionlessdata.io](https://specs.frictionlessdata.io) and the V1 announcement ([blog.okfn.org](https://blog.okfn.org/2017/09/05/frictionless-data-v1-0/), [hackmd.io](https://hackmd.io/KwUzE5wIwRgWgGYENzDgFmAgzHKA2fJOABmHwGMATEmK8GIoA===)).

## Functional Specification

Each library needs to implement a set of core “actions” that are further described in the implementation documentation. For simplicity, these core actions are reproduced here:

**Table Schema**

- read and validate a table schema descriptor
- create/edit a table schema descriptor
- provide a model-type interface to interact with a descriptor
- infer a Table Schema descriptor from a supplied sample of data
- validate a data source against the Table Schema descriptor, including in response to editing the descriptor
- enable streaming and reading of a data source through a Table Schema (cast on iteration)

**Data Package**

- read an existing Data Package descriptor
- validate an existing Data Package descriptor, including profile-specific validation via the registry of JSON Schemas
- create a new Data Package descriptor
- edit an existing Data Package descriptor
- as part of editing a descriptor, helper methods to add and remove resources from the resources array
- validate edits made to a data package descriptor
- save a Data Package descriptor to a file path
- zip a Data Package descriptor and its co-located references (more generically: "zip a data package")
- read a zip file that "claims" to be a data package
- save a zipped Data Package to disk

## API Proposal

Package names should be short and named as the base name of its source directory, as per conventions described in the [Julia Manual](https://docs.julialang.org/en/latest/manual/packages/).

We will have two central modules within the tableschema-jl root: Schema and Table. That will allow us to have constructions like Schema.Read, which are very desirable.

The first design proposal will follow the basic usage described [tableschema-py](https://github.com/frictionlessdata/tableschema-py).

The `Schema.load()` function accepts a stream (file I/O), string (JSON) or dictionary (parsed object) representation of a table schema:

```Julia
function load(ts::Dict) (*Schema, error)
function load(ts::String) (*Schema, error)
function load(ts::IO) (*Schema, error)
```

`Field` represents a resources in the schema, such as a cell on a table

## Usage

An example sequence which loosely follows the test suite seen in the `test` subfolder:

```Julia
filestream = os.open("schema.json")
schema = Tableschema.read(filestream)

err = schema.errors
# err is falsy, else an error summary

filestream = os.open("data.csv")
table = Tableschema.read(filestream)
err = table.errors

records = [ Dict(
    "name" => "header:name",
    "age" => "header:age"
) ]
filter = table.filter(records)
err = filter.errors

println("$i - $r") for (i, r) in filter
```

## Implementation

- At least, finish the basic implementation level. Interfaces are described here.
- Must follow OKI coding standards.
- Development process is described here.
- For Style and linting, we are going to use ****. On the linter and static analysis side, we recommend usage of ****.
- The code will be written and tested in Julia 0.6.1, the latest stable release as per November 2017.
- For Documentation, we are going to  Julia's standard package documentation and examples, which can be further extracted and generated using *****.
- The library documentation must be searchable at https://pkg.julialang.org
- Unit and integration tests are going to be done using Julia's standard Base.Test
