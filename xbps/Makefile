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
	install -Dm 744 xbps-action $$HOME/.local/bin/xbps-install
	install -Dm 744 xbps-action $$HOME/.local/bin/xbps-update
	install -Dm 744 xbps-action $$HOME/.local/bin/xbps-remove
	doas sh -c "install -Dm 644 ignorepkg.conf /etc/xbps.d/ignorepkg.conf && install -Dm 644 ignoreperl.conf /etc/xbps.d/ignoreperl.conf"')

uninstall:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl', `dnl
	rm $$HOME/.local/bin/xbps-install $$HOME/.local/bin/xbps-update $$HOME/.local/bin/xbps-remove
	doas rm /etc/xbps.d/ignorepkg.conf /etc/xbps.d/ignoreperl.conf')
