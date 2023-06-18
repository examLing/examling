# Style Guide

This style guide standardizes and tidies up the code found in the R directory of this package. The rules set here should be applied to each function, exported or otherwise, in the `rexamsll` package.

This style guide does *not* apply to `R/templates.R`.

This guide is loosely based on the style guide supplied in Advanced R, http://adv-r.had.co.nz/Style.html, which is in turn built upon Google's R style guide.

## Naming

### General Naming Conventions

Variable, file, and function names should all be lowercase. Separate words in names with underscores (as in `create_id.R`) or with the number "2" to represent an `exams`-style conversion (as in `exams2js.R`). `utils-pipe.R` is an exception to this rule.

Avoid the generic variable names `df` and `res`. Add one or two words that describe the intentions of these variables, like `df` -> `df_dynamic`, or substitute them entirely like `res` -> `row`. The reader knows that a variable is the result if it appears at the end of a function, so there is no need to specify. However, `df` and `x` are acceptable generic parameter names.

### File Names

All file names should end with the `.R` extension, as opposed to the lowercase `.r` extension. Each file's name should match the primary function found in that file.

## Syntax

### Line Width

All lines should fit within 80 characters. The *only* exceptions are lines with particularly long strings that cannot be shortened.

When a function definition is longer than 80 characters, give each parameter its own line, with the first parameter sharing a line with the function definition. The closing parentheses and starting curly bracket should go on their own line, with an indentation level equal to the function definition. This allows the editor to properly assess the indentation level of the function content without the author needing to press backspace repeatedly.

If a function *call* is too long, the arguments should all come after the first line, with one level of indentation greater than the function name. This allows for quick changes to the first line without needing to update every argument's spacing. The closing parentheses should still appear on its own line.

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

resulting_thing <- do_thing("This is a very long string that takes up way too much space, but there's no way around it.",
                            2,
                            3,
                            "dots",
                            4
)
```

### Spaces

Place spaces around all infix operators, including `=` operators in function calls and definitions, but *excluding* the operators `:`, `::`, and `:::`.

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

Don't add extra spaces to align things. You'll just have to re-align them later.

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

To indent code, use 4 spaces. In VSCode, the "Tab" button will automatically use this indentation method as long as the indentation option on the bottom bar is set to "Spaces: 4".

Entering a lower scope surrounded by curly braces adds 4 spaces to the indentation.

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

Opening curly brackets should never go on their own lines. Conversely, closing curly brackets should always go on their own lines, *unless* they are followed by `else`.

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
When using an `rexamsll` function, even one that is exported, add the prefix `rexamsll::`. If the function is not exported, you should need three colons: `rexamsll:::`.

```r
# Good
res_txt <- rexamsll:::img2txt(imgpath)

# Bad
res_text <- img2txt(imgpath)
```
