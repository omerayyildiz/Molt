# App Store Connect: Molt 1.0

Everything App Store Connect asks for, ready to paste. Screenshots: run `scripts/screenshots.sh`, then
`swift scripts/app-store-art.swift`; upload `build/app-store-screenshots/en` and `.../tr` (2880 × 1800).

## App Information

| Field | Value |
|---|---|
| Name | Molt: Developer Cleaner ("Molt" is taken) |
| Bundle ID | miedinger.Molt |
| SKU | molt-macos |
| Primary category | Utilities |
| Secondary category | Developer Tools |
| Content rights | Does not use third-party content |
| Age rating | 4+ (answer "None" to every question) |
| Copyright | 2026 Ömer Ayyıldız |
| Price | Free |

## URLs

| Field | Value |
|---|---|
| Support URL | https://molt.omerayyildiz.com/support |
| Marketing URL | https://molt.omerayyildiz.com |
| Privacy Policy URL | https://molt.omerayyildiz.com/privacy |

## App Privacy

Data Not Collected. Molt has no tracking, no analytics and no network access; the privacy manifest
(`Molt/PrivacyInfo.xcprivacy`) says the same.

## English (U.S.)

**Subtitle** (30): Clear node_modules and caches

**Promotional text** (170): Molt finds the rebuildable files developers collect, from node_modules to Xcode's Derived Data, explains each one, and removes only what you check.

**Keywords** (100): node_modules,xcode,derived data,cache,cleaner,disk space,developer,simulator,npm,homebrew,storage

**Description:**

```
Molt finds the files that quietly fill a developer's Mac and can be rebuilt: node_modules you forgot about, Xcode's Derived Data and device support, simulator caches, npm and Homebrew downloads, Python environments, local AI models, app caches and logs.

Every item tells you what it is, how safe it is to remove and how it comes back. Nothing is checked until you check it.

A CLEANER YOU CAN TRUST
• Only rebuildable files: a fixed list of rules decides what Molt may touch. Documents, photos, settings, mail and iCloud files are never on it.
• Three trust levels: Safe (comes back by itself or with the next build), Caution (comes back by downloading again) and Risky (does not come back, so it goes to the Trash instead of being deleted).
• Every item is checked again right before removal.
• No account, no analytics, no network access.

SEE YOUR DISK LIKE SYSTEM SETTINGS
• An overview splits your disk by category, so you see what "System Data" is made of.
• Filter by trust level or age to find projects you have not opened in months.
• Sort by size or date, check items in bulk, and hide folders you want to keep for good.

MOLT THE HERMIT CRAB
Like a hermit crab leaving a heavy shell for a lighter one, Molt helps your Mac drop what it no longer needs.

Molt is open source under the GPL-3.0. On first launch it asks once for access to your home folder, the only folder it scans.
```

## Turkish

**Name** (30): Molt: Disk Temizleyici

**Subtitle** (30): Mac'ini hafiflet

**Promotional text** (170): Molt, node_modules klasörlerini, Xcode verilerini ve önbellekleri bulur. Her dosyanın ne olduğunu açıklar, yalnızca senin seçtiklerini siler.

**Keywords** (100): node_modules,xcode,derived data,önbellek,disk,depolama,simülatör,npm,homebrew,cache,temizlik

**Description:**

```
Molt, Mac'inde yer kaplayan geliştirici dosyalarını bulur. Unuttuğun node_modules klasörlerini, Xcode'un Derived Data verilerini, simülatör önbelleklerini, npm ve Homebrew indirmelerini, Python ortamlarını, yerel yapay zekâ modellerini, uygulama önbelleklerini ve kayıt dosyalarını tek ekranda gösterir.

Her öğenin ne olduğunu, silinince ne olacağını ve nasıl geri geleceğini açıklar. Sen seçmedikçe hiçbir şey silinmez.

GÜVENLE TEMİZLE
• Molt yalnızca yeniden oluşturulabilen dosyalara dokunur. Neleri silebileceğini sabit bir kural listesi belirler. Belgelerin, fotoğrafların, ayarların, e-postaların ve iCloud dosyaların bu listede yer almaz.
• Her öğenin bir güven seviyesi vardır. Güvenli öğeler kendiliğinden ya da bir sonraki derlemede geri gelir. Dikkat gerektiren öğeler yeniden indirilir. Riskli öğeler geri gelmez, bu yüzden silinmez ve Çöp Sepeti'ne taşınır.
• Molt her öğeyi silmeden hemen önce yeniden kontrol eder.
• Hesap açman gerekmez. Molt veri toplamaz ve internete bağlanmaz.

DİSKİNİ TANI
• Genel bakış ekranı diskini kategorilere ayırır. "Sistem Verileri"nin nelerden oluştuğunu görürsün.
• Güven seviyesine ya da yaşa göre filtreleyerek aylardır açmadığın projeleri bulabilirsin.
• Öğeleri boyuta ya da tarihe göre sıralayabilir, toplu seçebilir, saklamak istediklerini listeden kalıcı olarak çıkarabilirsin.

KEŞİŞ YENGECİ MOLT
Keşiş yengeci ağırlaşan kabuğunu bırakıp daha hafif bir kabuğa geçer. Molt da Mac'inin artık ihtiyaç duymadığı dosyalardan kurtulmasını sağlar.

Molt, GPL-3.0 lisanslı açık kaynak bir uygulamadır. İlk açılışta yalnızca ev klasörüne erişim izni ister ve yalnızca bu klasörü tarar.
```

## Notes for App Review

```
Molt removes rebuildable developer files (caches, build output, node_modules). It runs in the App Sandbox.

On first launch Molt shows an Open panel and asks the reviewer to choose their home folder and click Allow. This user-selected access (com.apple.security.files.user-selected.read-write with an app-scoped bookmark) is the only way Molt reads files; it scans only inside the home folder and never asks for Full Disk Access.

To try it: Xcode installs create ~/Library/Developer/Xcode/DerivedData. Open the Xcode category, check an item and click Clean. Items marked Risky (Xcode archives, device backups) are moved to the Trash, never deleted.

No account, sign-in or network access is needed.
```

## Upload

1. Create the app record: App Store Connect › Apps › + › New App (macOS, bundle ID miedinger.Molt).
2. `scripts/upload-app-store.sh` archives the App Store build and uploads it.
3. In the 1.0 version page: paste the texts above, add the screenshots, choose the build, set the price, submit.
