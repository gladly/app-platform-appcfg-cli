## appcfg completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(appcfg completion bash)

To load completions for every new session, execute once:

#### Linux:

	appcfg completion bash > /etc/bash_completion.d/appcfg

#### macOS:

	appcfg completion bash > $(brew --prefix)/etc/bash_completion.d/appcfg

You will need to start a new shell for this setup to take effect.


```
appcfg completion bash
```

### Options

```
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the
                      GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg completion](appcfg_completion.md)	 - Generate the autocompletion script for the specified shell

###### Auto generated by spf13/cobra on 29-May-2024