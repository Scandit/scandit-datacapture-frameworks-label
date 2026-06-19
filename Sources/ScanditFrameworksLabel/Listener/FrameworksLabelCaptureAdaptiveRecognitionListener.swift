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
        if emitter.hasListener(for: .didRecognize) {
            didRecognizeEvent.emit(on: emitter, payload: ["result": result])
        }
    }

    public func labelCaptureAdaptiveRecognitionOverlayDidFail(_ overlay: LabelCaptureAdaptiveRecognitionOverlay) {
        if emitter.hasListener(for: .didFail) {
            didFailEvent.emit(on: emitter, payload: [:])
        }
    }
}
