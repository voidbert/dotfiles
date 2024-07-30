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
ifelse(__SYSTEM_TYPE__, `SERVER', `
CRONTAB := /var/spool/cron/crontabs/$$(whoami)', `dnl')

install:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl
	doas sh -c "install -Dm 600 crontab $(CRONTAB) && chown $$(whoami) $(CRONTAB) && chgrp crontab $(CRONTAB)"
	[ -d $$HOME/cron ] || mkdir -m 0755 $$HOME/cron
	[ -d $$HOME/cron/signal ] || mkdir -m 0755 $$HOME/cron/signal
	[ -d $$HOME/cron/signal/signal-cli-data ] || mkdir -m 0755 $$HOME/cron/signal/signal-cli-data
	install -Dm 744 signal/signal.sh $$HOME/cron/signal/signal.sh
	install -Dm 744 signal/managesignal.sh $$HOME/cron/signal/managesignal.sh
	install -Dm 744 automount.sh $$HOME/cron/automount.sh
	install -Dm 744 duckdns.sh $$HOME/cron/duckdns.sh
	yes | $$HOME/cron/signal/managesignal.sh install
	@printf "\n\033[1;31msignal-cli still needs to be manually configured\033[22;39m\n\n"', `dnl'])

uninstall:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl
	doas sh -c "rm -rf /var/spool/cron/crontabs/$$(whoami) $$HOME/cron"', `dnl')
