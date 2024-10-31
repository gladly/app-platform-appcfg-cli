## appcfg add oauth authorization_code

Create the oauth configuration folder and all relevant files for the authorization_code grant type

### Synopsis

Creates the "authentication/oauth" folder containing the HTTP request configurations
for requesting and refreshing an OAuth access token using the authorization_code
grant type.

This command will also create the HTTP Authorization header template in the
"authentication/headers" folder. OAuth uses bearer authentication and in many
cases the standard HTTP Authorization header is used for specifying the OAuth
access token. In the case that the system you are integrating with does not
utilize the Authorization header, simply replace the "Authorization.gtpl"
header template file with the header that is required by the external system
you are integrating with.

authentication/oauth/config.json
--------------------------------
The config.json file contains the grant type used for authentication. It should
not be necessary to modify the contents of this file.

authentication/headers/Authorization.gtpl
-----------------------------------------
This template creates the Authorization header value needed to authenticate each
data pull and action request. This template is pre-populated and should not
require modification. The Gladly app platform stores the retrieved OAuth access
tokens in the ".integration.secrets.access_token" attribute. This template has
access to the following template data attributes:

- correlationId
- integration

The following configuration folders and files will also be created:

# authentication/oauth/auth_code folder

Contains the configuration files for creating the request that initiates the
authorization_code OAuth flow with the authorization server of the external
system that you are integrating with.

authentication/oauth/auth_code/config.json
------------------------------------------
The auth code config.json file contains the HTTP meta data for making
the HTTP request for retrieving the authorization code. Only the HTTP GET
method is supported for the authorization server request so it is not
necessary to modify the contents of this file.

authentication/oauth/auth_code/request_url.gtpl
-----------------------------------------------
This template will be used to create the HTTP request URL for initiating the
OAuth flow with the authorization server. This template has access to the
following template data attributes. The template data is a combination of
values automatically populated by the Gladly app platform and the integration
configuration you have specified for the app.

- correlationId
- integration
- oauth

e.g. template data
```
{
  "correlationId": "",
  "integration": {
    "configuration": {
      ...,
      "client_id": ""
    },
    "secrets": {
      "client_secret": ""
    }
  },
  "oauth": {
    "redirect_uri": "Gladly OAuth redirect URI"
  }
}
```

# authentication/oauth/access_token folder

Contains the configuration files for creating the request that retrieves the
access token. This request is initiated as a response to the authorization
server redirect URI containing the authorization code.

authentication/oauth/access_token/config.json
---------------------------------------------
The access token config.json file contains the HTTP meta data for making
the HTTP request for retrieving the access token.

authentication/oauth/access_token/request_url.gtpl
--------------------------------------------------
This template will be used to create the HTTP request URL for retrieving the
access token. This template has access to the following template data attributes.
The template data is a combination of values automatically populated by the Gladly
app platform and the integration configuration you have specified for the app.

- correlationId
- integration
- oauth

e.g. template data
```
{
  "correlationId": "",
  "integration": {
    "configuration": {
      ...,
      "client_id": ""
    },
    "secrets": {
      "client_secret": ""
    }
  },
  "oauth" {
    "request": {
      "url": "Gladly OAuth redirect URI with authorization code and state from authorization server",
      "method": "GET",
      "headers": {
        "header-name": ["header value"]
      }
    },
    "code": "",
    "state": ""
  }
}
```

authentication/oauth/access_token/request_body.gtpl
-----------------------------------------------------
Depending on the HTTP request method, this template will create the HTTP request
body for retrieving the access token. This template has access to the following
template data attributes (see above for an example):

- correlationId
- integration
- oauth

# authentication/oauth/refresh_token folder

Contains the configuration files for creating the request for refreshing an
expired access token. This request is initiated when the Gladly app platform
receives an HTTP status of 401 or 403 from the external system as a result of
a data pull or an action.

authentication/oauth/refresh_token/config.json
----------------------------------------------
The refresh token config.json file contains the HTTP meta data for making
the HTTP request for refreshing the access token.

authentication/oauth/refresh_token/request_url.gtpl
---------------------------------------------------
This template will be used to create the HTTP request URL for refreshing the
access token. This template has access to the following template data attributes.
The template data is a combination of values automatically populated by the Gladly
app platform and the integration configuration you have specified for the app.

e.g. template data
```
{
  "correlationId": "",
  "integration": {
    "configuration": {
      ...,
      "client_id": ""
    },
    "secrets": {
      "client_secret": "",
      "access_token": "",
      "refresh_token": ""
    }
  }
}
```

authentication/oauth/refresh_token/request_body.gtpl
----------------------------------------------------
Depending on the HTTP request method, this template will create the HTTP request
body for refreshing the access token. This template has access to the following
template data attributes (see above for an example):

- correlationId
- integration


```
appcfg add oauth authorization_code [flags]
```

### Options

```
  -d, --auth-domain string   the domain of the authorization server associated with the app
  -h, --help                 help for authorization_code
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg add oauth](appcfg_add_oauth.md)	 - Create the oauth configuration folder and all relevant files for the specified grant type

###### Auto generated by spf13/cobra on 30-Oct-2024
