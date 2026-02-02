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

/// Factory for creating LabelCaptureModule commands from method calls.
/// Maps method names to their corresponding command implementations.
public class LabelCaptureModuleCommandFactory {
    /// Creates a command from a FrameworksMethodCall.
    ///
    /// - Parameter module: The LabelCaptureModule instance to bind to the command
    /// - Parameter method: The method call containing method name and arguments
    /// - Returns: The corresponding command, or nil if method is not recognized
    public static func create(module: LabelCaptureModule, _ method: FrameworksMethodCall) -> LabelCaptureModuleCommand?
    {
        switch method.method {
        case "finishLabelCaptureListenerDidUpdateSession":
            return FinishLabelCaptureListenerDidUpdateSessionCommand(module: module, method)
        case "addLabelCaptureListener":
            return AddLabelCaptureListenerCommand(module: module, method)
        case "removeLabelCaptureListener":
            return RemoveLabelCaptureListenerCommand(module: module, method)
        case "setLabelCaptureModeEnabledState":
            return SetLabelCaptureModeEnabledStateCommand(module: module, method)
        case "updateLabelCaptureMode":
            return UpdateLabelCaptureModeCommand(module: module, method)
        case "updateLabelCaptureSettings":
            return UpdateLabelCaptureSettingsCommand(module: module, method)
        case "updateLabelCaptureFeedback":
            return UpdateLabelCaptureFeedbackCommand(module: module, method)
        case "setViewForCapturedLabel":
            return SetViewForCapturedLabelCommand(module: module, method)
        case "setViewForCapturedLabelFromBytes":
            return SetViewForCapturedLabelFromBytesCommand(module: module, method)
        case "setViewForCapturedLabelField":
            return SetViewForCapturedLabelFieldCommand(module: module, method)
        case "setViewForCapturedLabelFieldFromBytes":
            return SetViewForCapturedLabelFieldFromBytesCommand(module: module, method)
        case "setAnchorForCapturedLabel":
            return SetAnchorForCapturedLabelCommand(module: module, method)
        case "setAnchorForCapturedLabelField":
            return SetAnchorForCapturedLabelFieldCommand(module: module, method)
        case "setOffsetForCapturedLabel":
            return SetOffsetForCapturedLabelCommand(module: module, method)
        case "setOffsetForCapturedLabelField":
            return SetOffsetForCapturedLabelFieldCommand(module: module, method)
        case "clearCapturedLabelViews":
            return ClearCapturedLabelViewsCommand(module: module, method)
        case "addLabelCaptureBasicOverlayListener":
            return AddLabelCaptureBasicOverlayListenerCommand(module: module, method)
        case "removeLabelCaptureBasicOverlayListener":
            return RemoveLabelCaptureBasicOverlayListenerCommand(module: module, method)
        case "updateLabelCaptureBasicOverlay":
            return UpdateLabelCaptureBasicOverlayCommand(module: module, method)
        case "setLabelCaptureBasicOverlayBrushForLabel":
            return SetLabelCaptureBasicOverlayBrushForLabelCommand(module: module, method)
        case "setLabelCaptureBasicOverlayBrushForFieldOfLabel":
            return SetLabelCaptureBasicOverlayBrushForFieldOfLabelCommand(module: module, method)
        case "addLabelCaptureAdvancedOverlayListener":
            return AddLabelCaptureAdvancedOverlayListenerCommand(module: module, method)
        case "removeLabelCaptureAdvancedOverlayListener":
            return RemoveLabelCaptureAdvancedOverlayListenerCommand(module: module, method)
        case "updateLabelCaptureAdvancedOverlay":
            return UpdateLabelCaptureAdvancedOverlayCommand(module: module, method)
        case "registerListenerForValidationFlowEvents":
            return RegisterListenerForValidationFlowEventsCommand(module: module, method)
        case "unregisterListenerForValidationFlowEvents":
            return UnregisterListenerForValidationFlowEventsCommand(module: module, method)
        case "updateLabelCaptureValidationFlowOverlay":
            return UpdateLabelCaptureValidationFlowOverlayCommand(module: module, method)
        case "registerListenerForAdaptiveRecognitionOverlayEvents":
            return RegisterListenerForAdaptiveRecognitionOverlayEventsCommand(module: module, method)
        case "unregisterListenerForAdaptiveRecognitionOverlayEvents":
            return UnregisterListenerForAdaptiveRecognitionOverlayEventsCommand(module: module, method)
        case "applyLabelCaptureAdaptiveRecognitionSettings":
            return ApplyLabelCaptureAdaptiveRecognitionSettingsCommand(module: module, method)
        default:
            return nil
        }
    }
}
