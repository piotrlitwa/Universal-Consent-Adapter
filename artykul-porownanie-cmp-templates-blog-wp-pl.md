# 10 template'ów CMP w GTM. Żaden nie czyta cookie na czas.

## Zmierzone fakty, nie opinie vendorów.

---

Każdy CMP ma oficjalny template do GTM. "Pełne wsparcie Google Consent Mode v2" — piszą w dokumentacji. Wdrażasz, konfigurujesz, zapominasz.

A potem Twój GA4 przez 1-3 sekundy zbiera dane z consent `denied` — bo template czeka na JavaScript z CDN, zamiast odczytać cookie, które leży w przeglądarce.

---

## Tabelka — co naprawdę potrafią natywne template'y

| CMP | Cookie pre-read | Microsoft Consent | Bugi | Tagów |
|---|---|---|---|---|
| **OneTrust** | ❌ | ❌ | ⚠️ 3 krytyczne | 1-2 |
| **Cookiebot** | ❌ | ⚠️ Tylko update | — | 1 + variable |
| **CookieYes** | ❌ | ❌ | — | 1 |
| **Usercentrics** | ❌ | ❌ | — | 1 |
| **Didomi** | ❌ | ❌ | — | 1 |
| **TrustArc** | ❌ | ❌ | — | 1 |
| **Axeptio** | ❌ | ❌ | — | 1-2 |
| **Complianz** | ❌ | ❌ | — | 1 (tylko WP) |
| **Borlabs** | ❌ | ❌ | ⚠️ Brak taga | Tylko variable |
| **Klaro** | ❌ | ❌ | ⚠️ Brak w Gallery | Custom HTML |

Kolumna "Cookie pre-read" — to jest cały problem. **Żaden template nie czyta cookie consent zanim załaduje się JavaScript CMP.**

---

## 60 sekund wyjaśnienia

Powracający użytkownik wchodzi na stronę. Zgodę dał wczoraj. Cookie jest w przeglądarce.

**Natywny template:**
```
0 ms    → default: denied
50 ms   → PageView leci z denied ❌
1800 ms → CMP JS się załadował → update: granted
         → za późno, PageView już poszedł
```

**Universal Consent Adapter:**
```
0 ms    → default: denied
5 ms    → UCA czyta cookie → update: granted ✅
50 ms   → PageView leci z granted ✅
```

Różnica? 1.8 sekundy. W których 67% Twoich sesji ma brudne dane.

---

## OneTrust — najgorzej

MeasureMinds Group oficjalnie odradza natywny template OneTrust. Trzy bugi:

1. **Fałszywy sygnał** — `OneTrustGroupsUpdated` odpala się przy KAŻDYM załadowaniu bannera, nie tylko po interakcji
2. **Timing losowy** — consent update dociera do GTM kiedy chce
3. **Zero cookie pre-read** — czeka na JS API ładujące się 1.8-3.7 sekundy

Efekt: połowa wdrożeń enterprise to custom HTML zamiast oficjalnego template'u.

---

## Microsoft Consent Mode — od maja 2025 obowiązkowy

Bing Ads i Clarity wymagają sygnałów consent. Ile natywnych template'ów to obsługuje?

Zero. Cookiebot ma częściowo (tylko update, bez default). Reszta — nic. Musisz dokładać osobny tag.

---

## Universal Consent Adapter — jeden tag, jedno rozwiązanie

| Cecha | Natywne template'y | UCA |
|---|---|---|
| Cookie pre-read | ❌ | ✅ Natychmiastowy |
| Microsoft Consent | ❌ | ✅ Clarity + Bing |
| Auto-detect CMP | Nie dotyczy | ✅ 10 CMP |
| Tagów w GTM | 1-2 + variable | 1 |
| Klaro / Borlabs | Brak template'u | ✅ |

**Co robi:** Czyta cookie CMP natychmiast na Consent Initialization. Zanim GA4 wyśle pierwszy hit, consent jest ustawiony. Callbacki reagują na zmiany na żywo. Microsoft Consent Mode jednym checkboxem.

---

## Wdrożenie: 2 minuty

1. GTM → Templates → Import → `template.tpl`
2. Nowy tag → Universal Consent Adapter → CMP: auto-detect
3. Trigger: **Consent Initialization — All Pages**
4. Preview → zakładka Consent → `granted` od pierwszego eventu
5. Publish

Nie musisz usuwać starego template'u. Testuj równolegle. UCA nie konfliktuje.

---

## Podsumowanie

Twój vendor CMP nie kłamie — ich template "działa". Tyle że 1-3 sekundy za późno. A te 1-3 sekundy to 67% sesji z brudnymi danymi.

Po co czekać na JavaScript z CDN, żeby odczytać cookie, które leży w przeglądarce?

Dane nie kłamią. Ale Twój CMP template — owszem.

---

*Universal Consent Adapter — open source, GTM Custom Template.*

*→ [GitHub](https://github.com/piotrlitwa/universal-consent-adapter)*
