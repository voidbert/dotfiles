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
CRONTAB := /var/spool/cron/crontabs/voidbert', `dnl')

install:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl
	doas sh -c "install -Dm 640 iptables /etc/iptables/rules.v4 && \
	            install -Dm 640 iptables /etc/iptables/rules.v6 && \
				iptables-restore /etc/iptables/rules.v4 && \
				ip6tables-restore /etc/iptables/rules.v6"', `dnl')

uninstall:
ifelse(__SYSTEM_TYPE__, `SERVER', `dnl
	doas sh -c "install -Dm 640 default /etc/iptables/rules.v4 && \
	            install -Dm 640 default /etc/iptables/rules.v6 && \
				iptables-restore /etc/iptables/rules.v4 && \
				ip6tables-restore /etc/iptables/rules.v6"', `dnl')
