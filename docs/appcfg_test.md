## appcfg test

Test various individual configurations or all configurations

### Synopsis

Most of the app configuration files that you create can be tested using this tool.

The general approach to testing is to validate output based on some configured
input. Inputs mainly come in the form of template data attributes and output
is either validated against expected plain text or JSON files.

Each template type supports a set of template data attributes and test data for
these attributes can be configured via JSON files. Each file is named after it's
corresponding attribute name and has a ".json" extension. E.g. the "customer"
attribute for data pull templates is configured in a "customer.json" file.

Test related files for action and data pull configurations are located in a
"_test_" sub folder of each configuration. Test configuration data is located
in the "_test_/data" folder and test output will be written to the "_test_/output"
folder when output is directed to a file.

Files used for validating test output have a prefix of "expected_" followed by
the name of the template file who's output is being validated. E.g. a "request_url.gtpl"
file will have an output validation file named "expected_request_url.txt". The
file extension depends on the expected output format of the corresponding
template.

For example, a "response_transformation.gtpl" template file  will have a validation
file named "expected_response_transformation.json" since these templates MUST
generate JSON output.

Expected JSON output uses a data comparison whereas expected plain text output
will either perform an exact string comparison or use a regular expression. Expected
text output files ("expected_*.txt") can specify a regular expression by surrounding
the text content of the file with a leading and trailing slash "/" character.

A test for a given template will create the template data from the ".json" attribute
files and compare the template result to the corresponding expected output file.

The "add" command for each configuration will create test stub files for the
relevant template data attributes in the "_test_/data" folder and "expected_*.*"
validation files in the "_test_/data/success" dataset folder. Tests are organized
via datasets which are comprised of template data attribute files and expected
template output files. The default test dataset created by the "add" command is
for testing successful template transformations.

Test datasets live in sub folders under the "_test_/data" folder, where each
folder contains the relevant JSON template attribute test data files and corresponding
expected output files for a given test scenario. The dataset folder name should
provide a brief description of what is being tested. Datasets are referenced
via the --data-set command line flag when running tests. Omitting the --data-set
flag will test all datasets for a given configuration. You can create as many
test dataset folders as needed.

The template data attribute files in the "_test_/data" folder serve as defaults
for all test datasets. Simply create a template data attribute file in a dataset
folder to override the default when unique values are required for the given test.

Conditions in your templates that trigger calling the "stop" or "fail" functions can
be tested by including the text from the corresponding "stop" and "fail" in the
"expected_*.*" file. The text MUST be surrounded by double quotes (") just as
specified for the "stop" and "fail" calls.

e.g. to verify the following condition
{{if not .rawData}}
    {{stop "the request did not return any data"}}
{{end}}

just include the text "the request did not return any data" (including the double
quotes) in the corresponding "expected_response_transformation.json" file.

For more information regarding the "stop" and "fail" (sprig) functions run
"appcfg platform template-functions".


```
appcfg test [action | action-header | auth-header | data-pull | data-pull-header | oauth | oauth-header | signing-header] [flags]
```

### Options

```
  -h, --help            help for test
  -o, --output string   where to output test results; one of: all, console, file, none; file output can be found in "_test_/output/[timestamp]" (default "console")
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg](appcfg.md)	 - Manage Gladly app platform configuration © 2024 Gladly Software Inc.
* [appcfg test action](appcfg_test_action.md)	 - Test an individual or all action configurations
* [appcfg test action-header](appcfg_test_action-header.md)	 - Test an individual or all action header configurations
* [appcfg test auth-header](appcfg_test_auth-header.md)	 - Test an individual or all authentication header configurations
* [appcfg test data-pull](appcfg_test_data-pull.md)	 - Test an individual or all data pull configurations
* [appcfg test data-pull-header](appcfg_test_data-pull-header.md)	 - Test an individual or all data pull header configurations
* [appcfg test oauth](appcfg_test_oauth.md)	 - Test an individual or all OAuth request configurations
* [appcfg test oauth-header](appcfg_test_oauth-header.md)	 - Test an individual or all OAuth header configurations
* [appcfg test signing-header](appcfg_test_signing-header.md)	 - Test an individual or all request signing header configurations

###### Auto generated by spf13/cobra on 17-Jul-2025
