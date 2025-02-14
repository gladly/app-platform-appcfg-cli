## appcfg apps logs record-detailed

Begin or end recording of detailed logs for a configuration

### Synopsis


Begin or end recording of detailed logs for a given configuration. Detailed logging captures the HTTP requests and responses involved in a GraphQL request to an app configuration.

How to Use:

1. Begin detailed logging to gather more information about your GraphQL requests. Once active, it remains enabled for six hours by default, after which it automatically deactivates.
2. Re-run this command before the six hours elapse if you need more time, or end recording the logs once you’ve gathered enough information.

Caution:
Detailed logging records all incoming external data, which can be substantial. This can impact the performance of the app configuration and any systems that rely on its data. Use it only when diagnosing issues and disable it once the problem is resolved.

Next Steps:

* After activating detailed logging, use "appcfg apps logs list" to retrieve your GraphQL logs.
* Then, use "appcfg apps logs detail" to view the captured requests and responses in detail.

By following these steps, you can isolate and resolve issues more efficiently while maintaining system performance when detailed logging is not required.


```
appcfg apps logs record-detailed {configuration name | configuration ID} [flags]
```

### Options

```
  -b, --begin   include to begin or extend recording detailed logs for this configuration
  -e, --end     include to end recording detailed logs for this configuration
  -h, --help    help for record-detailed
```

### Options inherited from parent commands

```
  -g, --gladly-host string   Gladly host; alternatively set the GLADLY_APP_CFG_HOST environment variable
  -r, --root string          root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
  -t, --token string         API token for Gladly user; alternatively set the GLADLY_APP_CFG_TOKEN environment variable
  -u, --user string          Gladly user email that created the API token; alternatively set the GLADLY_APP_CFG_USER environment variable
```

### SEE ALSO

* [appcfg apps logs](appcfg_apps_logs.md)	 - Record, view, and search logs related to your Gladly app platform apps

###### Auto generated by spf13/cobra on 7-Feb-2025
