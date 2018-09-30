#
# Exploration of an apparent bug in array iteration
#

using DelimitedFiles

mutable struct mytbl
    source
    function mytbl(csvdata::Base.GenericIOBuffer)
        source = readdlm(csvdata, ',')
        source = convert(Array, source[2:end,:]) # clear the headers
        new(source)
    end
end

Base.length(it::mytbl) = size(it.source, 1)
function Base.iterate(it::mytbl, (el, i)=(it.source[1,:], 1))
   return i >= length(it) ? nothing : (el, (it.source[i + 1,:], i + 1))
end


TABLE_CAST = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
3,10.2,3,string3,2014-06-15 02:00:00
4,10.3,4,string4,2015-06-15 03:00:00
5,10.4,5,string5,2016-06-15 04:00:00
"""

table =  mytbl(IOBuffer(TABLE_CAST))

[ row for row in table ]
# the last element is #undef

[ row[1] for row in table ]
# Returns:
[1, 2, 3, 4, 229445824]

[ row[2] for row in table ]
# Returns:
[10.0, 10.1, 10.2, 10.3, 4.94e-324]
