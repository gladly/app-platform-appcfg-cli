## appcfg build

Build the app ZIP file

### Synopsis


Create an app ZIP file containing all the configuration specified in the app root folder.

The app configuration is also validated as part of the build process.

When omitting the --file command line flag, the app ZIP file will be created in the current working directory and named "{author}-{appName}-{version}.zip".

e.g. the following manifest.json will create "mycompany.com-my_app-1.0.0.zip"
{
  "author": "mycompany.com",
  "appName": "my_app",
  "version": "1.0.0"
}


```
appcfg build [flags]
```

### Options

```
  -f, --filepath string   the file path and name to use for the app file (optional)
  -h, --help              help for build
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg](appcfg.md)	 - Manage Gladly app platform configuration © 2024 Gladly Software Inc.

###### Auto generated by spf13/cobra on 21-Jun-2025
