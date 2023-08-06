# ----------------------------------- ABOUT -----------------------------------
#
# This makefile processes dotfiles with the .pre extension, replacing variables
# in %PERCENT_SIGNS% with their values. This makes it possible for me to
# publish these dotfiles without revealing sensitive information, like my
# server's domain.
#
# ---------------------------------- LICENSE ----------------------------------
#
# Copyright 2023 Humberto Gomes
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
# ------------------------------- CONFIGURATION -------------------------------

# Directory where preprocessed files are placed in
PROCESSED_DIR   := processed

# Possibilities are:
#   - desktop: A Void Linux desktop. Includes configs for graphical application
#              and others.
#   - laptop:  Contains all desktop configs, and also power management settings
#   - server:  Configs for SSHd, iptables, PAMd, ...
TARGET_SYSTEM   := laptop

# DuckDNS domain of your home server. E.g.: xxxxx.duckdns.org -> xxxxx
SERVER_DOMAIN   := secret-domain

# A custom SSH port can be set to avoid script kiddies. Changes will break
# remotes of exiting git repositories hosted on the server.
SSH_PORT        := 22

# SERVER EXCLUSIVE SETTINGS

# The login token for DuckDNS
DUCKDNS_TOKEN   := secret-token

# The path where the logs of the duckdns cron job are stored
DUCKDNS_LOGFILE := /storage/logs/duckdns.log

# ----------------------------------- RULES -----------------------------------

ifeq ($(TARGET_SYSTEM), desktop)
	# Desktop has no NVIDIA components
	IGNORE_SYSTEM_SPECIFIC_FIRMWARE = "ignorepkg=linux-firmware-nvidia"
else
	# Laptop has no extra firmware to be excluded.
	# The server doesn't use Void Linux, so this is ignored.
	IGNORE_SYSTEM_SPECIFIC_FIRMWARE = ""
endif

NEED_PROCESSING := $(wildcard */*.pre)
PROCESSING_OUT  := $(patsubst %.pre, ${PROCESSED_DIR}/%, $(NEED_PROCESSING))
default: ${PROCESSING_OUT} ${PROCESSED_DIR}/xbps/perlhaters.conf

DUCKDNS_LOGFILE_ESCAPED = $(shell echo "${DUCKDNS_LOGFILE}" | sed 's/\//\\\//g')
SED_COMMAND = s/%SERVER_DOMAIN%/${SERVER_DOMAIN}/g ;$\
              s/%SSH_PORT%/${SSH_PORT}/g ;$\
              s/%DUCKDNS_TOKEN%/${DUCKDNS_TOKEN}/g ;$\
              s/%DUCKDNS_LOGFILE%/${DUCKDNS_LOGFILE_ESCAPED}/g ;$\
              s/%IGNORE_SYSTEM_SPECIFIC_FIRMWARE%/${IGNORE_SYSTEM_SPECIFIC_FIRMWARE}/g ;$\
              s/%TARGET_SYSTEM%/${TARGET_SYSTEM}/g

${PROCESSED_DIR}/%: %.pre
	@mkdir -p $(shell dirname "${PROCESSED_DIR}/$<")
	@cat $< | sed -e "${SED_COMMAND}" > $@

# Generate a file telling xbps to ignore all perl packages (wildcards aren't supported)
${PROCESSED_DIR}/xbps/perlhaters.conf: xbps/ignorepkg.conf.pre
	@mkdir -p "${PROCESSED_DIR}/xbps"
	@if command -v xbps-query > /dev/null ; then \
		xbps-query -Rs perl* | awk '{ print $$2 }' | \
		sed -e 's/-[0-9_.]*$$//g ; s/^/ignorepkg=/' > "$@" ; fi

.PHONY: clean
clean:
	@if [ -d "${PROCESSED_DIR}" ]; then rm -r "${PROCESSED_DIR}"; fi

