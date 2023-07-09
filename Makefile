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
TARGET_SYSTEM   := server

# DuckDNS IP of your home server. E.g.: xxxxx.duckdns.org -> xxxxx
SERVER_IP       := secret-domain

# A custom SSH port can be set to avoid script kiddies. Changes will break
# remotes of exiting git repositories hosted on the server.
SSH_PORT        := 22

# SERVER EXCLUSIVE SETTINGS

# The login token for DuckDNS
DUCKDNS_TOKEN   := secret-token

# The path where the logs of the duckdns cron job are stored
DUCKDNS_LOGFILE := /storage/logs/duckdns.log

# ----------------------------------- RULES -----------------------------------

NEED_PROCESSING := $(wildcard */*.pre)
PROCESSING_OUT  := $(patsubst %.pre, ${PROCESSED_DIR}/%, $(NEED_PROCESSING))
default: ${PROCESSING_OUT}

DUCKDNS_LOGFILE_ESCAPED = $(shell echo "${DUCKDNS_LOGFILE}" | sed 's/\//\\\//g')
SED_COMMAND = s/%SERVER_IP%/${SERVER_IP}/g ;$\
              s/%SSH_PORT%/${SSH_PORT}/g ;$\
              s/%DUCKDNS_TOKEN%/${DUCKDNS_TOKEN}/g ;$\
              s/%DUCKDNS_LOGFILE%/${DUCKDNS_LOGFILE_ESCAPED}/g

${PROCESSED_DIR}/%: %.pre
	@mkdir -p $(shell dirname "${PROCESSED_DIR}/$<")
	@cat $< | sed -e "${SED_COMMAND}" > $@

.PHONY: clean
clean:
	@if [ -d "${PROCESSED_DIR}" ]; then rm -r "${PROCESSED_DIR}"; fi

