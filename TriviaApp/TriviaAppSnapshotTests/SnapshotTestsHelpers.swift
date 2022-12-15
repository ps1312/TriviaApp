import Foundation
import UIKit
import XCTest

extension XCTestCase {
    func assert(snapshot: UIImage, named: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapshotData(snapshot: snapshot)
        let snapshotURL = makeSnapshotURL(file: String(describing: file), name: named)

        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }

        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)

            try? snapshotData?.write(to: temporarySnapshotURL)

            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }

    func record(snapshot: UIImage, named: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotData = makeSnapshotData(snapshot: snapshot)
        let snapshotURL = makeSnapshotURL(file: String(describing: file), name: named)

        do {
            try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try snapshotData?.write(to: snapshotURL)

            XCTFail("Recorded snapshot - use `assert` now to make the images comparisson", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot image PNG", file: file, line: line)
        }
    }

    func makeSnapshotData(snapshot: UIImage, file: StaticString = #file, line: UInt = #line) -> Data? {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate SUT snapshot data", file: file, line: line)
            return nil
        }
        return snapshotData
    }

    func makeSnapshotURL(file: String, name: String) -> URL {
        URL(fileURLWithPath: file).deletingLastPathComponent().appendingPathComponent("snapshots").appendingPathComponent("\(name).png")
    }
}

final class SnapshotWindow: UIWindow {
    private var configuration: SnapshotConfiguration = .iPhone13(style: .light)

    convenience init(configuration: SnapshotConfiguration, root: UIViewController) {
        self.init(frame: CGRect(origin: .zero, size: configuration.size))
        self.configuration = configuration
        layoutMargins = configuration.layoutMargins
        rootViewController = root
        isHidden = false
        root.view.layoutMargins = configuration.layoutMargins
    }

    override var safeAreaInsets: UIEdgeInsets {
        return configuration.safeAreaInsets
    }

    override var traitCollection: UITraitCollection {
        return UITraitCollection(traitsFrom: [super.traitCollection, configuration.traitCollection])
    }

    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: .init(for: traitCollection))
        return renderer.image { action in
            layer.render(in: action.cgContext)
        }
    }
}

struct SnapshotConfiguration {
    let size: CGSize
    let safeAreaInsets: UIEdgeInsets
    let layoutMargins: UIEdgeInsets
    let traitCollection: UITraitCollection

    static func iPhone13(style: UIUserInterfaceStyle, contentSize: UIContentSizeCategory = .medium) -> SnapshotConfiguration {
        return SnapshotConfiguration(
            size: CGSize(width: 390, height: 844),
            safeAreaInsets: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            layoutMargins: UIEdgeInsets(top: 55, left: 8, bottom: 42, right: 8),
            traitCollection: UITraitCollection(traitsFrom: [
                .init(forceTouchCapability: .unavailable),
                .init(layoutDirection: .leftToRight),
                .init(preferredContentSizeCategory: contentSize),
                .init(userInterfaceIdiom: .phone),
                .init(horizontalSizeClass: .compact),
                .init(verticalSizeClass: .regular),
                .init(displayScale: 3),
                .init(accessibilityContrast: .normal),
                .init(displayGamut: .P3),
                .init(userInterfaceStyle: style),
            ])
        )
    }
}
