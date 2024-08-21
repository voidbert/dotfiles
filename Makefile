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

MODULES := $(shell find . -maxdepth 1 -type d | grep -Ev '(^\./build$$)|(^\.$$)|(^\./\.git)')
OUTPUTS := $(patsubst ./%, $(BUILDDIR)/%, $(MODULES))

all: $(OUTPUTS)

$(foreach module, $(MODULES), $(eval \
	$(patsubst ./%, $(BUILDDIR)/%, $(module)): $(shell find $(module) -type f)))

$(BUILDDIR)/%: ./% Makefile config.m4
	@find $< -type d | xargs -I {} mkdir -p $(BUILDDIR)/{}
	@find $< -type f | xargs -I {} file {} | grep text | grep -Eo '^[^:]*' | \
		xargs -I {} sh -c "m4 $(CONFIG) {} > $(BUILDDIR)/{}"
	@find $< -type f | xargs -I {} file {} | grep -v text | grep -Eo '^[^:]*' | \
		xargs -I {} cp {} $(BUILDDIR)/{}
	@touch $@

install: $(OUTPUTS)
	@for module in $(OUTPUTS); do make -C $$module install; donea

.PHONY: clean
clean:
	@if [ -d $(BUILDDIR) ]; then rm -r $(BUILDDIR); fi
