# shelltpl

Super simple shell script templating.

## Usage

```
$ shelltpl input_file.txt ...
```

Input files are just alternating plaintext and `/bin/sh` code regions.

Delimit plaintext and `/bin/sh` code regions with #! lines (no whitespace
before or after):

```
A plaintext line.
#!
if [ -n "$USER" ]; then
#!
Your username is $USER.
#!
fi
#!
Another plaintext line.
```

Resulting in the following if `$USER` is set:

```
A plaintext line.
Your username is chris.
Another platintext line.
```

Or this if `$USER` is not set:

```
A plaintext line.
Another plaintext line.
```

## How

What actually happens here is that shelltpl builds up a shell script from
these regions and pipes it through `/bin/sh` to produce some final output.

The produced script in this case would be:

```bash
#!/bin/sh
cat <<__EOS
A plaintext line
__EOS

if [ -n "$USER" ]; then
cat <<__EOS
Your username is $USER.
__EOS
fi

cat <<__EOS
Another plaintext line.
__EOS
```

This means you can write primarily in plaintext, but control output logic to
a good degree using `/bin/sh`.

## Escaping

Backticks and backslashes are escaped in plaintext, but `$` are left alone;
however, backslashes immediately before a `$` are not escaped.  This allows
literal `$` to be inserted in plaintext regions as `\$`.

## Includes

shelltpl exports the SHELLTPL variable as the path of itself.  This allows
other shelltpl parts to be included into your template:

```
#!
$SHELLTPL inc/header.html
#!
<p>More text here...</p>
```

## Why?

I personally just wanted a really simple way of generating static HTML content
with some control over logic (e.g. for includes), but without having to use
some heavy, dependency-ridden tool.

This is all done using very simple awk.

## License

Released under the ISC license.

Copyright 2023 chrisjd

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
