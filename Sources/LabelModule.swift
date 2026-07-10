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
}

open class LabelModule: NSObject, FrameworkModule {
    private let deserializer: LabelCaptureDeserializer
    private let emitter: Emitter
    private let listener: FrameworksLabelCaptureListener
    private let basicOverlayListener: FrameworksLabelCaptureBasicOverlayListener
    private let advancedOverlayListener: FrameworksLabelCaptureAdvancedOverlayListener

    private let didTapViewForLabelEvent = Event(.didTapOnViewForLabel)
    private let didTapViewForFieldOfLabelEvent = Event(.didTapOnViewForFieldOfLabel)

    private var modeEnabled = AtomicBool(true)

    private var context: DataCaptureContext?
    private var dataCaptureView: DataCaptureView?

    private var labelCapture: LabelCapture? {
        willSet {
            labelCapture?.removeListener(listener)
        }
        didSet {
            labelCapture?.addListener(listener)
        }
    }

    public init(emitter: Emitter,
                listener: FrameworksLabelCaptureListener,
                basicOverlayListener: FrameworksLabelCaptureBasicOverlayListener,
                advancedOverlayListener: FrameworksLabelCaptureAdvancedOverlayListener,
                deserializer: LabelCaptureDeserializer = LabelCaptureDeserializer()) {
        self.emitter = emitter
        self.deserializer = deserializer
        self.listener = listener
        self.basicOverlayListener = basicOverlayListener
        self.advancedOverlayListener = advancedOverlayListener
    }
    
    public func didStart() {
        deserializer.delegate = self
        Deserializers.Factory.add(deserializer)
        DeserializationLifeCycleDispatcher.shared.attach(observer: self)
    }
    
    public func didStop() {
        deserializer.delegate = nil
        Deserializers.Factory.remove(deserializer)
        DeserializationLifeCycleDispatcher.shared.detach(observer: self)
    }

    public let defaults = LabelCaptureDefaults.shared.toEncodable()

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
        return try listener.label(with: labelTrackingId)
    }

    public func labelAndField(for labelTrackingId: Int, 
                              fieldName: String) throws -> (CapturedLabel, LabelField) {
        return try listener.labelAndField(with: labelTrackingId, 
                                          and: fieldName)
    }

    public func setBrushForLabel(brushForLabel: BrushForLabelField, result: FrameworksResult) {
        do {
            let label = try listener.label(with: brushForLabel.labelTrackingId)
            guard let brushJson = brushForLabel.brushJson else {
                return
            }
            guard let brush = Brush(jsonString: brushJson) else {
                result.reject(error: FrameworksLabelCaptureError.invalidBrush(brushJson))
                return
            }
            if let overlay: LabelCaptureBasicOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
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
        do {
            let (label, field) = try listener.labelAndField(with: brushForFieldOfLabel.labelTrackingId,
                                                            and: fieldName)
            
            guard let brushJson = brushForFieldOfLabel.brushJson else {
                return
            }
            
            guard let brush = Brush(jsonString: brushJson) else {
                result.reject(error: FrameworksLabelCaptureError.invalidBrush(brushJson))
                return
            }
            if let overlay: LabelCaptureBasicOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                overlay.setBrush(brush, for: field, of: label)
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func setViewForCapturedLabel(viewForLabel: ViewForLabel, result: FrameworksResult? = nil) {
        do {
            let label = try listener.label(with: viewForLabel.trackingId)
            let view = viewForLabel.view
            view?.didTap = { [weak self] in
                guard let self = self else { return }
                self.didTapViewForLabelEvent.emit(
                    on: self.emitter,
                    payload: ["label": label.jsonString]
                )
            }
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setView(viewForLabel.view, for: label)
                }
            }
        } catch {
            result?.reject(error: error)
            return
        }
        result?.success()
    }

    public func setAnchorForCapturedLabel(anchorForLabel: AnchorForLabel, result: FrameworksResult) {
        do {
            let label = try listener.label(with: anchorForLabel.trackingId)
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setAnchor(anchorForLabel.anchor, for: label)
                }
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func setOffsetForCapturedLabel(offsetForLabel: OffsetForLabel, result: FrameworksResult) {
        do {
            let label = try listener.label(with: offsetForLabel.trackingId)
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setOffset(offsetForLabel.offset, for: label)
                }
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func setViewForFieldOfLabel(viewForFieldOfLabel: ViewForLabel, result: FrameworksResult? = nil) {
        guard let fieldName = viewForFieldOfLabel.fieldName else {
            result?.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        do {
            let (label, field) = try listener.labelAndField(with: viewForFieldOfLabel.trackingId,
                                                            and: fieldName)
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
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setView(view, for: field, of: label)
                }
            }
        } catch {
            result?.reject(error: error)
            return
        }
        result?.success()
    }

    public func setAnchorForFieldOfLabel(anchorForFieldOfLabel: AnchorForLabel, result: FrameworksResult) {
        guard let fieldName = anchorForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        do {
            let (label, field) = try listener.labelAndField(with: anchorForFieldOfLabel.trackingId,
                                                            and: fieldName)
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setAnchor(anchorForFieldOfLabel.anchor, for: field, of: label)
                }
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func setOffsetForFieldOfLabel(offsetForFieldOfLabel: OffsetForLabel, result: FrameworksResult) {
        guard let fieldName = offsetForFieldOfLabel.fieldName else {
            result.reject(error: FrameworksLabelCaptureError.missingFieldName)
            return
        }
        do {
            let (label, field) = try listener.labelAndField(with: offsetForFieldOfLabel.trackingId,
                                                            and: fieldName)
            if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                dispatchMainSync {
                    overlay.setOffset(offsetForFieldOfLabel.offset, for: field, of: label)
                }
            }
        } catch {
            result.reject(error: error)
            return
        }
        result.success()
    }

    public func clearTrackedCapturedLabelViews() {
        if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
            dispatchMainSync {
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
        do {
            if let view = DataCaptureViewHandler.shared.topmostDataCaptureView {
                if let overlay: LabelCaptureBasicOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                    DataCaptureViewHandler.shared.removeOverlayFromView(view, overlay: overlay)
                }
                try dataCaptureView(addOverlay: overlayJson, to: view)
            }
            result.success(result: nil)
        } catch {
            result.reject(error: error)
        }
    }
    
    public func updateAdvancedOverlay(overlayJson: String, result: FrameworksResult) {
        do {
            if let view = DataCaptureViewHandler.shared.topmostDataCaptureView {
                if let overlay: LabelCaptureAdvancedOverlay = DataCaptureViewHandler.shared.findFirstOverlayOfType() {
                    DataCaptureViewHandler.shared.removeOverlayFromView(view, overlay: overlay)
                }
                try dataCaptureView(addOverlay: overlayJson, to: view)
            }
            result.success(result: nil)
        } catch {
            result.reject(error: error)
        }
    }
    
    func onModeRemovedFromContext() {
        labelCapture = nil
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
    }
    
    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer,
                                         didStartDeserializingAdvancedOverlay overlay: LabelCaptureAdvancedOverlay,
                                         from JSONValue: JSONValue) {}

    public func labelCaptureDeserializer(_ deserializer: LabelCaptureDeserializer, 
                                         didFinishDeserializingAdvancedOverlay overlay: LabelCaptureAdvancedOverlay,
                                         from JSONValue: JSONValue) {
    }
}

extension LabelModule: DeserializationLifeCycleObserver {
    public func dataCaptureContext(deserialized context: DataCaptureContext?) {
        self.context = context
    }
    
    public func dataCaptureContext(addMode modeJson: String) throws {
        if JSONValue(string: modeJson).string(forKey: "type") != "labelCapture" {
            return
        }
        
        guard let dcContext = context else {
            return
        }
        do {
            let mode = try deserializer.mode(fromJSONString: modeJson, with: dcContext)
            dcContext.addMode(mode)
        }catch {
            print(error)
        }
    }
    
    public func dataCaptureContext(removeMode modeJson: String) {
        if JSONValue(string: modeJson).string(forKey: "type") != "labelCapture" {
            return
        }
        
        guard let dcContext = context else {
            return
        }
        
        guard let mode = labelCapture else {
            return
        }
        dcContext.removeMode(mode)
        onModeRemovedFromContext()
    }
    
    public func dataCaptureContextAllModeRemoved() {
        onModeRemovedFromContext()
    }
    
    public func didDisposeDataCaptureContext() {
        context = nil
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
            
            (overlay as? LabelCaptureBasicOverlay)?.delegate = basicOverlayListener
            (overlay as? LabelCaptureAdvancedOverlay)?.delegate = advancedOverlayListener
            
            DataCaptureViewHandler.shared.addOverlayToView(view, overlay: overlay)
        }
    }
}
