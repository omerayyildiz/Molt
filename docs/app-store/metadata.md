# App Store Connect: Molt 1.0

Everything App Store Connect asks for, ready to paste. Screenshots: run `scripts/screenshots.sh`, then
`swift scripts/app-store-art.swift`; upload `build/app-store-screenshots/en` and `.../tr` (2880 × 1800).

## App Information

| Field | Value |
|---|---|
| Name | Molt (if taken: Molt: Developer Cleaner) |
| Bundle ID | miedinger.Molt |
| SKU | molt-macos |
| Primary category | Utilities |
| Secondary category | Developer Tools |
| Content rights | Does not use third-party content |
| Age rating | 4+ (answer "None" to every question) |
| Copyright | 2026 Ömer Ayyıldız |
| Price | USD 2.99 |

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

**Name**: Molt

**Subtitle** (30): Geliştirici çöpünü temizle

**Promotional text**: Molt, geliştiricilerin biriktirdiği yeniden oluşturulabilir dosyaları bulur; node_modules'tan Xcode'un Derived Data'sına kadar her birini açıklar ve yalnızca işaretlediğini siler.

**Keywords** (100): node_modules,xcode,önbellek,temizleyici,disk,depolama,geliştirici,simülatör,npm,homebrew,yer aç

**Description:**

```
Molt, bir geliştiricinin Mac'ini sessizce dolduran ve yeniden oluşturulabilen dosyaları bulur: unuttuğun node_modules klasörleri, Xcode'un Derived Data'sı ve cihaz desteği dosyaları, simülatör önbellekleri, npm ve Homebrew indirmeleri, Python ortamları, yerel yapay zekâ modelleri, uygulama önbellekleri ve kayıtlar.

Her öğe ne olduğunu, silmenin ne kadar güvenli olduğunu ve nasıl geri geldiğini söyler. Sen işaretlemeden hiçbir şey seçili değildir.

GÜVENEBİLECEĞİN BİR TEMİZLEYİCİ
• Yalnızca yeniden oluşan dosyalar: Molt'un neye dokunabileceğine sabit bir kural listesi karar verir. Belgeler, fotoğraflar, ayarlar, e-posta ve iCloud dosyaları bu listede asla yoktur.
• Üç güven seviyesi: Güvenli (kendiliğinden ya da bir sonraki build'le geri gelir), Dikkat (yeniden indirilerek geri gelir) ve Riskli (geri gelmez, bu yüzden silinmek yerine Çöp Sepeti'ne gider).
• Her öğe silinmeden hemen önce yeniden kontrol edilir.
• Hesap yok, analitik yok, internet bağlantısı yok.

DİSKİNİ SİSTEM AYARLARI GİBİ GÖR
• Genel bakış diski kategorilere böler; "Sistem Verileri"nin neden oluştuğunu görürsün.
• Aylardır açmadığın projeleri bulmak için güvene ya da yaşa göre filtrele.
• Boyuta ya da tarihe göre sırala, toplu işaretle, saklamak istediğin klasörleri bir daha gösterme.

KEŞİŞ YENGECİ MOLT
Ağır kabuğunu bırakıp hafif bir kabuğa geçen keşiş yengeci gibi, Molt da Mac'inin artık ihtiyacı olmayanı bırakmasına yardım eder.

Molt, GPL-3.0 lisanslı açık kaynak bir yazılımdır. İlk açılışta, taradığı tek klasör olan ev klasörüne erişim için bir kez izin ister.
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
