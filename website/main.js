// Molt's website: download link, English and Turkish, entrances and the hero's cleaning demo.

// The one place to change where every Download button points.
const DOWNLOAD_URL = "https://github.com/omerayyildiz/Molt/releases/latest/download/Molt.dmg";

const TURKISH = {
  "nav.how": "Nasıl çalışır",
  "nav.finds": "Neleri bulur",
  "skip": "İçeriğe geç",
  "nav.versions": "Sürümler",
  "nav.download": "İndir",
  "hero.title": "Kodunun geride bıraktığı dağınıklığı temizle.",
  "hero.lead": "node_modules klasörleri, Xcode build verileri, paket önbellekleri ve yapay zekâ modelleri sessizce birikir. Molt bunları bulur, her birini açıklar ve yalnızca seçtiklerini siler.",
  "hero.download": "Mac için indir",
  "hero.github": "GitHub'da incele",
  "hero.note": "Ücretsiz ve açık kaynak · macOS 15 ve sonrası",
  "demo.free": "boş",
  "demo.models": "Hugging Face modelleri",
  "demo.simulators": "Simülatör önbellekleri",
  "demo.done": "Tertemiz",
  "demo.empty": "Temizlenecek bir şey kalmadı",
  "trust.safe": "Güvenli",
  "trust.caution": "Dikkat",
  "trust.risky": "Riskli",
  "problem.title": "Mac'in, Finder'ın bakmadığı yerlerde dolar.",
  "problem.text": "Geliştirici araçları önbelleklerini ve build dosyalarını gizli klasörlerde tutar. macOS bunları Sistem Verileri altında toplar; neyin silinebileceğini göremezsin.",
  "fact.node.title": "node_modules klasörü başına",
  "fact.node.text": "Her proje bağımlılıklarının kendi kopyasını tutar; bir yıldır açmadığın projeler de dahil.",
  "fact.xcode.title": "yoğun bir Mac'te Xcode verisi",
  "fact.xcode.text": "DerivedData ve cihaz desteği, derlediğin her projeyle ve bağladığın her iOS sürümüyle büyür.",
  "fact.ai.title": "yerel yapay zekâ modeli başına",
  "fact.ai.text": "Ollama, LM Studio ve Hugging Face, sen silene kadar indirdiğin her modeli saklar.",
  "how.title": "Üç adım. Tahmin yok.",
  "step.scan.title": "Tara",
  "step.scan.text": "Molt yalnızca geliştirici araçlarının dosya tuttuğu yerlere bakar. Tarama birkaç saniye sürer.",
  "cat.projects": "Projeler",
  "cat.ai": "Yapay zekâ modelleri",
  "step.review.title": "İncele",
  "step.review.text": "Her öğe ne olduğunu, boyutunu, en son ne zaman değiştiğini ve nasıl geri getirileceğini gösterir.",
  "step.review.what": "Bir JavaScript projesi için kurulmuş paketler.",
  "step.review.back": "npm install ile geri gelir",
  "step.clean.title": "Temizle",
  "step.clean.text": "İşaretlediklerini sil. Yeniden oluşturulamayan her şey önce Çöp Sepeti'ne gider.",
  "step.clean.freed": "14,2 GB boşaltıldı",
  "finds.title": "Dağınıklığın nerede olduğunu bilir.",
  "finds.text": "Her biri tek bir dosya türü için yazılmış 30'dan fazla kural. Her kural, dosyanın nasıl geri geldiğini söyler.",
  "cat.xcode.back": "Bir sonraki build'de yeniden oluşur. Arşivler Çöp Sepeti'ne gider.",
  "cat.dependencies": "Proje bağımlılıkları",
  "cat.dependencies.back": "npm install, pip install ya da bir build ile geri gelir.",
  "cat.packages": "Paket önbellekleri",
  "cat.packages.back": "Bir sonraki kurulumda yeniden iner.",
  "cat.ai.back": "Modeli, onu kullanan uygulamadan yeniden indirebilirsin.",
  "cat.simulators": "Simülatörler",
  "cat.simulators.back": "Simülatör ihtiyacı olanı yeniden oluşturur.",
  "cat.devices": "iPhone ve iPad",
  "cat.devices.ex1": "iOS yükleyicileri",
  "cat.devices.ex2": "cihaz yedekleri",
  "cat.devices.back": "Yükleyiciler yeniden iner. Yedekler Çöp Sepeti'ne gider.",
  "cat.apps": "Uygulama önbellekleri",
  "cat.apps.back": "Uygulamalar ihtiyaç duydukça yeniden oluşturur.",
  "cat.logs": "Kayıtlar",
  "cat.logs.back": "Uygulamalar yenilerini yazar. Eski kayıtlara gerek yoktur.",
  "safety.title": "Güvenlik baştan düşünüldü.",
  "safety.text": "Molt yalnızca kurallarının tanımladığı dosyaları silebilir. Geri kalan her şey dokunulmazdır.",
  "safety.1": "Belgeler'e, Fotoğraflar'a, Mail'e, Mesajlar'a, iCloud'a ve anahtar zincirine asla dokunmaz.",
  "safety.2": "Her dosyayı silmeden hemen önce yeniden kontrol eder.",
  "safety.3": "Yönetici parolası istemez ve ev klasörünün dışına çıkmaz.",
  "safety.4": "Sen seçmeden hiçbir şey seçili olmaz.",
  "level.safe.title": "Kendiliğinden yeniden oluşur",
  "level.safe.text": "Kalıcı olarak silinir. Bir sonraki build ya da açılışta geri gelir.",
  "level.caution.title": "Yeniden indirilir",
  "level.caution.text": "Kalıcı olarak silinir. Yeniden kurmak biraz zaman ve internet bağlantısı ister.",
  "level.risky.title": "Yeniden oluşturulamaz",
  "level.risky.text": "Çöp Sepeti'ne taşınır; fikrini değiştirebilirsin.",
  "app.title": "Diskine net bir bakış.",
  "app.text": "Genel bakış, depolama alanını Sistem Ayarları'ndaki gibi kategorilere ayırır. Bir kategoriyi açıp sıralayabilir, filtreleyebilir ve temizleyebilirsin.",
  "shot.overview": "Molt'un genel bakışı: kategorilere ayrılmış disk",
  "shot.projects": "Güven seviyesi, tarih ve boyutlarıyla proje klasörleri",
  "app.1": "Eski projeleri yaşa göre filtrele",
  "app.2": "Saklamak istediğin klasörleri gizle",
  "app.3": "Zaman içinde ne kadar yer açtığını gör",
  "app.4": "Türkçe ve İngilizce",
  "privacy.title": "Hesap yok. Takip yok. İnternet yok.",
  "privacy.text": "Molt internete hiç bağlanmaz. Dosyalarının listesi Mac'inde kalır.",
  "source.title": "Açık kaynak",
  "source.text": "Her kural GitHub'da okuyabileceğin bir Swift kodu ve GPL-3.0 lisanslı.",
  "source.link": "Kuralları incele",
  "versions.title": "İki yol da ücretsiz.",
  "plan.free.name": "Doğrudan indirme",
  "plan.free.price": "Ücretsiz",
  "plan.free.text": "Geliştirici araçları gerektirenler dahil bütün kurallar.",
  "plan.free.button": "Molt'u indir",
  "plan.store.text": "Tek tıkla kurulur, kendiliğinden güncellenir ve Apple'ın sandbox ortamında çalışır.",
  "plan.store.button": "Yakında",
  "faq.title": "Sık sorulanlar",
  "faq.1.q": "node_modules klasörünü silmek güvenli mi?",
  "faq.1.a": "Evet. Bir sonraki npm install, pnpm install, yarn ya da bun install komutunda package.json'dan yeniden kurulur. Yeniden kurulum biraz zaman ve internet bağlantısı gerektirdiği için Molt bunu Dikkat olarak işaretler.",
  "faq.2.q": "Molt neden Belgeler klasörümü taramıyor?",
  "faq.2.a": "macOS, bir uygulama Masaüstü, Belgeler ya da İndirilenler'i okumadan önce izin ister. Molt, Ayarlar'dan bir proje klasörü eklemediğin sürece bu klasörleri atlar; böylece beklenmedik bir izin penceresiyle karşılaşmazsın.",
  "faq.3.q": "App Store sürümünün farkı ne?",
  "faq.3.a": "Apple'ın sandbox'ında çalışır. Bu ortam diğer uygulamaların önbelleklerinin çoğunu gizler ve geliştirici araçlarının çalışmasına izin vermez. Doğrudan indirilen sürümde bütün kurallar vardır.",
  "faq.4.q": "Molt herhangi bir veri gönderiyor mu?",
  "faq.4.a": "Hayır. Molt'ta analitik yok ve internete hiç istek göndermez. Temizlik geçmişin Mac'inde kalır.",
  "closing.title": "Mac'ine biraz nefes aldır.",
  "closing.button": "Ücretsiz indir",
  "closing.alt": "Kutularla dolu eski kabuğunu bırakıp hafif yeni kabuğuna geçen keşiş yengeci Molt",
  "theme.toDark": "Koyu temaya geç",
  "theme.toLight": "Açık temaya geç",
  "footer.privacy": "Gizlilik",
  "footer.support": "Destek",
};

const reducesMotion = matchMedia("(prefers-reduced-motion: reduce)").matches;
const prefersDark = matchMedia("(prefers-color-scheme: dark)");

// The theme the page shows: the one chosen with the switch, otherwise the system's.
const theme = () => document.documentElement.dataset.theme || (prefersDark.matches ? "dark" : "light");
const originals = new WeakMap();
const language = () => document.documentElement.lang;

function gigabytes(value, digits = 1) {
  return value.toLocaleString(language() === "tr" ? "tr-TR" : "en-US", { minimumFractionDigits: digits, maximumFractionDigits: digits });
}

function translate(element, attribute, key) {
  if (!originals.has(element)) originals.set(element, {});
  const saved = originals.get(element);
  if (!(attribute in saved)) saved[attribute] = attribute === "text" ? element.textContent : element.alt;
  const value = language() === "tr" && TURKISH[key] ? TURKISH[key] : saved[attribute];
  if (attribute === "text") element.textContent = value; else element.alt = value;
}

function setLanguage(next) {
  document.documentElement.lang = next;
  document.querySelectorAll("[data-i18n]").forEach((el) => translate(el, "text", el.dataset.i18n));
  document.querySelectorAll("[data-i18n-alt]").forEach((el) => translate(el, "alt", el.dataset.i18nAlt));
  showScreens();
  document.querySelectorAll("[data-gb]").forEach((el) => { el.textContent = `${gigabytes(Number(el.dataset.gb))} GB`; });
  const toggle = document.querySelector(".language");
  if (toggle) toggle.textContent = next === "tr" ? "EN" : "TR";
  labelThemeSwitch();
  demo?.render();
  try { localStorage.setItem("language", next); } catch {}
}

function showScreens() {
  document.querySelectorAll("[data-shot]").forEach((img) => {
    img.src = `/assets/${img.dataset.shot}-${language()}-${theme()}.webp`;
  });
  document.querySelector('meta[name="theme-color"]')?.setAttribute("content", theme() === "dark" ? "#0B0D11" : "#EEF0F3");
}

function labelThemeSwitch() {
  const toggle = document.querySelector(".theme-toggle");
  if (!toggle) return;
  const key = theme() === "dark" ? "theme.toLight" : "theme.toDark";
  toggle.setAttribute("aria-label", language() === "tr" ? TURKISH[key] : key === "theme.toDark" ? "Switch to dark theme" : "Switch to light theme");
}

function switchTheme() {
  const next = theme() === "dark" ? "light" : "dark";
  document.documentElement.dataset.theme = next;
  try { localStorage.setItem("theme", next); } catch {}
  showScreens();
  labelThemeSwitch();
}

function startingLanguage() {
  try {
    const saved = localStorage.getItem("language");
    if (saved) return saved;
  } catch {}
  return navigator.language.toLowerCase().startsWith("tr") ? "tr" : "en";
}

// The hero's miniature Molt: checks four items, cleans them, shows the freed space, then starts over.
const demo = (() => {
  const root = document.querySelector(".demo");
  if (!root) return null;
  const rows = [...root.querySelectorAll(".demo-row")];
  const sizes = rows.map((row) => Number(row.dataset.size));
  const total = sizes.reduce((a, b) => a + b, 0);
  const free = root.querySelector("[data-demo-free]");
  const count = root.querySelector("[data-demo-count]");
  const clean = root.querySelector("[data-demo-clean]");
  const freed = root.querySelector("[data-demo-freed]");
  const startFree = 18;
  const state = { checked: 0, free: startFree };
  let visible = false;

  const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
  const whileHidden = async () => { while (!visible) await wait(250); };

  function render() {
    const n = state.checked;
    const selected = sizes.slice(0, n).reduce((a, b) => a + b, 0);
    rows.forEach((row, i) => row.classList.toggle("is-checked", i < n));
    if (language() === "tr") {
      count.textContent = n === 0 ? "Seçili öğe yok" : `${n} öğe seçili`;
      clean.textContent = n === 0 ? "Temizle" : `${gigabytes(selected)} GB temizle`;
      freed.textContent = `${gigabytes(total)} GB boşaltıldı`;
    } else {
      count.textContent = n === 0 ? "Nothing selected" : `${n} ${n === 1 ? "item" : "items"} selected`;
      clean.textContent = n === 0 ? "Clean" : `Clean ${gigabytes(selected)} GB`;
      freed.textContent = `${gigabytes(total)} GB freed`;
    }
    clean.setAttribute("aria-disabled", String(n === 0));
    free.textContent = gigabytes(state.free);
  }

  function countFree(from, to, duration) {
    return new Promise((resolve) => {
      const start = performance.now();
      const step = (now) => {
        const t = Math.min((now - start) / duration, 1);
        state.free = from + (to - from) * (1 - Math.pow(1 - t, 3));
        free.textContent = gigabytes(state.free);
        if (t < 1) requestAnimationFrame(step); else resolve();
      };
      requestAnimationFrame(step);
    });
  }

  async function loop() {
    for (;;) {
      await whileHidden();
      state.checked = 0;
      state.free = startFree;
      root.classList.remove("is-clean", "is-done");
      render();
      await wait(1100);
      for (let i = 1; i <= rows.length; i++) {
        state.checked = i;
        render();
        await wait(520);
      }
      await wait(450);
      clean.classList.add("is-pressed");
      await wait(160);
      clean.classList.remove("is-pressed");
      root.classList.add("is-clean");
      state.checked = 0;
      render();
      await countFree(startFree, startFree + total, 1100);
      root.classList.add("is-done");
      await wait(2800);
      root.classList.remove("is-done");
      await wait(500);
      root.classList.remove("is-clean");
      await countFree(state.free, startFree, 900);
    }
  }

  if (reducesMotion) {
    state.checked = rows.length;
  } else {
    new IntersectionObserver((entries) => { visible = entries[0].isIntersecting; }).observe(root);
    loop();
  }
  return { render };
})();

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
      observer.unobserve(entry.target);
    });
  }, { threshold: 0.1, rootMargin: "0px 0px -40px 0px" });
  items.forEach((item) => observer.observe(item));
}

document.querySelectorAll("[data-download]").forEach((link) => { link.href = DOWNLOAD_URL; });
document.querySelector(".language")?.addEventListener("click", () => setLanguage(language() === "tr" ? "en" : "tr"));
document.querySelector(".theme-toggle")?.addEventListener("click", switchTheme);
prefersDark.addEventListener("change", () => { showScreens(); labelThemeSwitch(); });
setLanguage(startingLanguage());
revealOnScroll();
