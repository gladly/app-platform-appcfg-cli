## appcfg-docs test oauth

Test an individual or all OAuth request configurations

```
appcfg-docs test oauth [ access_token | auth_code | refresh_token ] [flags]
```

### Options

```
  -d, --data-set string   name of the data set to use for the test; data sets are located in sub folders of {request type}/_test_/data
  -h, --help              help for oauth
  -t, --target string     target of the test; one of all, body, url (default "all")
```

### Options inherited from parent commands

```
  -o, --output string   where to output test results; one of: all, console, file, none; file output can be found in "_test_/output/[timestamp]" (default "console")
  -r, --root string     root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg-docs test](appcfg-docs_test.md)	 - Test various individual configurations or all configurations

###### Auto generated by spf13/cobra on 29-Oct-2024