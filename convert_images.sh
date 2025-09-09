#!/usr/bin/env bash
set -euo pipefail

# Exit early if no md files
shopt -s nullglob
mds=( *.md )
if [ ${#mds[@]} -eq 0 ]; then
  echo "No .md files found in $(pwd)"
  exit 0
fi

for file in "${mds[@]}"; do
  echo "Processing: $file"
  perl -0777 -pe '
    sub enc { my $s = shift; $s =~ s/ /%20/g; return $s }
    s/!\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/ do {
      my ($fname, $alt) = ($1, $2);
      $alt = defined $alt ? $alt : $fname;
      "![$alt](" . enc($fname) . ")"
    } /ge
  ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
done

echo "Done."
