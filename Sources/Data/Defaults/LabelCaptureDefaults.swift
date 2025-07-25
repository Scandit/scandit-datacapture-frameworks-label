/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

struct LabelCaptureDefaults: DefaultsEncodable {
    private let cameraSettings: CameraSettingsDefaults
    private let basicOverlay: LabelCaptureBasicOverlayDefaults

    func toEncodable() -> [String: Any?] {
        [
            "RecommendedCameraSettings": cameraSettings.toEncodable(),
            "LabelCaptureBasicOverlay": basicOverlay.toEncodable()
        ]
    }

    static var shared: LabelCaptureDefaults = {
        .init(cameraSettings: 
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
              )
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
            "DefaultLabelBrush": labelBrush.toEncodable()
        ]
    }
}
