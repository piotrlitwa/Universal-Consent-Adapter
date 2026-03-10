# GTM Consent Bridge — Notatki strategiczne

## Problem do rozwiązania

OneTrust (i inne CMP) ładuje się z zewnętrznego CDN — mija 2-3 sekundy zanim zwróci informację o zgodach. Przez ten czas GA4, Google Ads i inne tagi nie wiedzą jaki consent ustawić → dane zatrucie, luki w Consent Mode v2, ryzyko compliance.

---

## Architektura rozwiązania

### Warstwa 1 — Consent Default (natychmiastowy)
Odpala się na **Consent Initialization trigger** (najwcześniejszy możliwy w GTM), ustawia domyślne `denied` dla wszystkich:

```js
gtag('consent', 'default', {
  analytics_storage: 'denied',
  ad_storage: 'denied',
  ad_user_data: 'denied',
  ad_personalization: 'denied',
  functionality_storage: 'denied',
  personalization_storage: 'denied',
  wait_for_update: 2000
});
```

### Warstwa 2 — Adapter per CMP

Każdy CMP ma inny mechanizm odczytu zgód:

| CMP | Mechanizm |
|-----|-----------|
| OneTrust | `window.OneTrust`, `OptanonWrapper`, `OTEventHandlers` |
| Cookiebot | `window.Cookiebot`, `CookiebotCallback_OnAccept` |
| CookieYes | `window.getCkyConsent()`, event `cookieyes-consent-update` |
| Usercentrics | `window.UC_UI`, event `ucEvent` |
| Axeptio | `window._axcb`, event `axeptio_cookies_complete` |
| Complianz | `window.cmplz_fire_categories` |
| Borlabs | `window.BorlabsCookie` |
| TrustArc | `window.truste`, `TrustArcAsyncCallbacks` |
| Didomi | `window.Didomi`, `window.didomiOnReady` |
| Klaro | `window.klaro`, `window.klaroConfig` |

### Warstwa 3 — Mapping kategorii → Google Consent Mode v2

```
"performance" / "analytics" / "statystyczne"  →  analytics_storage
"marketing" / "targeting" / "reklamowe"        →  ad_storage
"functional" / "preferences"                   →  functionality_storage
```

### Wzorzec dla OneTrust (GTM Sandboxed JS)

```js
const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');

const oneTrust = copyFromWindow('OneTrust');

if (oneTrust) {
  readOneTrustConsent();
} else {
  const existingWrapper = copyFromWindow('OptanonWrapper');
  setInWindow('OptanonWrapper', function() {
    if (existingWrapper) existingWrapper();
    readOneTrustConsent();
  });
}
```

---

## Struktura artykułu (content marketing)

1. **Problem** — "OneTrust ładuje się 2-3 sekundy, przez ten czas GA4 nie wie jaki consent ustawić"
2. **Dlaczego to boli** — dane zatrucie, Consent Mode v2 shows gaps, ryzyko audytu
3. **Jak różne CMP rozwiązują to inaczej** (tabela — shareable content)
4. **Rozwiązanie krok po kroku** — kod + wyjaśnienie
5. **CTA naturalny** — "zebrałem to w gotowy GTM Template"

---

## Gdzie publikować

- **Measure Slack** — największa społeczność analytics globalnie
- **r/googletagmanager**, **r/analytics** — Reddit
- **LinkedIn** — artykuł techniczny, dobrze indeksuje się u agency people
- **Grupy FB** — GTM Polska, Analytics Polska
- **StackOverflow** — sam zadaj pytanie + odpowiedz

---

## Pomysł na produkt

**Nazwa:** `GTM Consent Bridge` / `Consent Sync` / `Universal Consent Adapter`

**Model:**
- Darmowy GTM Template na Community Gallery
- Płatna wersja z dashboardem — monitoring czy consent odpala się w czasie (nowy SaaS / rozszerzenie Cookie Banner Pro)

**Mocna strona:** Działa niezależnie od tego czy klient używa Cookie Banner Pro — możesz sprzedawać klientom konkurencji.

---

## Warstwa 0 — Odczyt z cookie (najszybsza, przed JS API)

Cookie jest dostępne **natychmiast** przy ładowaniu strony — zanim jakikolwiek zewnętrzny skrypt CMP się załaduje. To najszybszy możliwy sposób na ustawienie consent.

### Optymalny flow

```
Consent Initialization trigger
  → odczytaj cookie CMP
  → jeśli cookie istnieje → ustaw consent natychmiast (update)
  → jeśli cookie brak (pierwsza wizyta) → zostaw default: denied
  → gdy CMP JS się załaduje → callback → ewentualny update
```

---

### Parsowanie cookies per CMP

#### Helper — odczyt dowolnego cookie (GTM Sandboxed JS)

```js
const getCookieValues = require('getCookieValues');

// Zwraca tablicę wartości dla danej nazwy cookie
const values = getCookieValues('OptanonConsent');
const raw = values.length ? values[0] : null;
```

---

#### OneTrust — cookie `OptanonConsent`

Format: URL-encoded string
```
isGpcEnabled=0&datestamp=...&groups=C0001%3A1%2CC0002%3A0%2CC0003%3A1%2CC0004%3A0
```

Parsowanie:
```js
const decodeUri = require('decodeUri');
const getCookieValues = require('getCookieValues');

function parseOneTrust() {
  const raw = getCookieValues('OptanonConsent')[0];
  if (!raw) return null;

  const decoded = decodeUri(raw);
  const groupsMatch = decoded.match(/groups=([^&]+)/);
  if (!groupsMatch) return null;

  const groups = {};
  groupsMatch[1].split(',').forEach(function(pair) {
    const parts = pair.split(':');
    groups[parts[0]] = parts[1] === '1';
  });

  // Domyślne mapowanie OneTrust:
  // C0001 = Necessary, C0002 = Performance, C0003 = Functional, C0004 = Targeting
  return {
    analytics_storage: groups['C0002'] ? 'granted' : 'denied',
    ad_storage: groups['C0004'] ? 'granted' : 'denied',
    functionality_storage: groups['C0003'] ? 'granted' : 'denied',
    personalization_storage: groups['C0003'] ? 'granted' : 'denied',
    ad_user_data: groups['C0004'] ? 'granted' : 'denied',
    ad_personalization: groups['C0004'] ? 'granted' : 'denied',
  };
}
```

> ⚠️ Uwaga: Klient może mieć niestandardowe ID grup w OneTrust (nie zawsze C0001-C0004). Należy sprawdzić w panelu OneTrust jakie ID mają kategorie.

---

#### Cookiebot — cookie `CookieConsent`

Format: JavaScript object jako string
```
{necessary:true,preferences:false,statistics:true,marketing:false,...}
```

Parsowanie:
```js
function parseCookiebot() {
  const raw = getCookieValues('CookieConsent')[0];
  if (!raw) return null;

  // Wyciągamy wartości przez regex bo sandbox nie ma JSON.parse dla tego formatu
  function extract(key) {
    const match = raw.match(new RegExp(key + ':(true|false)'));
    return match ? match[1] === 'true' : false;
  }

  return {
    analytics_storage: extract('statistics') ? 'granted' : 'denied',
    ad_storage: extract('marketing') ? 'granted' : 'denied',
    functionality_storage: extract('preferences') ? 'granted' : 'denied',
    personalization_storage: extract('preferences') ? 'granted' : 'denied',
    ad_user_data: extract('marketing') ? 'granted' : 'denied',
    ad_personalization: extract('marketing') ? 'granted' : 'denied',
  };
}
```

---

#### CookieYes — cookie `cookieyes-consent`

Format: klucz:wartość oddzielone przecinkami
```
consent:yes,action:yes,analytics:yes,advertisement:no,functional:yes,performance:yes,other:no
```

Parsowanie:
```js
function parseCookieYes() {
  const raw = getCookieValues('cookieyes-consent')[0];
  if (!raw) return null;

  const map = {};
  raw.split(',').forEach(function(pair) {
    const parts = pair.split(':');
    map[parts[0]] = parts[1] === 'yes';
  });

  return {
    analytics_storage: map['analytics'] ? 'granted' : 'denied',
    ad_storage: map['advertisement'] ? 'granted' : 'denied',
    functionality_storage: map['functional'] ? 'granted' : 'denied',
    personalization_storage: map['performance'] ? 'granted' : 'denied',
    ad_user_data: map['advertisement'] ? 'granted' : 'denied',
    ad_personalization: map['advertisement'] ? 'granted' : 'denied',
  };
}
```

---

#### Usercentrics — brak standardowego cookie (używa localStorage)

Usercentrics zapisuje stan w `localStorage` pod kluczem `uc_user_interaction` lub `ucConsent`. GTM Sandboxed JS **nie ma dostępu do localStorage** — tutaj odczyt możliwy tylko przez JS API (`window.UC_UI`) po załadowaniu skryptu. Fallback: zostaw `denied` i czekaj na event `ucEvent`.

---

#### Borlabs Cookie — cookie `borlabs-cookie`

Format: JSON (URL-encoded)
```json
{"consents":{"statistics":true,"marketing":false},"uid":"..."}
```

Parsowanie:
```js
function parseBorlabs() {
  const raw = getCookieValues('borlabs-cookie')[0];
  if (!raw) return null;

  const decoded = decodeUri(raw);
  // W sandboxie GTM nie ma JSON.parse — używamy regex
  const statistics = decoded.match(/"statistics":(true|false)/);
  const marketing = decoded.match(/"marketing":(true|false)/);

  return {
    analytics_storage: (statistics && statistics[1] === 'true') ? 'granted' : 'denied',
    ad_storage: (marketing && marketing[1] === 'true') ? 'granted' : 'denied',
    functionality_storage: 'denied',
    personalization_storage: 'denied',
    ad_user_data: (marketing && marketing[1] === 'true') ? 'granted' : 'denied',
    ad_personalization: (marketing && marketing[1] === 'true') ? 'granted' : 'denied',
  };
}
```

---

#### Axeptio — cookie `axeptio_cookies`

Format: JSON
```json
{"$completed":true,"analytics":true,"marketing":false}
```

Parsowanie analogiczne do Borlabs — regex po URL-decoded stringu.

---

### Tabela podsumowująca — cookie vs JS API

| CMP | Nazwa cookie | Dostępne bez JS | Format |
|-----|-------------|-----------------|--------|
| OneTrust | `OptanonConsent` | ✅ | URL-encoded |
| Cookiebot | `CookieConsent` | ✅ | JS object string |
| CookieYes | `cookieyes-consent` | ✅ | key:value |
| Usercentrics | brak (localStorage) | ❌ | tylko JS API |
| Axeptio | `axeptio_cookies` | ✅ | JSON |
| Borlabs | `borlabs-cookie` | ✅ | JSON URL-encoded |
| Complianz | `cmplz_consent` | ✅ | key=value |
| TrustArc | `notice_preferences` | ✅ | pipe-separated |
| Didomi | `euconsent-v2` (TCF) | ✅ | base64 TCF string |
| Klaro | `klaro` | ✅ | JSON |

---

---

## Dlaczego inne rozwiązania mają problem z timingiem

Każdy CMP — OneTrust, Cookiebot, CookieYes — **zawsze ładuje swój skrypt z zewnętrznego serwera**, nawet gdy użytkownik wraca i cookie już istnieje. Dopiero po załadowaniu skryptu CMP odczytuje cookie i pushuje event do dataLayer.

| CMP | Co się dzieje przy powrotnej wizycie |
|-----|--------------------------------------|
| OneTrust | Ładuje `otSDKStub.js` z CDN → czyta `OptanonConsent` → pushuje `OneTrustGroupsUpdated` |
| Cookiebot | Ładuje skrypt z CDN → czyta `CookieConsent` → pushuje `cookie_consent_update` |
| CookieYes | Ładuje skrypt z CDN → czyta `cookieyes-consent` → emituje event |
| Usercentrics | Ładuje skrypt z CDN → czyta localStorage |

### Dodatkowy błąd OneTrust

OneTrust pushuje `OneTrustGroupsUpdated` do dataLayer **przy każdym załadowaniu bannera** — nie tylko po interakcji użytkownika. Inne CMP jak Cookiebot wysyłają event tylko po faktycznym accept/decline. Skutek: GTM dostaje fałszywy sygnał "consent zaktualizowany" zanim użytkownik cokolwiek kliknął.

### Konsekwencja dla GA4

Przy każdej wizycie między momentem `Container Loaded` a momentem gdy CMP pushuje event do dataLayer — GA4 **nie zna stanu consent**. Jeśli w tym oknie odpali się PageView (a odpala się zawsze), hit leci z niepewnym stanem consent lub w ogóle bez niego.

---

## Core — jak działa ta wtyczka

**Trigger: Consent Initialization — All Pages**

To najwcześniejszy możliwy moment w GTM — odpala się przed `Initialization`, przed `Container Loaded`, przed jakimkolwiek PageView.

```
GTM się ładuje
  └─► Consent Initialization trigger
        └─► [TA WTYCZKA] odczytuje cookie CMP natychmiast
              └─► mapuje na Google Consent Mode v2
                    └─► gtag('consent', 'update', {...})
                          └─► PageView — GA4 już ZNA stan consent ✅
```

Wtyczka **nie czeka** na:
- załadowanie skryptu CMP
- odpowiedź serwera CMP
- event z dataLayer (`OneTrustGroupsUpdated`, `cookie_consent_update`)
- interakcję użytkownika z bannerem

Czyta cookie bezpośrednio — cookie jest dostępne natychmiast w przeglądarce, zero requestów sieciowych.

### Scenariusze

**Powracający użytkownik (cookie istnieje):**
```
Consent Initialization → czyta cookie → update consent → PageView
Czas: ~0ms (lokalny odczyt)
```

**Nowy użytkownik (brak cookie):**
```
Consent Initialization → brak cookie → ustaw default: denied → PageView
Gdy CMP się załaduje → użytkownik klika → update consent
```

W obu przypadkach **PageView nigdy nie wyprzedza consent**.

---

## Prompt do napisania artykułu

```
Jesteś ekspertem GTM i Google Consent Mode v2. Napisz artykuł techniczny w stylu Simo Ahava — konkretny, z kodem, bez marketingowego języka.

Temat: Jak zapewnić że consent z CMP (OneTrust, Cookiebot, CookieYes i innych) trafia do GTM/GA4 zawsze na czas — przed pierwszym PageView.

Struktura:
1. Opis problemu (timing consent vs ładowanie CMP)
2. Dlaczego to powoduje błędy w Consent Mode v2
3. Tabela: top 10 CMP i ich mechanizm callbacków
4. Rozwiązanie: GTM Custom Template jako "consent proxy"
   - Warstwa 1: consent default na Consent Initialization trigger
   - Warstwa 2: detekcja CMP i podpięcie się pod callback
   - Warstwa 3: mapping kategorii na Google Consent Mode v2
5. Przykładowy kod w GTM Sandboxed JS dla OneTrust
6. Zakończenie: naturalne CTA — gotowy template

Styl: po angielsku, techniczny ale przystępny, akapity a nie bullet pointy, ton eksperta który rozwiązał realny problem u klienta. Długość: około 1200-1500 słów. Bez hype, bez "game-changer".
```
