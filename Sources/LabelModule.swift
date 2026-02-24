/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

enum FrameworksLabelCaptureError: Error {
    case noSession
    case noSuchLabel(Int)
    case noSuchField(Int, String)
    case missingFieldName
    case invalidBrush(String)
    case noAdvancedOverlay
}

open class LabelModule: NSObject, FrameworkModule {
    private let deserializer: LabelCaptureDeserializer
    private let emitter: Emitter
    private let listener: FrameworksLabelCaptureListener
    private let basicOverlayListener: FrameworksLabelCaptureBasicOverlayListener
    private let advancedOverlayListener: FrameworksLabelCaptureAdvancedOverlayListener
    private let captureContext = DefaultFrameworksCaptureContext.shared
    let sessionHolder = SessionHolder<FrameworksLabelCaptureSession>()
    var advancedOverlayViewCache: AdvancedOverlayViewCache?

    private let didTapViewForFieldOfLabelEvent = Event(.didTapOnViewForFieldOfLabel)

    private var modeEnabled = AtomicBool(true)

    private var dataCaptureView: DataCaptureView?
    
    var advancedOverlay: LabelCaptureAdvancedOverlay? = nil
    
    var basicOverlay: LabelCaptureBasicOverlay? = nil

    private var labelCapture: LabelCapture? {
        willSet {
            labelCapture?.removeListener(listener)
        }
        didSet {
            labelCapture?.addListener(listener)
        }
    }

    public init(emitter: Emitter) {
        self.emitter = emitter
        self.deserializer = LabelCaptureDeserializer()
        self.listener = FrameworksLabelCaptureListener(emitter: emitter, sessionHolder: sessionHolder)
        self.basicOverlayListener = FrameworksLabelCaptureBasicOverlayListener(emitter: emitter)
        self.advancedOverlayListener = FrameworksLabelCaptureAdvancedOverlayListener(emitter: emitter)
    }

    public func didStart() {
        deserializer.delegate = self
        Deserializers.Factory.add(deserializer)
        DeserializationLifeCycleDispatcher.shared.attach(observer: self)
        advancedOverlayViewCache = DefaultAdvancedOverlayViewCache()
    }

    public func didStop() {
        deserializer.delegate = nil
        Deserializers.Factory.remove(deserializer)
        DeserializationLifeCycleDispatcher.shared.detach(observer: self)
        advancedOverlayViewCache = nil
    }

    public let defaults = LabelCaptureDefaults.shared

    public func addListener() {
        listener.enable()
    }

    public func removeListener() {
        listener.disable()
    }

    public func addBasicOverlayListener() {
        basicOverlayListener.enable()
    }

    public func removeBasicOverlayListener() {
        basicOverlayListener.disable()
    }

    public func addAdvancedOverlayListener() {
        advancedOverlayListener.enable()
    }

    public func removeAdvancedOverlayListener() {
        advancedOverlayListener.disable()
    }

    public func finishDidUpdateCallback(enabled: Bool) {
        listener.finishDidUpdateCallback(enabled: enabled)
    }

    public func setModeEnabled(enabled: Bool) {
        modeEnabled.value = enabled
        labelCapture?.isEnabled = enabled
    }

    public func isModeEnabled() -> Bool {
        return labelCapture?.isEnabled == true
    }

    public func label(for labelTrackingId: Int,
                      frameSequenceId: Int? = nil) throws -> CapturedLabel {
        guard let label = sessionHolder.value?.getLabel(byId: labelTrackingId) else {
            throw FrameworksLabelCaptureError.noSuchLabel(labelTrackingId)
        }
        return label
    }

    public func labelAndField(for labelTrackingId: Int,
                              fieldName: String) throws -> (CapturedLabel, LabelField) {
        guard let label = sessionHolder.value?.getLabel(byId: labelTrackingId) else {
            throw FrameworksLabelCaptureError.noSuchLabel(labelTrackingId)
        }
        let labelFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: labelTrackingId, fieldName: fieldName)
        guard let labelField = sessionHolder.value?.getField(byKey: labelFieldKey) else {
            throw FrameworksLabelCaptureError.noSuchField(labelTrackingId, fieldName)
        }
        return (label, labelField)
    }
    
    public func labelAndField(for labelFieldIdentifier: String) throws -> (CapturedLabel, LabelField) {
        guard let label = sessionHolder.value?.getLabel(byFieldKey: labelFieldIdentifier) else {
            throw FrameworksLabelCaptureError.noSuchField(0, labelFieldIdentifier)
        }
        guard let labelField = sessionHolder.value?.getField(byKey: labelFieldIdentifier) else {
            throw FrameworksLabelCaptureError.noSuchField(0, labelFieldIdentifier)
        }
        return (label, labelField)
    }

    public func setBrushForLabel(brushForLabel: BrushForLabelField, result: FrameworksResult) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }
        
        do {
            guard let label = session.getLabel(byId: brushForLabel.labelTrackingId) else {
                throw FrameworksLabelCaptureError.noSuchLabel(brushForLabel.labelTrackingId)
            }
            guard let brushJson = brushForLabel.brushJson else {
                return
            }
            guard let brush = Brush(jsonString: brushJson) else {
                result.reject(error: FrameworksLabelCaptureError.invalidBrush(brushJson))
                return
            }
            if let overlay: LabelCaptureBasicOverlay = basicOverlay {
                overlay.setBrush(brush, for: label)
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func setBrushForFieldOfLabel(brushForFieldOfLabel: BrushForLabelField, result: FrameworksResult) {
        guard let fieldName = brushForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }

        guard let (label, field) = getField(forLabel: brushForFieldOfLabel.labelTrackingId,
                                          fieldName: fieldName,
                                          result: result),
              let brush = createBrush(from: brushForFieldOfLabel.brushJson, result: result) else {
            return
        }

        withBasicOverlay({ overlay in
            overlay.setBrush(brush, for: field, of: label)
            return
        }, result: result) { _ in
            result.success()
        }
    }

    public func setViewForCapturedLabel(viewForLabel: ViewForLabel, result: FrameworksResult) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        guard let label = session.getLabel(byId: viewForLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(viewForLabel.trackingId))
            return
        }
        if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
            dispatchMain {
                overlay.setView(viewForLabel.view, for: label)
            }
        }
        result.success()
    }

    public func setViewForCapturedLabel(with viewParams: [String: Any?], result: FrameworksResult) {
        guard let identifier = viewParams["identifier"] as? Int,
              let label = getLabel(byId: identifier, result: result) else {
            return
        }

        let viewData = viewParams["view"] as? Data

        withAdvancedOverlay({ overlay in
            if let view = self.createView(from: viewData, identifier: String(identifier)) {
                overlay.setView(view, for: label)
            }
            return
        }, result: result) { _ in
            result.success()
        }
    }

    public func setViewForCapturedLabelField(with viewParams: [String: Any?], result: FrameworksResult) {
        guard let overlay: LabelCaptureAdvancedOverlay = advancedOverlay else {
            result.reject(error: FrameworksLabelCaptureError.noAdvancedOverlay)
            return
        }

        guard let identifier = viewParams["identifier"] as? String else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }

        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier),
              let labelField = sessionHolder.value?.getField(byKey: identifier) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchField(0, identifier))
            return
        }

        let viewData = viewParams["view"] as? Data

        dispatchMain {
            let view = viewData.flatMap { data in
                self.advancedOverlayViewCache?.getOrCreateView(
                    fromBase64EncodedData: data,
                    withIdentifier: identifier
                )
            }

            if let view = view {
                overlay.setView(view, for: labelField, of: label)
            }
            result.success()
        }
    }
    
    
    public func setViewForCapturedLabelField(for label: CapturedLabel, and labelField: LabelField, view: UIView?, result: FrameworksResult) {
        guard let overlay: LabelCaptureAdvancedOverlay = advancedOverlay else {
            result.reject(error: FrameworksLabelCaptureError.noAdvancedOverlay)
            return
        }
        dispatchMain {
            overlay.setView(view, for: labelField, of: label)
            result.success()
        }
    }

    public func setAnchorForCapturedLabel(anchorForLabel: AnchorForLabel, result: FrameworksResult) {
        guard let label = sessionHolder.value?.getLabel(byId: anchorForLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(anchorForLabel.trackingId))
            return
        }

        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.setAnchor(anchorForLabel.anchor, for: label)
            }
        }
        result.success()
    }

    public func setOffsetForCapturedLabel(offsetForLabel: OffsetForLabel, result: FrameworksResult) {
        guard let label = sessionHolder.value?.getLabel(byId: offsetForLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(offsetForLabel.trackingId))
            return
        }

        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.setOffset(offsetForLabel.offset, for: label)
            }
        }
        result.success()
    }

    public func setViewForFieldOfLabel(viewForFieldOfLabel: ViewForLabel, result: FrameworksResult) {
        guard let fieldName = viewForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: viewForFieldOfLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(viewForFieldOfLabel.trackingId))
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: viewForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchField(viewForFieldOfLabel.trackingId, fieldName))
            return
        }

        let view = viewForFieldOfLabel.view
        view?.didTap = { [weak self] in
            guard let self = self else { return }
            self.didTapViewForFieldOfLabelEvent.emit(
                on: self.emitter,
                payload: [
                    "label": label.jsonString,
                    "field": field.jsonString
                ]
            )
        }
        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.setView(view, for: field, of: label)
            }
        }
        result.success()
    }

    public func setAnchorForFieldOfLabel(anchorForFieldOfLabel: AnchorForLabel, result: FrameworksResult) {
        guard let fieldName = anchorForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: anchorForFieldOfLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(anchorForFieldOfLabel.trackingId))
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: anchorForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchField(anchorForFieldOfLabel.trackingId, fieldName))
            return
        }
        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.setAnchor(anchorForFieldOfLabel.anchor, for: field, of: label)
            }
        }
        result.success()
    }

    public func setOffsetForFieldOfLabel(offsetForFieldOfLabel: OffsetForLabel, result: FrameworksResult) {
        guard let fieldName = offsetForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: offsetForFieldOfLabel.trackingId) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(offsetForFieldOfLabel.trackingId))
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: offsetForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchField(offsetForFieldOfLabel.trackingId, fieldName))
            return
        }
        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.setOffset(offsetForFieldOfLabel.offset, for: field, of: label)
            }
        }
        result.success()
    }

    public func clearTrackedCapturedLabelViews() {
        if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
            dispatchMain {
                overlay.clearTrackedCapturedLabelViews()
            }
        }
    }

    public func updateModeFromJson(modeJson: String, result: FrameworksResult) {
        guard let mode = labelCapture else {
            result.success(result: nil)
            return
        }
        do {
            try deserializer.updateMode(mode, fromJSONString: modeJson)
            result.success()
        } catch {
            result.reject(error: error)
        }
    }

    public func applyModeSettings(modeSettingsJson: String, result: FrameworksResult) {
        guard let mode = labelCapture else {
            result.success(result: nil)
            return
        }
        do {
            let settings = try deserializer.settings(fromJSONString: modeSettingsJson)
            mode.apply(settings)
            result.success()
        } catch {
            result.reject(error: error)
        }
    }

    public func updateBasicOverlay(overlayJson: String, result: FrameworksResult) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let view = DataCaptureViewHandler.shared.topmostDataCaptureView {
                    if let overlay: LabelCaptureBasicOverlay = basicOverlay {
                        DataCaptureViewHandler.shared.removeOverlayFromView(view, overlay: overlay)
                    }
                    try self.dataCaptureView(addOverlay: overlayJson, to: view)
                }
                result.success(result: nil)
            } catch {
                result.reject(error: error)
            }
        }
        dispatchMain(block)
    }

    public func updateAdvancedOverlay(overlayJson: String, result: FrameworksResult) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let view = DataCaptureViewHandler.shared.topmostDataCaptureView {
                    if let overlay: LabelCaptureAdvancedOverlay = advancedOverlay {
                        DataCaptureViewHandler.shared.removeOverlayFromView(view, overlay: overlay)
                    }
                    try self.dataCaptureView(addOverlay: overlayJson, to: view)
                }
                result.success(result: nil)
            } catch {
                result.reject(error: error)
            }
        }
        dispatchMain(block)
    }

    func onModeRemovedFromContext() {
        labelCapture = nil
        basicOverlay = nil
        advancedOverlay = nil
    }
}

extension LabelModule: LabelCaptureDeserializerDelegate {
    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didStartDeserializingMode mode: LabelCapture,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didFinishDeserializingMode mode: LabelCapture,
                                         from JSONValue: JSONValue) {
        mode.isEnabled = modeEnabled.value
        labelCapture = mode

    }

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didStartDeserializingSettings settings: LabelCaptureSettings,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didFinishDeserializingSettings settings: LabelCaptureSettings,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didStartDeserializingBasicOverlay overlay: LabelCaptureBasicOverlay,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didFinishDeserializingBasicOverlay overlay: LabelCaptureBasicOverlay,
                                         from JSONValue: JSONValue) {
        basicOverlay = overlay
        overlay.delegate = self.basicOverlayListener
    }

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didStartDeserializingAdvancedOverlay overlay: LabelCaptureAdvancedOverlay,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didFinishDeserializingAdvancedOverlay overlay: LabelCaptureAdvancedOverlay,
                                         from JSONValue: JSONValue) {
        advancedOverlay = overlay
        overlay.delegate = self.advancedOverlayListener
    }
}

extension LabelModule: DeserializationLifeCycleObserver {
    public func dataCaptureContext(addMode modeJson: String) throws {
        if JSONValue(string: modeJson).string(forKey: "type") != "labelCapture" {
            return
        }

        guard let dcContext = captureContext.context else {
            return
        }
        do {
            let mode = try deserializer.mode(fromJSONString: modeJson, with: dcContext)
            captureContext.addMode(mode: mode)
        }catch {
            print(error)
        }
    }

    public func dataCaptureContext(removeMode modeJson: String) {
        if JSONValue(string: modeJson).string(forKey: "type") != "labelCapture" {
            return
        }

        guard let mode = labelCapture else {
            return
        }
        captureContext.removeMode(mode: mode)
        onModeRemovedFromContext()
    }

    public func dataCaptureContextAllModeRemoved() {
        onModeRemovedFromContext()
    }

    public func didDisposeDataCaptureContext() {
        onModeRemovedFromContext()
    }

    public func dataCaptureView(addOverlay overlayJson: String, to view: DataCaptureView) throws {
        let overlayType = JSONValue(string: overlayJson).string(forKey: "type")
        if overlayType != "labelCaptureBasic" && overlayType != "labelCaptureAdvanced" {
            return
        }

        guard let mode = labelCapture else {
            return
        }

        try dispatchMainSync {
            let overlay: DataCaptureOverlay = (overlayType == "labelCaptureBasic") ?
            try deserializer.basicOverlay(fromJSONString: overlayJson, withMode: mode) :
            try deserializer.advancedOverlay(fromJSONString: overlayJson, withMode: mode)

            DataCaptureViewHandler.shared.addOverlayToView(view, overlay: overlay)
        }
    }
}
