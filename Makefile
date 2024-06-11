# --------------------------------------------- ABOUT ---------------------------------------------
# 
# This Makefile performs various macro replacements that allow me to publish my dotfiles without
# sharing sensitive information.
#
# -------------------------------------------- LICENSE --------------------------------------------
#
# Copyright 2023 Humberto Gomes
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
# ----------------------------------------- CONFIGURATION -----------------------------------------

# Directory where the processed files will be placed in.
BUILDDIR := build

# Path to the configuration file.
CONFIG := config.m4

# --------------------------------------------- RULES ---------------------------------------------

SOURCES := $(shell find . -maxdepth 1 -type d | \
             grep -v '\./build'               | \
			 grep -v '\.$$'                   | \
			 grep -v '\./\.git')
OUTPUTS := $(patsubst ./%, $(BUILDDIR)/%, $(SOURCES))
ROOT    := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: $(OUTPUTS)

$(BUILDDIR)/%: ./% config.m4
	@find $< -type d | while IFS= read -r d; do mkdir -p $(BUILDDIR)/$$d; done
	@find $< -type f | while IFS= read -r f; do m4 $(CONFIG) $$f > $(BUILDDIR)/$$f; done

install: $(OUTPUTS)
	@for s in $(OUTPUTS); do cd $$s && make install; cd $(ROOT); done

.PHONY: clean
clean:
	@if [ -d $(BUILDDIR) ]; then rm -r $(BUILDDIR); fi
