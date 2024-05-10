## appcfg add data-pull

Create a data pull configuration folder and all relevant files

### Synopsis

Creates a "data/pull/{data pull name}" folder containing placeholders for all relevant 
data pull configuration files.

If not already present, it will also create a "data/data_schema.graphql" file. You will
add the data pull's corresponding GraphQL schema definition to this file.

The following configuration files will be created:

config.json
-----------
The config.json file contains meta data about the HTTP request for this data pull. This
file is populated with values that you specify via add data-pull command line flags.

request_url.gtpl
----------------
This template will be used to create the HTTP request URL associated with the
data pull. This template has access to the following template data attributes:
- correlationId
- integration
- customer (data from the associated Gladly customer profile)
- externalData (contains data retrieved by other data pull requests; used by dependant data pulls)

request_body.gtpl
-----------------
This template will be used to create the HTTP request body for requests that
use the POST, PUT or PATCH method. The format of the output for this template
must match the "contentType" format specified in the "config.json" file. This
template has access to the following template data attributes:
- correlationId
- integration
- customer
- externalData
 
response_transformation.gtpl
----------------------------
The Gladly app platform supports data formatted using the JSON format. If
the external system already returns data in JSON as either an individual
object "{}" or as an array of objects "[{}, {}]" that conform to the desired
format then you do not need to create a response transformation template.
Simplify provide a definition of the data structure in the "data_schema.graphql"
file. Otherwise you will need to create a template that will transform the raw
JSON response in to the desired data format. Your transformed JSON must
either be an object "{}" or an array of objects "[{}, {}]" that conform
to the corresponding definition in the "data_schema.graphql" file.

This template has access to the following template data attributes:
- correlationId
- integration
- customer
- rawData (object representing the JSON response data; this is the data you will transform)
- externalData
- request (HTTP request data)
- response (HTTP response data)

external_id.gtpl
----------------
Each object must have a unique ID assigned to it in the external system. The
Gladly app platform references objects by this ID. The ID is needed in order
to support modelling relationships between objects (e.g. an order object my
reference product objects) as well as being able to update existing objects
with newer versions. This template acts on each individual transformed data
object and has access to all object attributes. This template usually just
contains a reference to the attribute containing the ID of the object;
e.g. {{.id}}.

external_parent_id.gtpl
-----------------------
An external parent ID template is needed when an object is a child of another
object and is used to model the parent/child relationship; e.g order objects
are related to a customer object and orders reference their parent via a
customer ID attribute on the orders object. The external parent ID template tells
the Gladly app platform how child objects are related and enables the creation
of seamless object hierarchies; e.g. this allows for orders to be simply
referenced as an attribute of a "Customer" object event though they are separate
data objects. The Gladly app platform automatically creates the relationship
based on the parent ID of the child object. This template acts on each individual
transformed data object and has access to all object attributes. This template
usually just contains a reference to the attribute containing the parent ID;
e.g. {{.customerId}} of an orders object.

external_updated_at.gtpl
------------------------
The external updated at template is used to extract the timestamp of when
the object was last updated in the external system. The Gladly app platform
uses the update at timestamp to make sure that newer object data is not
overwritten with older versions. Also, data is always returned in descending
order from newest updated at timestamp to oldest to ensure that the most recent
data is always front and center. In case the data object does not contain
an updated at attribute, the Gladly app platform will use the timestamp of
when the data was retrieved from the external system as the updated at
timestamp. This template acts on each individual transformed data object and
has access to all object attributes. This template usually just contains
a reference to the attribute containing the updated at timestamp;
e.g. {{.updatedAt}}. The resulting template output MUST be in ISO8601 format.


Take a look in the "data/pull/{data pull name}/_test_/data" folder for examples
of the template data attributes mentioned above. Each example is in a file
named "{attribute name}.json". You will use this data for testing and verifying
the output of the various templates that you define.


```
appcfg add data-pull {data pull name} [flags]
```

### Options

```
  -c, --content-type string           Content-Type of the request body when http-method is POST, PUT or PATCH
  -t, --data-type string              the data type name associated with this data; data type names are alphanumeric and may also include an underscore
  -v, --data-version string           the version of the data type; data types use semantic versioning
  -d, --depends-on-type stringArray   one or more data types that this data pull depends on; use multiple flags for multiple types
  -h, --help                          help for data-pull
  -m, --http-method string            one of GET,POST,PUT,PATCH,DELETE
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the
                      GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg add](appcfg_add.md)	 - Add various configurations

###### Auto generated by spf13/cobra on 10-May-2024
