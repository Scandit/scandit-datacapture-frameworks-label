/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public enum FrameworksLabelCaptureValidationFlowEvents: String, CaseIterable {
    case didCaptureLabelWithFields = "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
    case didSubmitManualInputForField = "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
    case didUpdateValidationFlowResult = "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
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
    private let didSubmitManualInputForFieldEvent = Event(.didSubmitManualInputForField)

    public func labelCaptureValidationFlowOverlay(
        _ overlay: LabelCaptureValidationFlowOverlay,
        didCaptureLabelWith fields: [LabelField]
    ) {
        if emitter.hasListener(for: .didCaptureLabelWithFields) {
            didCaptureLabelWithEvent.emit(on: emitter, payload: ["fields": fields.map { $0.jsonString }])
        }
    }

    public func labelCaptureValidationFlowOverlay(
        _ overlay: LabelCaptureValidationFlowOverlay,
        didSubmitManualInputFor field: LabelField,
        replacingValue oldValue: String?,
        withValue newValue: String
    ) {
        if emitter.hasListener(for: .didSubmitManualInputForField) {
            didSubmitManualInputForFieldEvent.emit(
                on: emitter,
                payload: [
                    "fields": [field.jsonString],
                    "oldValue": oldValue as Any,
                    "newValue": newValue,
                ]
            )
        }
    }

    private let didUpdateValidationFlowResultEvent = EventWithResult<Bool>(event: Event(.didUpdateValidationFlowResult))

    public func labelCaptureValidationFlowOverlay(
        _ overlay: LabelCaptureValidationFlowOverlay,
        didUpdateResult type: LabelResultUpdateType,
        asyncId: Int,
        fields: [LabelField],
        frameData: (any FrameData)?
    ) {
        guard emitter.hasListener(for: .didUpdateValidationFlowResult) else { return }

        dispatchBackground {
            let frameId = frameData.map { LastFrameData.shared.addToCache(frameData: $0) }
            defer {
                if let frameId {
                    LastFrameData.shared.removeFromCache(frameId: frameId)
                }
            }

            self.didUpdateValidationFlowResultEvent.emit(
                on: self.emitter,
                payload: [
                    "fields": fields.map { $0.jsonString },
                    "type": type.jsonString,
                    "asyncId": asyncId,
                    "frameId": frameId,
                ]
            )
        }
    }

    public func finishValidationFlowResultUpdate() {
        didUpdateValidationFlowResultEvent.unlock(value: true)
    }
}

fileprivate extension LabelResultUpdateType {
    var jsonString: String {
        switch self {
        case .sync:
            return "Sync"
        case .asyncFinished:
            return "AsyncFinished"
        case .asyncStarted:
            return "AsyncStarted"
        @unknown default:
            fatalError("Unhandled LabelResultUpdateType case: \(self)")
        }
    }
}
