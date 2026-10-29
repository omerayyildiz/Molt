import Foundation

/// Local AI models. Each can be several gigabytes and takes long to download again.
nonisolated extension RuleCatalog {
    static let ai: [Rule] = [
        model("ollama", "Ollama Models", ".ollama/models"),
        model("lm-studio", "LM Studio Models", ".lmstudio/models"),
        model("hugging-face", "Hugging Face Cache", ".cache/huggingface/hub"),
    ]

    private static func model(_ id: String, _ name: LocalizedStringResource, _ path: String) -> Rule {
        Rule(
            id: "ai.\(id)",
            category: .ai,
            name: name,
            summary: "AI models downloaded to run on this Mac.",
            recovery: "Download the model again from the app that uses it.",
            trust: .caution,
            locator: .folders([path])
        )
    }
}
