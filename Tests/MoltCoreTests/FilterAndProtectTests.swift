import Foundation
import Testing
@testable import MoltCore

struct FilterAndProtectTests {
    private let now = Date(timeIntervalSince1970: 1_800_000_000)
    private let calendar = Calendar(identifier: .gregorian)

    private func daysAgo(_ days: Int) -> Date { now.addingTimeInterval(-Double(days) * 86_400) }

    @Test func ageFilterKeepsOnlyOldEnoughItems() {
        #expect(AgeFilter.any.includes(nil, now: now, calendar: calendar))
        #expect(AgeFilter.any.includes(daysAgo(1), now: now, calendar: calendar))
        #expect(!AgeFilter.oneMonth.includes(daysAgo(10), now: now, calendar: calendar))
        #expect(AgeFilter.oneMonth.includes(daysAgo(40), now: now, calendar: calendar))
        #expect(!AgeFilter.sixMonths.includes(daysAgo(100), now: now, calendar: calendar))
        #expect(AgeFilter.oneYear.includes(daysAgo(400), now: now, calendar: calendar))
        // An unknown age never passes an age filter.
        #expect(!AgeFilter.oneMonth.includes(nil, now: now, calendar: calendar))
    }

    @Test func pathListMatchesTheFolderAndEverythingInside() {
        let paths = ["/Users/me/Code/app/node_modules"]

        #expect(PathList.contains(URL(filePath: "/Users/me/Code/app/node_modules"), in: paths))
        #expect(PathList.contains(URL(filePath: "/Users/me/Code/app/node_modules/react"), in: paths))
        #expect(!PathList.contains(URL(filePath: "/Users/me/Code/app/node_modules-old"), in: paths))
        #expect(!PathList.contains(URL(filePath: "/Users/me/Code/web/node_modules"), in: paths))
    }

    @Test func pathListIsSavedSortedWithoutDuplicates() throws {
        let home = try TemporaryHome()
        let list = PathList(file: home.url.appending(path: "Molt/protected.json"))
        #expect(list.load().isEmpty)

        try list.save(["/b", "/a", "/b"])

        #expect(list.load() == ["/a", "/b"])
    }

    @Test func historyAddsUpWhatWasFreed() throws {
        let home = try TemporaryHome()
        let history = CleanupHistory(file: home.url.appending(path: "Molt/history.json"))
        #expect(history.totalFreed() == 0)

        try history.append([
            .init(date: now, ruleID: "packages.npm", path: "~/.npm/_cacache", bytes: 40),
            .init(date: now, ruleID: "xcode.derived-data", path: "~/Library/Developer/Xcode/DerivedData/A", bytes: 2),
        ])

        #expect(history.totalFreed() == 42)
    }
}
