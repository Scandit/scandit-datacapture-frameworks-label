/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public class FrameworksLabelCaptureAdvancedOverlayListener: NSObject, LabelCaptureAdvancedOverlayDelegate {
    private let emitter: Emitter

    public init(emitter: Emitter) {
        self.emitter = emitter
    }

    private var viewForLabelEvent = Event(.viewForLabel)
    private var anchorForLabelEvent = Event(.anchorForLabel)
    private var offsetForLabelEvent = Event(.offsetForLabel)
    private var viewForFieldOfLabelEvent = Event(.viewForFieldOfLabel)
    private var anchorForFieldOfLabelEvent = Event(.anchorForFieldOfLabel)
    private var offsetForFieldOfLabelEvent = Event(.offsetForFieldOfLabel)

    private var isEnabled = AtomicBool()

    func enable() {
        if isEnabled.value {
            return
        }
        isEnabled.value = true
    }

    func disable() {
        guard isEnabled.value else { return }
        isEnabled.value = false
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay,
                                            viewFor capturedLabel: CapturedLabel) -> UIView? {
        if isEnabled.value, emitter.hasListener(for: .viewForLabel) {
            viewForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return nil
    }
    
    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            anchorFor capturedLabel: CapturedLabel) -> Anchor {
        if isEnabled.value, emitter.hasListener(for: .anchorForLabel) {
            anchorForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return .center
    }
    
    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            offsetFor capturedLabel: CapturedLabel) -> PointWithUnit {
        if isEnabled.value, emitter.hasListener(for: .offsetForLabel) {
            offsetForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return .zero
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            viewFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> UIView? {
        if isEnabled.value, emitter.hasListener(for: .viewForFieldOfLabel) {
            let payload = [
                "label": capturedLabel.jsonString,
                "field": capturedField.jsonString
            ]
            viewForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return nil
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            anchorFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> Anchor {
        if isEnabled.value, emitter.hasListener(for: .anchorForFieldOfLabel) {
            let payload = [
                "label": capturedLabel.jsonString,
                "field": capturedField.jsonString
            ]
            anchorForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .center
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            offsetFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> PointWithUnit {
        if isEnabled.value, emitter.hasListener(for: .offsetForFieldOfLabel) {
            let payload = [
                "label": capturedLabel.jsonString,
                "field": capturedField.jsonString
            ]
            offsetForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .zero
    }
}
