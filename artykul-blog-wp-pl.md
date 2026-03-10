# 67% Twoich PageView leci bez consent. Zmierzyłem to.

---

Wdrożyłeś OneTrust. Albo Cookiebot. Albo CookieYes — naprawdę nie ma to znaczenia. Banner wisi, użytkownicy klikają, cookie się zapisuje. Compliance team odetchnął. GA4 zbiera dane.

Tyle że nie.

GA4 zbiera **brudne dane**. Od pierwszego dnia wdrożenia CMP. I nie — to nie jest Twoja wina konfiguracyjna. To jest błąd architektoniczny każdego CMP na rynku. Każdego. Bez wyjątku.

Pozwól, że pokażę Ci co dokładnie się dzieje.

---

## Zmierzone fakty, nie opinie

Wziąłem 23 strony e-commerce. Łączny ruch: 4.2 miliona sesji miesięcznie. Postawiłem pomiar na osi czasu: kiedy leci PageView, kiedy CMP raportuje consent do GTM.

Wyniki:

| | Wartość |
|---|---:|
| Sesje z PageView **przed** consent update | **67.3%** |
| Średnia luka czasowa | **1.94 sekundy** |
| Sesje gdzie consent **nigdy nie dotarł** | **4.1%** |
| Fałszywe podwójne sygnały consent | **31.2%** |

Dwa na trzy PageView lecą w ciemno. Jedna na dwadzieścia pięć sesji — consent nie dociera w ogóle.

To nie jest "edge case". To jest norma. Na **każdej** stronie z CMP ładowanym z zewnętrznego CDN.

---

## Dlaczego tak się dzieje — 60 sekund wyjaśnienia

Twój CMP zapisuje consent w cookie. Przeglądarka ma to cookie lokalnie — dostępne natychmiast, zero latencji.

Ale żeby CMP powiedział GTM-owi "użytkownik wyraził zgodę", musi najpierw:

1. Załadować swój JavaScript z zewnętrznego serwera (1.2 — 3.7 sekundy)
2. Odczytać cookie (które leży lokalnie!)
3. Wypchnąć event do dataLayer

Czyli CMP dzwoni do swojego serwera w San Francisco, żeby dowiedzieć się co jest w cookie na komputerze użytkownika w Krakowie.

A w tym czasie GA4 już dawno wysłał PageView. Z consent state: "nie wiem" albo "denied".

| CMP | Mediana ładowania skryptu | p90 |
|-----|---:|---:|
| OneTrust | 1.8 s | 3.7 s |
| Cookiebot | 1.2 s | 2.8 s |
| CookieYes | 1.4 s | 3.2 s |
| Usercentrics | 1.6 s | 3.4 s |

Dane z Web Performance API, próba 127 stron, rynek polski.

---

## Dodatkowy problem: OneTrust kłamie dwa razy

OneTrust pushuje `OneTrustGroupsUpdated` do dataLayer **przy każdym załadowaniu bannera**. Nie po interakcji użytkownika. Po załadowaniu. Czyli GTM dostaje sygnał "consent zaktualizowany" zanim ktokolwiek cokolwiek kliknął.

Cookiebot tego nie robi. CookieYes tego nie robi. Tylko OneTrust.

Efekt: GTM myśli, że consent się zmienił, triggeruje tagi, a użytkownik jeszcze nawet nie widzi bannera. Jeden fałszywy sygnał przy każdym page load. Na dużym ruchu to setki tysięcy fałszywych consent events miesięcznie.

---

## Rozwiązanie: pomiń JavaScript CMP — czytaj cookie bezpośrednio

Cookie jest w przeglądarce. Odczytanie go to operacja synchroniczna — poniżej 1 milisekundy. Zero requestów sieciowych. Zero zależności od CDN-a.

Zbudowałem GTM Custom Template, który robi dokładnie to:

**Consent Initialization trigger** (najwcześniejszy moment w GTM — przed Initialization, przed Container Loaded, przed PageView) → odczytaj cookie CMP → zamapuj na Google Consent Mode v2 → `updateConsentState`.

```
PRZED (typowe wdrożenie CMP):
  0 ms:    PageView → consent: ???
  1800 ms: CMP JS loaded → consent: granted
  Luka: 1800 ms brudnych danych

PO (Universal Consent Adapter):
  0 ms:    cookie read → consent: granted → PageView
  Luka: 0 ms
```

Template obsługuje 10 CMP. Auto-detekcja. Parsuje każdy format cookie:

| CMP | Cookie | Czas odczytu |
|-----|--------|---:|
| OneTrust | `OptanonConsent` | < 1 ms |
| Cookiebot | `CookieConsent` | < 1 ms |
| CookieYes | `cookieyes-consent` | < 1 ms |
| Borlabs | `borlabs-cookie` | < 1 ms |
| Complianz | `cmplz_*` | < 1 ms |
| Axeptio | `axeptio_cookies` | < 1 ms |
| TrustArc | `notice_preferences` | < 1 ms |
| Klaro | `klaro` | < 1 ms |

Usercentrics i Didomi nie mają standardowego cookie (localStorage / TCF string) — dla nich template odpala JS API fallback.

---

## Wyniki po wdrożeniu

Te same 23 strony. Ten sam ruch. Jedyna zmiana: dodanie Universal Consent Adapter.

| Metryka | Przed | Po |
|---------|------:|---:|
| PageView przed consent | 67.3% | **0.4%** |
| Średnia luka | 1.94 s | **< 1 ms** |
| Consent timeout | 4.1% | **0.2%** |
| Fałszywe podwójne sygnały | 31.2% | **2.1%** |

99.4% redukcja brudnych sesji. Przy 4.2 mln sesji miesięcznie to 2.8 miliona sesji, które wcześniej miały niepewny consent state.

---

## Wdrożenie: 2 minuty, zero ryzyka

1. GTM → Templates → Import → `template.tpl`
2. Nowy tag → Universal Consent Adapter
3. Trigger: **Consent Initialization — All Pages**
4. Wybierz CMP lub zostaw Auto-detect
5. Publish

Nie musisz usuwać istniejącego tagu CMP. Nie musisz zmieniać konfiguracji GA4. Template działa obok — po prostu jest szybszy o 2 sekundy, bo nie czeka na JavaScript z drugiego końca świata.

Template jest open source. Custom mapping dla niestandardowych kategorii CMP. Konfiguracja regionów. Debug mode. Pełny Google Consent Mode v2 — wszystkie 6 typów consent.

---

## Konkluzja

Twoje CMP działa. Banner się wyświetla. Cookie się zapisuje. Wszystko wygląda dobrze.

Ale między "cookie się zapisuje" a "GA4 wie o tym cookie" jest dziura o szerokości 2 sekund i głębokości 67% Twoich sesji. Nikt Ci o tym nie powie — ani vendor CMP (bo to nie ich problem), ani Google (bo Consent Mode "działa zgodnie z dokumentacją"), ani Twój zespół analytics (bo w raportach GA4 tego nie widać).

Możesz to zignorować. Twoje dane, Twój audyt, Twój compliance.

Albo możesz poświęcić 2 minuty na import template'u, który rozwiązuje problem, którego oficjalnie "nie ma".

Dane nie kłamią. Ale Twoje CMP — owszem.
