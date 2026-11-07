// Draws the Mac App Store screenshots in the website's style with SwiftUI: 2880 x 1800, English and Turkish.
// Needs the screens from scripts/screenshots.sh.
//
// Usage: swift scripts/app-store-art.swift
// Output: build/app-store-screenshots/<language>/<number>-<name>.png
import AppKit
import SwiftUI
import UniformTypeIdentifiers

let root = URL(filePath: CommandLine.arguments[0]).deletingLastPathComponent().deletingLastPathComponent()

// MARK: Copy

struct Copy {
    let language: String
    let decimalSeparator: String
    let overviewTitle, overviewText, allClean, freed: String
    let knowTitle, knowText, caution, safe, risky, nodeWhat, nodeBack: String
    let findsTitle, findsText: String
    let categories: [(name: String, symbol: String, color: Color, examples: [String], tags: [String])]
    let safetyTitle, safetyText: String
    let levels: [(tag: String, title: String, text: String)]
    let checks: [String]
}

let english = Copy(
    language: "en", decimalSeparator: ".",
    overviewTitle: "Clear the clutter your code leaves behind.",
    overviewText: "Molt finds caches, build files and dependencies you can rebuild.",
    allClean: "All clean", freed: "14.2 GB freed",
    knowTitle: "Know what you're removing.",
    knowText: "Every item shows what it is, when it last changed and how it comes back.",
    caution: "Caution", safe: "Safe", risky: "Risky",
    nodeWhat: "Packages installed for a JavaScript project.", nodeBack: "Comes back with npm install",
    findsTitle: "Knows where the clutter lives.",
    findsText: "More than 30 rules for Xcode, package managers, AI models and more.",
    categories: [
        ("Xcode", "hammer", .blue, ["DerivedData", "Device Support", "Archives"], ["Safe", "Risky"]),
        ("Project dependencies", "folder", .orange, ["node_modules", ".venv", "Pods", "target"], ["Safe", "Caution"]),
        ("Package caches", "shippingbox", .brown, ["npm", "pnpm", "Homebrew", "pip", "Cargo"], ["Safe"]),
        ("AI models", "brain", .purple, ["Ollama", "LM Studio", "Hugging Face"], ["Caution"]),
        ("Simulators", "iphone", .cyan, ["CoreSimulator caches"], ["Safe"]),
        ("iPhone and iPad", "ipad.and.iphone", .indigo, ["iOS installers", "backups"], ["Safe", "Risky"]),
        ("App caches", "app.dashed", .pink, ["~/Library/Caches"], ["Safe"]),
        ("Logs", "doc.text", .teal, ["~/Library/Logs"], ["Safe"]),
    ],
    safetyTitle: "Careful by design.",
    safetyText: "Molt removes only what its rules describe. Nothing is selected until you choose.",
    levels: [
        ("Safe", "Rebuilds on its own", "Your next build or launch recreates it."),
        ("Caution", "Downloads again", "Reinstalling takes a moment and a connection."),
        ("Risky", "Goes to the Trash", "Can't be rebuilt, so you can still change your mind."),
    ],
    checks: [
        "Never touches Documents, Photos, Mail or iCloud",
        "Checks every file again before removing it",
        "No account, no tracking, no network",
    ]
)

let turkish = Copy(
    language: "tr", decimalSeparator: ",",
    overviewTitle: "Kodunun geride bıraktığı dağınıklığı temizle.",
    overviewText: "Molt, yeniden oluşturulabilen önbellekleri, build dosyalarını ve bağımlılıkları bulur.",
    allClean: "Tertemiz", freed: "14,2 GB boşaltıldı",
    knowTitle: "Neyi sildiğini bil.",
    knowText: "Her öğe ne olduğunu, en son ne zaman değiştiğini ve nasıl geri geldiğini gösterir.",
    caution: "Dikkat", safe: "Güvenli", risky: "Riskli",
    nodeWhat: "Bir JavaScript projesi için kurulmuş paketler.", nodeBack: "npm install ile geri gelir",
    findsTitle: "Dağınıklığın nerede olduğunu bilir.",
    findsText: "Xcode, paket yöneticileri, yapay zekâ modelleri ve daha fazlası için 30'dan fazla kural.",
    categories: [
        ("Xcode", "hammer", .blue, ["DerivedData", "Device Support", "Archives"], ["Güvenli", "Riskli"]),
        ("Proje bağımlılıkları", "folder", .orange, ["node_modules", ".venv", "Pods", "target"], ["Güvenli", "Dikkat"]),
        ("Paket önbellekleri", "shippingbox", .brown, ["npm", "pnpm", "Homebrew", "pip", "Cargo"], ["Güvenli"]),
        ("Yapay zekâ modelleri", "brain", .purple, ["Ollama", "LM Studio", "Hugging Face"], ["Dikkat"]),
        ("Simülatörler", "iphone", .cyan, ["CoreSimulator önbellekleri"], ["Güvenli"]),
        ("iPhone ve iPad", "ipad.and.iphone", .indigo, ["iOS yükleyicileri", "yedekler"], ["Güvenli", "Riskli"]),
        ("Uygulama önbellekleri", "app.dashed", .pink, ["~/Library/Caches"], ["Güvenli"]),
        ("Kayıtlar", "doc.text", .teal, ["~/Library/Logs"], ["Güvenli"]),
    ],
    safetyTitle: "Güvenlik baştan düşünüldü.",
    safetyText: "Molt yalnızca kurallarının tanımladığı dosyaları siler. Sen seçmeden hiçbir şey işaretlenmez.",
    levels: [
        ("Güvenli", "Kendiliğinden yeniden oluşur", "Bir sonraki build ya da açılışta geri gelir."),
        ("Dikkat", "Yeniden indirilir", "Yeniden kurmak biraz zaman ve internet ister."),
        ("Riskli", "Çöp Sepeti'ne taşınır", "Yeniden oluşmaz; fikrini değiştirebilirsin."),
    ],
    checks: [
        "Belgeler'e, Fotoğraflar'a, Mail'e ve iCloud'a dokunmaz",
        "Her dosyayı silmeden önce yeniden kontrol eder",
        "Hesap yok, takip yok, internet yok",
    ]
)

// MARK: Style, matching the website

let ink = Color(red: 0.055, green: 0.063, blue: 0.078)
let muted = Color(red: 0.435, green: 0.463, blue: 0.506)
let soft = Color(red: 0.957, green: 0.961, blue: 0.969)
let line = Color.black.opacity(0.07)

func trustColor(_ tag: String) -> Color {
    switch tag {
    case "Safe", "Güvenli": Color(red: 0.086, green: 0.639, blue: 0.498)
    case "Caution", "Dikkat": Color(red: 0.851, green: 0.478, blue: 0.078)
    default: Color(red: 0.878, green: 0.267, blue: 0.294)
    }
}

func image(_ path: String) -> Image {
    guard let image = NSImage(contentsOf: root.appending(path: path)) else { fatalError("missing \(path)") }
    return Image(nsImage: image)
}

struct Background: View {
    var body: some View {
        ZStack {
            Color(red: 0.933, green: 0.941, blue: 0.953)
            RadialGradient(colors: [Color(red: 0.867, green: 0.910, blue: 0.988), .clear], center: UnitPoint(x: 0.9, y: -0.1), startRadius: 0, endRadius: 900)
            RadialGradient(colors: [Color(red: 0.886, green: 0.957, blue: 0.933), .clear], center: UnitPoint(x: -0.1, y: 0.25), startRadius: 0, endRadius: 700)
        }
    }
}

struct Card<Content: View>: View {
    var radius: CGFloat = 26
    @ViewBuilder let content: Content

    var body: some View {
        // The shadow belongs to the card's shape only; on the content every text and chip would cast its own.
        content
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.white)
                    .shadow(color: Color(red: 0.06, green: 0.1, blue: 0.16).opacity(0.05), radius: 3, y: 1)
                    .shadow(color: Color(red: 0.06, green: 0.1, blue: 0.16).opacity(0.16), radius: 30, y: 18)
            }
            .overlay(RoundedRectangle(cornerRadius: radius).strokeBorder(line))
    }
}

struct Tag: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(trustColor(text))
            .padding(.horizontal, 10).padding(.vertical, 4)
            .background(trustColor(text).opacity(0.12), in: .capsule)
    }
}

struct Headline: View {
    let title: String
    let text: String
    var alignment: HorizontalAlignment = .leading

    var body: some View {
        VStack(alignment: alignment, spacing: 18) {
            Text(title)
                .font(.system(size: 58, weight: .semibold).leading(.tight))
                .tracking(-1.6)
                .foregroundStyle(ink)
            Text(text)
                .font(.system(size: 24))
                .lineSpacing(4)
                .foregroundStyle(muted)
        }
        .multilineTextAlignment(alignment == .center ? .center : .leading)
    }
}

struct Window: View {
    let screen: String
    var body: some View {
        Card(radius: 22) {
            image(screen).resizable().scaledToFit().clipShape(.rect(cornerRadius: 16)).padding(6)
        }
    }
}

struct CategoryIcon: View {
    let symbol: String
    let color: Color
    var size: CGFloat = 40
    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(color.gradient, in: .rect(cornerRadius: size * 0.28))
    }
}

// MARK: Screens

struct OverviewScreen: View {
    let copy: Copy
    var body: some View {
        ZStack(alignment: .topLeading) {
            Background()
            Headline(title: copy.overviewTitle, text: copy.overviewText)
                .frame(width: 470, alignment: .leading)
                .offset(x: 84, y: 250)
            Window(screen: "build/screenshots/light-\(copy.language)/1-overview.png")
                .frame(width: 820)
                .offset(x: 580, y: 170)
            Card(radius: 22) {
                HStack(spacing: 16) {
                    image("website/assets/crab-celebrating.webp").resizable().scaledToFit().frame(width: 84, height: 84)
                        .blendMode(.multiply)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(copy.allClean).font(.system(size: 22, weight: .semibold)).foregroundStyle(ink)
                        Text(copy.freed).font(.system(size: 19, weight: .semibold)).foregroundStyle(trustColor("Safe"))
                    }
                }
                .padding(.leading, 14).padding(.trailing, 30).padding(.vertical, 12)
            }
            .offset(x: 470, y: 640)
        }
    }
}

struct KnowScreen: View {
    let copy: Copy
    var body: some View {
        ZStack(alignment: .topLeading) {
            Background()
            Headline(title: copy.knowTitle, text: copy.knowText)
                .frame(width: 470, alignment: .leading)
                .offset(x: 84, y: 270)
            Window(screen: "build/screenshots/light-\(copy.language)/2-projects.png")
                .frame(width: 820)
                .offset(x: 580, y: 120)
            Card(radius: 22) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("node_modules").font(.system(size: 20, weight: .semibold, design: .monospaced)).foregroundStyle(ink)
                        Spacer()
                        Tag(text: copy.caution)
                    }
                    Text(copy.nodeWhat).font(.system(size: 17)).foregroundStyle(muted)
                    Label(copy.nodeBack, systemImage: "checkmark.circle.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(trustColor("Safe"))
                }
                .padding(22)
                .frame(width: 400)
            }
            .offset(x: 440, y: 600)
        }
    }
}

struct FindsScreen: View {
    let copy: Copy
    var body: some View {
        ZStack(alignment: .top) {
            Background()
            VStack(spacing: 56) {
                Headline(title: copy.findsTitle, text: copy.findsText, alignment: .center)
                    .frame(width: 980)
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(296), spacing: 20), count: 4), spacing: 20) {
                    ForEach(copy.categories, id: \.name) { category in
                        Card {
                            VStack(alignment: .leading, spacing: 12) {
                                CategoryIcon(symbol: category.symbol, color: category.color)
                                Text(category.name).font(.system(size: 21, weight: .semibold)).foregroundStyle(ink)
                                FlowChips(items: category.examples)
                                Spacer(minLength: 0)
                                HStack(spacing: 6) { ForEach(category.tags, id: \.self) { Tag(text: $0) } }
                            }
                            .padding(22)
                            .frame(width: 296, height: 228, alignment: .topLeading)
                        }
                    }
                }
            }
            .padding(.top, 118)
        }
    }
}

/// Example folders as monospaced chips that wrap to a second line.
struct FlowChips: View {
    let items: [String]
    var body: some View {
        ChipLayout(spacing: 6) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 13, design: .monospaced))
                    .foregroundStyle(Color(red: 0.23, green: 0.25, blue: 0.28))
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(soft, in: .rect(cornerRadius: 7))
                    .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(line))
            }
        }
    }
}

struct ChipLayout: Layout {
    var spacing: CGFloat
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 260
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > 0, x + size.width > width { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: width, height: y + rowHeight)
    }
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x > bounds.minX, x + size.width > bounds.maxX { x = bounds.minX; y += rowHeight + spacing; rowHeight = 0 }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

struct SafetyScreen: View {
    let copy: Copy
    var body: some View {
        ZStack {
            Background()
            HStack(alignment: .center, spacing: 64) {
                VStack(alignment: .leading, spacing: 40) {
                    Headline(title: copy.safetyTitle, text: copy.safetyText)
                    Card(radius: 22) {
                        HStack(alignment: .center, spacing: 8) {
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(copy.checks, id: \.self) { check in
                                    Label {
                                        Text(check).font(.system(size: 19)).foregroundStyle(ink)
                                    } icon: {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 20)).foregroundStyle(trustColor("Safe"))
                                    }
                                }
                            }
                            Spacer(minLength: 0)
                            image("website/assets/crab-winking.webp").resizable().scaledToFit()
                                .frame(width: 130)
                                .blendMode(.multiply)
                        }
                        .padding(.leading, 26).padding(.trailing, 18).padding(.vertical, 22)
                    }
                }
                .frame(width: 600, alignment: .leading)

                VStack(spacing: 18) {
                    ForEach(copy.levels, id: \.tag) { level in
                        Card {
                            HStack(alignment: .firstTextBaseline, spacing: 16) {
                                Tag(text: level.tag).frame(minWidth: 76, alignment: .leading)
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(level.title).font(.system(size: 22, weight: .semibold)).foregroundStyle(ink)
                                    Text(level.text).font(.system(size: 17)).foregroundStyle(muted)
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(26)
                            .frame(width: 590)
                        }
                    }
                }
            }
        }
    }
}

// MARK: Rendering

@MainActor func render(_ view: some View, to url: URL) {
    let renderer = ImageRenderer(content: view.frame(width: 1440, height: 900).clipped())
    renderer.scale = 2
    guard let image = renderer.cgImage,
          let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)
    else { fatalError("could not render \(url.lastPathComponent)") }
    CGImageDestinationAddImage(destination, image, nil)
    CGImageDestinationFinalize(destination)
}

MainActor.assumeIsolated {
    for copy in [english, turkish] {
        let folder = root.appending(path: "build/app-store-screenshots/\(copy.language)", directoryHint: .isDirectory)
        try? FileManager.default.removeItem(at: folder)
        try! FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        render(OverviewScreen(copy: copy), to: folder.appending(path: "1-overview.png"))
        render(KnowScreen(copy: copy), to: folder.appending(path: "2-know.png"))
        render(FindsScreen(copy: copy), to: folder.appending(path: "3-finds.png"))
        render(SafetyScreen(copy: copy), to: folder.appending(path: "4-safety.png"))
        print("\(folder.path(percentEncoded: false)): 4 screenshots")
    }
}
