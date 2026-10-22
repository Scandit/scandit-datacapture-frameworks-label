/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Foundation
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
        // makes the emitter's JSONSerialization abort (SIGABRT). Decoding into the generated
        // SchemaTypes.ReceiptScanningResult both converts and checks the shape. (SDC-30555)
        guard let receiptResult = result as? ReceiptScanningResult else {
            logDropped("unsupported result type \(type(of: result))")
            return
        }
        guard let data = receiptResult.jsonString.data(using: .utf8) else {
            logDropped("jsonString is not valid UTF-8")
            return
        }
        let resultJSON: SchemaTypes.ReceiptScanningResult
        do {
            resultJSON = try JSONDecoder().decode(SchemaTypes.ReceiptScanningResult.self, from: data)
        } catch {
            logDropped("receipt does not match schema", error: error)
            return
        }
        let payload = SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized(
            result: resultJSON,
            event: FrameworksLabelCaptureEvent.didRecognize.rawValue
        ).toDictionary()
        didRecognizeEvent.emit(on: emitter, payload: payload)
    }

    private func logDropped(_ reason: String, error: Error? = nil) {
        ScanditLogger.shared.emit(
            level: .warn,
            category: .listener,
            source: "FrameworksLabelCaptureAdaptiveRecognitionListener",
            message: "didRecognizeWith: dropping recognition, \(reason)",
            error: error.map { LogRecordError(name: String(describing: type(of: $0)), message: "\($0)") }
        )
    }

    public func labelCaptureAdaptiveRecognitionOverlayDidFail(_ overlay: LabelCaptureAdaptiveRecognitionOverlay) {
        if emitter.hasListener(for: .didFail) {
            let payload = SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure(
                event: FrameworksLabelCaptureEvent.didFail.rawValue
            ).toDictionary()
            didFailEvent.emit(on: emitter, payload: payload)
        }
    }
}
