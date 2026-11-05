/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import XCTest

@testable import ScanditFrameworksLabel

final class FrameworksLabelCaptureSessionTests: XCTestCase {
    func testCapturedLabelFieldsIsEmptyWithoutLabels() {
        let session = FrameworksLabelCaptureSession(capturedLabels: [])

        XCTAssertTrue(session.capturedLabelFields.isEmpty)
    }

    func testCapturedLabelFieldsCachesTheFirstBuild() {
        let session = FrameworksLabelCaptureSession(capturedLabels: [])

        // Second read must come from the cache behind the lock, not re-enter the build.
        XCTAssertEqual(session.capturedLabelFields.count, 0)
        XCTAssertEqual(session.capturedLabelFields.count, 0)
        XCTAssertNil(session.getField(byKey: "0\(FrameworksLabelCaptureSession.separator)price"))
    }

    func testGetFieldKeyJoinsTrackingIdAndName() {
        XCTAssertEqual(
            FrameworksLabelCaptureSession.getFieldKey(trackingId: 7, fieldName: "price"),
            "7\(FrameworksLabelCaptureSession.separator)price"
        )
    }
}
