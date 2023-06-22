# Style Guide

This style guide standardizes and tidies up the code found in the R directory
of this package. The rules set here should be applied to each function,
exported or otherwise, in the `rexamsll` package.

This style guide does *not* apply to `R/templates.R`.

This guide is loosely based on the style guide supplied in Advanced R,
http://adv-r.had.co.nz/Style.html, which is in turn built upon Google's R style
guide.

## Naming

### General Naming Conventions

Variable, file, and function names should all be lowercase. Separate words in
names with underscores (as in `create_id.R`) or with the number "2" to
represent an `exams`-style conversion (as in `exams2js.R`). `utils-pipe.R` is
an exception to this rule.

### Variables

Avoid the generic variable names `df` and `res`. Add one or two words that
describe the intentions of these variables, like `df` -> `df_dynamic`, or
substitute them entirely like `res` -> `row`. The reader knows that a variable
is the result if it appears at the end of a function, so there is no need to
specify. However, `df` and `x` are acceptable generic parameter names.

### Helper Functions

Helper functions are functions that are used in other `rexamsll` functions but
are not meant to be directly called by the user. These functions are not
exported and do not usually share the same name as the file they appear in.

Helper functions should end with a single extra underscore at the end to mark
that they are purely internal functions. Helper functions should *not* just be
called `<function-name>_helper_`; give these functions short, descriptive names
that say how they are meant to be used.

```r
# Good
add_four <- function(a) {
    total <- add_(a, 4)
    total
}

add_ <- function(a, b) {
    total <- a + b
    total
}

# Bad
add_four_helper_ <- function(a, b) {
    ...
}

## Assuming "add" is not exported
add <- function(a, b) {
    ...
}
```

### File Names

All file names should end with the `.R` extension, as opposed to the lowercase
`.r` extension. Each file's name should match the primary function found in
that file.

## Syntax

### Line Width

All lines should fit within 80 characters. The *only* exceptions are lines with
particularly long strings that cannot be shortened.

When a function definition is longer than 80 characters, give each parameter
its own line, with the first parameter sharing a line with the function
definition. The closing parentheses and starting curly bracket should go on
their own line, with an indentation level equal to the function definition.
This allows the editor to properly assess the indentation level of the function
content without the author needing to press backspace repeatedly.

If a function *call* is too long, the arguments should all come after the first
line, with one level of indentation greater than the function name. This allows
for quick changes to the first line without needing to update every argument's
spacing. The closing parentheses should still appear on its own line.

Each argument should receive its own line in these cases. An exception is the
function `paste` (or `paste0`), where as many arguments should be put on
each line as possible.

Another exception is `tryCatch`, where, if the first argument is a code block
surrounded by curly braces, the first curly brace should go on the same line as
`tryCatch`. The code block should still be indented as if the curly brace went
on its own line. Or, even better, explicitly name the first argument as `expr`.

```r
# Good
do_thing <- function(parameter1,
                     parameter2 = 2,
                     parameter3 = 3,
                     ...,
                     parameter4 = 4
) {
    <code content>
}

resulting_thing <- do_thing(
    "This is a very long string that takes up way too much space, but there's no way around it.",
    2,
    3,
    "dots",
    4
)

together_string <- paste(c(
    "This", "is", "a", "very", "long", "string", "that", "takes", "up", "way",
    "too", "much", "space,", "but", "there's", "no", "way", "around", "it."
), collapse = " ")

attempted_thing <- tryCatch({
        x %>%
            difficult_thing() %>%
            second_thing()
    },
    error = ...
)

# Better

attempted_thing <- tryCatch(
    expr = {
        x %>%
            difficult_thing() %>%
            second_thing()
    },
    error = ...
)

# Bad
do_thing <- function(parameter1, parameter2 = 2, parameter3 = 3, ..., parameter4 = 4) {
    <code content>
}

do_thing <- function(parameter1,
                     parameter2 = 2,
                     parameter3 = 3,
                     ...,
                     parameter4 = 4) {
                        <code content>
                     }

resulting_thing <- do_thing("This is a very long string that takes up way too
much space, but there's no way around it.",
                            2,
                            3,
                            "dots",
                            4
)
```

### Spaces

Place spaces around all infix operators, including `=` operators in function
calls and definitions, but *excluding* the operators `:`, `::`, and `:::`.

```r
# Good
average <- add(a = 4, b = 2) / 2

# Bad
average<-add(a=4, b=2)/2
```

Always add a space after a comma, but not before.

```r
# Good
df_all[5, ]

# Bad
df_all[5,]
```

Don't add extra spaces to align things. You'll just have to re-align them
later.

```r
# Good
num8 <- 8
num9 <- 9
num10 <- 10

# Bad
num8  <- 8
num9  <- 9
num10 <- 10
```

### Indentation

To indent code, use 4 spaces. In VSCode, the "Tab" button will automatically
use this indentation method as long as the indentation option on the bottom bar
is set to "Spaces: 4".

Entering a lower scope surrounded by curly braces adds 4 spaces to the
indentation.

```r
# Good
if (true) {
    do_thing()
}

# Bad
if (true) {
  do_thing()
}

if (true) {
do_thing()
}
```

When writing a multi-line function definition, the indentation of each
parameter should match that of the first.

```r
# Good
do_thing <- function(parameter1,
                     parameter2 = 2,
                     parameter3 = 3,
                     ...,
                     parameter4 = 4
) {
    <code content>
}

# Bad
do_thing <- function(parameter1,
    parameter2 = 2,
    parameter3 = 3,
    ...,
    parameter4 = 4
) {
    <code content>
}
```

### Curly Brackets

Opening curly brackets should never go on their own lines. Conversely, closing
curly brackets should always go on their own lines, *unless* they are followed
by `else`.

```r
# Good
if (true) {
    do_thing()
} else {
    do_other_thing()
}

# Bad
if (true) {
    do_thing()
}
else {
    do_other_thing()
}

if (true)
{
    do_thing()
}
```

Include curly brackets for all multi-line `if` statements.

```r
# Good
if (true) {
    do_thing()
}

if (true) do_thing()

# Bad
if (true)
    do_thing()
```

### Pipes

Use `magrittr` pipes (`%>%`) whenever a variable or value goes through a
series of transformations, or when reading all of the function names in the
reverse order would be confusing. When to use a pipe is a subjective matter,
but avoid using it when only one function is called.

Only use `magrittr`'s dot variable (`.`) when the left-hand-side is *not* the
first variable of the right-hand-side. In other words, only use the dot if you
need to.

If the right-hand-side has no arguments other than the left-hand-side, you
should still include parentheses in order to emphasize the right-hand-side's
status as a function.

Pipes should only appear at the end of the line. All following lines that
continue the pipeline should be indented one more than the starting line.

```r
# Good
a <- b %>%
    do_thing() %>%
    add(4)

a <- b %>%
    do_thing() %>%
    add(4, .)

# Bad
a <- b %>%
do_thing() %>%
add(4)

a <- b %>%
    do_thing %>%
    add(4)

a <- b %>%
    do_thing() %>%
    add(., 4)

a <- b %>%
    do_thing()
```

## Semantics

### Return Values

If a function has a return value, that return value must be saved as a
variable. The final line of the function must be that variable, alone. For big
functions, add an empty line above this final return line to distinguish it.

```r
# Good
add <- function(a, b) {
    total <- a + b
    total
}

# Bad
add <- function(a, b) {
    a + b
}

add <- function(a, b, d) {
    total <- add(a, b)
    total + d
}
```

### Internal Functions
When using an `rexamsll` function, even one that is exported, add the prefix
`rexamsll::`. If the function is not exported, you should need three colons:
`rexamsll:::`.

This does not apply to helper functions that appear in the same file.

```r
# Good
res_txt <- rexamsll:::img2txt(imgpath)

res_txt <- make_text_(x)

# Bad
res_text <- img2txt(imgpath)
```
