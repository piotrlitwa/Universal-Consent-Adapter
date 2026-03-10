___INFO___

{
  "type": "TAG",
  "id": "cvt_universal_consent_adapter",
  "version": 1,
  "securityGroups": [],
  "displayName": "Universal Consent Adapter",
  "brand": {
    "id": "brand_piotr_litwa_web_analyst",
    "displayName": "Piotr Litwa Web Analyst",
    "thumbnail": ""
  },
  "description": "Auto-detects your CMP, reads consent from cookies instantly (before CMP JS loads), and maps to Google Consent Mode v2. Ensures PageView never fires before consent is set.",
  "categories": ["TAG_MANAGEMENT", "UTILITY"],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "cmpType",
    "displayName": "Consent Management Platform",
    "macrosInSelect": false,
    "selectItems": [
      { "value": "auto_detect", "displayValue": "Auto-detect" },
      { "value": "onetrust", "displayValue": "OneTrust" },
      { "value": "cookiebot", "displayValue": "Cookiebot" },
      { "value": "cookieyes", "displayValue": "CookieYes" },
      { "value": "usercentrics", "displayValue": "Usercentrics" },
      { "value": "borlabs", "displayValue": "Borlabs Cookie" },
      { "value": "complianz", "displayValue": "Complianz" },
      { "value": "axeptio", "displayValue": "Axeptio" },
      { "value": "trustarc", "displayValue": "TrustArc" },
      { "value": "didomi", "displayValue": "Didomi" },
      { "value": "klaro", "displayValue": "Klaro" }
    ],
    "simpleValueType": true,
    "defaultValue": "auto_detect",
    "help": "Select your CMP or choose Auto-detect to let the template identify it by checking for known cookies."
  },
  {
    "type": "GROUP",
    "name": "defaultConsentGroup",
    "displayName": "Default Consent State",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SELECT",
        "name": "default_analytics_storage",
        "displayName": "analytics_storage",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      },
      {
        "type": "SELECT",
        "name": "default_ad_storage",
        "displayName": "ad_storage",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      },
      {
        "type": "SELECT",
        "name": "default_ad_user_data",
        "displayName": "ad_user_data",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      },
      {
        "type": "SELECT",
        "name": "default_ad_personalization",
        "displayName": "ad_personalization",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      },
      {
        "type": "SELECT",
        "name": "default_functionality_storage",
        "displayName": "functionality_storage",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      },
      {
        "type": "SELECT",
        "name": "default_personalization_storage",
        "displayName": "personalization_storage",
        "selectItems": [
          { "value": "denied", "displayValue": "denied" },
          { "value": "granted", "displayValue": "granted" }
        ],
        "simpleValueType": true,
        "defaultValue": "denied"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "regionGroup",
    "displayName": "Region Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableRegion",
        "checkboxText": "Apply defaults only to specific regions",
        "simpleValueType": true,
        "defaultValue": false
      },
      {
        "type": "TEXT",
        "name": "region",
        "displayName": "Region codes (comma-separated ISO 3166-2, e.g. PL,DE,FR)",
        "simpleValueType": true,
        "defaultValue": "",
        "enablingConditions": [
          {
            "paramName": "enableRegion",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "waitForUpdate",
        "displayName": "wait_for_update (ms)",
        "simpleValueType": true,
        "defaultValue": "2000",
        "help": "How long (in milliseconds) to wait for a consent update before using defaults. Recommended: 2000."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "customMappingGroup",
    "displayName": "Custom Category Mapping",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableCustomMapping",
        "checkboxText": "Override default CMP category mapping",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Use this if your CMP uses non-standard category IDs (e.g. OneTrust with custom group IDs instead of C0001-C0004)."
      },
      {
        "type": "PARAM_TABLE",
        "name": "customMappingTable",
        "displayName": "Category → Consent Type mapping",
        "paramTableColumns": [
          {
            "param": {
              "type": "TEXT",
              "name": "cmpCategory",
              "displayName": "CMP Category ID / Name",
              "simpleValueType": true
            },
            "isUnique": true
          },
          {
            "param": {
              "type": "SELECT",
              "name": "consentType",
              "displayName": "Google Consent Type",
              "selectItems": [
                { "value": "analytics_storage", "displayValue": "analytics_storage" },
                { "value": "ad_storage", "displayValue": "ad_storage" },
                { "value": "ad_user_data", "displayValue": "ad_user_data" },
                { "value": "ad_personalization", "displayValue": "ad_personalization" },
                { "value": "functionality_storage", "displayValue": "functionality_storage" },
                { "value": "personalization_storage", "displayValue": "personalization_storage" }
              ],
              "simpleValueType": true
            },
            "isUnique": false
          },
          {
            "param": {
              "type": "SELECT",
              "name": "grantedWhen",
              "displayName": "Granted when value is",
              "selectItems": [
                { "value": "truthy", "displayValue": "truthy (1, true, yes, allow)" },
                { "value": "1", "displayValue": "1" },
                { "value": "true", "displayValue": "true" },
                { "value": "yes", "displayValue": "yes" },
                { "value": "allow", "displayValue": "allow" }
              ],
              "simpleValueType": true,
              "defaultValue": "truthy"
            },
            "isUnique": false
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableCustomMapping",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "help": "Map your CMP's category IDs to Google Consent Mode types. For OneTrust: C0002 → analytics_storage, C0004 → ad_storage. For Cookiebot: statistics → analytics_storage, marketing → ad_storage."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "additionalSettings",
    "displayName": "Additional Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "adsDataRedaction",
        "checkboxText": "Enable ads_data_redaction when ad_storage is denied",
        "simpleValueType": true,
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "urlPassthrough",
        "checkboxText": "Enable url_passthrough for cross-domain ad click measurement",
        "simpleValueType": true,
        "defaultValue": false
      },
      {
        "type": "CHECKBOX",
        "name": "enableMicrosoftConsent",
        "checkboxText": "Enable Microsoft Consent Mode (Clarity + Bing UET)",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "If checked, consent signals are also sent to Microsoft Clarity (consentv2) and Bing UET (uetq). Maps ad_storage and analytics_storage to Microsoft's consent API."
      },
      {
        "type": "CHECKBOX",
        "name": "debugMode",
        "checkboxText": "Enable debug logging (visible in GTM Preview mode)",
        "simpleValueType": true,
        "defaultValue": false
      },
      {
        "type": "CHECKBOX",
        "name": "pushToDataLayer",
        "checkboxText": "Push consent events to dataLayer (uca_consent_default + uca_consent_update)",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Pushes dataLayer events: uca_consent_default (initial state, all denied) and uca_consent_update (every consent change). Includes CMP name, consent state, source, and timing. Use as triggers or for debugging in GTM Preview."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Universal Consent Adapter v1.5
// Reads CMP cookies instantly, maps to Google Consent Mode v2

const getCookieValues = require('getCookieValues');
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const gtagSet = require('gtagSet');
const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const callInWindow = require('callInWindow');
const callLater = require('callLater');
const decodeUri = require('decodeUri');
const log = require('logToConsole');
const makeNumber = require('makeNumber');
const getType = require('getType');
const createQueue = require('createQueue');

var dataLayerPush = createQueue('dataLayer');
var startTime = require('getTimestampMillis')();

// ─── Helpers ───────────────────────────────────────────

function debugLog(msg) {
  if (data.debugMode) {
    log('[UniversalConsentAdapter] ' + msg);
  }
}

function granted(val) {
  return val ? 'granted' : 'denied';
}

/**
 * Wrapper: updates Google consent + sends Microsoft consent signals.
 */
function updateConsentAndMicrosoft(consentState) {
  updateConsentState(consentState);
  sendMicrosoftConsent('update', consentState);
}

/**
 * Sends consent signals to Microsoft Clarity and Bing UET.
 * @param {string} command - 'default' or 'update'
 * @param {Object} consentState - consent state with ad_storage, analytics_storage, etc.
 */
function sendMicrosoftConsent(command, consentState) {
  if (!data.enableMicrosoftConsent || !consentState) return;

  // Bing UET — push consent command
  var uetq = createQueue('uetq');
  uetq('consent', command, {
    ad_storage: consentState.ad_storage || 'denied'
  });
  debugLog('Microsoft Bing UET: consent ' + command + ', ad_storage=' + (consentState.ad_storage || 'denied'));

  // Clarity — get or create clarity function, then send consentv2
  var clarity = copyFromWindow('clarity');
  if (!clarity) {
    setInWindow('clarity', function() {
      callInWindow('clarity.q.push', arguments);
    });
    createQueue('clarity.q');
    clarity = copyFromWindow('clarity');
  }
  if (clarity) {
    callInWindow('clarity', 'consentv2', {
      ad_Storage: consentState.ad_storage || 'denied',
      analytics_Storage: consentState.analytics_storage || 'denied'
    });
    debugLog('Microsoft Clarity: consentv2 sent, ad=' + (consentState.ad_storage || 'denied') + ', analytics=' + (consentState.analytics_storage || 'denied'));
  }
}

/**
 * Pushes consent debug event to dataLayer.
 * @param {string} cmp - detected CMP name
 * @param {Object} consentState - consent state object
 * @param {string} source - 'cookie' or 'callback'
 */
function pushConsentEvent(cmp, consentState, source) {
  if (!data.pushToDataLayer) return;

  var elapsed = require('getTimestampMillis')() - startTime;
  var eventName = (source === 'default') ? 'uca_consent_default' : 'uca_consent_update';

  dataLayerPush({
    event: eventName,
    uca_command: (source === 'default') ? 'default' : 'update',
    uca_cmp: cmp || 'none',
    uca_source: source,
    uca_timing_ms: elapsed,
    uca_analytics_storage: consentState ? consentState.analytics_storage : 'denied',
    uca_ad_storage: consentState ? consentState.ad_storage : 'denied',
    uca_ad_user_data: consentState ? consentState.ad_user_data : 'denied',
    uca_ad_personalization: consentState ? consentState.ad_personalization : 'denied',
    uca_functionality_storage: consentState ? consentState.functionality_storage : 'denied',
    uca_personalization_storage: consentState ? consentState.personalization_storage : 'denied'
  });

  debugLog('dataLayer push: ' + eventName + ' | cmp=' + (cmp || 'none') +
           ' | source=' + source + ' | timing=' + elapsed + 'ms');
}

// Simple string split — GTM sandbox supports .split()
function splitStr(str, delimiter) {
  return str.split(delimiter);
}

// ─── Custom Mapping ────────────────────────────────────

/**
 * Applies custom category mapping from PARAM_TABLE.
 * Takes raw CMP categories (key:value pairs) and maps them to
 * Google Consent Mode types based on user-defined rules.
 *
 * @param {Object} rawCategories - CMP category values, e.g. {C0002: true, C0004: false}
 * @returns {Object|null} Consent state object or null if no mapping defined
 */
function applyCustomMapping(rawCategories) {
  if (!data.enableCustomMapping || !data.customMappingTable || !data.customMappingTable.length) {
    return null;
  }

  var consent = {
    analytics_storage: 'denied',
    ad_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    functionality_storage: 'denied',
    personalization_storage: 'denied'
  };

  for (var i = 0; i < data.customMappingTable.length; i++) {
    var row = data.customMappingTable[i];
    var categoryId = row.cmpCategory;
    var consentType = row.consentType;
    var grantedWhen = row.grantedWhen;

    if (!categoryId || !consentType) continue;

    var rawValue = rawCategories[categoryId];
    var isGranted = false;

    if (grantedWhen === 'truthy') {
      isGranted = !!rawValue && rawValue !== '0' && rawValue !== 'false' && rawValue !== 'no' && rawValue !== 'deny';
    } else {
      // Exact match: '1', 'true', 'yes', 'allow'
      isGranted = ('' + rawValue) === grantedWhen;
    }

    consent[consentType] = granted(isGranted);
  }

  debugLog('Custom mapping applied');
  return consent;
}

/**
 * Parses OneTrust cookie into raw category map {C0001: true, C0002: false, ...}
 * Used by both default parser and custom mapping.
 */
function parseOneTrustRaw() {
  var values = getCookieValues('OptanonConsent');
  if (!values.length) return null;

  var decoded = decodeUri(values[0]);
  var groupsMatch = decoded.match('groups=([^&]+)');
  if (!groupsMatch) return null;

  var groups = {};
  var pairs = splitStr(groupsMatch[1], ',');
  for (var i = 0; i < pairs.length; i++) {
    var parts = splitStr(pairs[i], ':');
    if (parts.length === 2) {
      groups[parts[0]] = parts[1] === '1';
    }
  }
  return groups;
}

/**
 * Parses Cookiebot cookie into raw category map {statistics: true, marketing: false, ...}
 */
function parseCookiebotRaw() {
  var values = getCookieValues('CookieConsent');
  if (!values.length) return null;
  var raw = values[0];
  if (raw === '-1') return null;

  var categories = {};
  var keys = ['necessary', 'preferences', 'statistics', 'marketing'];
  for (var i = 0; i < keys.length; i++) {
    var match = raw.match(keys[i] + ':(true|false)');
    categories[keys[i]] = match ? match[1] === 'true' : false;
  }
  return categories;
}

/**
 * Parses CookieYes cookie into raw category map {analytics: true, advertisement: false, ...}
 */
function parseCookieYesRaw() {
  var values = getCookieValues('cookieyes-consent');
  if (!values.length) return null;

  var map = {};
  var pairs = splitStr(values[0], ',');
  for (var i = 0; i < pairs.length; i++) {
    var parts = splitStr(pairs[i], ':');
    if (parts.length === 2) {
      map[parts[0]] = parts[1] === 'yes';
    }
  }
  return map;
}

// ─── Cookie Parsers ────────────────────────────────────

/**
 * OneTrust — cookie: OptanonConsent
 * Format: URL-encoded, contains groups=C0001:1,C0002:0,...
 * Supports custom mapping for non-standard group IDs.
 */
function parseOneTrust() {
  var groups = parseOneTrustRaw();
  if (!groups) return null;

  // Try custom mapping first
  var custom = applyCustomMapping(groups);
  if (custom) return custom;

  // Default OneTrust mapping:
  // C0001 = Necessary (always on), C0002 = Performance/Analytics
  // C0003 = Functional, C0004 = Targeting/Marketing
  return {
    analytics_storage: granted(groups['C0002']),
    ad_storage: granted(groups['C0004']),
    ad_user_data: granted(groups['C0004']),
    ad_personalization: granted(groups['C0004']),
    functionality_storage: granted(groups['C0003']),
    personalization_storage: granted(groups['C0003'])
  };
}

/**
 * Cookiebot — cookie: CookieConsent
 * Format: JS object-like string {necessary:true,preferences:false,...}
 * Supports custom mapping.
 */
function parseCookiebot() {
  var categories = parseCookiebotRaw();
  if (!categories) return null;

  // Try custom mapping first
  var custom = applyCustomMapping(categories);
  if (custom) return custom;

  return {
    analytics_storage: granted(categories['statistics']),
    ad_storage: granted(categories['marketing']),
    ad_user_data: granted(categories['marketing']),
    ad_personalization: granted(categories['marketing']),
    functionality_storage: granted(categories['preferences']),
    personalization_storage: granted(categories['preferences'])
  };
}

/**
 * CookieYes — cookie: cookieyes-consent
 * Format: key:value,key:value (e.g. analytics:yes,advertisement:no)
 * Supports custom mapping.
 */
function parseCookieYes() {
  var categories = parseCookieYesRaw();
  if (!categories) return null;

  // Try custom mapping first
  var custom = applyCustomMapping(categories);
  if (custom) return custom;

  return {
    analytics_storage: granted(categories['analytics']),
    ad_storage: granted(categories['advertisement']),
    ad_user_data: granted(categories['advertisement']),
    ad_personalization: granted(categories['advertisement']),
    functionality_storage: granted(categories['functional']),
    personalization_storage: granted(categories['performance'])
  };
}

/**
 * Borlabs Cookie — cookie: borlabs-cookie
 * Format: URL-encoded JSON with consents object
 */
function parseBorlabs() {
  var values = getCookieValues('borlabs-cookie');
  if (!values.length) return null;

  var decoded = decodeUri(values[0]);
  var statistics = decoded.match('"statistics":(true|false)');
  var marketing = decoded.match('"marketing":(true|false)');

  var hasStats = statistics && statistics[1] === 'true';
  var hasMkt = marketing && marketing[1] === 'true';

  return {
    analytics_storage: granted(hasStats),
    ad_storage: granted(hasMkt),
    ad_user_data: granted(hasMkt),
    ad_personalization: granted(hasMkt),
    functionality_storage: 'denied',
    personalization_storage: 'denied'
  };
}

/**
 * Complianz — separate cookies: cmplz_statistics, cmplz_marketing, cmplz_preferences
 * Values: "allow" or "" / absent
 */
function parseComplianz() {
  var stats = getCookieValues('cmplz_statistics');
  var mkt = getCookieValues('cmplz_marketing');
  var prefs = getCookieValues('cmplz_preferences');

  // At least one cookie must exist
  if (!stats.length && !mkt.length && !prefs.length) return null;

  var hasStats = stats.length && stats[0] === 'allow';
  var hasMkt = mkt.length && mkt[0] === 'allow';
  var hasPrefs = prefs.length && prefs[0] === 'allow';

  return {
    analytics_storage: granted(hasStats),
    ad_storage: granted(hasMkt),
    ad_user_data: granted(hasMkt),
    ad_personalization: granted(hasMkt),
    functionality_storage: granted(hasPrefs),
    personalization_storage: granted(hasPrefs)
  };
}

/**
 * Axeptio — cookie: axeptio_cookies
 * Format: URL-encoded JSON
 */
function parseAxeptio() {
  var values = getCookieValues('axeptio_cookies');
  if (!values.length) return null;

  var decoded = decodeUri(values[0]);
  var analytics = decoded.match('"analytics":(true|false)');
  var marketing = decoded.match('"marketing":(true|false)');

  var hasAnalytics = analytics && analytics[1] === 'true';
  var hasMkt = marketing && marketing[1] === 'true';

  return {
    analytics_storage: granted(hasAnalytics),
    ad_storage: granted(hasMkt),
    ad_user_data: granted(hasMkt),
    ad_personalization: granted(hasMkt),
    functionality_storage: 'denied',
    personalization_storage: 'denied'
  };
}

/**
 * TrustArc — cookie: notice_preferences
 * Format: pipe-separated or colon-separated category IDs
 * 0=required, 1=functional, 2=analytics, 3=targeting
 */
function parseTrustArc() {
  var values = getCookieValues('notice_preferences');
  if (!values.length) return null;

  var raw = values[0];
  var hasAnalytics = raw.match('2') !== null;
  var hasTargeting = raw.match('3') !== null;
  var hasFunctional = raw.match('1') !== null;

  return {
    analytics_storage: granted(hasAnalytics),
    ad_storage: granted(hasTargeting),
    ad_user_data: granted(hasTargeting),
    ad_personalization: granted(hasTargeting),
    functionality_storage: granted(hasFunctional),
    personalization_storage: granted(hasFunctional)
  };
}

/**
 * Klaro — cookie: klaro
 * Format: URL-encoded JSON with service-level booleans
 */
function parseKlaro() {
  var values = getCookieValues('klaro');
  if (!values.length) return null;

  var decoded = decodeUri(values[0]);

  // Klaro uses per-service consent. Try common service names.
  var analytics = decoded.match('"google-analytics":(true|false)') ||
                  decoded.match('"analytics":(true|false)') ||
                  decoded.match('"ga":(true|false)');
  var ads = decoded.match('"google-ads":(true|false)') ||
            decoded.match('"marketing":(true|false)') ||
            decoded.match('"advertising":(true|false)');

  var hasAnalytics = analytics && analytics[1] === 'true';
  var hasAds = ads && ads[1] === 'true';

  return {
    analytics_storage: granted(hasAnalytics),
    ad_storage: granted(hasAds),
    ad_user_data: granted(hasAds),
    ad_personalization: granted(hasAds),
    functionality_storage: 'denied',
    personalization_storage: 'denied'
  };
}

/**
 * Didomi — cookie: euconsent-v2 (TCF string) + didomi_token
 * TCF v2 string is too complex to decode in sandbox.
 * We detect Didomi by cookie presence but defer to JS API for consent values.
 */
function parseDidomi() {
  // Didomi uses TCF string — we cannot parse it in sandboxed JS.
  // Return null to force JS API fallback.
  var values = getCookieValues('euconsent-v2');
  if (values.length) {
    debugLog('Didomi: TCF cookie found, deferring to JS API for consent values');
  }
  return null;
}

// ─── CMP Configuration ────────────────────────────────

var CMP_CONFIG = {
  onetrust:     { cookieName: 'OptanonConsent',     parseFn: parseOneTrust,   windowVar: 'OneTrust' },
  cookiebot:    { cookieName: 'CookieConsent',      parseFn: parseCookiebot,  windowVar: 'Cookiebot' },
  cookieyes:    { cookieName: 'cookieyes-consent',  parseFn: parseCookieYes,  windowVar: null },
  borlabs:      { cookieName: 'borlabs-cookie',     parseFn: parseBorlabs,    windowVar: 'BorlabsCookie' },
  complianz:    { cookieName: 'cmplz_statistics',   parseFn: parseComplianz,  windowVar: null },
  axeptio:      { cookieName: 'axeptio_cookies',    parseFn: parseAxeptio,    windowVar: null },
  trustarc:     { cookieName: 'notice_preferences', parseFn: parseTrustArc,   windowVar: 'truste' },
  didomi:       { cookieName: 'euconsent-v2',       parseFn: parseDidomi,     windowVar: 'Didomi' },
  klaro:        { cookieName: 'klaro',              parseFn: parseKlaro,      windowVar: 'klaro' },
  usercentrics: { cookieName: null,                 parseFn: null,            windowVar: 'UC_UI' }
};

// Detection order for auto-detect (most common first, Usercentrics last)
var DETECTION_ORDER = [
  'onetrust', 'cookiebot', 'cookieyes', 'borlabs', 'complianz',
  'axeptio', 'trustarc', 'didomi', 'klaro', 'usercentrics'
];

// ─── CMP Detection ────────────────────────────────────

function detectCMP() {
  // Phase 1: Check cookies (fastest)
  for (var i = 0; i < DETECTION_ORDER.length; i++) {
    var cmpId = DETECTION_ORDER[i];
    var config = CMP_CONFIG[cmpId];
    if (config.cookieName) {
      var values = getCookieValues(config.cookieName);
      if (values.length) {
        debugLog('Detected CMP by cookie: ' + cmpId);
        return cmpId;
      }
    }
  }

  // Phase 2: Check window variables (CMP JS already loaded)
  for (var j = 0; j < DETECTION_ORDER.length; j++) {
    var cmpId2 = DETECTION_ORDER[j];
    var config2 = CMP_CONFIG[cmpId2];
    if (config2.windowVar) {
      var windowObj = copyFromWindow(config2.windowVar);
      if (windowObj) {
        debugLog('Detected CMP by window variable: ' + cmpId2);
        return cmpId2;
      }
    }
  }

  debugLog('No CMP detected');
  return null;
}

// ─── JS API Callbacks (Layer 2 — Fallback) ─────────────

/**
 * Parses consent from OnetrustActiveGroups JS variable (available instantly in callback).
 * Format: ",C0001,C0002,C0004," — comma-separated active group IDs.
 * Falls back to cookie parsing if the variable is not available.
 */
function parseOneTrustFromAPI() {
  var activeGroups = copyFromWindow('OnetrustActiveGroups');
  if (!activeGroups) return null;

  var hasGroup = function(groupId) {
    return activeGroups.indexOf(groupId) !== -1;
  };

  // Check if custom mapping is configured
  var groups = {};
  var allGroupIds = ['C0001', 'C0002', 'C0003', 'C0004', 'C0005'];
  for (var i = 0; i < allGroupIds.length; i++) {
    groups[allGroupIds[i]] = hasGroup(allGroupIds[i]);
  }

  var custom = applyCustomMapping(groups);
  if (custom) return custom;

  return {
    analytics_storage: granted(hasGroup('C0002')),
    ad_storage: granted(hasGroup('C0004')),
    ad_user_data: granted(hasGroup('C0004')),
    ad_personalization: granted(hasGroup('C0004')),
    functionality_storage: granted(hasGroup('C0003')),
    personalization_storage: granted(hasGroup('C0003'))
  };
}

function setupOneTrustCallback() {
  // Strategy: OptanonWrapper gets overwritten by inline <script> on the page.
  // Instead, we poll OnetrustActiveGroups for changes — reliable, can't be overwritten.
  var lastActiveGroups = copyFromWindow('OnetrustActiveGroups') || '';
  var otPollCount = 0;

  function pollOneTrustGroups() {
    var currentGroups = copyFromWindow('OnetrustActiveGroups') || '';

    if (currentGroups && currentGroups !== lastActiveGroups) {
      lastActiveGroups = currentGroups;
      var consent = parseOneTrustFromAPI();
      if (consent) {
        debugLog('OneTrust: consent change detected via OnetrustActiveGroups polling');
        updateConsentAndMicrosoft(consent);
        pushConsentEvent('onetrust', consent, 'callback');
      }
    }

    // Keep polling — user may change consent at any time during the session
    otPollCount++;
    if (otPollCount < 500) {
      callLater(pollOneTrustGroups);
    }
  }

  // Also try to set OptanonWrapper as backup (may work if inline script runs first)
  callLater(function() {
    callLater(function() {
      var existingWrapper = copyFromWindow('OptanonWrapper');
      setInWindow('OptanonWrapper', function() {
        if (existingWrapper) existingWrapper();
        var consent = parseOneTrustFromAPI() || parseOneTrust();
        if (consent) {
          debugLog('OneTrust OptanonWrapper callback: updating consent');
          updateConsentAndMicrosoft(consent);
          pushConsentEvent('onetrust', consent, 'callback_wrapper');
        }
      }, true);
      debugLog('OneTrust: OptanonWrapper set (delayed, after inline scripts)');
    });
  });

  // Start polling
  callLater(pollOneTrustGroups);
  debugLog('OneTrust: OnetrustActiveGroups polling started');
}

function setupCookiebotCallback() {
  setInWindow('CookiebotCallback_OnAccept', function() {
    // JS API first (instant), cookie fallback with delay
    var consent = parseCookiebotFromAPI();
    if (consent) {
      debugLog('Cookiebot accept callback (API): updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('cookiebot', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseCookiebot();
        if (c) {
          debugLog('Cookiebot accept callback (cookie fallback): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('cookiebot', c, 'callback');
        }
      });
    }
  }, true);

  setInWindow('CookiebotCallback_OnDecline', function() {
    var consent = parseCookiebotFromAPI();
    if (consent) {
      debugLog('Cookiebot decline callback (API): updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('cookiebot', consent, 'callback_decline');
    } else {
      callLater(function() {
        var c = parseCookiebot();
        if (c) {
          debugLog('Cookiebot decline callback (cookie fallback): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('cookiebot', c, 'callback_decline');
        }
      });
    }
  }, true);
}

/**
 * Reads consent from Cookiebot JS API (window.Cookiebot.consent object).
 * Available instantly in callback, before cookie is written.
 */
function parseCookiebotFromAPI() {
  var cb = copyFromWindow('Cookiebot');
  if (!cb || !cb.consent) return null;
  var c = cb.consent;

  var groups = {
    necessary: true,
    preferences: !!c.preferences,
    statistics: !!c.statistics,
    marketing: !!c.marketing
  };

  var custom = applyCustomMapping(groups);
  if (custom) return custom;

  return {
    analytics_storage: granted(c.statistics),
    ad_storage: granted(c.marketing),
    ad_user_data: granted(c.marketing),
    ad_personalization: granted(c.marketing),
    functionality_storage: granted(c.preferences),
    personalization_storage: granted(c.preferences)
  };
}

function setupCookieYesCallback() {
  // CookieYes fires a custom event. We poll for the consent function.
  var retries = 0;
  function checkCookieYes() {
    var consent = parseCookieYes();
    if (consent) {
      debugLog('CookieYes: consent cookie updated');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('cookieyes', consent, 'callback_poll');
    } else if (retries < 10) {
      retries++;
      callLater(checkCookieYes);
    }
  }
  // Also set up a window callback if available
  setInWindow('__ucaConsentCookieYesCallback', function() {
    // Try instant read, fallback to delayed read if cookie not yet written
    var consent = parseCookieYes();
    if (consent) {
      debugLog('CookieYes callback (instant): updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('cookieyes', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseCookieYes();
        if (c) {
          debugLog('CookieYes callback (delayed): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('cookieyes', c, 'callback');
        }
      });
    }
  }, true);
}

function setupUsercentricsCallback() {
  // Usercentrics stores consent in localStorage (not accessible from GTM sandbox).
  // Strategy: hook into window.__ucCmp push to intercept consent signals,
  // and poll UC_UI.getServicesBaseInfo() via callInWindow when available.
  var retries = 0;

  function readUCConsent() {
    // UC_UI.getServicesBaseInfo() returns array of {name, consent:{status}}
    // We can't call it directly, but we can read the consent from UC's
    // internal state pushed to dataLayer as 'consent_status'
    var ucConsent = copyFromWindow('UC_CONSENT');
    if (ucConsent) {
      debugLog('Usercentrics: reading UC_CONSENT');
      var consentState = {
        analytics_storage: 'denied',
        ad_storage: 'denied',
        ad_user_data: 'denied',
        ad_personalization: 'denied',
        functionality_storage: 'denied',
        personalization_storage: 'denied'
      };
      // UC_CONSENT may contain category-level booleans
      if (ucConsent.analytics) consentState.analytics_storage = 'granted';
      if (ucConsent.marketing) {
        consentState.ad_storage = 'granted';
        consentState.ad_user_data = 'granted';
        consentState.ad_personalization = 'granted';
      }
      if (ucConsent.functional) consentState.functionality_storage = 'granted';
      updateConsentAndMicrosoft(consentState);
      pushConsentEvent('usercentrics', consentState, 'callback_poll');
      return true;
    }
    return false;
  }

  function checkUC() {
    var ucUI = copyFromWindow('UC_UI');
    if (ucUI) {
      debugLog('Usercentrics: UC_UI available');
      if (!readUCConsent()) {
        // UC_UI loaded but no consent object yet — retry briefly
        if (retries < 5) {
          retries++;
          callLater(checkUC);
        }
      }
    } else if (retries < 30) {
      retries++;
      callLater(checkUC);
    } else {
      debugLog('Usercentrics: UC_UI not available after retries, staying with defaults');
    }
  }

  // Also set up a window variable that Usercentrics GTM integration can write to
  setInWindow('__ucaUsercentricsUpdate', function(consentData) {
    debugLog('Usercentrics: consent update received via callback');
    if (consentData) {
      var ucState = {
        analytics_storage: consentData.analytics ? 'granted' : 'denied',
        ad_storage: consentData.marketing ? 'granted' : 'denied',
        ad_user_data: consentData.marketing ? 'granted' : 'denied',
        ad_personalization: consentData.marketing ? 'granted' : 'denied',
        functionality_storage: consentData.functional ? 'granted' : 'denied',
        personalization_storage: consentData.functional ? 'granted' : 'denied'
      };
      updateConsentAndMicrosoft(ucState);
      pushConsentEvent('usercentrics', ucState, 'callback');
    }
  }, true);

  callLater(checkUC);
}

/**
 * Reads consent from Borlabs JS API (window.BorlabsCookie).
 * BorlabsCookie.checkCookieGroupConsent('statistics') etc.
 */
function parseBorlabsFromAPI() {
  var bc = copyFromWindow('BorlabsCookie');
  if (!bc || !bc.Consents) return null;
  var consents = bc.Consents;

  var hasStats = !!consents.statistics;
  var hasMkt = !!consents.marketing;
  var hasFunctional = !!consents.functional;

  return {
    analytics_storage: granted(hasStats),
    ad_storage: granted(hasMkt),
    ad_user_data: granted(hasMkt),
    ad_personalization: granted(hasMkt),
    functionality_storage: granted(hasFunctional),
    personalization_storage: granted(hasFunctional)
  };
}

function setupBorlabsCallback() {
  setInWindow('__ucaBorlabsCallback', function() {
    // JS API first (instant), cookie fallback
    var consent = parseBorlabsFromAPI() || parseBorlabs();
    if (consent) {
      debugLog('Borlabs callback: updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('borlabs', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseBorlabsFromAPI() || parseBorlabs();
        if (c) {
          debugLog('Borlabs callback (delayed): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('borlabs', c, 'callback');
        }
      });
    }
  }, true);
}

function setupComplianzCallback() {
  var existing = copyFromWindow('cmplz_fire_categories');
  setInWindow('cmplz_fire_categories', function() {
    if (existing) existing();
    var consent = parseComplianz();
    if (consent) {
      debugLog('Complianz callback (instant): updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('complianz', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseComplianz();
        if (c) {
          debugLog('Complianz callback (delayed): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('complianz', c, 'callback');
        }
      });
    }
  }, true);
}

function setupAxeptioCallback() {
  var axcb = copyFromWindow('_axcb');
  if (!axcb) {
    setInWindow('_axcb', [], true);
  }
  callInWindow('_axcb.push', function() {
    var consent = parseAxeptio();
    if (consent) {
      debugLog('Axeptio callback (instant): updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('axeptio', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseAxeptio();
        if (c) {
          debugLog('Axeptio callback (delayed): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('axeptio', c, 'callback');
        }
      });
    }
  });
}

/**
 * Reads consent from TrustArc JS API (window.truste.cma.callApi).
 * truste object exposes consent preferences directly.
 */
function parseTrustArcFromAPI() {
  var trusteObj = copyFromWindow('truste');
  if (!trusteObj || !trusteObj.cma) return null;

  // truste.cma.callApi('getConsentDecision') returns consent categories
  // We can also read from truste.cma.callApi('getGDPRConsentDecision')
  // Fallback: check notice_preferences which truste updates in its state
  var prefs = trusteObj.actmgr;
  if (!prefs) return null;

  // TrustArc categories: 0=required, 1=functional, 2=analytics, 3=targeting
  var raw = prefs.consentDecision || '';
  var hasAnalytics = raw.indexOf('2') !== -1;
  var hasTargeting = raw.indexOf('3') !== -1;
  var hasFunctional = raw.indexOf('1') !== -1;

  return {
    analytics_storage: granted(hasAnalytics),
    ad_storage: granted(hasTargeting),
    ad_user_data: granted(hasTargeting),
    ad_personalization: granted(hasTargeting),
    functionality_storage: granted(hasFunctional),
    personalization_storage: granted(hasFunctional)
  };
}

function setupTrustArcCallback() {
  setInWindow('__ucaTrustArcCallback', function() {
    // JS API first (instant), cookie fallback
    var consent = parseTrustArcFromAPI() || parseTrustArc();
    if (consent) {
      debugLog('TrustArc callback: updating consent');
      updateConsentAndMicrosoft(consent);
      pushConsentEvent('trustarc', consent, 'callback');
    } else {
      callLater(function() {
        var c = parseTrustArcFromAPI() || parseTrustArc();
        if (c) {
          debugLog('TrustArc callback (delayed): updating consent');
          updateConsentAndMicrosoft(c);
          pushConsentEvent('trustarc', c, 'callback');
        }
      });
    }
  }, true);
}

function setupDidomiCallback() {
  // Didomi uses TCF v2 string in cookie (too complex to decode in sandbox).
  // Strategy:
  // 1. Push to didomiOnReady array — fires when Didomi JS API is ready
  // 2. Push to didomiEventListeners — fires on consent changes
  // 3. Read consent via Didomi.getUserStatus() through callInWindow

  // Ensure arrays exist
  var onReady = copyFromWindow('didomiOnReady');
  if (!onReady) {
    setInWindow('didomiOnReady', [], true);
  }

  var eventListeners = copyFromWindow('didomiEventListeners');
  if (!eventListeners) {
    setInWindow('didomiEventListeners', [], true);
  }

  function readDidomiConsent() {
    // After Didomi loads, it may set a vendor-consent cookie or
    // we can check Didomi's internal state via window variables
    var didomiState = copyFromWindow('Didomi');
    if (!didomiState) return;

    // Didomi exposes consent status. We read the purpose-level consent
    // via a bridge variable that the didomiOnReady callback sets.
    var purposes = copyFromWindow('__ucaDidomiPurposes');
    if (purposes) {
      var consentState = {
        analytics_storage: purposes.analytics ? 'granted' : 'denied',
        ad_storage: purposes.advertising ? 'granted' : 'denied',
        ad_user_data: purposes.advertising ? 'granted' : 'denied',
        ad_personalization: purposes.advertising ? 'granted' : 'denied',
        functionality_storage: purposes.functional ? 'granted' : 'denied',
        personalization_storage: purposes.functional ? 'granted' : 'denied'
      };

      // Try custom mapping
      var custom = applyCustomMapping(purposes);
      if (custom) {
        updateConsentAndMicrosoft(custom);
        pushConsentEvent('didomi', custom, 'callback');
      } else {
        updateConsentAndMicrosoft(consentState);
        pushConsentEvent('didomi', consentState, 'callback');
      }
      debugLog('Didomi: consent updated from JS API');
    }
  }

  // When Didomi is ready, extract purpose-level consent and store in bridge variable
  callInWindow('didomiOnReady.push', function() {
    debugLog('Didomi: JS API ready');
    // Use callInWindow to query Didomi API
    // Didomi.getUserStatus().purposes.consent.enabled contains enabled purpose IDs
    // We store the result in a bridge variable for readDidomiConsent() to read
    var purposes = {
      analytics: false,
      advertising: false,
      functional: false
    };

    // Try to read purpose consent from Didomi's cookie/state
    // Didomi standard purpose IDs: 'analytics', 'advertising', 'content_personalization'
    // After didomiOnReady fires, the SDK has processed the TCF string
    setInWindow('__ucaDidomiPurposes', purposes, true);
    readDidomiConsent();
  });

  // Listen for consent changes (user updates preferences)
  callInWindow('didomiEventListeners.push', {
    event: 'consent.changed',
    listener: function() {
      debugLog('Didomi: consent.changed event');
      readDidomiConsent();
    }
  });
}

function setupKlaroCallback() {
  // Klaro: watch for manager updates
  var retries = 0;
  function checkKlaro() {
    var klaroObj = copyFromWindow('klaro');
    if (klaroObj) {
      debugLog('Klaro: available, reading consent from cookie');
      var consent = parseKlaro();
      if (consent) {
        updateConsentAndMicrosoft(consent);
        pushConsentEvent('klaro', consent, 'callback');
      }
    } else if (retries < 20) {
      retries++;
      callLater(checkKlaro);
    }
  }
  callLater(checkKlaro);
}

var CALLBACK_MAP = {
  onetrust: setupOneTrustCallback,
  cookiebot: setupCookiebotCallback,
  cookieyes: setupCookieYesCallback,
  usercentrics: setupUsercentricsCallback,
  borlabs: setupBorlabsCallback,
  complianz: setupComplianzCallback,
  axeptio: setupAxeptioCallback,
  trustarc: setupTrustArcCallback,
  didomi: setupDidomiCallback,
  klaro: setupKlaroCallback
};

// ─── Main Entry Point ──────────────────────────────────

// Warn if debug active — help diagnose "A tag read consent state before a default was set"
if (data.debugMode) {
  log('[UniversalConsentAdapter] Tag fired. Trigger MUST be "Consent Initialization - All Pages".');
  log('[UniversalConsentAdapter] If GTM shows "A tag read consent state before a default was set":');
  log('[UniversalConsentAdapter]   → Check that NO other tag calls setDefaultConsentState or reads consent before UCA.');
  log('[UniversalConsentAdapter]   → Check that UCA is the ONLY consent tag on Consent Initialization trigger.');
  log('[UniversalConsentAdapter]   → Disable any other Consent Mode templates (e.g. SIMO Ahava, native CMP template).');
}

// Step 1: Set default consent state — immediately, all denied
var defaultConsent = {
  analytics_storage: data.default_analytics_storage || 'denied',
  ad_storage: data.default_ad_storage || 'denied',
  ad_user_data: data.default_ad_user_data || 'denied',
  ad_personalization: data.default_ad_personalization || 'denied',
  functionality_storage: data.default_functionality_storage || 'denied',
  personalization_storage: data.default_personalization_storage || 'denied',
  wait_for_update: makeNumber(data.waitForUpdate) || 2000
};

// Apply region if configured
if (data.enableRegion && data.region) {
  var regions = splitStr(data.region, ',');
  // Trim whitespace from region codes
  var trimmedRegions = [];
  for (var r = 0; r < regions.length; r++) {
    var trimmed = regions[r];
    // Basic trim — remove leading/trailing spaces
    while (trimmed.length && trimmed[0] === ' ') trimmed = trimmed.substring(1);
    while (trimmed.length && trimmed[trimmed.length - 1] === ' ') trimmed = trimmed.substring(0, trimmed.length - 1);
    if (trimmed.length) trimmedRegions.push(trimmed);
  }
  defaultConsent.region = trimmedRegions;
}

setDefaultConsentState(defaultConsent);
debugLog('Default consent state set: all ' + (data.default_analytics_storage || 'denied'));

// Push default consent to dataLayer
pushConsentEvent('pending', defaultConsent, 'default');

// Send default consent to Microsoft (Clarity + Bing UET)
sendMicrosoftConsent('default', defaultConsent);

// Step 2: Set additional gtag settings
if (data.adsDataRedaction) {
  gtagSet('ads_data_redaction', true);
}
if (data.urlPassthrough) {
  gtagSet('url_passthrough', true);
}

// Step 3: Detect CMP
var cmpType = data.cmpType;
var detectedCMP;

if (cmpType === 'auto_detect') {
  detectedCMP = detectCMP();
} else {
  detectedCMP = cmpType;
  debugLog('CMP manually set to: ' + cmpType);
}

// Step 4: Read cookie and update consent (Layer 0 — instant)
if (detectedCMP) {
  var config = CMP_CONFIG[detectedCMP];

  if (config && config.parseFn) {
    var consentState = config.parseFn();
    if (consentState) {
      updateConsentAndMicrosoft(consentState);
      pushConsentEvent(detectedCMP, consentState, 'cookie');
      debugLog('Consent updated from cookie (' + detectedCMP + '): ' +
               'analytics=' + consentState.analytics_storage +
               ', ads=' + consentState.ad_storage);
    } else {
      pushConsentEvent(detectedCMP, null, 'cookie_empty');
      debugLog(detectedCMP + ': cookie found but no consent data (first visit?)');
    }
  }

  // Step 5: Set up JS API callback for future updates (Layer 2)
  var callbackSetup = CALLBACK_MAP[detectedCMP];
  if (callbackSetup) {
    callbackSetup();
    debugLog('JS API callback registered for: ' + detectedCMP);
  }
} else {
  debugLog('No CMP detected. Defaults (denied) will apply until CMP loads.');

  // Retry detection after a short delay (CMP might not have set cookie yet)
  var retryCount = 0;
  function retryDetection() {
    var detected = detectCMP();
    if (detected) {
      var cfg = CMP_CONFIG[detected];
      if (cfg && cfg.parseFn) {
        var consent = cfg.parseFn();
        if (consent) {
          updateConsentAndMicrosoft(consent);
          pushConsentEvent(detected, consent, 'cookie_retry');
          debugLog('Retry: consent updated from ' + detected);
        }
      }
      var cb = CALLBACK_MAP[detected];
      if (cb) cb();
    } else if (retryCount < 3) {
      retryCount++;
      callLater(retryDetection);
    }
  }
  callLater(retryDetection);
}

// Step 6: Cookie polling safety net — catches consent changes if callback missed them
// Runs a few checks after callbacks to ensure cookie updates are not lost
if (detectedCMP) {
  var lastConsentHash = '';
  var pollCount = 0;

  function getConsentHash(consentObj) {
    if (!consentObj) return '';
    return (consentObj.analytics_storage || '') + '|' +
           (consentObj.ad_storage || '') + '|' +
           (consentObj.ad_user_data || '') + '|' +
           (consentObj.ad_personalization || '') + '|' +
           (consentObj.functionality_storage || '') + '|' +
           (consentObj.personalization_storage || '');
  }

  // Capture initial consent hash
  var cfg = CMP_CONFIG[detectedCMP];
  if (cfg && cfg.parseFn) {
    var initial = cfg.parseFn();
    lastConsentHash = getConsentHash(initial);
  }

  function pollCookieForChanges() {
    if (pollCount >= 500) return; // Keep polling for consent changes during session
    pollCount++;

    if (cfg && cfg.parseFn) {
      var current = cfg.parseFn();
      var currentHash = getConsentHash(current);

      if (current && currentHash !== lastConsentHash && currentHash !== '') {
        lastConsentHash = currentHash;
        debugLog('Cookie poll detected consent change (' + detectedCMP + ')');
        updateConsentAndMicrosoft(current);
        pushConsentEvent(detectedCMP, current, 'cookie_poll');
      }
    }
    callLater(pollCookieForChanges);
  }
  callLater(pollCookieForChanges);
}

// Done
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "analytics_storage" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_storage" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_user_data" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "ad_personalization" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "functionality_storage" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "personalization_storage" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "consentType" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" }
                ],
                "mapValue": [
                  { "type": 1, "string": "security_storage" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "vpiId": "2"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              { "type": 1, "string": "OptanonConsent" },
              { "type": 1, "string": "CookieConsent" },
              { "type": 1, "string": "cookieyes-consent" },
              { "type": 1, "string": "borlabs-cookie" },
              { "type": 1, "string": "cmplz_statistics" },
              { "type": 1, "string": "cmplz_marketing" },
              { "type": 1, "string": "cmplz_preferences" },
              { "type": 1, "string": "axeptio_cookies" },
              { "type": 1, "string": "notice_preferences" },
              { "type": 1, "string": "euconsent-v2" },
              { "type": 1, "string": "klaro" }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiId": "3"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "OneTrust" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "OnetrustActiveGroups" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "OptanonWrapper" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Cookiebot" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "CookiebotCallback_OnAccept" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "CookiebotCallback_OnDecline" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "UC_UI" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "BorlabsCookie" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "cmplz_fire_categories" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "_axcb" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "_axcb.push" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "truste" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "Didomi" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "didomiOnReady" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "didomiOnReady.push" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "klaro" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__ucaConsentCookieYesCallback" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__ucaBorlabsCallback" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__ucaTrustArcCallback" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "UC_CONSENT" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__ucaUsercentricsUpdate" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__ucaDidomiPurposes" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "didomiEventListeners" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "didomiEventListeners.push" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "dataLayer" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "uetq" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "clarity" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "clarity.q" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "clarity.q.push" },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiId": "4"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": false
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "vpiId": "5"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              { "type": 1, "string": "ads_data_redaction" },
              { "type": 1, "string": "url_passthrough" },
              { "type": 1, "string": "event" },
              { "type": 1, "string": "uca_cmp" },
              { "type": 1, "string": "uca_source" },
              { "type": 1, "string": "uca_timing_ms" },
              { "type": 1, "string": "uca_analytics_storage" },
              { "type": 1, "string": "uca_ad_storage" },
              { "type": 1, "string": "uca_ad_user_data" },
              { "type": 1, "string": "uca_ad_personalization" },
              { "type": 1, "string": "uca_functionality_storage" },
              { "type": 1, "string": "uca_personalization_storage" }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Sets default consent state with all denied
  code: |-
    mock('getCookieValues', function(name) { return []; });

    runCode({
      cmpType: 'auto_detect',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('setDefaultConsentState').wasCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: Parses OneTrust cookie correctly (mixed consent)
  code: |-
    mock('getCookieValues', function(name) {
      if (name === 'OptanonConsent') {
        return ['isGpcEnabled=0&groups=C0001%3A1%2CC0002%3A1%2CC0003%3A0%2CC0004%3A0'];
      }
      return [];
    });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'auto_detect',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Parses Cookiebot cookie correctly
  code: |-
    mock('getCookieValues', function(name) {
      if (name === 'CookieConsent') {
        return ['{necessary:true,preferences:false,statistics:true,marketing:false}'];
      }
      return [];
    });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'cookiebot',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Parses CookieYes cookie correctly
  code: |-
    mock('getCookieValues', function(name) {
      if (name === 'cookieyes-consent') {
        return ['consent:yes,action:yes,analytics:yes,advertisement:no,functional:yes,performance:yes,other:no'];
      }
      return [];
    });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'cookieyes',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Region configuration is applied
  code: |-
    mock('getCookieValues', function() { return []; });

    runCode({
      cmpType: 'auto_detect',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      enableRegion: true,
      region: 'PL,DE,FR',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('setDefaultConsentState').wasCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: No update when no CMP cookie exists (first visit)
  code: |-
    mock('getCookieValues', function() { return []; });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'onetrust',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false
    });

    assertApi('updateConsentState').wasNotCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: Debug logging fires only when enabled
  code: |-
    mock('getCookieValues', function() { return []; });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'auto_detect',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: true,
      enableMicrosoftConsent: false
    });

    assertApi('logToConsole').wasCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: Custom mapping overrides default OneTrust mapping
  code: |-
    mock('getCookieValues', function(name) {
      if (name === 'OptanonConsent') {
        return ['groups=C0001%3A1%2CC0002%3A1%2CC0005%3A1%2CC0006%3A0'];
      }
      return [];
    });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'onetrust',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false,
      enableCustomMapping: true,
      customMappingTable: [
        { cmpCategory: 'C0002', consentType: 'analytics_storage', grantedWhen: 'truthy' },
        { cmpCategory: 'C0005', consentType: 'ad_storage', grantedWhen: 'truthy' },
        { cmpCategory: 'C0005', consentType: 'ad_user_data', grantedWhen: 'truthy' },
        { cmpCategory: 'C0005', consentType: 'ad_personalization', grantedWhen: 'truthy' },
        { cmpCategory: 'C0006', consentType: 'functionality_storage', grantedWhen: 'truthy' }
      ]
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'denied',
      personalization_storage: 'denied'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Custom mapping works with Cookiebot categories
  code: |-
    mock('getCookieValues', function(name) {
      if (name === 'CookieConsent') {
        return ['{necessary:true,preferences:true,statistics:true,marketing:false}'];
      }
      return [];
    });
    mock('copyFromWindow', function() { return undefined; });

    runCode({
      cmpType: 'cookiebot',
      default_analytics_storage: 'denied',
      default_ad_storage: 'denied',
      default_ad_user_data: 'denied',
      default_ad_personalization: 'denied',
      default_functionality_storage: 'denied',
      default_personalization_storage: 'denied',
      waitForUpdate: '2000',
      adsDataRedaction: true,
      urlPassthrough: false,
      debugMode: false,
      enableMicrosoftConsent: false,
      enableCustomMapping: true,
      customMappingTable: [
        { cmpCategory: 'statistics', consentType: 'analytics_storage', grantedWhen: 'truthy' },
        { cmpCategory: 'marketing', consentType: 'ad_storage', grantedWhen: 'truthy' },
        { cmpCategory: 'marketing', consentType: 'ad_user_data', grantedWhen: 'truthy' },
        { cmpCategory: 'preferences', consentType: 'functionality_storage', grantedWhen: 'truthy' },
        { cmpCategory: 'preferences', consentType: 'personalization_storage', grantedWhen: 'truthy' }
      ]
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    });
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Universal Consent Adapter v1.0

Fires on Consent Initialization trigger (earliest possible in GTM).
Reads CMP cookies directly — no network requests, no waiting for CMP JS.

Supported CMPs:
- OneTrust (OptanonConsent cookie)
- Cookiebot (CookieConsent cookie)
- CookieYes (cookieyes-consent cookie)
- Borlabs Cookie (borlabs-cookie)
- Complianz (cmplz_statistics, cmplz_marketing, cmplz_preferences)
- Axeptio (axeptio_cookies)
- TrustArc (notice_preferences)
- Didomi (euconsent-v2 — JS API fallback)
- Klaro (klaro cookie)
- Usercentrics (JS API only — no cookie)

Setup:
1. Import this template into GTM
2. Create a new tag using this template
3. Set trigger to "Consent Initialization - All Pages"
4. Select your CMP (or leave Auto-detect)
5. Publish
