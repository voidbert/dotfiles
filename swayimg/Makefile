# --------------------------------------------- ABOUT ---------------------------------------------
#
# This Makefile defines rules for installing and uninstalling the configuration files pertaining to
# this program.
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
# --------------------------------------------- RULES ---------------------------------------------

install:
ifelse(__SYSTEM_TYPE__, `SERVER', `', `	install -Dm 644 config $$HOME/.config/swayimg/config
')dnl

uninstall:
ifelse(__SYSTEM_TYPE__, `SERVER', `', `	rm -r $$HOME/.config/swayimg/')
