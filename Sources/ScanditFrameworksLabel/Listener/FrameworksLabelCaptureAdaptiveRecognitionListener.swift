/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

open class FrameworksLabelCaptureAdaptiveRecognitionListener: NSObject, LabelCaptureAdaptiveRecognitionDelegate {

    private let emitter: Emitter

    public init(emitter: Emitter) {
        self.emitter = emitter
    }

    private var didRecognizeEvent = Event(.didRecognize)
    private var didFailEvent = Event(.didFail)

    public func labelCaptureAdaptiveRecognitionOverlay(
        _ overlay: LabelCaptureAdaptiveRecognitionOverlay,
        didRecognizeWith result: AdaptiveRecognitionResult
    ) {
        guard emitter.hasListener(for: .didRecognize) else { return }
        // The native result is an Objective-C class, not a Foundation JSON type; emitting it raw
        // makes the emitter's JSONSerialization abort (SIGABRT). Decode its JSONString into a
        // dictionary so the payload is a valid JSON object, matching the shape the framework layer
        // expects (`result` as an object, not a string). Drop the event on malformed JSON. (SDC-30555)
        guard let receiptResult = result as? ReceiptScanningResult,
            let resultObject = receiptResult.jsonString.decodeJSONObject()
        else {
            return
        }
        didRecognizeEvent.emit(on: emitter, payload: ["result": resultObject])
    }

    public func labelCaptureAdaptiveRecognitionOverlayDidFail(_ overlay: LabelCaptureAdaptiveRecognitionOverlay) {
        if emitter.hasListener(for: .didFail) {
            didFailEvent.emit(on: emitter, payload: [:])
        }
    }
}
