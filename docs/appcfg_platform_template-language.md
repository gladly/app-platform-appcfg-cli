## appcfg platform template-language

Go template language documentation

### Synopsis

The go template language
------------------------
Templates are executed by applying them to a data structure. Annotations in the
template refer to elements of the data structure (typically a field of a struct
or a key in a map) to control execution and derive values to be displayed.
Execution of the template walks the structure and sets the cursor, represented
by a period `.` and called "dot", to the value at the current location in the
structure as execution proceeds.

Text and spaces
---------------
By default, all text between actions is copied verbatim when the template is
executed. For example, the string " items are made of " in the example above
appears on standard output when the program is run.

However, to aid in formatting template source code, if an action's left
delimiter (`{{`) is followed immediately by a minus sign and white space, all
trailing white space is trimmed from the immediately preceding text. Similarly,
if the right delimiter (`}}`) is preceded by white space and a minus sign, all
leading white space is trimmed from the immediately following text. In these
trim markers, the white space must be present:     `{{- 3}}` is like `{{3}}` but
trims the immediately preceding text, while `{{-3}}` parses as an action
containing the number `-3`.

Actions
-------
Here is the list of actions. "Arguments" and "pipelines" are evaluations of data,
defined in detail in the corresponding sections that follow.
```
{{/* a comment */}}
{{- /* a comment with white space trimmed from preceding and following text */ -}}
    A comment; discarded. May contain newlines.
    Comments do not nest and must start and end at the
    delimiters, as shown here.

{{pipeline}}
    The default textual representation (the same as would be
    printed by fmt.Print) of the value of the pipeline is copied
    to the output.

{{if pipeline}} T1 {{end}}
    If the value of the pipeline is empty, no output is generated;
    otherwise, T1 is executed. The empty values are false, 0, any
    nil pointer or interface value, and any array, slice, map, or
    string of length zero.
    Dot is unaffected.

{{if pipeline}} T1 {{else}} T0 {{end}}
    If the value of the pipeline is empty, T0 is executed;
    otherwise, T1 is executed. Dot is unaffected.

{{if pipeline}} T1 {{else if pipeline}} T0 {{end}}
    To simplify the appearance of if-else chains, the else action
    of an if may include another if directly; the effect is exactly
    the same as writing
        {{if pipeline}} T1 {{else}}{{if pipeline}} T0 {{end}}{{end}}

{{range pipeline}} T1 {{end}}
    The value of the pipeline must be an array, slice, map, or channel.
    If the value of the pipeline has length zero, nothing is output;
    otherwise, dot is set to the successive elements of the array,
    slice, or map and T1 is executed. If the value is a map and the
    keys are of basic type with a defined order, the elements will be
    visited in sorted key order.

{{range pipeline}} T1 {{else}} T0 {{end}}
    The value of the pipeline must be an array, slice, map, or channel.
    If the value of the pipeline has length zero, dot is unaffected and
    T0 is executed; otherwise, dot is set to the successive elements
    of the array, slice, or map and T1 is executed.

{{break}}
    The innermost {{range pipeline}} loop is ended early, stopping the
    current iteration and bypassing all remaining iterations.

{{continue}}
    The current iteration of the innermost {{range pipeline}} loop is
    stopped, and the loop starts the next iteration.

{{template "name"}}
    The template with the specified name is executed with nil data.

{{template "name" pipeline}}
    The template with the specified name is executed with dot set
    to the value of the pipeline.

{{block "name" pipeline}} T1 {{end}}
    A block is shorthand for defining a template
        {{define "name"}} T1 {{end}}
    and then executing it in place
        {{template "name" pipeline}}
    The typical use is to define a set of root templates that are
    then customized by redefining the block templates within.

{{with pipeline}} T1 {{end}}
    If the value of the pipeline is empty, no output is generated;
    otherwise, dot is set to the value of the pipeline and T1 is
    executed.

{{with pipeline}} T1 {{else}} T0 {{end}}
    If the value of the  pipeline is empty, dot is unaffected and T0
    is executed; otherwise, dot is set to the value of the pipeline
    and T1 is executed.
```

Pipelines
---------
A pipeline is a possibly chained sequence of "commands". A command is 
a simple value (argument) or a function or method call, possibly with 
multiple arguments:

```
Argument
    The result is the value of evaluating the argument.
.Method [Argument...]
    The method can be alone or the last element of a chain but,
    unlike methods in the middle of a chain, it can take arguments.
    The result is the value of calling the method with the
    arguments:
        dot.Method(Argument1, etc.)
functionName [Argument...]
    The result is the value of calling the function associated
    with the name:
        function(Argument1, etc.)
    Functions and function names are described below.
```

A pipeline may be "chained" by separating a sequence of commands with pipeline
characters `|`. In a chained pipeline, the result of each command is passed as
the last argument of the following command. The output of the final command in
the pipeline is the value of the pipeline.

The output of a command will be either one value or two values, the second of
which has type error. If that second value is present and evaluates to non-nil,
execution terminates and the error is returned to the caller of Execute.

Variables
---------
A pipeline inside an action may initialize a variable to capture the result. The
initialization has syntax 
    `$variable := pipeline`

where `$variable` is the name of the variable. An action that declares a variable
produces no output.

Variables previously declared can also be assigned, using the syntax
    `$variable = pipeline`

If a `range` action initializes a variable, the variable is set to the successive
elements of the iteration. Also, a `range` may declare two variables, separated
by a comma:
    `range $index, $element := pipeline`

in which case $index and $element are set to the successive values of the array/slice
index or map key and element, respectively. Note that if there is only one variable,
it is assigned the element; this is opposite to the convention in Go range clauses.

A variable's scope extends to the `end` action of the control structure (`if`, `with`,
or `range`) in which it is declared, or to the end of the template if there is no such
control structure. A template invocation does not inherit variables from the point of
its invocation.
    
When execution begins, $ is set to the data argument passed to Execute, that is, to the
starting value of dot. 

Examples
--------
Here are some example one-line templates demonstrating pipelines and variables. All 
produce the quoted word "output":

```
{{"\"output\""}}
    A string constant.
{{printf "%q" "output"}}
    A function call.
{{"output" | printf "%q"}}
    A function call whose final argument comes from the previous
    command.
{{printf "%q" (print "out" "put")}}
    A parenthesized argument.
{{"put" | printf "%s%s" "out" | printf "%q"}}
    A more elaborate call.
{{"output" | printf "%s" | printf "%q"}}
    A longer chain.
{{with "output"}}{{printf "%q" .}}{{end}}
    A with action using dot.
{{with $x := "output" | printf "%q"}}{{$x}}{{end}}
    A with action that creates and uses a variable.
{{with $x := "output"}}{{printf "%q" $x}}{{end}}
    A with action that uses the variable in another action.
{{with $x := "output"}}{{$x | printf "%q"}}{{end}}
    The same, but pipelined.
```

Nested template definitions
---------------------------
When parsing a template, another template may be defined and associated with the
template being parsed. Template definitions must appear at the top level of the
template, much like global variables in a Go program.
    
The syntax of such definitions is to surround each template declaration with a
`define` and `end` action.
    
The define action names the template being created by providing a string constant.
Here is a simple example:

```
{{define "T1"}}ONE{{end}}
{{define "T2"}}TWO{{end}}
{{define "T3"}}{{template "T1"}} {{template "T2"}}{{end}}
{{template "T3"}}
```

This defines two templates, `T1` and `T2`, and a third `T3` that invokes the other two
when it is executed. Finally it invokes T3. If executed this template will produce
the text

`ONE TWO`

>This documentation was taken from the Go standard library "text/template" package documentation
>- Go Copyright (https://go.dev/copyright)
>- Used under Creative Commons Attribution 4.0 License (https://creativecommons.org/licenses/by/4.0/)


```
appcfg platform template-language [flags]
```

### Options

```
  -h, --help   help for template-language
```

### Options inherited from parent commands

```
  -r, --root string   root folder for the app configuration; alternatively set the GLADLY_APP_CFG_ROOT environment variable
```

### SEE ALSO

* [appcfg platform](appcfg_platform.md)	 - General Gladly app platform documentation

###### Auto generated by spf13/cobra on 7-Feb-2025
