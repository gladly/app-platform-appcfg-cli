## appcfg platform template-functions

Template function documentation

### Synopsis

The following functions are available to templates.

Standard Go template functions
------------------------------

```
and
    Returns the boolean AND of its arguments by returning the
    first empty argument or the last argument. That is,
    "and x y" behaves as "if x then y else x."
    Evaluation proceeds through the arguments left to right
    and returns when the result is determined.
html
    Returns the escaped HTML equivalent of the textual
    representation of its arguments. This function is unavailable
    in html/template, with a few exceptions.
index
    Returns the result of indexing its first argument by the
    following arguments. Thus "index x 1 2 3" is, in Go syntax,
    x[1][2][3]. Each indexed item must be a map, slice, or array.
slice
    slice returns the result of slicing its first argument by the
    remaining arguments. Thus "slice x 1 2" is, in Go syntax, x[1:2],
    while "slice x" is x[:], "slice x 1" is x[1:], and "slice x 1 2 3"
    is x[1:2:3]. The first argument must be a string, slice, or array.
js
    Returns the escaped JavaScript equivalent of the textual
    representation of its arguments.
len
    Returns the integer length of its argument.
not
    Returns the boolean negation of its single argument.
or
    Returns the boolean OR of its arguments by returning the
    first non-empty argument or the last argument, that is,
    "or x y" behaves as "if x then x else y".
    Evaluation proceeds through the arguments left to right
    and returns when the result is determined.
print
    See https://pkg.go.dev/fmt
printf
    See https://pkg.go.dev/fmt
println
    See https://pkg.go.dev/fmt
urlquery
    Returns the escaped value of the textual representation of
    its arguments in a form suitable for embedding in a URL query.
    This function is unavailable in html/template, with a few
    exceptions.
eq
    Returns the boolean truth of arg1 == arg2
ne
    Returns the boolean truth of arg1 != arg2
lt
    Returns the boolean truth of arg1 < arg2
le
    Returns the boolean truth of arg1 <= arg2
gt
    Returns the boolean truth of arg1 > arg2
ge
    Returns the boolean truth of arg1 >= arg2
```

sprig function library
----------------------
http://masterminds.github.io/sprig/


Miscellaneous other functions
-----------------------------

```
fromXml, mustFromXml
    fromXml decodes an XML document into an XML Document Model like object (see "appcfg platform xml" 
    for more details). If the input cannot be decoded the function will return nil. mustFromXml
    will return an error in case the XML is invalid.
hexDec
    Returns the bytes represented by the hexadecimal of it's single string argument
hexEnc
    Returns the hexadecimal encoding of it's single byte array argument
hmacSha256, mustHmacSha256
    Returns the SHA256 HMAC of it's 3 arguments: signing key, salt, string to sign.
    hmacSha256 returns an empty string if there is a problem and mustHmacSha256 triggers
    an error in the template engine if there is a problem.
stop
    Its single argument is the reason string for why template processing should stop. It
    is strongly recommended to call this function when an expected condition is encountered
    which would cause further template processing to create invalid output. "stop" should
    NOT be called when encountering error conditions, call the sprig "fail" function instead.
    e.g. call "stop" when a data pull request URL requires a Gladly customer email address but 
    there are no email addresses configured for the given Gladly customer. It is expected that
    some Gladly customer profiles do not have an email address configured.
url, mustUrl
    Parses a relative or absolute URL in to a url.URL structure. Its single argument is a raw URL.
    See https://pkg.go.dev/net/url#URL for more details. url returns an empty URL structure if
    there is a problem parsing the raw URL and mustUrl triggers an error in the template engine
    if there is a problem.
urlb64dec
    base64 decode string using encoding defined in RFC 4648; typically used in URLs and file names
urlb64enc
    base64 encode bytes using encoding defined in RFC 4648; typically used in URLs and file names
```

DEBUG ONLY
----------
The following functions are only available when debugging with this tool.
References to these functions MUST be removed from all templates before
validating and building an app.

```
consolePrintln
    Print output to the console for debugging; see https://pkg.go.dev/fmt
consolePrintf
    Print output to the console for debugging; see https://pkg.go.dev/fmt
```

>Part of this documentation was taken from the Go standard library "text/template" package documentation
>- Go Copyright (https://go.dev/copyright)
>- Used under Creative Commons Attribution 4.0 License (https://creativecommons.org/licenses/by/4.0/)


```
appcfg platform template-functions [flags]
```

### Options

```
  -h, --help   help for template-functions
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg platform](appcfg_platform.md)	 - General Gladly app platform documentation

###### Auto generated by spf13/cobra on 7-Feb-2025
