/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public struct LabelCaptureDefaults {
    private let cameraSettings: CameraSettingsDefaults
    private let validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults

    /// The residual set of label defaults that a framework plugin cannot resolve statically: the
    /// recommended camera settings (derived differently per platform wrapper) and the
    /// locale-dependent validation-flow texts. Every other label default ships as a generated
    /// static file.
    public func toDynamicEncodable() -> [String: Any?] {
        [
            Keys.recommendedCameraSettings: cameraSettings.toEncodable(),
            Keys.validationFlowOverlay: validationFlowOverlay.toEncodable(),
        ]
    }

    private enum Keys {
        static let recommendedCameraSettings = "RecommendedCameraSettings"
        static let validationFlowOverlay = "LabelCaptureValidationFlowOverlay"
    }

    public static var shared: LabelCaptureDefaults = {
        .init(
            cameraSettings:
                CameraSettingsDefaults(
                    cameraSettings: LabelCapture.recommendedCameraSettings
                ),
            validationFlowOverlay: LabelCaptureValidationFlowOverlayDefaults.shared
        )
    }()
}
