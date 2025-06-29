## appcfg add auth-header

Create an HTTP authentication header template and supporting folders

### Synopsis


Creates an {auth header name}.gtpl template placeholder as well as supporting test files in "authentication/headers".

Auth headers are general headers and apply to all of the app's action and data pull REST calls. A common type of auth header is one that specifies credentials that are required in order to execute a REST call against the external system.

This template has access to the following template data attributes:
- correlationId
- integration

Take a look in the "authentication/headers/_test_/data" folder for examples of the template data attributes mentioned above. Each example is in a file named "{attribute name}.json". You will use this data for testing and verifying the output of the header template.


```
appcfg add auth-header {header name} [flags]
```

### Options

```
  -h, --help   help for auth-header
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg add](appcfg_add.md)	 - Add various configurations

###### Auto generated by spf13/cobra on 21-Jun-2025
