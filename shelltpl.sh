#!/bin/sh
#
# shelltpl - super simple shell script templating
#
# Plaintext and code regions are delimited by lone `#!` lines.  Output is
# produced by running the concatenated script through `/bin/sh`.
#
# There is no magic here.
#

export SHELLTPL=$0

awk '
BEGIN   { n = 0 }
/^#!$/  { n++ }
!/^#!$/ { parts[n] = parts[n] $0 "\n" }

END {
    print "#!/bin/sh"
    text = 1
    for (i = 0; i <= n; i++) {
        if (text) {
            print "cat <<__EOS"
            gsub("\\\\[^$]", "\\\\", parts[i])
            gsub("`", "\\`", parts[i])
            print parts[i] "__EOS\n"
            text = 0
        } else {
            print parts[i]
            text = 1
        }
    }
}
' $* | /bin/sh
