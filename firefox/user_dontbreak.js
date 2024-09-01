divert(-1)

---------------------------------------------- ABOUT ----------------------------------------------

user.js for a secondary profile, still without telemetry and unwanted connections, but with less
features disabled not to break pages.

--------------------------------------------- LICENSE ---------------------------------------------

Copyright 2024 Humberto Gomes

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

---------------------------------------------- SCRIPT ----------------------------------------------

divert(0)dnl
define(`__PROFILE__', `DONTBREAK')dnl
include(`firefox/user.js')dnl
