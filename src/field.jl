"""
Table Schema field
https://github.com/frictionlessdata/tableschema-jl#field
"""

type Field
    descriptor::Descriptor

    function Field(d::Descriptor)
        new(d)
    end

    function Field()
        new(Descriptor())
    end

    name() = descriptor._name
    # get_type = descriptor._type
    # format = descriptor._format
    #
    # required = haskey(descriptor._constraints, "required") ?
    #     descriptor._constraints["required"] : false
    # constraints = descriptor._constraints
    #
    # cast_value = NullException()
    # test_value = NullException()
end
