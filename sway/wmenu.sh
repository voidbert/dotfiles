#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Wrapper around the wmenu launcher with a cache for the list of programs.
#
# -------------------------------------------- LICENSE --------------------------------------------
#
# Copyright 2024 Humberto Gomes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# --------------------------------------------- SCRIPT --------------------------------------------

CACHE_FILE="$XDG_RUNTIME_DIR/wmenu_cache"

# Generates the contents of the program list cache.
# stdout - Cache contents
cache() {
    echo "$PATH"                                                                                  |\
    tr ":" "\n"                                                                                   |\
    xargs -L1 readlink -f                                                                         |\
    sort -u                                                                                       |\
    xargs -I path find path -maxdepth 1 \( -type f -o -type l \) -executable -exec basename {} \; |\
    sort -u
}

if [ "$1" = "--cache" ]; then
    cache > "$CACHE_FILE"
    exit
fi

(cat "$CACHE_FILE" 2> /dev/null || cache | tee "$CACHE_FILE") | \
    wmenu -ibf "monospace 13" -N 373737 -n D4D4D4 -S 264F78 -s D4D4D4
