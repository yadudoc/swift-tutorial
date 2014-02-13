#!/bin/bash -e

if false; then
  echo skipping
pushd part11-swift-py-r/code >& /dev/null
# Strip comments, blank lines; prepend shell prompt ($)
grep -A 20 stc run-dets.sh | \
  grep -v -e "^$\|#" | \
  sed 's/^/$ /' > run-dets.sh.txt
popd >& /dev/null
fi

asciidoc -a icons -a "src_tab=3 --line-number=' '" -a toc -a toplevels=2 -a stylesheet=$PWD/asciidoc.css -a max-width=800px -o cic-tutorial.html README
