BASE_URL = "https://raw.githubusercontent.com/frictionlessdata/tableschema-py/master/"
DESCRIPTOR_MIN = Dict(
    "fields" => [
        Dict( "name" => "id" ),
        Dict( "name" => "height", "type" => "integer" )
    ]
)
DESCRIPTOR_MIN_JSON = """
{"fields": [{"name": "id"}, {"name": "height", "type": "integer"}]}
"""
DESCRIPTOR_MAX_JSON = """
{
    "fields": [
        {"name": "id", "type": "string", "constraints": {"required": true}},
        {"name": "height", "type": "number"},
        {"name": "age", "type": "integer"},
        {"name": "name", "type": "string"},
        {"name": "occupation", "type": "string"}
    ],
    "primaryKey": ["id"],
    "foreignKeys": [{"fields": ["name"], "reference": {"resource": "", "fields": ["id"]}}],
    "missingValues": ["", "-", "null"]
}
"""

TABLE_MIN_FILE_CSV = "test/files/table-min.csv"

TABLE_MIN_DATA_CSV = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
3,10.2,3,string3,2014-06-15 02:00:00
4,10.3,4,string4,2015-06-15 03:00:00
5,10.4,5,string5,2016-06-15 04:00:00
"""

TABLE_BAD_DATA_CSV = """id,height,age,name,occupation
1,10.0,1,string1,2012-06-15 00:00:00
2,10.1,2,string2,2013-06-15 01:00:00
,10.2,3,string3,2014-06-15 02:00:00
4,yikes,4,string4,2015-06-15 03:00:00
5,10.4,not good,1234,5678
"""

TABLE_MIN_SCHEMA_JSON = """
{
  "fields": [
    {"name": "id", "type": "integer", "constraints": {"required": true}},
    {"name": "height", "type": "number"},
    {"name": "age", "type": "integer"},
    {"name": "name", "type": "string", "constraints": {"unique": true}},
    {"name": "occupation", "type": "datetime", "format": "any"}
  ],
  "primaryKey": "id"
}
"""
