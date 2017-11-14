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
