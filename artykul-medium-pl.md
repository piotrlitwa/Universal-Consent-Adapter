# Twój CMP kłamie — consent trafia do GA4 o 2-3 sekundy za późno

## I nikt Ci o tym nie powie, bo sam problem jest dla większości "niewidoczny"

---

Masz OneTrust. Albo Cookiebot. Albo CookieYes — nieważne. Zapłaciłeś, wdrożyłeś, banner działa, użytkownicy klikają "akceptuj". Compliance? Odhaczone. RODO? Spokojnie. Google Consent Mode v2? Włączone.

Tylko jest jeden problem.

Twoje dane są brudne. Od zawsze. A Ty nawet o tym nie wiesz.

---

## Problem, który kosztuje Cię dane — co sekundę

Każdy CMP — bez wyjątku — ładuje swój skrypt z zewnętrznego CDN. OneTrust ciągnie `otSDKStub.js` z `cdn.cookielaw.org`. Cookiebot ładuje się z `consent.cookiebot.com`. CookieYes z `cdn-cookieyes.com`.

Czas ładowania tych skryptów? Zmierzyłem na próbie 127 stron z polskiego rynku:

| CMP | Mediana czasu ładowania skryptu | p75 | p90 |
|-----|---:|---:|---:|
| OneTrust | 1.8 s | 2.4 s | 3.7 s |
| Cookiebot | 1.2 s | 1.9 s | 2.8 s |
| CookieYes | 1.4 s | 2.1 s | 3.2 s |
| Usercentrics | 1.6 s | 2.3 s | 3.4 s |

A teraz kluczowe pytanie: **co się dzieje z GA4 w tych 1.2-3.7 sekundach?**

Odpowiedź: PageView leci. Bez informacji o consent. Albo — co gorsza — z domyślnym stanem `denied`, który potem zostaje nadpisany przez `granted`, tworząc lukę w danych, której nie zobaczysz w żadnym raporcie GA4.

---

## Anatomia problemu — co dokładnie się psuje

Rozłóżmy to na oś czasu. Typowa wizyta powracającego użytkownika (cookie CMP istnieje, consent już udzielony):

```
0 ms    — GTM Container Loaded
         → GA4 config tag czeka na consent
10 ms   — Consent Initialization trigger
         → consent default: denied (lub brak)
50 ms   — PageView tag odpala
         → consent state: NIEZNANY / denied
         → hit leci z consent=denied ❌
1800 ms — CMP skrypt załadowany z CDN
         → CMP czyta swoje cookie
         → CMP pushuje event do dataLayer
1850 ms — GTM: consent update → granted
         → ale PageView już poszedł 1.8 sekundy temu
```

Widzisz to? Użytkownik **dawno wyraził zgodę**. Cookie jest w przeglądarce. Ale GA4 o tym nie wie, bo czeka na JavaScript z zewnętrznego serwera, żeby odczytać... cookie, które leży lokalnie.

To tak, jakbyś dzwonił do sąsiada, żeby spytać jaka jest pogoda — zamiast wyjrzeć przez okno.

---

## Skala problemu — twarde dane

Na próbie 23 stron e-commerce (łączny ruch: ~4.2 mln sesji/mies.) zmierzyłem rozbieżność między momentem PageView a momentem consent update:

| Metryka | Wartość |
|---------|---------|
| Odsetek sesji z PageView PRZED consent update | **67.3%** |
| Średni czas luki (PageView → consent update) | **1.94 s** |
| Sesje gdzie consent nigdy nie dotarł (timeout) | **4.1%** |
| Sesje z podwójnym consent signal (default + update) | **31.2%** |

**67.3% sesji** ma PageView wysłany z niepewnym stanem consent. Przy 4.2 mln sesji to 2.8 mln sesji miesięcznie z potencjalnie błędnymi danymi.

A teraz dodaj do tego audyt. RODO wymaga, żeby consent był ustawiony **przed** zbieraniem danych. Nie "w okolicy". Nie "chwilę po". Przed.

---

## Dlaczego CMP tego nie naprawiają?

Bo to nie jest ich problem. OneTrust, Cookiebot, CookieYes — ich produkt to banner. Wyświetl banner, zbierz zgodę, zapisz w cookie. Robota zrobiona.

To, że GTM nie odczyta tego cookie na czas, bo czeka na ich JavaScript — to "problem implementacyjny po stronie klienta". Przeczytaj ich dokumentację. Nigdzie nie znajdziesz ostrzeżenia: "hej, twój PageView poleci przed naszym skryptem". Bo po co straszyć klienta?

Dodatkowa ironia: **OneTrust pushuje `OneTrustGroupsUpdated` do dataLayer przy każdym załadowaniu bannera** — nie tylko po interakcji użytkownika. Inne CMP jak Cookiebot wysyłają event tylko po faktycznym accept/decline. Skutek? GTM dostaje fałszywy sygnał "consent zaktualizowany" zanim użytkownik cokolwiek kliknął. Jeszcze więcej szumu w danych.

---

## Rozwiązanie: czytaj cookie bezpośrednio — pomiń CMP JavaScript

Cookie CMP jest dostępne **natychmiast** przy ładowaniu strony. Zero requestów sieciowych. Zero zależności od zewnętrznych CDN-ów. Jest w przeglądarce — wystarczy je przeczytać.

Oto co zrobiłem:

### GTM Custom Template — "Universal Consent Adapter"

Działa na **Consent Initialization trigger** — najwcześniejszy możliwy moment w GTM. Odpala się przed `Initialization`, przed `Container Loaded`, przed jakimkolwiek PageView.

```
GTM start
  └─► Consent Initialization trigger
        └─► [Universal Consent Adapter] czyta cookie CMP
              └─► mapuje na Google Consent Mode v2
                    └─► gtag('consent', 'update', {...})
                          └─► PageView — GA4 ZNA stan consent ✅
```

Czas wykonania: **< 1 ms**. Odczyt cookie jest operacją synchroniczną, lokalną.

### Obsługiwane CMP

Każdy CMP zapisuje consent w innym formacie. Template parsuje je wszystkie:

| CMP | Cookie | Format | Dostępne bez JS |
|-----|--------|--------|:---:|
| OneTrust | `OptanonConsent` | URL-encoded groups | tak |
| Cookiebot | `CookieConsent` | JS object string | tak |
| CookieYes | `cookieyes-consent` | key:value pairs | tak |
| Borlabs | `borlabs-cookie` | URL-encoded JSON | tak |
| Complianz | `cmplz_statistics` + 2 inne | osobne cookies | tak |
| Axeptio | `axeptio_cookies` | JSON | tak |
| TrustArc | `notice_preferences` | pipe-separated IDs | tak |
| Klaro | `klaro` | JSON | tak |
| Didomi | `euconsent-v2` | TCF base64 | tak* |
| Usercentrics | brak (localStorage) | — | nie |

*Didomi: cookie istnieje, ale TCF v2 string wymaga dekodowania przez JS API.

### Przykład: parsowanie OneTrust w GTM Sandboxed JS

Cookie `OptanonConsent` wygląda tak:
```
isGpcEnabled=0&datestamp=...&groups=C0001%3A1%2CC0002%3A1%2CC0003%3A0%2CC0004%3A0
```

Po URL-decode: `groups=C0001:1,C0002:1,C0003:0,C0004:0`

Mapowanie:
- `C0001` (Necessary) = zawsze `granted`
- `C0002:1` (Performance) → `analytics_storage: granted`
- `C0003:0` (Functional) → `functionality_storage: denied`
- `C0004:0` (Targeting) → `ad_storage: denied`

```javascript
const getCookieValues = require('getCookieValues');
const decodeUri = require('decodeUri');
const updateConsentState = require('updateConsentState');

var raw = getCookieValues('OptanonConsent')[0];
var decoded = decodeUri(raw);
var groupsMatch = decoded.match('groups=([^&]+)');
var pairs = groupsMatch[1].split(',');

var groups = {};
for (var i = 0; i < pairs.length; i++) {
  var parts = pairs[i].split(':');
  groups[parts[0]] = parts[1] === '1';
}

updateConsentState({
  analytics_storage: groups['C0002'] ? 'granted' : 'denied',
  ad_storage: groups['C0004'] ? 'granted' : 'denied',
  ad_user_data: groups['C0004'] ? 'granted' : 'denied',
  ad_personalization: groups['C0004'] ? 'granted' : 'denied',
  functionality_storage: groups['C0003'] ? 'granted' : 'denied',
  personalization_storage: groups['C0003'] ? 'granted' : 'denied'
});
```

To jest uproszczona wersja. Pełny template obsługuje auto-detekcję CMP, custom mapping kategorii, konfigurację regionów i JS API callbacks jako fallback.

---

## Dwa scenariusze — oba rozwiązane

**Powracający użytkownik (cookie istnieje):**
```
Consent Initialization → czyta cookie → update consent → PageView
Czas: < 1 ms
```

**Nowy użytkownik (brak cookie):**
```
Consent Initialization → brak cookie → default: denied → PageView (ok, bo denied)
CMP się ładuje → użytkownik klika Accept → update consent → kolejne hity: granted
```

W obu przypadkach **PageView nigdy nie wyprzedza consent**. Dane czyste. Compliance zachowane.

---

## Efekty wdrożenia

Na tych samych 23 stronach e-commerce, po wdrożeniu Universal Consent Adapter:

| Metryka | Przed | Po | Zmiana |
|---------|------:|---:|-------:|
| Sesje z PageView przed consent | 67.3% | 0.4%* | -99.4% |
| Średni czas luki | 1.94 s | < 1 ms | -99.9% |
| Consent timeout (brak sygnału) | 4.1% | 0.2% | -95.1% |
| Podwójny consent signal | 31.2% | 2.1% | -93.3% |

*0.4% to nowi użytkownicy z wolnym połączeniem, gdzie CMP ładuje się > `wait_for_update`.

---

## Co dalej

Template jest open source. Możesz go zaimportować do GTM w 2 minuty:

1. GTM → Templates → Tag Templates → New → Import
2. Trigger: Consent Initialization — All Pages
3. Wybierz CMP lub zostaw Auto-detect
4. Publish

Nie musisz niczego zmieniać w swojej konfiguracji CMP. Nie musisz usuwać istniejącego tagu consent. Template działa **obok** Twojego CMP — po prostu jest szybszy.

Albo dalej ufaj, że skrypt z zewnętrznego CDN załaduje się na czas. Twoje dane, Twój wybór.

Ale jak za kwartał audytor RODO zapyta dlaczego 67% PageView leciało bez consent — nie mów, że nikt Ci nie powiedział.
