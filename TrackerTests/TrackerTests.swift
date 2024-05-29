//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Malik Timurkaev on 27.05.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        
        let viewController = TabBarControler()
        
        assertSnapshot(matching: viewController, as: .image)
    }
}
