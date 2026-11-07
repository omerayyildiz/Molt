// Molt's website: download link, English and Turkish, bubbles and scroll reveals.

// The one place to change where the Download buttons point.
const DOWNLOAD_URL = "https://github.com/omerayyildiz/Molt/releases/latest/download/Molt.dmg";

const TURKISH = {
  "nav.features": "Özellikler",
  "nav.cleans": "Neleri temizler",
  "nav.source": "Kaynak kod",
  "nav.download": "İndir",
  "hero.eyebrow": "Ücretsiz ve açık kaynak · macOS 15+",
  "hero.title": "Mac'inin artık ihtiyacı olmayanı at.",
  "hero.lead": "Unuttuğun node_modules klasörleri, Xcode'un Derived Data'sı, simülatör önbellekleri, npm ve Homebrew indirmeleri, eski iOS yükleyicileri. Molt hepsini bulur, her birini açıklar ve yalnızca işaretlediğini siler.",
  "hero.download": "Mac için indir",
  "hero.appstore": "Mac App Store · $2.99",
  "hero.fineprint": "Apple tarafından imzalı ve onaylı · Apple silicon ve Intel · Hesap yok, takip yok",
  "hero.alt": "Kutular ve kablolarla dolu eski kabuğunu bırakıp hafif yeni kabuğuna geçen keşiş yengeci Molt",
  "shot.overview": "Molt'un genel bakışı: Sistem Ayarları'ndaki gibi kategorilere bölünmüş disk",
  "shot.xcode": "Güven seviyesi, tarih ve boyutlarıyla Xcode öğeleri",
  "shot.done": "Temizlikten sonra yengeç 3,4 GB boşalmasını kutluyor",
  "features.title": "Güvenebileceğin bir temizleyici",
  "features.explain.title": "Her öğeyi açıklar",
  "features.explain.text": "Ne olduğunu, silmenin ne kadar güvenli olduğunu ve nasıl geri geldiğini söyler. Sen işaretlemeden hiçbir şey seçili değildir.",
  "features.rebuildable.title": "Yalnızca yeniden oluşan dosyalar",
  "features.rebuildable.text": "Molt'un neye dokunabileceğine sabit bir kural listesi karar verir. Belgeler, fotoğraflar, ayarlar, e-posta ve iCloud bu listede asla yoktur.",
  "features.safe.title": "Güvenli tasarım",
  "features.safe.text": "Her öğe silinmeden hemen önce yeniden kontrol edilir. Geri gelmeyen dosyalar Çöp Sepeti'ne gider. Asla yönetici parolası istemez.",
  "features.private.title": "Gizli ve açık",
  "features.private.text": "Hesap yok, analitik yok, internet bağlantısı yok. Her kural GitHub'da GPL lisansıyla okunabilir Swift kodudur.",
  "explain.title": "Gitmeden önce ne olduğunu gör",
  "explain.text": "Her kategori öğelerini güven seviyesi, son değişiklik tarihi ve kapladığı alanla listeler. Aylardır açmadığın projeleri bulmak için güvene ya da yaşa göre filtrele.",
  "trust.safe": "Güvenli",
  "trust.safe.text": "Kendiliğinden ya da bir sonraki build'le geri gelir.",
  "trust.caution": "Dikkat",
  "trust.caution.text": "Yeniden indirilerek ya da kurularak geri gelir.",
  "trust.risky": "Riskli",
  "trust.risky.text": "Geri gelmez, bu yüzden Çöp Sepeti'ne gider.",
  "cleans.title": "Molt neleri temizler",
  "cleans.lead": "Her biri tek bir tür yeniden oluşturulabilir dosya için yazılmış 34 kural.",
  "chip.archives": "Xcode arşivleri",
  "chip.simulators": "Simülatör önbellekleri",
  "chip.ipsw": "iOS yükleyicileri",
  "chip.backups": "Cihaz yedekleri",
  "chip.appcaches": "Uygulama önbellekleri",
  "chip.logs": "Kayıtlar",
  "done.title": "Yerin geri geldiğini hisset",
  "done.text": "Tek tıkla temizle, öğelerin listeden çıktığını izle. Molt sildiği her şeyin geçmişini tutar; ne kadar yer açtığını hep bilirsin.",
  "editions.title": "Molt'u almanın iki yolu",
  "editions.free.title": "Doğrudan indirme",
  "editions.free.price": "Ücretsiz",
  "editions.free.text": "Geliştirici araçları gerektirenler dahil bütün kurallar. Apple tarafından imzalı ve onaylı.",
  "editions.free.button": "Molt.dmg'yi indir",
  "editions.store.title": "Mac App Store",
  "editions.store.text": "Apple'ın sandbox'ında çalışır, otomatik güncellenir. Satın almak Molt'a destek olmanın bir yolu; ücretsiz sürüm daha fazlasını yapar.",
  "editions.store.button": "Yakında",
  "cta.title": "Mac'in, biraz daha hafif.",
  "cta.button": "Molt'u ücretsiz indir",
  "footer.license": "GPL-3.0 lisanslı özgür yazılım",
  "footer.privacy": "Gizlilik",
  "footer.support": "Destek",
};

const englishText = new Map();
const englishAlt = new Map();

function setLanguage(language) {
  document.documentElement.lang = language;
  document.querySelectorAll("[data-i18n]").forEach((element) => {
    if (!englishText.has(element)) englishText.set(element, element.textContent);
    const key = element.dataset.i18n;
    element.textContent = language === "tr" && TURKISH[key] ? TURKISH[key] : englishText.get(element);
  });
  document.querySelectorAll("[data-i18n-alt]").forEach((image) => {
    if (!englishAlt.has(image)) englishAlt.set(image, image.alt);
    const key = image.dataset.i18nAlt;
    image.alt = language === "tr" && TURKISH[key] ? TURKISH[key] : englishAlt.get(image);
  });
  document.querySelectorAll("[data-shot]").forEach((image) => {
    image.src = `/assets/${image.dataset.shot}-${language}.webp`;
  });
  const toggle = document.querySelector(".language");
  if (toggle) toggle.textContent = language === "tr" ? "EN" : "TR";
  try { localStorage.setItem("language", language); } catch {}
}

function savedLanguage() {
  try {
    const saved = localStorage.getItem("language");
    if (saved) return saved;
  } catch {}
  return navigator.language.toLowerCase().startsWith("tr") ? "tr" : "en";
}

function addBubbles() {
  const layer = document.querySelector(".bubbles");
  if (!layer || matchMedia("(prefers-reduced-motion: reduce)").matches) return;
  for (let i = 0; i < 18; i++) {
    const bubble = document.createElement("span");
    const size = 6 + Math.random() * 22;
    bubble.style.width = bubble.style.height = `${size}px`;
    bubble.style.left = `${Math.random() * 100}%`;
    bubble.style.animationDuration = `${12 + Math.random() * 16}s`;
    bubble.style.animationDelay = `${-Math.random() * 20}s`;
    bubble.style.setProperty("--drift", `${(Math.random() - 0.5) * 120}px`);
    layer.appendChild(bubble);
  }
}

function revealOnScroll() {
  const items = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window)) {
    items.forEach((item) => item.classList.add("visible"));
    return;
  }
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });
  items.forEach((item) => observer.observe(item));
}

document.querySelectorAll("[data-download]").forEach((link) => { link.href = DOWNLOAD_URL; });
document.querySelector(".language")?.addEventListener("click", () => {
  setLanguage(document.documentElement.lang === "tr" ? "en" : "tr");
});
setLanguage(savedLanguage());
addBubbles();
revealOnScroll();
