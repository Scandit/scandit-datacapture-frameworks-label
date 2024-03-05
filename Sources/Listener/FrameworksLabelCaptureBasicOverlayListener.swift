/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public class FrameworksLabelCaptureBasicOverlayListener: NSObject, LabelCaptureBasicOverlayDelegate {
    private let emitter: Emitter

    private let brushForFieldOfLabelEvent = Event(.brushForFieldOfLabel)
    private let brushForLabelEvent = Event(.brushForLabel)
    private let didTapLabelEvent = Event(.didTapLabel)

    private var isEnabled = AtomicBool()

    public init(emitter: Emitter) {
        self.emitter = emitter
    }

    public func labelCaptureBasicOverlay(_ overlay: LabelCaptureBasicOverlay,
                                         brushFor field: LabelField,
                                         of label: CapturedLabel) -> Brush? {
        guard isEnabled.value, emitter.hasListener(for: .brushForFieldOfLabel) else { return nil }
        let payload = [
            "field": field.jsonString,
            "label": label.jsonString
        ]
        brushForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        return overlay.capturedFieldBrush
    }
    
    public func labelCaptureBasicOverlay(_ overlay: LabelCaptureBasicOverlay, 
                                         brushFor label: CapturedLabel) -> Brush? {
        guard isEnabled.value, emitter.hasListener(for: .brushForLabel) else { return nil }
        brushForLabelEvent.emit(on: emitter, payload: ["label": label.jsonString])
        return overlay.labelBrush
    }
    
    public func labelCaptureBasicOverlay(_ overlay: LabelCaptureBasicOverlay, 
                                         didTap label: CapturedLabel) {
        guard isEnabled.value, emitter.hasListener(for: .didTapLabel) else { return }
        didTapLabelEvent.emit(on: emitter, payload: ["label": label.jsonString])
    }

    func enable() {
        if isEnabled.value { return }
        isEnabled.value = true
    }

    func disable() {
        guard isEnabled.value else { return }
        isEnabled.value = false
    }
}
