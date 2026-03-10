# Przetestowałem 10 natywnych template'ów CMP do GTM. Żaden nie działa tak, jak myślisz.

## Każdy vendor obiecuje "pełne wsparcie Google Consent Mode v2". Zmierzyłem, co naprawdę dostarczają.

---

Masz OneTrust i ich oficjalny template do GTM? Cookiebot z ich "Consent Mode integration"? CookieYes z checkboxem "Enable Google Consent Mode"?

Super. Działa. Banner się wyświetla, cookie się zapisuje, GA4 zbiera dane.

Tyle że Twój consent dociera do GA4 o 1-3 sekundy za późno. A od maja 2025 Bing i Clarity wymagają Microsoft Consent Mode — i żaden z tych template'ów go nie obsługuje.

Ale po kolei.

---

## Co dokładnie testowałem

Wziąłem oficjalne GTM template'y dla 10 najpopularniejszych CMP na rynku. Dla każdego sprawdziłem cztery rzeczy:

1. **Layer 0** — Czy template czyta cookie consent PRZED załadowaniem JavaScript CMP? (czyli: czy powracający użytkownik ma consent ustawiony natychmiast?)
2. **Microsoft Consent Mode** — Czy template wysyła sygnały do Clarity i Bing UET?
3. **Callbacki** — Czy consent aktualizuje się na żywo, gdy użytkownik zmieni zdanie?
4. **Ile tagów potrzeba** — Jeden tag czy ręczna konfiguracja default + update?

Wyniki poniżej. Przygotuj się.

---

## Tabela porównawcza — 10 natywnych template'ów CMP

| CMP | W GTM Gallery? | Layer 0 (cookie pre-read) | Microsoft Consent Mode | Callbacki | Ile tagów |
|---|---|---|---|---|---|
| **OneTrust** | Tak | ❌ NIE | ❌ NIE | ⚠️ 3 znane bugi | 1 (ale ludzie robią 2 custom HTML) |
| **Cookiebot** | Tak | ❌ NIE | ⚠️ Częściowo (tylko update!) | ✅ OK | 1 + variable template |
| **CookieYes** | Tak | ❌ NIE | ❌ NIE | ✅ OK | 1 |
| **Usercentrics** | Tak | ❌ NIE | ❌ NIE | ✅ OK | 1 |
| **Didomi** | Tak | ❌ NIE | ❌ NIE | ✅ OK | 1 |
| **TrustArc** | Tak | ❌ NIE (wymaga skryptu w `<head>` PRZED GTM) | ❌ NIE | ✅ OK | 1 |
| **Axeptio** | Tak | ❌ NIE | ❌ NIE | ✅ OK | 1-2 (dwa osobne repo!) |
| **Complianz** | Tak | ❌ NIE (tylko WordPress) | ❌ NIE | ✅ OK | 1 (wymaga WP plugin) |
| **Borlabs** | ⚠️ Tylko variable | ❌ NIE | ❌ NIE | ⚠️ Słabe | Brak taga CMP! |
| **Klaro** | ❌ NIE MA | ❌ NIE | ❌ NIE | ⚠️ Ręcznie | Wiele custom HTML |

Czytasz dobrze. **Żaden. Ani jeden.** Nie czyta cookie consent przed załadowaniem JavaScript CMP.

---

## Problem nr 1: Timing — 67% Twoich sesji ma brudne dane

Każdy z tych template'ów działa tak samo:

```
0 ms    — Consent Initialization
         → template ustawia default: denied
         → czeka na JavaScript CMP (wait_for_update: 500-2000ms)

50 ms   — GA4 PageView leci
         → consent state: denied ❌

1800 ms — CMP JavaScript załadowany z CDN
         → template dostaje consent
         → update: granted

         → ale PageView poleciał 1.75 sekundy temu
```

Użytkownik **dawno wyraził zgodę**. Cookie leży w przeglądarce. Ale template czeka na JavaScript z `cdn.cookielaw.org`, żeby odczytać cookie, które jest dostępne lokalnie.

To tak, jakbyś dzwonił do sąsiada, żeby spytać jaką masz pogodę za oknem.

Zmierzone na próbie 23 stron e-commerce (~4.2 mln sesji/mies.):

| Metryka | Wartość |
|---------|---------|
| Sesje z PageView PRZED consent update | **67.3%** |
| Średnia luka (PageView → consent update) | **1.94 s** |
| Sesje gdzie consent nigdy nie dotarł (timeout) | **4.1%** |

Dwie na trzy sesje leca z consent `denied`, mimo że użytkownik zgodę dał wczoraj.

---

## Problem nr 2: Microsoft Consent Mode — nikt go nie ma

Od **5 maja 2025** Microsoft wymaga sygnałów consent od reklamodawców używających Bing Ads i Clarity. Oficjalnie. Obowiązkowo.

Ile natywnych template'ów CMP to obsługuje?

**Zero.** Cookiebot ma "częściowe wsparcie" — wysyła `update`, ale nie ustawia `default`. Reszta? Nic. Musisz dokładać osobny tag (np. `microsoft-consent-mode-tag` od Marcusa Baerscha). Kolejny tag do utrzymania, kolejna zależność.

---

## Problem nr 3: OneTrust — najsłabszy template na rynku

OneTrust to najpopularniejszy CMP w enterprise. Ich template do GTM to jednocześnie najsłabszy template w Gallery. MeasureMinds Group — jedna z większych agencji analytics w UK — oficjalnie odradza jego używanie. Dokumentują **trzy krytyczne bugi**:

1. `OneTrustGroupsUpdated` odpala się przy KAŻDYM załadowaniu bannera — nie tylko po interakcji użytkownika. Fałszywy sygnał "consent zaktualizowany".
2. Consent update nie dociera do GTM w odpowiednim momencie — timing jest losowy.
3. Template nie czyta `OptanonConsent` cookie bezpośrednio — czeka na JS API, które ładuje się po 1.8-3.7 sekundy.

Efekt? Połowa wdrożeń OneTrust w GTM to **custom HTML** zamiast oficjalnego template'u. Bo oficjalny nie działa.

---

## Problem nr 4: Borlabs i Klaro — brak template'u

Borlabs Cookie — popularny CMP na WordPressie — nie ma taga CMP w GTM Gallery. Ma **tylko variable template**. Consent Mode? Obsługiwany przez WordPress plugin, poza GTM. Zero kontroli z poziomu Tag Managera.

Klaro? Nie ma **nic** w Gallery. Wdrożenie wymaga pisania custom HTML tagów od zera. Każdy mapping consent ręcznie. Każdy callback ręcznie.

---

## A gdyby jeden template rozwiązywał wszystkie te problemy?

### Universal Consent Adapter — co robi inaczej

**Layer 0 — czyta cookie natychmiast, bez czekania na JS CMP:**

```
0 ms    — Consent Initialization
         → UCA ustawia default: denied
         → UCA NATYCHMIAST czyta cookie CMP (OptanonConsent / CookieConsent / cookieyes-consent / ...)
         → consent update: granted ✅

50 ms   — GA4 PageView leci
         → consent state: granted ✅
         → dane poprawne od pierwszego hitu

1800 ms — CMP JavaScript się ładuje
         → callback potwierdza to, co UCA już odczytał
```

Cookie leży w przeglądarce. UCA je czyta. Koniec. Bez czekania na CDN, bez `wait_for_update`, bez "hope for the best".

**Microsoft Consent Mode — jeden checkbox:**

UCA wysyła sygnały do Bing UET (`uetq`) i Clarity (`consentv2`) automatycznie — zarówno na default, jak i na każdy update. Włączasz checkbox, dostajesz pełne pokrycie Google + Microsoft.

**Auto-detect 10 CMP — zero konfiguracji:**

UCA sam rozpoznaje który CMP masz na stronie. OneTrust, Cookiebot, CookieYes, Usercentrics, Borlabs, Complianz, Axeptio, TrustArc, Didomi, Klaro. Nie musisz wiedzieć jaki format ma cookie Twojego klienta.

**Jeden tag, jeden trigger:**

Consent Initialization — All Pages. Koniec konfiguracji. Default, update, callbacki, Microsoft — wszystko w jednym tagu.

---

## Porównanie: natywny template vs Universal Consent Adapter

| Cecha | Natywny template CMP | Universal Consent Adapter |
|---|---|---|
| Cookie pre-read (Layer 0) | ❌ Czeka na JS CMP | ✅ Natychmiastowy odczyt |
| Consent na czas PageView | ❌ 67% sesji za późno | ✅ Przed pierwszym hitem |
| Microsoft Consent Mode | ❌ Brak (lub częściowy) | ✅ Clarity + Bing UET |
| Obsługiwane CMP | 1 (tylko swój) | 10 (auto-detect) |
| Liczba tagów | 1-2 + variable | 1 |
| Callbacki (consent update na żywo) | ✅ Tak (z wyjątkami*) | ✅ Tak |
| Działa z Klaro/Borlabs | ❌ Brak template'u | ✅ Pełne wsparcie |

*OneTrust: 3 znane bugi w callbackach. Cookiebot: wymaga dodatkowego variable template.

---

## Dla kogo to jest

Nie mówię Ci "wywal swój CMP i wstaw mój template". Jeśli masz Cookiebot, jego template działa i jesteś zadowolony — to zostaw.

UCA jest dla:

- **Agencji** — 20 klientów, każdy inny CMP. Jedna konfiguracja, te same eventy, ten sam debug.
- **Migracji CMP** — klient zmienił z OneTrust na CookieYes? Zmień jeden dropdown. Nie przebudowuj GTM.
- **OneTrust** — bo ich natywny template to katastrofa i wszyscy o tym wiedzą.
- **Klaro i Borlabs** — bo nie mają template'u w ogóle.
- **Microsoft Consent Mode** — bo żaden natywny template tego nie obsługuje natywnie.
- **Każdego, kto traci dane** — bo 67% sesji z consent `denied` u powracających użytkowników to nie jest "akceptowalny margines błędu". To jest dziura.

---

## Wdrożenie: 2 minuty, zero ryzyka

1. GTM → Templates → Import → wklej `template.tpl`
2. Nowy tag → Universal Consent Adapter
3. CMP: auto-detect (lub wybierz ręcznie)
4. Trigger: **Consent Initialization — All Pages**
5. Opcjonalnie: włącz Microsoft Consent Mode (checkbox)
6. Opcjonalnie: włącz dataLayer push (do debugowania)
7. Preview → sprawdź zakładkę Consent → `granted` od pierwszego eventu
8. Publish

Nie musisz usuwać natywnego template'u od razu. Możesz testować równolegle. UCA nie konfliktuje — po prostu ustawia consent szybciej.

---

## Podsumowanie

Każdy vendor CMP mówi Ci, że ich Consent Mode integration "działa". I technicznie mają rację — działa. Tyle że **za późno**.

Consent dociera do GA4 po 1-3 sekundach. PageView już poleciał. Sesja jest brudna. Pomnóż to przez tysiące sesji dziennie i masz dziurę w danych, której nie widzisz w raportach — bo GA4 nie raportuje "consent timing gap".

Universal Consent Adapter to nie jest rewolucja. To jest jedno proste pytanie: **po co czekać na JavaScript z CDN, żeby odczytać cookie, które leży w przeglądarce?**

Nikt Ci o tym nie powie — ani vendor CMP (bo to nie ich problem), ani Google (bo Consent Mode "działa zgodnie z dokumentacją"), ani Twój zespół analytics (bo w raportach tego nie widać).

Nie mów, że nikt Ci nie powiedział.

---

*Universal Consent Adapter — GTM Custom Template. Open source. Jeden tag. Consent na czas.*

*→ [GitHub](https://github.com/piotrlitwa/universal-consent-adapter)*
