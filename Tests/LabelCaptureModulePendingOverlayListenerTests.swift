/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import XCTest

@testable import ScanditFrameworksLabel

/// Regression coverage for SDC-32821: the four label-capture overlay-listener register
/// methods used to write `overlay?.delegate = listener` with no fallback. When the overlay
/// wasn't attached yet (new-architecture view creation racing the JS registration call), the
/// optional-chained assignment silently no-op'd while the register call still reported
/// success via `successAndKeepCallback` - JS believed it registered, but no event ever fired
/// because `dataCaptureView(addOverlay:to:)` had no memory of the request when it later
/// created the overlay.
///
/// A real `LabelCaptureBasicOverlay` / `LabelCaptureAdvancedOverlay` /
/// `LabelCaptureValidationFlowOverlay` / `LabelCaptureAdaptiveRecognitionOverlay` cannot be
/// constructed in a unit test (private init, live `DataCaptureContext`, native
/// deserialization via `LabelCaptureDeserializer`), so this cannot drive
/// `dataCaptureView(addOverlay:to:)` end-to-end. Instead it asserts at the reachable
/// boundary: the four `pending*OverlayListenerViewIds` sets that method consults when the
/// overlay is (re)created. Those properties were made non-`private` specifically to allow
/// this direct assertion via `@testable import`, mirroring the precedent in
/// `FrameworksBarcodeCountViewListenerTests` (SDC-33376).
final class LabelCaptureModulePendingOverlayListenerTests: XCTestCase {

    private var module: LabelCaptureModule!

    override func setUp() {
        super.setUp()
        module = LabelCaptureModule(emitter: RecordingEmitter())
    }

    override func tearDown() {
        module.didStop()
        module = nil
        super.tearDown()
    }

    // MARK: - Basic overlay

    func testAddBasicOverlayListener_overlayNotYetCreated_recordsPendingRegistration() {
        let viewId = 9001
        module.addLabelCaptureBasicOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertTrue(
            module.pendingBasicOverlayListenerViewIds.contains(viewId),
            "register must remember the request so a later-created basic overlay honors it (SDC-32821)"
        )
    }

    func testRemoveBasicOverlayListener_clearsPendingRegistration() {
        let viewId = 9002
        module.addLabelCaptureBasicOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.removeLabelCaptureBasicOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertFalse(module.pendingBasicOverlayListenerViewIds.contains(viewId))
    }

    // MARK: - Advanced overlay

    func testAddAdvancedOverlayListener_overlayNotYetCreated_recordsPendingRegistration() {
        let viewId = 9003
        module.addLabelCaptureAdvancedOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertTrue(
            module.pendingAdvancedOverlayListenerViewIds.contains(viewId),
            "register must remember the request so a later-created advanced overlay honors it (SDC-32821)"
        )
    }

    func testRemoveAdvancedOverlayListener_clearsPendingRegistration() {
        let viewId = 9004
        module.addLabelCaptureAdvancedOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.removeLabelCaptureAdvancedOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertFalse(module.pendingAdvancedOverlayListenerViewIds.contains(viewId))
    }

    // MARK: - Validation-flow overlay

    func testRegisterValidationFlowListener_overlayNotYetCreated_recordsPendingRegistration() {
        let viewId = 9005
        module.registerListenerForValidationFlowEvents(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertTrue(
            module.pendingValidationFlowOverlayListenerViewIds.contains(viewId),
            "register must remember the request so a later-created validation-flow overlay honors it (SDC-32821)"
        )
    }

    func testUnregisterValidationFlowListener_clearsPendingRegistration() {
        let viewId = 9006
        module.registerListenerForValidationFlowEvents(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.unregisterListenerForValidationFlowEvents(dataCaptureViewId: viewId, result: NoopFrameworksResult())

        XCTAssertFalse(module.pendingValidationFlowOverlayListenerViewIds.contains(viewId))
    }

    // MARK: - Adaptive-recognition overlay

    func testRegisterAdaptiveRecognitionListener_overlayNotYetCreated_recordsPendingRegistration() {
        let viewId = 9007
        module.registerListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: viewId,
            result: NoopFrameworksResult()
        )

        XCTAssertTrue(
            module.pendingAdaptiveRecognitionOverlayListenerViewIds.contains(viewId),
            "register must remember the request so a later-created adaptive-recognition overlay honors it "
                + "(SDC-32821)"
        )
    }

    func testUnregisterAdaptiveRecognitionListener_clearsPendingRegistration() {
        let viewId = 9008
        module.registerListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: viewId,
            result: NoopFrameworksResult()
        )
        module.unregisterListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: viewId,
            result: NoopFrameworksResult()
        )

        XCTAssertFalse(module.pendingAdaptiveRecognitionOverlayListenerViewIds.contains(viewId))
    }

    // MARK: - didStop

    func testDidStop_clearsAllPendingOverlayListenerRegistrations() {
        let viewId = 9009
        module.addLabelCaptureBasicOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.addLabelCaptureAdvancedOverlayListener(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.registerListenerForValidationFlowEvents(dataCaptureViewId: viewId, result: NoopFrameworksResult())
        module.registerListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: viewId,
            result: NoopFrameworksResult()
        )

        module.didStop()

        XCTAssertTrue(module.pendingBasicOverlayListenerViewIds.isEmpty)
        XCTAssertTrue(module.pendingAdvancedOverlayListenerViewIds.isEmpty)
        XCTAssertTrue(module.pendingValidationFlowOverlayListenerViewIds.isEmpty)
        XCTAssertTrue(module.pendingAdaptiveRecognitionOverlayListenerViewIds.isEmpty)
    }
}

private class RecordingEmitter: Emitter {
    func emit(name: String, payload: [String: Any?]) {}
    func hasListener(for event: String) -> Bool { false }
    func hasViewSpecificListenersForEvent(_ viewId: Int, for event: String) -> Bool { false }
    func hasModeSpecificListenersForEvent(_ modeId: Int, for event: String) -> Bool { false }
}
