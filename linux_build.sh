#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$root/build"
compiler=${DOLETC:-doletc}
"$compiler" "$root/main.dlt" -o "$root/build/dopm" -O3 --target linux/x86_64
