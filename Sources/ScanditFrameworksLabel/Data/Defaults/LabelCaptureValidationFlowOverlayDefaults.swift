/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

#if !COCOAPODS
import ScanditFrameworksLabelObjC
#endif

public struct LabelCaptureValidationFlowOverlayDefaults: DefaultsEncodable {
    private let settings: FrameworksLabelCaptureValidationFlowSettingsDefaults

    public func toEncodable() -> [String: Any?] {
        [
            "Settings": settings.toEncodable()
        ]
    }

    public static var shared: LabelCaptureValidationFlowOverlayDefaults = {
        .init(settings: FrameworksLabelCaptureValidationFlowSettingsDefaults())
    }()
}

struct FrameworksLabelCaptureValidationFlowSettingsDefaults: DefaultsEncodable {
    func toEncodable() -> [String: Any?] {
        [
            "missingFieldsHintText": LabelCaptureValidationFlowSettingsDefaults.defaultMissingFieldsHintText,
            "standbyHintText": LabelCaptureValidationFlowSettingsDefaults.defaultStandbyHintText,
            "validationHintText": LabelCaptureValidationFlowSettingsDefaults.defaultValidationHintText,
            "validationErrorText": LabelCaptureValidationFlowSettingsDefaults.defaultValidationErrorText,
            "requiredFieldErrorText": LabelCaptureValidationFlowSettingsDefaults.defaultRequiredFieldErrorText,
            "manualInputButtonText": LabelCaptureValidationFlowSettingsDefaults.defaultManualInputButtonText,
            "validationFinishButtonText": LabelCaptureValidationFlowSettingsDefaults.defaultValidationFinishButtonText,
            "validationRestartButtonText": LabelCaptureValidationFlowSettingsDefaults
                .defaultValidationRestartButtonText,
            "validationPauseButtonText": LabelCaptureValidationFlowSettingsDefaults.defaultValidationPauseButtonText,
            "validationAdaptiveScanningText": LabelCaptureValidationFlowSettingsDefaults
                .defaultValidationAdaptiveScanningText,
            "validationScanningText": LabelCaptureValidationFlowSettingsDefaults.defaultValidationScanningText,
        ]
    }
}
