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
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl', `dnl
	install -Dm 644 config              $$HOME/.config/sway/config
	install -Dm 744 wmenu.sh            $$HOME/.config/sway/wmenu.sh
ifelse(__SYSTEM_TYPE__, `LAPTOP', `dnl
	install -Dm 744 external-display.sh $$HOME/.config/sway/external-display.sh
	install -Dm 744 brightness.sh       $$HOME/.config/sway/brightness.sh
	install -Dm 644 brightness_levels   $$HOME/.config/sway/brightness_levels', `dnl')')

uninstall:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl', `dnl
	rm -r $$HOME/.config/sway')
