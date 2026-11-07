// Molt's website: download link, English and Turkish, entrances and the hero's small animations.

// The one place to change where every Download button points.
const DOWNLOAD_URL = "https://github.com/omerayyildiz/Molt/releases/latest/download/Molt.dmg";

const TURKISH = {
  "nav.features": "Özellikler",
  "nav.pricing": "Fiyat",
  "nav.download": "İndir",
  "hero.title": "Kodunun geride bıraktığı dağınıklığı temizle.",
  "hero.lead": "Molt; node_modules klasörlerini, Xcode önbelleklerini, paket indirmelerini ve yeniden oluşturulabilen diğer dosyaları bulur. Hiçbir şey silinmeden önce her birinin ne olduğunu görürsün.",
  "hero.download": "Mac için indir",
  "hero.github": "GitHub'da incele",
  "hero.note": "Ücretsiz ve açık kaynak · macOS 15 ve sonrası",
  "widget.label": "Boşaltılabilir",
  "widget.largest": "En büyük öğe",
  "widget.scan": "Tara",
  "widget.clean": "Temizle",
  "widget.cleaning": "node_modules temizleniyor",
  "widget.left": "2,1 GB · 3 sn kaldı",
  "tools.label": "Kullandığın araçları tanır",
  "know.title": "Neyi sildiğini bil.",
  "know.text": "Her öğe ne olduğunu, en son ne zaman değiştiğini ve nasıl geri geldiğini gösterir. Sen seçmeden hiçbir şey işaretlenmez.",
  "trust.safe": "Güvenli",
  "trust.safe.text": "Kendiliğinden yeniden oluşur.",
  "trust.caution": "Dikkat",
  "trust.caution.text": "Gerektiğinde yeniden indirilir.",
  "trust.risky": "Riskli",
  "trust.risky.text": "Yeniden oluşmaz, bu yüzden Çöp Sepeti'ne taşınır.",
  "shot.xcode": "Molt, Xcode dosyalarını güven seviyesi, tarih ve boyutlarıyla listeliyor",
  "bento.title": "Geliştiricilerin Mac'i için.",
  "bento.text": "Molt, araçlarının dosyalarını nerede tuttuğunu bilir; başka hiçbir şeye dokunmaz.",
  "projects.title": "Unutulan projeleri bul",
  "projects.text": "Aylardır dokunmadığın bağımlılıkları yaşa göre filtreleyerek bul.",
  "projects.filter": "3 aydan eski",
  "stats.rules": "temizlik kuralı",
  "stats.bytes": "dışarı gönderilen bayt",
  "stats.trust": "güven seviyesi",
  "mascot.title": "Molt'la tanış",
  "mascot.text": "Ağır kabuğunu hafif bir kabukla değiştiren bir keşiş yengeci. Mac'in de aynısını yapabilir.",
  "private.title": "Varsayılan olarak gizli",
  "private.text": "Hesap yok, analitik yok, internet bağlantısı yok.",
  "open.title": "Açık kaynak",
  "open.text": "Her kural okunabilir bir Swift kodu ve GPL-3.0 lisanslı.",
  "overview.title": "Diskini neyin doldurduğunu gör.",
  "overview.text": "Genel bakış, Mac'inin depolama alanını Sistem Ayarları'ndaki gibi kategorilere ayırır. Her kategoriden sıralayıp filtreleyebileceğin ve temizleyebileceğin bir listeye geçersin.",
  "shot.overview": "Molt'un genel bakışı: kategorilere ayrılmış disk",
  "pricing.title": "Kullanması ücretsiz. Desteklemesi senden.",
  "plan.free.name": "Doğrudan indirme",
  "plan.free.price": "Ücretsiz",
  "plan.free.text": "Geliştirici araçları gerektirenler dahil 34 kuralın tamamı.",
  "plan.free.button": "Molt'u indir",
  "plan.store.price": "2,99 $",
  "plan.store.text": "Otomatik güncellenir; satın alman geliştirmeyi destekler. App Store sandbox'ı nedeniyle daha az klasöre erişir.",
  "plan.store.button": "Yakında",
  "closing.title": "Mac'ine biraz nefes aldır.",
  "closing.button": "Ücretsiz indir",
  "closing.alt": "Kutular ve kablolarla dolu eski kabuğunu bırakıp hafif yeni kabuğuna geçen keşiş yengeci Molt",
  "footer.privacy": "Gizlilik",
  "footer.support": "Destek",
};

const reducesMotion = matchMedia("(prefers-reduced-motion: reduce)").matches;
const originals = new Map();

function translate(element, attribute, key, language) {
  const id = `${attribute}:${key}`;
  if (!originals.has(element)) originals.set(element, new Map());
  const saved = originals.get(element);
  if (!saved.has(id)) saved.set(id, attribute === "text" ? element.textContent : element.alt);
  const value = language === "tr" && TURKISH[key] ? TURKISH[key] : saved.get(id);
  if (attribute === "text") element.textContent = value; else element.alt = value;
}

function setLanguage(language) {
  document.documentElement.lang = language;
  document.querySelectorAll("[data-i18n]").forEach((el) => translate(el, "text", el.dataset.i18n, language));
  document.querySelectorAll("[data-i18n-alt]").forEach((el) => translate(el, "alt", el.dataset.i18nAlt, language));
  document.querySelectorAll("[data-shot]").forEach((img) => { img.src = `/assets/${img.dataset.shot}-${language}.webp`; });
  document.querySelectorAll("[data-count]").forEach((el) => { el.textContent = formatNumber(Number(el.dataset.count), language); });
  const toggle = document.querySelector(".language");
  if (toggle) toggle.textContent = language === "tr" ? "EN" : "TR";
  try { localStorage.setItem("language", language); } catch {}
}

function formatNumber(value, language) {
  return value.toLocaleString(language === "tr" ? "tr-TR" : "en-US", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
}

function startingLanguage() {
  try {
    const saved = localStorage.getItem("language");
    if (saved) return saved;
  } catch {}
  return navigator.language.toLowerCase().startsWith("tr") ? "tr" : "en";
}

// Counts the hero's number up from zero, once.
function countUp(element) {
  const target = Number(element.dataset.count);
  if (reducesMotion) return;
  const start = performance.now();
  const duration = 1600;
  const step = (now) => {
    const t = Math.min((now - start) / duration, 1);
    const eased = 1 - Math.pow(1 - t, 3);
    element.textContent = formatNumber(target * eased, document.documentElement.lang);
    if (t < 1) requestAnimationFrame(step);
  };
  requestAnimationFrame(step);
}

function revealOnScroll() {
  const items = document.querySelectorAll(".reveal");
  if (reducesMotion || !("IntersectionObserver" in window)) {
    items.forEach((item) => item.classList.add("visible"));
    return;
  }
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add("visible");
      entry.target.querySelectorAll("[data-count]").forEach(countUp);
      observer.unobserve(entry.target);
    });
  }, { threshold: 0.12, rootMargin: "0px 0px -40px 0px" });
  items.forEach((item) => observer.observe(item));
}

// The tools strip scrolls forever: a second copy of the list follows the first.
function loopMarquee() {
  const track = document.querySelector(".marquee-track");
  if (!track) return;
  track.innerHTML += track.innerHTML;
  [...track.children].slice(track.children.length / 2).forEach((item) => item.setAttribute("aria-hidden", "true"));
}

document.querySelectorAll("[data-download]").forEach((link) => { link.href = DOWNLOAD_URL; });
document.querySelector(".language")?.addEventListener("click", () => {
  setLanguage(document.documentElement.lang === "tr" ? "en" : "tr");
});
loopMarquee();
setLanguage(startingLanguage());
revealOnScroll();
