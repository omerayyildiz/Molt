import SwiftUI

/// Molt the hermit crab, in the pose that fits the moment. Decorative: the text beside it carries the meaning.
enum Mascot: String {
    case scanning = "MascotScanning"
    case cleaning = "MascotCleaning"
    case done = "MascotDone"
    case nothingToClean = "MascotNothingToClean"

    func image(height: CGFloat) -> some View {
        Image(rawValue)
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .accessibilityHidden(true)
    }
}

/// A mascot above a title and an optional line, for empty and in-progress pages.
struct MascotMessage<Accessory: View>: View {
    let mascot: Mascot
    let title: LocalizedStringKey
    var message: LocalizedStringKey?
    @ViewBuilder var accessory: Accessory

    var body: some View {
        VStack(spacing: 10) {
            mascot.image(height: 130)
                .padding(.bottom, 6)
            Text(title)
                .font(.title3.weight(.semibold))
            if let message {
                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            accessory
        }
        .padding(24)
        .accessibilityElement(children: .contain)
    }
}

extension MascotMessage where Accessory == EmptyView {
    init(mascot: Mascot, title: LocalizedStringKey, message: LocalizedStringKey? = nil) {
        self.init(mascot: mascot, title: title, message: message) { EmptyView() }
    }
}
