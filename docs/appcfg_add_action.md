## appcfg add action

Create an action configuration folder and all relevant files

### Synopsis

Creates an "actions/{action name}" folder containing placeholders for all relevant
action configuration files.

If not already present, it will also create an "actions/actions_schema.graphql" file.
You will add the action's corresponding GraphQL schema definition to this file.

The following configuration files will be created:

config.json
-----------
The config.json file contains meta data about the HTTP request for this action. This
file is populated with values that you specify via the add action command line flags.

request_url.gtpl
----------------
This template will be used to create the HTTP request URL associated with the
action. This template has access to the following template data attributes:
- correlationId
- integration
- inputs

request_body.gtpl
-----------------
This template will be used to create the HTTP request body for requests that
use the POST, PUT or PATCH method. The format of the output for this template
must match the "contentType" format specified in the "config.json" file.This
template has access to the following template data attributes:
- correlationId
- integration
- inputs
 
response_transformation.gtpl
----------------------------
The Gladly app platform supports HTTP response data formatted as JSON or XML. If
the external system already returns data in JSON that conforms to the desired
format then you do not need to create a response transformation template.
Simply provide a definition of the data structure in the "actions_schema.graphql"
file. Otherwise you will need to create a template that will transform the JSON
or XML response in to the desired data format. HTTP response data is accessed
via the ".rawData" template data attribute. When the response data is in JSON
format then the ".rawData" attribute is an object representation of that data
and data fields can be accessed using simple dot notation; e.b. {{.rawData.someAttr}}.
When response data is in XML format then the ".rawData" attribute will be an
XML Document Object Model object; see "appcfg platform xml" for more details.
When the action is configured to process the raw response data (i.e. "rawResponse"
is true in the config.json file) then the ".rawData" attribute will be a
byte array containing the response. When the action is configured to process
raw response data, it is the responsibility of the template to appropriately
handle any HTTP response status codes as well as parse the binary response data
in order to transform it in to JSON.

This template has access to the following template data attributes:
- correlationId
- integration
- inputs
- rawData (representing the response data; this is the data you will transform)
- request (HTTP request data)
- response (HTTP response data)

Take a look in the "actions/{action name}/_test_/data" folder for examples of the
template data attributes mentioned above. Each example is in a file  named
"{attribute name}.{json|xml|bin}". You will use this data for testing and verifying the
output of the various templates that you define.


```
appcfg add action {action name} [flags]
```

### Options

```
  -c, --content-type string   Content-Type of the request body when http-method is POST, PUT or PATCH
  -h, --help                  help for action
  -m, --http-method string    one of GET,POST,PUT,PATCH,DELETE
      --raw-response          due to how the HTTP response is formatted it is necessary for the "response_transformation.gtpl" template to handle all logic for processing the response
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg add](appcfg_add.md)	 - Add various configurations

###### Auto generated by spf13/cobra on 21-Jun-2025
