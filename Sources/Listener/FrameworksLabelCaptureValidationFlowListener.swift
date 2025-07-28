/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public enum FrameworksLabelCaptureValidationFlowEvents: String, CaseIterable {
    case didCaptureLabelWithFields = "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
}

extension Event {
    init(_ event: FrameworksLabelCaptureValidationFlowEvents) {
        self.init(name: event.rawValue)
    }
}

extension Emitter {
    func hasListener(for event: FrameworksLabelCaptureValidationFlowEvents) -> Bool {
        hasListener(for: event.rawValue)
    }
}

open class FrameworksLabelCaptureValidationFlowListener: NSObject, LabelCaptureValidationFlowDelegate {
    private let emitter: Emitter

    public init(emitter: Emitter) {
        self.emitter = emitter
    }

    private let didCaptureLabelWithEvent = Event(.didCaptureLabelWithFields)

    public func labelCaptureValidationFlowOverlay(_ overlay: LabelCaptureValidationFlowOverlay, didCaptureLabelWith fields: [LabelField]) {
        if (!emitter.hasListener(for: .didCaptureLabelWithFields)) {

            didCaptureLabelWithEvent.emit(on: emitter, payload: ["fields": fields.map { $0.jsonString }])
        }

    }
}
