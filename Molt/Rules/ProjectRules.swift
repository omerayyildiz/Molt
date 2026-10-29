import Foundation

/// Dependencies and build output inside projects. Each is found only next to the file of the tool that made it.
nonisolated extension RuleCatalog {
    static let projects: [Rule] = [
        Rule(
            id: "projects.node-modules",
            category: .projects,
            name: "node_modules",
            summary: "Packages installed for a JavaScript project.",
            recovery: "Run npm install (or pnpm, yarn, bun) in the project.",
            trust: .caution,
            locator: .projectArtifact(folder: "node_modules", markers: ["package.json"])
        ),
        Rule(
            id: "projects.next",
            category: .projects,
            name: "Next.js Build",
            summary: "Build output and cache of a Next.js project.",
            recovery: "The next build or dev server recreates it.",
            trust: .safe,
            locator: .projectArtifact(folder: ".next", markers: ["package.json"])
        ),
        Rule(
            id: "projects.rust-target",
            category: .projects,
            name: "Rust Build",
            summary: "Build output of a Rust project.",
            recovery: "The next cargo build recreates it.",
            trust: .safe,
            locator: .projectArtifact(folder: "target", markers: ["Cargo.toml"])
        ),
        Rule(
            id: "projects.swiftpm-build",
            category: .projects,
            name: "Swift Package Build",
            summary: "Build output of a Swift package.",
            recovery: "The next swift build recreates it.",
            trust: .safe,
            locator: .projectArtifact(folder: ".build", markers: ["Package.swift"])
        ),
        Rule(
            id: "projects.pods",
            category: .projects,
            name: "CocoaPods",
            summary: "Libraries CocoaPods installed for an Xcode project.",
            recovery: "Run pod install in the project.",
            trust: .caution,
            locator: .projectArtifact(folder: "Pods", markers: ["Podfile"])
        ),
        Rule(
            id: "projects.python-venv",
            category: .projects,
            name: "Python Environment",
            summary: "A virtual environment with the packages of a Python project.",
            recovery: "Recreate it with uv sync or pip install.",
            trust: .caution,
            locator: .projectArtifact(folder: ".venv", markers: ["pyproject.toml", "requirements.txt"])
        ),
        Rule(
            id: "projects.gradle-build",
            category: .projects,
            name: "Gradle Build",
            summary: "Build output of a Gradle or Android project.",
            recovery: "The next Gradle build recreates it.",
            trust: .safe,
            locator: .projectArtifact(folder: "build", markers: ["build.gradle", "build.gradle.kts"])
        ),
    ]
}
