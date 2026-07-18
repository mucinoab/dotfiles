#!/bin/sh
# Git-format diff for jj that honours ~/.config/jj/attributes.
#
# jj has no .gitattributes support and no way to hide a file's diff, so the
# diff is delegated to `git diff --no-index` over the two trees jj hands us,
# with a global attributes file: `*.pdf -diff` then renders as
# "Binary files ... differ" instead of thousands of lines of PDF guts.
# (jj and git both look for a NUL byte only in the first ~8KB, and a Typst
# PDF's first NUL comes later than that, so neither calls it binary on its own.)
#
# Upstream, this should one day be a jj config instead:
#   .gitattributes support:            https://github.com/jj-vcs/jj/issues/53
#   exclude files from a diff:         https://github.com/jj-vcs/jj/issues/2915
#   hide diffs by fileset by default:  https://github.com/jj-vcs/jj/issues/4548
# All three still open as of jj 0.44.0 (August 2026); drop this script when one
# of them lands.
#
# The sed pass strips the temp tree names (left/, right/) that git puts in the
# headers, so paths read as plain a/foo b/foo.
left=$1
right=$2
l=$(basename "$left")
r=$(basename "$right")
git --no-pager -c core.attributesfile="$HOME/.config/jj/attributes" \
    diff --no-index --no-color "$left" "$right" |
  sed -E \
    -e "/^(diff --git |Binary files |rename |copy )/ s# (a|b)/($l|$r)/# \1/#g" \
    -e "s#^--- (a|b)/($l|$r)/#--- \1/#" \
    -e "s#^\+\+\+ (a|b)/($l|$r)/#+++ \1/#"
exit 0
