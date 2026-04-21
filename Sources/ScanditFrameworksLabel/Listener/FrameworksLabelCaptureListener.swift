/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public enum FrameworksLabelCaptureEvent: String, CaseIterable {
    case didUpdateSession = "LabelCaptureListener.didUpdateSession"
    case brushForFieldOfLabel = "LabelCaptureBasicOverlayListener.brushForFieldOfLabel"
    case brushForLabel = "LabelCaptureBasicOverlayListener.brushForLabel"
    case didTapLabel = "LabelCaptureBasicOverlayListener.didTapLabel"
    case viewForLabel = "LabelCaptureAdvancedOverlayListener.viewForLabel"
    case viewForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
    case anchorForLabel = "LabelCaptureAdvancedOverlayListener.anchorForLabel"
    case anchorForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
    case offsetForLabel = "LabelCaptureAdvancedOverlayListener.offsetForLabel"
    case offsetForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
    case didTapOnViewForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.didTapOnViewForFieldOfLabel"
}

extension Event {
    init(_ event: FrameworksLabelCaptureEvent) {
        self.init(name: event.rawValue)
    }
}

extension Emitter {
    func hasListener(for event: FrameworksLabelCaptureEvent) -> Bool {
        hasListener(for: event.rawValue)
    }
}

open class FrameworksLabelCaptureListener: NSObject, LabelCaptureListener {
    private let emitter: Emitter
    private let sessionHolder: SessionHolder<FrameworksLabelCaptureSession>
    private let isEnabled: AtomicValue<Bool> = AtomicValue(false)
    private let modeId: Int

    public init(emitter: Emitter, modeId: Int, sessionHolder: SessionHolder<FrameworksLabelCaptureSession>) {
        self.emitter = emitter
        self.modeId = modeId
        self.sessionHolder = sessionHolder
    }

    private let didUpdateEvent = EventWithResult<Bool>(event: Event(.didUpdateSession))

    public func labelCapture(
        _ labelCapture: LabelCapture,
        didUpdate session: LabelCaptureSession,
        frameData: FrameData
    ) {

        sessionHolder.value = FrameworksLabelCaptureSession.create(from: session)

        if !isEnabled.value {
            return
        }

        if !emitter.hasListener(for: .didUpdateSession) {
            return
        }

        let frameId = LastFrameData.shared.addToCache(frameData: frameData)
        defer { LastFrameData.shared.removeFromCache(frameId: frameId) }

        let payload: [String: Any?] = [
            "session": session.jsonString,
            "frameId": frameId,
            "modeId": modeId,
        ]

        let result = didUpdateEvent.emit(on: emitter, payload: payload) ?? true
        labelCapture.isEnabled = result
    }

    public func finishDidUpdateCallback(enabled: Bool) {
        didUpdateEvent.unlock(value: enabled)
    }

    public func setEnabled(enabled: Bool) {
        isEnabled.value = enabled
    }

    public func reset() {
        sessionHolder.value = nil
        didUpdateEvent.reset()
    }
}
