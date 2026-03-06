/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

open class FrameworksLabelCaptureAdvancedOverlayListener: NSObject, LabelCaptureAdvancedOverlayDelegate {
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

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay,
                                            viewFor capturedLabel: CapturedLabel) -> UIView? {
        if emitter.hasListener(for: .viewForLabel) {
            viewForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return nil
    }
    
    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            anchorFor capturedLabel: CapturedLabel) -> Anchor {
        if emitter.hasListener(for: .anchorForLabel) {
            anchorForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return .center
    }
    
    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            offsetFor capturedLabel: CapturedLabel) -> PointWithUnit {
        if emitter.hasListener(for: .offsetForLabel) {
            offsetForLabelEvent.emit(on: emitter, payload: ["label": capturedLabel.jsonString])
        }
        return .zero
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            viewFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> UIView? {
        if emitter.hasListener(for: .viewForFieldOfLabel) {
            let payload = [
                "field": capturedField.jsonString,
                "identifier": FrameworksLabelCaptureSession.getFieldKey(
                    trackingId: capturedLabel.trackingId,
                    fieldName: capturedField.name
                )
            ]
            viewForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return nil
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            anchorFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> Anchor {
        if emitter.hasListener(for: .anchorForFieldOfLabel) {
            let payload = [
                "field": capturedField.jsonString,
                "identifier": FrameworksLabelCaptureSession.getFieldKey(
                    trackingId: capturedLabel.trackingId,
                    fieldName: capturedField.name
                )
            ]
            anchorForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .center
    }

    public func labelCaptureAdvancedOverlay(_ overlay: LabelCaptureAdvancedOverlay, 
                                            offsetFor capturedField: LabelField,
                                            of capturedLabel: CapturedLabel) -> PointWithUnit {
        if emitter.hasListener(for: .offsetForFieldOfLabel) {
            let payload = [
                "field": capturedField.jsonString,
                "identifier": FrameworksLabelCaptureSession.getFieldKey(
                    trackingId: capturedLabel.trackingId,
                    fieldName: capturedField.name
                )
            ]
            offsetForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .zero
    }
}
