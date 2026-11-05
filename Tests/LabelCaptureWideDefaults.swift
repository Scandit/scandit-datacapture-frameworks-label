/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import Foundation
import ScanditFrameworksCore
import ScanditLabelCapture

@testable import ScanditFrameworksLabel

/// Test-only *wide* defaults builder for the Label module.
///
/// Production only ever emits the narrow, dynamic payload
/// (`LabelCaptureDefaults.toDynamicEncodable()`), so the wide `toEncodable()` graph - and the
/// leaf `LabelCaptureBasicOverlayDefaults` / `LabelCaptureFeedbackDefaults` builders reachable
/// only through it - lives here, in the test target only. It is the oracle
/// `LabelCaptureDefaultsDriftTests` compares the SoT snapshot against: real SDK objects, dumped
/// wide.
///
/// Named `LabelCaptureWideDefaults` so it does not clash with the narrow production
/// `LabelCaptureDefaults`, which the test target sees via `@testable import`.
///
/// The key strings are literals rather than `LabelCaptureDefaults.Keys` references because that
/// enum is `private` in production - file-scoped, so `@testable import` cannot reach it.
struct LabelCaptureWideDefaults: DefaultsEncodable {
    private let cameraSettings: CameraSettingsDefaults
    private let basicOverlay: LabelCaptureBasicOverlayDefaults
    private let validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults
    private let feedback: LabelCaptureFeedback

    init(
        cameraSettings: CameraSettingsDefaults,
        basicOverlay: LabelCaptureBasicOverlayDefaults,
        validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults,
        feedback: LabelCaptureFeedback
    ) {
        self.cameraSettings = cameraSettings
        self.basicOverlay = basicOverlay
        self.validationFlowOverlay = validationFlowOverlay
        self.feedback = feedback
    }

    func toEncodable() -> [String: Any?] {
        [
            "RecommendedCameraSettings": cameraSettings.toEncodable(),
            "LabelCaptureBasicOverlay": basicOverlay.toEncodable(),
            "LabelCaptureValidationFlowOverlay": validationFlowOverlay.toEncodable(),
            "feedback": feedback.jsonString,
        ]
    }

    static var shared: LabelCaptureWideDefaults = {
        LabelCaptureWideDefaults(
            cameraSettings:
                CameraSettingsDefaults(
                    cameraSettings: LabelCapture.recommendedCameraSettings
                ),
            basicOverlay: LabelCaptureBasicOverlayDefaults(
                predictedFieldBrush:
                    EncodableBrush(
                        brush: LabelCaptureBasicOverlay.defaultPredictedFieldBrush
                    ),
                capturedFieldBrush:
                    EncodableBrush(
                        brush: LabelCaptureBasicOverlay.defaultCapturedFieldBrush
                    ),
                labelBrush:
                    EncodableBrush(
                        brush: LabelCaptureBasicOverlay.defaultLabelBrush
                    )
            ),
            validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults.shared,
            feedback: LabelCaptureFeedback()
        )
    }()
}

/// Leaf builders that only ever fed the wide dump above; they lived in
/// `Sources/.../LabelCaptureDefaults.swift` until the wide half moved here.
struct LabelCaptureBasicOverlayDefaults: DefaultsEncodable {
    let predictedFieldBrush: EncodableBrush
    let capturedFieldBrush: EncodableBrush
    let labelBrush: EncodableBrush

    func toEncodable() -> [String: Any?] {
        [
            "DefaultPredictedFieldBrush": predictedFieldBrush.toEncodable(),
            "DefaultCapturedFieldBrush": capturedFieldBrush.toEncodable(),
            "DefaultLabelBrush": labelBrush.toEncodable(),
        ]
    }
}

struct LabelCaptureFeedbackDefaults: DefaultsEncodable {

    func toEncodable() -> [String: Any?] {
        [
            "success": LabelCaptureFeedback.default.jsonString
        ]
    }
}
