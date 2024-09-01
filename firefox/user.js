// --------------------------------------------- ABOUT ---------------------------------------------
//
// This opinated script automatically sets Firefox's about:config preferences for better privacy,
// security and general user experience,
//
// -------------------------------------------- LICENSE --------------------------------------------
//
// Copyright 2024 Humberto Gomes
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// --------------------------------------------- NOTES ---------------------------------------------

/*
 * Keep updated with:
 * 
 *   https://github.com/arkenfox/user.js
 *   https://github.com/yokoffing/Betterfox
 *   https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections
 *
 * TODO:
 *
 *   Automate installation of uBlockOrigin's filters and Redirector's redirects
 *   Find out if it's possible to build OpenH264 locally
 *   Whitelist for fingerprinting protection
 *   Implement userChorme.css for custom container colors and icons
 *   Implement xulStore.json for history order preference
 *   Implement automatic positioning of elements in the toolbar
 *   Manually define websites foe which cookies must be saved (see policies.json)
 */

/* ------------------------------------------ STARTUP ------------------------------------------ */

// Tab startup
user_pref("browser.startup.page", 0);
user_pref("browser.startup.homepage", "about:blank");
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// Disable welcome tour and notices
user_pref("browser.uitour.enabled", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("browser.startup.homepage_override.mstone", "ignore");

/* ------------------------------------ MOZILLA'S TELEMETRY ------------------------------------ */

// Mozilla's general telemetry
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");

// Mozilla's coverage telemetry (for searches)
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");

// Mozilla's telemetry on its home page
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// Mozilla's studies
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("messaging-system.rsexperimentloader.enabled", false);
user_pref("app.normandy.api_url", "");

// Advertising
user_pref("dom.private-attribution.submission.enabled", false);

// Crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

/* --------------------------------------- SAFE BROWSING --------------------------------------- */

user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");

/* ----------------------------------- SEARCH & LOCATION BARS ----------------------------------- */

// Disable Firefox Suggest
user_pref("browser.urlbar.quicksuggest.enabled", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);

// Disable search suggestions
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.engines", false);

// Disable all other suggestions
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.addons.featureGate", false);
user_pref("browser.urlbar.mdn.featureGate", false);
user_pref("browser.urlbar.pocket.featureGate", false);
user_pref("browser.urlbar.weather.featureGate", false);
user_pref("browser.urlbar.yelp.featureGate", false);
user_pref("browser.urlbar.clipboard.featureGate", false);
user_pref("browser.urlbar.recentsearches.featureGate", false);

// Use same search engine on Private Windows
user_pref("browser.search.separatePrivateDefault", false);
user_pref("browser.search.separatePrivateDefault.ui.enabled", false);

// Eliminate possible spoofing using punycode
user_pref("network.IDN_show_punycode", true);

// Disable clipboard searches
user_pref("browser.tabs.searchclipboardfor.middleclick", false);

/* ---------------------------------------- DNS & PROXY ---------------------------------------- */

// Disable non-URL paths
user_pref("network.file.disable_unc_paths", true);
user_pref("network.gio.supported-protocols", "");

// DNS-over-HTTPS
user_pref("network.trr.mode", 3);
user_pref("network.trr.bootstrapAddr", "9.9.9.9");
user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");
user_pref("network.trr.custom_uri", "https://dns.quad9.net/dns-query");

// DNS prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// Proxy settings
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.proxy.allow_bypass", false);

// WebRTC and proxy
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);

/* --------------------------------- OTHER IMPLICIT CONNECTIONS --------------------------------- */

// Disable predictor
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);

// Link prefetch tag, hovering and pings
user_pref("network.prefetch-next", false);
user_pref("network.preconnect", false);
user_pref("browser.send_pings", false);

// Prefetching on Firefox's UI
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.places.speculativeConnect.enabled", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// Captive portal detection
user_pref("network.captive-portal-service.enabled", false);
user_pref("captivedetect.canonicalURL", "");
user_pref("network.connectivity-service.enabled", false);

/* ------------------------------------------ HTTP(S) ------------------------------------------ */

// Protocol security
user_pref("security.ssl.require_safe_negotiation", true);
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.cert_pinning.enforcement_level", 2);

// Certificate validation (OCSP -> CRLite)
user_pref("security.OCSP.enabled", 0);
user_pref("security.OCSP.require", true);
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

// HTTPS over HTTP
user_pref("dom.security.https_first", true);
user_pref("dom.security.https_only_mode", true);
ifelse(__PROFILE__, `DONTBREAK', `dnl', `user_pref("security.mixed_content.block_display_content", true);')
user_pref("dom.security.https_only_mode.upgrade_local", false);
user_pref("dom.security.https_only_mode_send_http_background_request", true);

// Headers (referer and do not track)
ifelse(__PROFILE__, `DONTBREAK', `dnl', `user_pref("network.http.sendRefererHeader", 0);')
user_pref("privacy.globalprivacycontrol.functionality.enabled", true);
user_pref("privacy.globalprivacycontrol.pbmode.enabled", true);
user_pref("privacy.globalprivacycontrol.enabled", true);

// HTTP authentication
user_pref("network.auth.subresource-http-auth-allow", 1);

// User interface
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
user_pref("browser.xul.error_pages.expert_bad_cert", true);

/* ----------------------------------------- DOWNLOADS ----------------------------------------- */

user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.download.useDownloadDir", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.alwaysopenpanel", false);
user_pref("browser.download.forbid_open_with", true);

/* ----------------------------------------- EXTENSIONS ----------------------------------------- */

// General settings
user_pref("extensions.enabledScopes", 5);
user_pref("extensions.postDownloadThirdPartyPrompt", false);
user_pref("extensions.blocklist.enabled", false);

// Google Analytics used for addon suggestion
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);

// Recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

/* ------------------------------------- FORMS & PASSWORDS ------------------------------------- */

user_pref("browser.formfill.enable", false);
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

/* ---------------------------------------- STORED DATA ---------------------------------------- */

// RAM-only cache, with more capacity than normal and fewer cached pages
user_pref("browser.cache.disk.enable", false);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("browser.sessionhistory.max_total_viewers", 4);
user_pref("browser.cache.memory.capacity", 65536);
user_pref("media.memory_cache_max_size", 65536);

// Thumbnails
user_pref("browser.pagethumbnails.capturing_disabled", true);

// Session
user_pref("browser.sessionstore.max_tabs_undo", 0);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.sessionstore.privacy_level", 2);

// Clean up on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown_v2.cache", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false);
user_pref("privacy.clearOnShutdown.openWindows", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);
user_pref("privacy.clearOnShutdown.cookies", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown_v2.cookiesAndStorage", true);

// Default settings for manual clean up (does not respect exceptions)
user_pref("privacy.sanitize.timeSpan", 0);
user_pref("privacy.cpd.cache", true);
user_pref("privacy.clearHistory.cache", true);
user_pref("privacy.cpd.formdata", true);
user_pref("privacy.cpd.history", true);
user_pref("privacy.cpd.downloads", true);
user_pref("privacy.clearHistory.historyFormDataAndDownloads", true);
user_pref("privacy.cpd.cookies", true);
user_pref("privacy.cpd.sessions", true);
user_pref("privacy.cpd.offlineApps", true);
user_pref("privacy.clearHistory.cookiesAndStorage", true);
user_pref("privacy.cpd.openWindows", true);
user_pref("privacy.cpd.passwords", true);
user_pref("privacy.cpd.siteSettings", true);
user_pref("privacy.clearHistory.siteSettings", true);

/* --------------------------------------- FINGERPRINTING --------------------------------------- */
ifelse(__PROFILE__, `DONTBREAK', `dnl', `
// Fingerprinting Protection
// See https://searchfox.org/mozilla-central/source/toolkit/components/resistfingerprinting/RFPTargets.inc
user_pref("privacy.fingerprintingProtection.pbmode", true);
user_pref("privacy.fingerprintingProtection.overrides", "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC");
user_pref("privacy.fingerprintingProtection.granularOverrides", "");')

// Non-FPP changes
user_pref("intl.accept_languages", "en-US");
user_pref("browser.display.use_system_colors", false);

/* ------------------------------------- DISABLED FEATURES ------------------------------------- */
ifelse(__PROFILE__, `DONTBREAK', `dnl', `
// APIs
user_pref("webgl.disabled", true);')

// DRM
user_pref("media.eme.enabled", false);
user_pref("browser.eme.ui.enabled", false);

// Mozilla extensions
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.api", "");
user_pref("extensions.pocket.bffApi", "");
user_pref("extensions.pocket.oAuthConsumerKey", "");
user_pref("extensions.pocket.oAuthConsumerKeyBff", "");

user_pref("identity.fxaccounts.enabled", false);
user_pref("identity.fxaccounts.auth.uri", "");
user_pref("identity.fxaccounts.remote.oauth.uri", "");
user_pref("identity.fxaccounts.remote.pairing.uri", "");
user_pref("identity.fxaccounts.remote.profile.uri", "");
user_pref("identity.fxaccounts.remote.root", "");

// Other Firefox features
user_pref("browser.translations.enable", false);
user_pref("accessibility.force_disabled", 1);

/* ---------------------------------------- PERFORMANCE ---------------------------------------- */

// Hardware acceleration
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.compositor", true);
user_pref("gfx.webrender.compositor.force-enabled", true);
user_pref("gfx.canvas.accelerated", true);

// Hardware video decoder
user_pref("media.ffmpeg.vaapi.enabled", true);

// Page loading
user_pref("reader.parse-on-load.enabled", false);
user_pref("dom.iframe_lazy_loading.enabled", true);

/* --------------------------------------------- UI --------------------------------------------- */

// Enable extra costumizations
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Compact UI
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);

// Web page changes
ifelse(__PROFILE__, `DONTBREAK', `dnl', `user_pref("layout.css.visited_links_enabled", false);')
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// Window management
user_pref("browser.link.open_newwindow", 3);
user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("dom.disable_window_move_resize", false);

// Disable full screen notice
user_pref("full-screen-api.warning.delay", -1);
user_pref("full-screen-api.warning.timeout", 0);

ifelse(__SYSTEM_TYPE__, `LAPTOP', `dnl
// Disable touchpad gestures
user_pref("browser.gesture.swipe.left", "");
user_pref("browser.gesture.swipe.right", "");
user_pref("apz.gtk.kinetic_scroll.enabled", false);
', `dnl')
// Other changes
user_pref("widget.non-native-theme.scrollbar.style", 1);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("widget.gtk.hide-pointer-while-typing.enabled", false);
user_pref("findbar.highlightAll", true);

/* ------------------------------------------- OTHER ------------------------------------------- */

// Containers and sandboxing
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);
user_pref("privacy.userContext.newTabContainerOnLeftClick.enabled", true);
user_pref("security.sandbox.gpu.level", 1);

// Devtools
user_pref("devtools.editor.tabsize", 4);
user_pref("devtools.debugger.remote-inabled", false);
user_pref("devtools.debugger.ui.editor-wrapping", true);

// Disable content analysis for Data Loss Prevention
user_pref("browser.contentanalysis.enabled", false);
user_pref("browser.contentanalysis.default_result", 0);

// Disable special permissions for Mozilla's websites
user_pref("permissions.manager.defaultsUrl", "");
user_pref("webchannel.allowObject.urlWhitelist", "");

// Disable VPN ad
user_pref("browser.vpn_promo.enabled", false);
user_pref("browser.privatebrowsing.vpnpromourl", "");

// Disable geolocation
user_pref("geo.provider.use_geoclue", false);
user_pref("geo.provider.network.url", "");

// Media
user_pref("media.autoplay.default", 5);
user_pref("media.autoplay.blocking_policy", 2);
user_pref("media.videocontrols.picture-in-picture.enabled", false);

// Miscelaneous
user_pref("browser.contentblocking.category", "strict");
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.shopping.experience2023.enabled", false);
user_pref("pdfjs.enableScripting", false);
