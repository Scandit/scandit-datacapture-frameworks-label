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

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        viewFor capturedLabel: CapturedLabel
    ) -> UIView? {
        if emitter.hasListener(for: .viewForLabel) {
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel(
                label: capturedLabel.jsonString,
                event: FrameworksLabelCaptureEvent.viewForLabel.rawValue
            ).toDictionary()
            viewForLabelEvent.emit(on: emitter, payload: payload)
        }
        return nil
    }

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        anchorFor capturedLabel: CapturedLabel
    ) -> Anchor {
        if emitter.hasListener(for: .anchorForLabel) {
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel(
                label: capturedLabel.jsonString,
                event: FrameworksLabelCaptureEvent.anchorForLabel.rawValue
            ).toDictionary()
            anchorForLabelEvent.emit(on: emitter, payload: payload)
        }
        return .center
    }

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        offsetFor capturedLabel: CapturedLabel
    ) -> PointWithUnit {
        if emitter.hasListener(for: .offsetForLabel) {
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel(
                label: capturedLabel.jsonString,
                event: FrameworksLabelCaptureEvent.offsetForLabel.rawValue
            ).toDictionary()
            offsetForLabelEvent.emit(on: emitter, payload: payload)
        }
        return .zero
    }

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        viewFor capturedField: LabelField,
        of capturedLabel: CapturedLabel
    ) -> UIView? {
        if emitter.hasListener(for: .viewForFieldOfLabel) {
            let identifier = FrameworksLabelCaptureSession.getFieldKey(
                trackingId: capturedLabel.trackingId,
                fieldName: capturedField.name
            )
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel(
                field: capturedField.jsonString,
                identifier: identifier,
                event: FrameworksLabelCaptureEvent.viewForFieldOfLabel.rawValue
            ).toDictionary()
            viewForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return nil
    }

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        anchorFor capturedField: LabelField,
        of capturedLabel: CapturedLabel
    ) -> Anchor {
        if emitter.hasListener(for: .anchorForFieldOfLabel) {
            let identifier = FrameworksLabelCaptureSession.getFieldKey(
                trackingId: capturedLabel.trackingId,
                fieldName: capturedField.name
            )
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel(
                field: capturedField.jsonString,
                identifier: identifier,
                event: FrameworksLabelCaptureEvent.anchorForFieldOfLabel.rawValue
            ).toDictionary()
            anchorForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .center
    }

    public func labelCaptureAdvancedOverlay(
        _ overlay: LabelCaptureAdvancedOverlay,
        offsetFor capturedField: LabelField,
        of capturedLabel: CapturedLabel
    ) -> PointWithUnit {
        if emitter.hasListener(for: .offsetForFieldOfLabel) {
            let identifier = FrameworksLabelCaptureSession.getFieldKey(
                trackingId: capturedLabel.trackingId,
                fieldName: capturedField.name
            )
            let payload = SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel(
                field: capturedField.jsonString,
                identifier: identifier,
                event: FrameworksLabelCaptureEvent.offsetForFieldOfLabel.rawValue
            ).toDictionary()
            offsetForFieldOfLabelEvent.emit(on: emitter, payload: payload)
        }
        return .zero
    }
}
