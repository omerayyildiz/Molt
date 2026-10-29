import Foundation
import Testing
@testable import MoltCore

struct RuleCatalogTests {
    @Test func ruleIDsAreUnique() {
        let ids = RuleCatalog.all.map(\.id)
        #expect(Set(ids).count == ids.count)
    }

    @Test func pathsAreRelativeToTheHomeFolder() {
        for rule in RuleCatalog.all {
            for path in rule.locator.claimedPaths {
                #expect(!path.isEmpty && !path.hasPrefix("/") && !path.hasPrefix("~") && !path.contains(".."), "\(rule.id)")
            }
        }
    }

    /// A folder rule must never point at a protected folder or a folder that holds one,
    /// and a contents rule must never list a protected folder as one of its items.
    @Test func noRuleReachesAProtectedFolder() {
        for rule in RuleCatalog.all {
            for protected in SafeRemover.protectedPaths {
                switch rule.locator {
                case .folders(let paths):
                    for path in paths {
                        #expect(protected != path && !protected.hasPrefix(path + "/"), "\(rule.id) reaches \(protected)")
                    }
                case .contents(let path, _):
                    let parent = (protected as NSString).deletingLastPathComponent
                    #expect(parent != path, "\(rule.id) lists \(protected)")
                case .projectArtifact:
                    break
                }
            }
        }
    }

    @Test func everyCategoryHasARule() {
        for category in Category.allCases {
            #expect(RuleCatalog.all.contains { $0.category == category }, "\(category)")
        }
    }
}
