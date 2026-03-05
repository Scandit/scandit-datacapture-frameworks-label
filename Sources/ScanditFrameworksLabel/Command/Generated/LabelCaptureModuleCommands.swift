/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/label.json

import Foundation
import ScanditFrameworksCore

/// Generated LabelCaptureModule command implementations.
/// Each command extracts parameters in its initializer and executes via LabelCaptureModule.

/// Finish callback for label capture did update session event
public class FinishLabelCaptureListenerDidUpdateSessionCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    private let isEnabled: Bool
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
        self.isEnabled = method.argument(key: "isEnabled") ?? Bool()
    }

    public func execute(result: FrameworksResult) {
        module.finishLabelCaptureListenerDidUpdateSession(
            modeId: modeId,
            isEnabled: isEnabled,
            result: result
        )
    }
}
/// Register persistent event listener for label capture events
public class AddLabelCaptureListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.registerModeSpecificCallback(
            modeId,
            eventNames: [
                "LabelCaptureListener.didUpdateSession"
            ]
        )
        module.addLabelCaptureListener(
            modeId: modeId,
            result: result
        )
    }
}
/// Unregister event listener for label capture events
public class RemoveLabelCaptureListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.unregisterModeSpecificCallback(
            modeId,
            eventNames: [
                "LabelCaptureListener.didUpdateSession"
            ]
        )
        module.removeLabelCaptureListener(
            modeId: modeId,
            result: result
        )
    }
}
/// Sets the enabled state of the label capture mode
public class SetLabelCaptureModeEnabledStateCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    private let isEnabled: Bool
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
        self.isEnabled = method.argument(key: "isEnabled") ?? Bool()
    }

    public func execute(result: FrameworksResult) {
        module.setLabelCaptureModeEnabledState(
            modeId: modeId,
            isEnabled: isEnabled,
            result: result
        )
    }
}
/// Updates the label capture mode configuration
public class UpdateLabelCaptureModeCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeJson = method.argument(key: "modeJson") ?? String()
    }

    public func execute(result: FrameworksResult) {
        module.updateLabelCaptureMode(
            modeJson: modeJson,
            result: result
        )
    }
}
/// Updates the label capture mode settings
public class UpdateLabelCaptureSettingsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    private let settingsJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
        self.settingsJson = method.argument(key: "settingsJson") ?? String()
    }

    public func execute(result: FrameworksResult) {
        module.updateLabelCaptureSettings(
            modeId: modeId,
            settingsJson: settingsJson,
            result: result
        )
    }
}
/// Updates the label capture feedback configuration
public class UpdateLabelCaptureFeedbackCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let modeId: Int
    private let feedbackJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.modeId = method.argument(key: "modeId") ?? Int()
        self.feedbackJson = method.argument(key: "feedbackJson") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !feedbackJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'feedbackJson' is missing",
                details: nil
            )
            return
        }
        module.updateLabelCaptureFeedback(
            modeId: modeId,
            feedbackJson: feedbackJson,
            result: result
        )
    }
}
/// Sets the view for a captured label in advanced overlay
public class SetViewForCapturedLabelCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let viewJson: String?
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.viewJson = method.argument(key: "viewJson")
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        module.setViewForCapturedLabel(
            dataCaptureViewId: dataCaptureViewId,
            viewJson: viewJson,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Sets the view for a captured label in advanced overlay using byte array
public class SetViewForCapturedLabelFromBytesCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let viewBytes: Data?
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.viewBytes = method.argument(key: "viewBytes")
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        module.setViewForCapturedLabelFromBytes(
            dataCaptureViewId: dataCaptureViewId,
            viewBytes: viewBytes,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Sets the view for a captured label field in advanced overlay
public class SetViewForCapturedLabelFieldCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let identifier: String
    private let viewJson: String?
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.identifier = method.argument(key: "identifier") ?? ""
        self.viewJson = method.argument(key: "viewJson")
    }

    public func execute(result: FrameworksResult) {
        guard !identifier.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'identifier' is missing",
                details: nil
            )
            return
        }
        module.setViewForCapturedLabelField(
            dataCaptureViewId: dataCaptureViewId,
            identifier: identifier,
            viewJson: viewJson,
            result: result
        )
    }
}
/// Sets the view for a captured label field in advanced overlay using byte array
public class SetViewForCapturedLabelFieldFromBytesCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let viewBytes: Data?
    private let identifier: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.viewBytes = method.argument(key: "viewBytes")
        self.identifier = method.argument(key: "identifier") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !identifier.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'identifier' is missing",
                details: nil
            )
            return
        }
        module.setViewForCapturedLabelFieldFromBytes(
            dataCaptureViewId: dataCaptureViewId,
            viewBytes: viewBytes,
            identifier: identifier,
            result: result
        )
    }
}
/// Sets the anchor for a captured label in advanced overlay
public class SetAnchorForCapturedLabelCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let anchorJson: String
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.anchorJson = method.argument(key: "anchorJson") ?? ""
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        guard !anchorJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'anchorJson' is missing",
                details: nil
            )
            return
        }
        module.setAnchorForCapturedLabel(
            dataCaptureViewId: dataCaptureViewId,
            anchorJson: anchorJson,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Sets the anchor for a captured label field in advanced overlay
public class SetAnchorForCapturedLabelFieldCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let anchorJson: String
    private let identifier: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.anchorJson = method.argument(key: "anchorJson") ?? ""
        self.identifier = method.argument(key: "identifier") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !anchorJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'anchorJson' is missing",
                details: nil
            )
            return
        }
        guard !identifier.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'identifier' is missing",
                details: nil
            )
            return
        }
        module.setAnchorForCapturedLabelField(
            dataCaptureViewId: dataCaptureViewId,
            anchorJson: anchorJson,
            identifier: identifier,
            result: result
        )
    }
}
/// Sets the offset for a captured label in advanced overlay
public class SetOffsetForCapturedLabelCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let offsetJson: String
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.offsetJson = method.argument(key: "offsetJson") ?? ""
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        guard !offsetJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'offsetJson' is missing",
                details: nil
            )
            return
        }
        module.setOffsetForCapturedLabel(
            dataCaptureViewId: dataCaptureViewId,
            offsetJson: offsetJson,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Sets the offset for a captured label field in advanced overlay
public class SetOffsetForCapturedLabelFieldCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let offsetJson: String
    private let identifier: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.offsetJson = method.argument(key: "offsetJson") ?? ""
        self.identifier = method.argument(key: "identifier") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !offsetJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'offsetJson' is missing",
                details: nil
            )
            return
        }
        guard !identifier.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'identifier' is missing",
                details: nil
            )
            return
        }
        module.setOffsetForCapturedLabelField(
            dataCaptureViewId: dataCaptureViewId,
            offsetJson: offsetJson,
            identifier: identifier,
            result: result
        )
    }
}
/// Clears all views for captured labels in advanced overlay
public class ClearCapturedLabelViewsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        module.clearCapturedLabelViews(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Register persistent event listener for label capture basic overlay events
public class AddLabelCaptureBasicOverlayListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.registerCallbackForEvents([
            "LabelCaptureBasicOverlayListener.didTapLabel",
            "LabelCaptureBasicOverlayListener.brushForLabel",
            "LabelCaptureBasicOverlayListener.brushForFieldOfLabel",
        ])
        module.addLabelCaptureBasicOverlayListener(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Unregister event listener for label capture basic overlay events
public class RemoveLabelCaptureBasicOverlayListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.unregisterCallbackForEvents([
            "LabelCaptureBasicOverlayListener.didTapLabel",
            "LabelCaptureBasicOverlayListener.brushForLabel",
            "LabelCaptureBasicOverlayListener.brushForFieldOfLabel",
        ])
        module.removeLabelCaptureBasicOverlayListener(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Updates the label capture basic overlay configuration
public class UpdateLabelCaptureBasicOverlayCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let basicOverlayJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.basicOverlayJson = method.argument(key: "basicOverlayJson") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !basicOverlayJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'basicOverlayJson' is missing",
                details: nil
            )
            return
        }
        module.updateLabelCaptureBasicOverlay(
            dataCaptureViewId: dataCaptureViewId,
            basicOverlayJson: basicOverlayJson,
            result: result
        )
    }
}
/// Sets the brush for a captured label in basic overlay
public class SetLabelCaptureBasicOverlayBrushForLabelCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let brushJson: String?
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.brushJson = method.argument(key: "brushJson")
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        module.setLabelCaptureBasicOverlayBrushForLabel(
            dataCaptureViewId: dataCaptureViewId,
            brushJson: brushJson,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Sets the brush for a captured label field in basic overlay
public class SetLabelCaptureBasicOverlayBrushForFieldOfLabelCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let brushJson: String?
    private let fieldName: String
    private let trackingId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.brushJson = method.argument(key: "brushJson")
        self.fieldName = method.argument(key: "fieldName") ?? ""
        self.trackingId = method.argument(key: "trackingId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        guard !fieldName.isEmpty else {
            result.reject(code: "MISSING_PARAMETER", message: "Required parameter 'fieldName' is missing", details: nil)
            return
        }
        module.setLabelCaptureBasicOverlayBrushForFieldOfLabel(
            dataCaptureViewId: dataCaptureViewId,
            brushJson: brushJson,
            fieldName: fieldName,
            trackingId: trackingId,
            result: result
        )
    }
}
/// Register persistent event listener for label capture advanced overlay events
public class AddLabelCaptureAdvancedOverlayListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.registerCallbackForEvents([
            "LabelCaptureAdvancedOverlayListener.viewForLabel",
            "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel",
            "LabelCaptureAdvancedOverlayListener.anchorForLabel",
            "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel",
            "LabelCaptureAdvancedOverlayListener.offsetForLabel",
            "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel",
        ])
        module.addLabelCaptureAdvancedOverlayListener(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Unregister event listener for label capture advanced overlay events
public class RemoveLabelCaptureAdvancedOverlayListenerCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.unregisterCallbackForEvents([
            "LabelCaptureAdvancedOverlayListener.viewForLabel",
            "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel",
            "LabelCaptureAdvancedOverlayListener.anchorForLabel",
            "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel",
            "LabelCaptureAdvancedOverlayListener.offsetForLabel",
            "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel",
        ])
        module.removeLabelCaptureAdvancedOverlayListener(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Updates the label capture advanced overlay configuration
public class UpdateLabelCaptureAdvancedOverlayCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let advancedOverlayJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.advancedOverlayJson = method.argument(key: "advancedOverlayJson") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !advancedOverlayJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'advancedOverlayJson' is missing",
                details: nil
            )
            return
        }
        module.updateLabelCaptureAdvancedOverlay(
            dataCaptureViewId: dataCaptureViewId,
            advancedOverlayJson: advancedOverlayJson,
            result: result
        )
    }
}
/// Register persistent event listener for label capture validation flow overlay events
public class RegisterListenerForValidationFlowEventsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.registerCallbackForEvents([
            "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
        ])
        module.registerListenerForValidationFlowEvents(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Unregister event listener for label capture validation flow overlay events
public class UnregisterListenerForValidationFlowEventsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.unregisterCallbackForEvents([
            "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
        ])
        module.unregisterListenerForValidationFlowEvents(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Updates the label capture validation flow overlay configuration
public class UpdateLabelCaptureValidationFlowOverlayCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let overlayJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.overlayJson = method.argument(key: "overlayJson") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !overlayJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'overlayJson' is missing",
                details: nil
            )
            return
        }
        module.updateLabelCaptureValidationFlowOverlay(
            dataCaptureViewId: dataCaptureViewId,
            overlayJson: overlayJson,
            result: result
        )
    }
}
/// Register persistent event listener for label capture adaptive recognition overlay events
public class RegisterListenerForAdaptiveRecognitionOverlayEventsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.registerCallbackForEvents([
            "LabelCaptureAdaptiveRecognitionListener.recognized",
            "LabelCaptureAdaptiveRecognitionListener.failure",
        ])
        module.registerListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Unregister event listener for label capture adaptive recognition overlay events
public class UnregisterListenerForAdaptiveRecognitionOverlayEventsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
    }

    public func execute(result: FrameworksResult) {
        // Register/unregister event callbacks
        result.unregisterCallbackForEvents([
            "LabelCaptureAdaptiveRecognitionListener.recognized",
            "LabelCaptureAdaptiveRecognitionListener.failure",
        ])
        module.unregisterListenerForAdaptiveRecognitionOverlayEvents(
            dataCaptureViewId: dataCaptureViewId,
            result: result
        )
    }
}
/// Applies adaptive recognition settings to the label capture overlay
public class ApplyLabelCaptureAdaptiveRecognitionSettingsCommand: LabelCaptureModuleCommand {
    private let module: LabelCaptureModule
    private let dataCaptureViewId: Int
    private let overlayJson: String
    public init(module: LabelCaptureModule, _ method: FrameworksMethodCall) {
        self.module = module
        self.dataCaptureViewId = method.argument(key: "dataCaptureViewId") ?? Int()
        self.overlayJson = method.argument(key: "overlayJson") ?? ""
    }

    public func execute(result: FrameworksResult) {
        guard !overlayJson.isEmpty else {
            result.reject(
                code: "MISSING_PARAMETER",
                message: "Required parameter 'overlayJson' is missing",
                details: nil
            )
            return
        }
        module.applyLabelCaptureAdaptiveRecognitionSettings(
            dataCaptureViewId: dataCaptureViewId,
            overlayJson: overlayJson,
            result: result
        )
    }
}
