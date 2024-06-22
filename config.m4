divert(-1)

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Settings for configuring the dotfiles.
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
# --------------------------------------- GENERAL SETTINGS ----------------------------------------

# Type of the system where the installation is being performed (DESKTOP, LAPTOP or SERVER)
define(`__SYSTEM_TYPE__', `SERVER')

# DuckDNS domain of my home server (__SERVER_DOMAIN__.duckdns.org).
define(`__SERVER_DOMAIN__', `________')

# -------------------------------------- SERVER-ONLY SETTINGS -------------------------------------

# DuckDNS's login token.
define(`__DUCKDNS_TOKEN__', `ffffffff-ffff-ffff-ffff-ffffffffffff')

# My personal phone number, that will receive Signal messages with warnings from the server.
define(`__SIGNAL_DESTINATION__', `+351_________')

# A secondary phone number, that will send Signal messages with warnings from the server.
define(`__SIGNAL_SOURCE__', `+351_________')

divert(0)dnl
