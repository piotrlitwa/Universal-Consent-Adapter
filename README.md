# Universal Consent Adapter — GTM Template

Auto-detects your CMP, reads consent from cookies **instantly** (before CMP JavaScript loads), and maps it to **Google Consent Mode v2**. Ensures no tag fires before consent is set.

## Supported CMPs (10)

| CMP | Cookie Read | JS API | dataLayer Hook |
|-----|:-----------:|:------:|:--------------:|
| OneTrust | ✓ | ✓ | ✓ |
| Cookiebot | ✓ | ✓ | ✓ |
| CookieYes | ✓ | — | ✓ |
| Usercentrics | ✓ | — | ✓ |
| Borlabs Cookie | ✓ | ✓ | ✓ |
| Complianz | ✓ | — | ✓ |
| Axeptio | ✓ | — | ✓ |
| TrustArc | ✓ | ✓ | ✓ |
| Didomi | ✓ | — | ✓ |
| Klaro | ✓ | — | ✓ |

## How It Works

```
Layer 0  →  Read CMP cookie instantly (Consent Initialization, before CMP JS loads)
Layer 1  →  Set default consent (all denied + wait_for_update)
Layer 2  →  JS API callbacks for real-time consent changes
Layer 3  →  dataLayer.push hook — intercepts CMP events, zero CPU when idle
```

1. **Consent Initialization**: UCA reads the CMP cookie before the CMP's JavaScript even loads. If the user previously consented, tags get `granted` immediately — no waiting.
2. **Default denied**: If no cookie exists (first visit), all consent types default to `denied`.
3. **Real-time updates**: When the user interacts with the consent banner, UCA detects changes via JS API callbacks and `dataLayer.push` hook, then calls `gtag('consent', 'update', ...)`.
4. **Hash comparison**: Prevents duplicate consent updates — only fires when consent actually changes.

## Features

- **Google Consent Mode v2** — all 6 consent types: `analytics_storage`, `ad_storage`, `ad_user_data`, `ad_personalization`, `functionality_storage`, `personalization_storage`
- **Microsoft Consent Mode** — Clarity (`consentv2`) + Bing UET (`uetq`) support (optional checkbox)
- **Auto-detect** or manually select your CMP
- **Custom category mapping** — override default CMP-to-consent mapping via parameter table
- **Region-specific defaults** — ISO 3166-2 region codes
- **`ads_data_redaction`** and **`url_passthrough`** support
- **Debug mode** — detailed logging in GTM Preview console
- **dataLayer events** — optional `uca_consent_default` / `uca_consent_update` events

## Installation

1. In GTM, go to **Templates** → **Search Gallery** (or import manually)
2. Add the template and create a new tag
3. Set trigger to **Consent Initialization - All Pages**
4. Select your CMP (or leave Auto-detect)
5. Configure options as needed
6. Publish

## Configuration

| Setting | Default | Description |
|---------|---------|-------------|
| CMP | Auto-detect | Select CMP or let UCA detect it |
| Default consent | All denied | Initial state before cookie/API read |
| Region | (empty) | ISO 3166-2 codes for region-specific defaults |
| ads_data_redaction | Off | Redact ad click IDs when ad_storage is denied |
| url_passthrough | Off | Pass ad click info through URL parameters |
| Microsoft Consent Mode | Off | Send consent to Clarity + Bing UET |
| Push dataLayer events | Off | Fire uca_consent_default / uca_consent_update |
| Debug mode | Off | Console logging in GTM Preview |

## Why Not Use Native CMP Templates?

Native CMP templates (provided by OneTrust, Cookiebot, etc.) have a critical flaw: they wait for the CMP's JavaScript to load before setting consent. This creates a **timing gap** where tags can fire without consent, or `gtag('consent', 'default')` arrives too late.

UCA solves this by reading cookies at Consent Initialization — before any JavaScript loads.

## License

Apache License 2.0 — see [LICENSE](LICENSE)

## Author

**Piotr Litwa** — Web Analyst
