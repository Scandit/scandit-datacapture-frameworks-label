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
    case viewForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.viewForCapturedLabelField"
    case anchorForLabel = "LabelCaptureAdvancedOverlayListener.anchorForLabel"
    case anchorForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.anchorForCapturedLabelField"
    case offsetForLabel = "LabelCaptureAdvancedOverlayListener.offsetForLabel"
    case offsetForFieldOfLabel = "LabelCaptureAdvancedOverlayListener.offsetForCapturedLabelField"
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

    public init(emitter: Emitter, sessionHolder: SessionHolder<FrameworksLabelCaptureSession>) {
        self.emitter = emitter
        self.sessionHolder = sessionHolder
    }

    private var isEnabled = AtomicBool()
    
    private lazy var isLicenseArFull: Bool? = {
        // This check works only when the first frame has been processed
        return DefaultFrameworksCaptureContext.shared.context?.isFeatureSupported("barcode-ar-full")
    }()
    
    private let didUpdateEvent = EventWithResult<Bool>(event: Event(.didUpdateSession))

    public func labelCapture(_ labelCapture: LabelCapture,
                             didUpdate session: LabelCaptureSession,
                             frameData: FrameData) {
        guard isEnabled.value, emitter.hasListener(for: .didUpdateSession) else { return }
        
        let frameId = LastFrameData.shared.addToCache(frameData: frameData)
        defer { LastFrameData.shared.removeFromCache(frameId: frameId) }
        
        sessionHolder.value = FrameworksLabelCaptureSession.create(from: session)
        let result = didUpdateEvent.emit(on: emitter,
                                         payload: ["session": session.jsonString,
                                                   "frameId": frameId,
                                                   "isBarcodeArFull": isLicenseArFull
                                                  ]) ?? true
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
}
