user_pref("webgl.disabled", true);

user_pref("browser.shell.checkDefaultBrowser", false);

// New tab telemetry
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.feeds.discoverystreamfeed", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.default.sites", ""); // Remove default top sites

// Geolocation
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%"); //Use mozilla instead of google
user_pref("geo.provider.use_gpsd", false);
user_pref("browser.region.network.url", "");
user_pref("browser.region.update.enabled", false);

// Languages
user_pref("intl.accept_languages", "en");

// Disable suggestions
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);

// Telemetry
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");
user_pref("browser.ping-centre.telemetry", false);
user_pref("beacon.enabled", false);

// Studies
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// Crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// Google safe browsing
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);

// Disable implicit requests
user_pref("network.prefetch-next", false);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.predictor.enabled", false);
user_pref("network.predictor.enable-prefetch", false);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("browser.places.speculativeConnect.enabled", false);

// Network
user_pref("network.proxy.socks_remote_dns", true);
user_pref("network.gio.supported-protocols", ""); // Disable GIO (GVfs) as a way to bypass proxies

//Search bar
user_pref("keyword.enabled", true);
user_pref("browser.fixup.alternate.enabled", false);
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("network.IDN_show_punycode", true);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);

// History
user_pref("layout.css.visited_links_enabled", false); // NOTE - not great for web development

// Autofill
user_pref("browser.formfill.enable", false);
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.available", "off");
user_pref("extensions.formautofill.creditCards.available", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("signon.autofillForms", false);
user_pref("signon.formlessCapture.enabled", false);
user_pref("network.auth.subresource-http-auth-allow", 0);

// Disable disk cache (testing for performance). Maybe more than 8GiB of RAM would be great.
user_pref("browser.cache.disk.enable", false);
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 4096);
user_pref("browser.sessionstore.privacy_level", 2); // Don't store any extra session data for any site
user_pref("browser.shell.shortcutFavicons", false);

// HTTPS
user_pref("security.ssl.require_safe_negotiation", false); // NOTE - otherwise, www.uminho.pt doesn't work
user_pref("security.tls.enable_0rtt_data", false);
user_pref("security.OCSP.enabled", 1); // Leaks visited website to certificate authority for some security
user_pref("security.OCSP.require", true);
user_pref("security.cert_pinning.enforcement_level", 2);
user_pref("security.pki.crlite_mode", 0);

user_pref("security.mixed_content.block_display_content", true); // Comment out if this causes problems
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_send_http_background_request", false);

// UI / UX
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true); // Broken padlock
user_pref("browser.ssl_override_behavior", 1); // Add security exception on SSL warnings
user_pref("browser.compactmode.show", true);

// Gestures (touchpad related)
user_pref("browser.gesture.swipe.left", "");
user_pref("browser.gesture.swipe.right", "");
user_pref("apz.gtk.kinetic_scroll.enabled", false);

// Fonts (enable to fix font problems)
user_pref("gfx.font_rendering.opentype_svg.enabled", false);
user_pref("layout.css.font-visibility.private", 1);
user_pref("layout.css.font-visibility.standard", 1);
user_pref("layout.css.font-visibility.trackingprotection", 1);

// Headers (breaks some sites)
user_pref("network.http.referer.XOriginPolicy", 2);
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// Containers
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

// Media
user_pref("media.peerconnection.enabled", false);
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);
user_pref("media.peerconnection.ice.default_address_only", true);
user_pref("media.gmp-widevinecdm.enabled", false);
user_pref("media.eme.enabled", false);
user_pref("browser.eme.ui.enabled", false);
user_pref("media.autoplay.default", 5);
user_pref("media.autoplay.blocking_policy", 2);

// DOM
user_pref("dom.disable_beforeunload", true);
user_pref("dom.disable_window_move_resize", true);
user_pref("dom.disable_open_during_load", true);
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");

// Misc
user_pref("accessibility.force_disabled", 1);
user_pref("browser.helperApps.deleteTempFileOnExit", true);
user_pref("browser.pagethumbnails.capturing_disabled", true);
user_pref("browser.uitour.enabled", false);
user_pref("browser.uitour.url", "");
user_pref("middlemouse.contentLoadURL", false); // Clipboard links
user_pref("permissions.default.shortcuts", 2);
user_pref("permissions.manager.defaultsUrl", "");
user_pref("webchannel.allowObject.urlWhitelist", "");
user_pref("permissions.delegation.enabled", false);

user_pref("pdfjs.disabled", false);
user_pref("pdfjs.enableScripting", false);

user_pref("devtools.chrome.enabled", false);
user_pref("devtools.debugger.remote-enabled", false);

// Downloads
user_pref("browser.download.useDownloadDir", false); // Always ask where to save files (security)
user_pref("browser.download.manager.addToRecentDocs", false);
user_pref("browser.download.always_ask_before_handling_new_types", true);

// Extensions
user_pref("extensions.enabledScopes", 5);
user_pref("extensions.autoDisableScopes", 15);
user_pref("extensions.postDownloadThirdPartyPrompt", false);

// Tracking protection
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.antitracking.enableWebcompat", false); // This can break things
user_pref("privacy.partition.serviceWorkers", true);

// Shutdown
user_pref("network.cookie.lifetimePolicy", 2); // Clear cookies. Logins won't be kept.
user_pref("privacy.sanitize.sanitizeOnShutdown", true); // To allow for the following items
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.sessions", true);
user_pref("privacy.clearOnShutdown.offlineApps", true);
user_pref("privacy.clearOnShutdown.cookies", false); // Having this true would ignore site exceptions

// Fingerprinting
user_pref("privacy.resistFingerprinting", true);
user_pref("privacy.window.maxInnerWidth", 2000);
user_pref("privacy.window.maxInnerHeight", 1100);
user_pref("privacy.resistFingerprinting.letterboxing", false); //It's unbearable having this on
user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "");
user_pref("layout.css.font-visibility.resistFingerprinting", 1);
user_pref("browser.startup.blankWindow", false);
user_pref("privacy.resistFingerprinting", true);
user_pref("widget.non-native-theme.enabled", true);
user_pref("browser.link.open_newwindow", 3);
user_pref("browser.link.open_newwindow.restriction", 0);
user_pref("webgl.disabled", true);

// Other
user_pref("signon.rememberSignons", false);
user_pref("permissions.memory_only", true);
user_pref("browser.sessionstore.resume_from_crash", false);
user_pref("browser.download.folderList", 1); //Defalt save directory is downloads
user_pref("extensions.pocket.enabled", false);
user_pref("identity.fxaccounts.enabled", false);

// Disable updates
user_pref("app.update.auto", false);
user_pref("browser.search.update", false);

// Video acceleration
user_pref("media.ffmpeg.vaapi.enabled", true);

// Arkenfox: https://github.com/arkenfox/user.js/blob/master/user.js

