/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public struct LabelCaptureDefaults: DefaultsEncodable {
    private let cameraSettings: CameraSettingsDefaults
    private let basicOverlay: LabelCaptureBasicOverlayDefaults
    private let validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults
    private let feedback: LabelCaptureFeedback

    public func toEncodable() -> [String: Any?] {
        [
            "RecommendedCameraSettings": cameraSettings.toEncodable(),
            "LabelCaptureBasicOverlay": basicOverlay.toEncodable(),
            "LabelCaptureValidationFlowOverlay": validationFlowOverlay.toEncodable(),
            "feedback": feedback.jsonString,
        ]
    }

    public static var shared: LabelCaptureDefaults = {
        .init(
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
