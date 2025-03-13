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
    case anchorForLabel = "LabelCaptureAdvancedOverlayListener.anchorForLabel"
    case offsetForLabel = "LabelCaptureAdvancedOverlayListener.offsetForLabel"
    case didTapOnViewForLabel = "LabelCaptureAdvancedOverlayListener.didTapOnViewForLabel"
    case viewForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
    case anchorForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
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

    public init(emitter: Emitter) {
        self.emitter = emitter
    }

    private var isEnabled = AtomicBool()

    private var sessionHolder = SessionHolder<LabelCaptureSession>()
    
    private let didUpdateEvent = EventWithResult<Bool>(event: Event(.didUpdateSession))

    public func labelCapture(_ labelCapture: LabelCapture,
                             didUpdate session: LabelCaptureSession,
                             frameData: FrameData) {
        guard isEnabled.value, emitter.hasListener(for: .didUpdateSession) else { return }
        
        let frameId = LastFrameData.shared.addToCache(frameData: frameData)
        defer { LastFrameData.shared.removeFromCache(frameId: frameId) }
        
        sessionHolder.value = session
        let result = didUpdateEvent.emit(on: emitter,
                                         payload: ["session": session.jsonString,
                                                   "frameId": frameId]) ?? true
        labelCapture.isEnabled = result
    }

    public func finishDidUpdateCallback(enabled: Bool) {
        didUpdateEvent.unlock(value: enabled)
    }

    public func enable() {
        if isEnabled.value {
            return
        }
        isEnabled.value = true
    }

    public func disable() {
        if isEnabled.value {
            isEnabled.value = false
            didUpdateEvent.reset()
        }
    }

    public func label(with id: Int) throws -> CapturedLabel {
        guard let session = sessionHolder.value else {
            throw FrameworksLabelCaptureError.noSession
        }
        if let label = session.capturedLabels.first(where: { $0.trackingId == id }) {
            return label
        }
        throw FrameworksLabelCaptureError.noSuchLabel(id)
    }

    public func labelAndField(with id: Int, and fieldName: String) throws -> (CapturedLabel, LabelField) {
        let label = try label(with: id)
        guard let field = label.fields.first(where: { $0.name == fieldName }) else {
            throw FrameworksLabelCaptureError.noSuchField(id, fieldName)
        }
        return (label, field)
    }
}
