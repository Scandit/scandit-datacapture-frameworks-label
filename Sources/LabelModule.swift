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

open class LabelModule: BasicFrameworkModule<FrameworksLabelCaptureMode> {
    private let deserializer: LabelCaptureDeserializer
    private let emitter: Emitter
    private let basicOverlayListener: FrameworksLabelCaptureBasicOverlayListener
    private let validationFlowListener: FrameworksLabelCaptureValidationFlowListener
    private let advancedOverlayListener: FrameworksLabelCaptureAdvancedOverlayListener
    private let captureContext = DefaultFrameworksCaptureContext.shared
    let sessionHolder = SessionHolder<FrameworksLabelCaptureSession>()
    var advancedOverlayViewCache: AdvancedOverlayViewCache?

    private let captureViewHandler = DataCaptureViewHandler.shared

    private let didTapViewForFieldOfLabelEvent = Event(.didTapOnViewForFieldOfLabel)

    public init(emitter: Emitter,
                 deserializer: LabelCaptureDeserializer = LabelCaptureDeserializer(),
                 captureViewHandler: DataCaptureViewHandler = DataCaptureViewHandler.shared) {
        self.emitter = emitter
        self.deserializer = deserializer
        self.basicOverlayListener = FrameworksLabelCaptureBasicOverlayListener(emitter: emitter)
        self.advancedOverlayListener = FrameworksLabelCaptureAdvancedOverlayListener(emitter: emitter)
        self.validationFlowListener = FrameworksLabelCaptureValidationFlowListener(emitter: emitter)
    }

    public override func didStart() {
        Deserializers.Factory.add(deserializer)
        DeserializationLifeCycleDispatcher.shared.attach(observer: self)
        advancedOverlayViewCache = DefaultAdvancedOverlayViewCache()
    }

    public override func didStop() {
        Deserializers.Factory.remove(deserializer)
        DeserializationLifeCycleDispatcher.shared.detach(observer: self)
        advancedOverlayViewCache = nil
    }

    public let defaults = LabelCaptureDefaults.shared

    public func addListener(_ modeId: Int) {
        guard let mode = getModeFromCache(modeId) else {
            addPostModeCreationAction(modeId, action: {
                self.addListener(modeId)
            })
            return
        }
        mode.addListener()
    }

    public func removeListener(_ modeId: Int) {
        if let mode = getModeFromCache(modeId) {
            mode.removeListener()
        }
    }

    public func addBasicOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType() {
            overlay.delegate = basicOverlayListener
        }
    }

    public func removeBasicOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType() {
            overlay.delegate = nil
        }
    }

    public func addAdvancedOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            overlay.delegate = advancedOverlayListener
        }
    }

    public func removeAdvancedOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            overlay.delegate = nil
        }
    }

    public func addValidationFlowOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType() {
            overlay.delegate = validationFlowListener
        }
    }

    public func removeValidationFlowOverlayListener(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType() {
            overlay.delegate = nil
        }
    }

    public func finishDidUpdateCallback(modeId: Int, enabled: Bool) {
        if let mode = getModeFromCache(modeId) {
            mode.finishDidUpdateSession(enabled: enabled)
        }
    }

    public func setModeEnabled(modeId: Int, enabled: Bool) {
        guard let mode = self.getModeFromCache(modeId) else {
            return
        }
        mode.isEnabled = enabled
    }

    public func label(for labelTrackingId: Int,
                      frameSequenceId: Int? = nil) throws -> CapturedLabel {
        guard let label = sessionHolder.value?.getLabel(byId: labelTrackingId) else {
            throw FrameworksLabelCaptureError.noSuchLabel(labelTrackingId)
        }
        return label
    }

    public func labelAndField(for labelTrackingId: Int,
                              fieldName: String) -> (CapturedLabel, LabelField)? {
        guard let label = sessionHolder.value?.getLabel(byId: labelTrackingId) else {
            return nil
        }
        let labelFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: labelTrackingId, fieldName: fieldName)
        guard let labelField = sessionHolder.value?.getField(byKey: labelFieldKey) else {
            return nil
        }
        return (label, labelField)
    }

    public func labelAndField(for labelFieldIdentifier: String) -> (CapturedLabel, LabelField)? {
        guard let label = sessionHolder.value?.getLabel(byFieldKey: labelFieldIdentifier) else {
            return nil
        }
        guard let labelField = sessionHolder.value?.getField(byKey: labelFieldIdentifier) else {
            return nil
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
                handleError(FrameworksLabelCaptureError.invalidBrush(brushJson), result: result)
                return
            }

            if let dcView = getDataCaptureView(for: brushForLabel.dataCaptureViewId),
               let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType() {
                overlay.setBrush(brush, for: label)
            }
        } catch {
            handleError(error, result: result)
            return
        }
        result.success()
    }

    public func setBrushForFieldOfLabel(brushForFieldOfLabel: BrushForLabelField, result: FrameworksResult) {
        guard let fieldName = brushForFieldOfLabel.fieldName else {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }

        guard let (label, field) = getField(forLabel: brushForFieldOfLabel.labelTrackingId,
                                          fieldName: fieldName,
                                          result: result),
              let brush = createBrush(from: brushForFieldOfLabel.brushJson, result: result) else {
            return
        }

        if let dcView = getDataCaptureView(for: brushForFieldOfLabel.dataCaptureViewId),
           let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType() {
            overlay.setBrush(brush, for: field, of: label)
        }

        result.success()
    }

    public func setViewForCapturedLabel(viewForLabel: ViewForLabel, result: FrameworksResult) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        guard let label = session.getLabel(byId: viewForLabel.trackingId) else {
            handleError(FrameworksLabelCaptureError.noSuchLabel(viewForLabel.trackingId), result: result)
            return
        }

        if let dcView = getDataCaptureView(for: viewForLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            overlay.setView(viewForLabel.view, for: label)
        }
        result.success()
    }

    public func setViewForCapturedLabel(with viewParams: [String: Any?], result: FrameworksResult) {
        guard let identifier = viewParams["identifier"] as? Int,
              let label = getLabel(byId: identifier, result: result),
              let dataCaptureViewId = viewParams["dataCaptureViewId"] as? Int else {

            result.success()
            return
        }

        let viewData = viewParams["view"] as? Data

        if let dcView = self.captureViewHandler.getView(dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            if let view = self.createView(from: viewData, identifier: String(identifier)) {
                overlay.setView(view, for: label)
            }
        }

        result.success()
    }

    public func setViewForCapturedLabelField(with viewParams: [String: Any?], result: FrameworksResult) {
        guard let identifier = viewParams["identifier"] as? String,
              let dataCaptureViewId = viewParams["dataCaptureViewId"] as? Int else {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }

        guard let dcView = self.captureViewHandler.getView(dataCaptureViewId),
              let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() else {
            handleError(FrameworksLabelCaptureError.noAdvancedOverlay, result: result)
            return
        }

        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier),
              let labelField = sessionHolder.value?.getField(byKey: identifier) else {
            // Most probably session already changed
            result.success()
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

    public func setViewForCapturedLabelField(_ dataCaptureViewId: Int, for label: CapturedLabel, and labelField: LabelField, view: UIView?, result: FrameworksResult) {
        guard let dcView = getDataCaptureView(for: dataCaptureViewId),
              let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() else {
            handleError(FrameworksLabelCaptureError.noAdvancedOverlay, result: result)
            return
        }
        dispatchMain {
            overlay.setView(view, for: labelField, of: label)
            result.success()
        }
    }

    public func setAnchorForCapturedLabel(anchorForLabel: AnchorForLabel, result: FrameworksResult) {
        guard let label = sessionHolder.value?.getLabel(byId: anchorForLabel.trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }

        if let dcView = getDataCaptureView(for: anchorForLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.setAnchor(anchorForLabel.anchor, for: label)
            }
        }

        result.success()
    }

    public func setOffsetForCapturedLabel(offsetForLabel: OffsetForLabel, result: FrameworksResult) {
        guard let label = sessionHolder.value?.getLabel(byId: offsetForLabel.trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }

        if let dcView = getDataCaptureView(for: offsetForLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.setOffset(offsetForLabel.offset, for: label)
            }
        }

        result.success()
    }

    public func setViewForFieldOfLabel(viewForFieldOfLabel: ViewForLabel, result: FrameworksResult) {
        guard let fieldName = viewForFieldOfLabel.fieldName else {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: viewForFieldOfLabel.trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: viewForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            // Most probably session already changed
            result.success()
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

        if let dcView = getDataCaptureView(for: viewForFieldOfLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.setView(view, for: field, of: label)
            }
        }
        result.success()
    }

    public func setAnchorForFieldOfLabel(anchorForFieldOfLabel: AnchorForLabel, result: FrameworksResult) {
        guard let fieldName = anchorForFieldOfLabel.fieldName else {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: anchorForFieldOfLabel.trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: anchorForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            // Most probably session already changed
            result.success()
            return
        }
        if let dcView = getDataCaptureView(for: anchorForFieldOfLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.setAnchor(anchorForFieldOfLabel.anchor, for: field, of: label)
            }
        }
        result.success()
    }

    public func setOffsetForFieldOfLabel(offsetForFieldOfLabel: OffsetForLabel, result: FrameworksResult) {
        guard let fieldName = offsetForFieldOfLabel.fieldName else {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }
        guard let label = sessionHolder.value?.getLabel(byId: offsetForFieldOfLabel.trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: offsetForFieldOfLabel.trackingId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: barcodeFieldKey) else {
            // Most probably session already changed
            result.success()
            return
        }
        if let dcView = getDataCaptureView(for: offsetForFieldOfLabel.dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.setOffset(offsetForFieldOfLabel.offset, for: field, of: label)
            }
        }
        result.success()
    }

    public func clearTrackedCapturedLabelViews(_ dataCaptureViewId: Int) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
           let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
            dispatchMain {
                overlay.clearTrackedCapturedLabelViews()
            }
        }
    }

    public func updateModeFromJson(modeJson: String, result: FrameworksResult) {
        let modeId = JSONValue(string: modeJson).integer(forKey: "modeId", default: -1)

        if modeId == -1 {
            handleError(FrameworksLabelCaptureError.missingFieldName, result: result)
            return
        }

        guard let mode = getModeFromCache(modeId) else {
            result.success(result: nil)
            return
        }

        do {
            try mode.updateModeFromJson(modeJson: modeJson)
            result.success()
        } catch {
            handleError(error, result: result)
        }
    }

    public func applyModeSettings(modeId: Int, modeSettingsJson: String, result: FrameworksResult) {
        guard let mode = getModeFromCache(modeId) else {
            result.success(result: nil)
            return
        }
        do {
            try mode.applySettings(modeSettingsJson: modeSettingsJson)
            result.success()
        } catch {
            handleError(error, result: result)
        }
    }

    public func updateBasicOverlay(_ dataCaptureViewId: Int, overlayJson: String, result: FrameworksResult) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                   let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType() {
                    dcView.removeOverlay(overlay)

                    try self.dataCaptureView(addOverlay: overlayJson, to: dcView)
                }

                result.success(result: nil)
            } catch {
                self.handleError(error, result: result)
            }
        }
        dispatchMain(block)
    }

    public func updateAdvancedOverlay(_ dataCaptureViewId: Int, overlayJson: String, result: FrameworksResult) {
        let block = { [weak self] in
            guard let self = self else {
                self?.handleError(ScanditFrameworksCoreError.nilSelf, result: result)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                   let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType() {
                    dcView.removeOverlay(overlay)

                    try self.dataCaptureView(addOverlay: overlayJson, to: dcView)
                }
                result.success(result: nil)
            } catch {
                self.handleError(error, result: result)
            }
        }
        dispatchMain(block)
    }

    public func updateValidationFlowOverlay(_ dataCaptureViewId: Int, overlayJson: String, result: FrameworksResult) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                   let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType() {
                    dcView.removeOverlay(overlay)

                    try self.dataCaptureView(addOverlay: overlayJson, to: dcView)
                }

                result.success(result: nil)
            } catch {
                self.handleError(error, result: result)
            }
        }
        dispatchMain(block)
    }
    
    public func updateFeedback(modeId: Int, feedbackJson: String, result: FrameworksResult) {
        dispatchMain { [weak self] in
            guard let self = self else {
                result.success()
                return
            }
            
            do {
                // in case we don't have a mode yet, it will return success and cache the new
                // feedback to be applied after the creation of the view.
                if let mode = self.getModeFromCache(modeId) {
                    try mode.updateLabelCaptureFeedback(feedbackJson: feedbackJson)
                }
                result.success()
            } catch let error {
                result.reject(error: error)
            }
        }
    }

    // MARK: - Method Execution

    public func execute(method: FrameworksMethodCall, result: FrameworksResult) -> Bool {
        switch method.method {
        case "getLabelCaptureDefaults":
            let defaults = defaults.stringValue
            result.success(result: defaults)

        case "finishLabelCaptureListenerDidUpdateSession":
            if let enabled: Bool = method.argument(key: "isEnabled"), let modeId: Int = method.argument(key: "modeId") {
                finishDidUpdateCallback(modeId: modeId, enabled: enabled)
            }
            result.success()

        case "addLabelCaptureListener":
            if let modeId: Int = method.argument(key: "modeId") {
                addListener(modeId)
                result.success()
            } else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
            }

        case "setLabelCaptureModeEnabledState":
            guard let modeId: Int = method.argument(key: "modeId"),
               let enabled: Bool = method.argument(key: "enabled") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            setModeEnabled(modeId: modeId, enabled: enabled)
            result.success()

        case "updateLabelCaptureMode":
            guard let modeJson: String = method.argument(key: "modeJson") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            updateModeFromJson(modeJson: modeJson, result: result)

        case "applyLabelCaptureModeSettings":
            guard let settingsJson: String = method.argument(key: "settings"),
                  let modeId: Int = method.argument(key: "modeId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            applyModeSettings(modeId: modeId, modeSettingsJson: settingsJson, result: result)

        case "removeLabelCaptureListener":
            guard let modeId: Int = method.argument(key: "modeId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            removeListener(modeId)
            result.success()

        case "setViewForCapturedLabel":
            if let args: [String: Any?] = method.arguments() {
                setViewForCapturedLabel(with: args, result: result)
            } else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
            }

        case "setViewForCapturedLabelField":
            if let args: [String: Any?] = method.arguments() {
                setViewForCapturedLabelField(with: args, result: result)
            } else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
            }

        case "setAnchorForCapturedLabel":
            guard let anchor: String = method.argument(key: "anchor"),
                  let trackingId: Int = method.argument(key: "identifier"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            let anchorForLabel = AnchorForLabel(dataCaptureViewId: dataCaptureViewId,
                                               anchorString: anchor,
                                               trackingId: trackingId)
            setAnchorForCapturedLabel(anchorForLabel: anchorForLabel, result: result)

        case "setAnchorForCapturedLabelField":
            guard let anchor: String = method.argument(key: "anchor"),
                  let identifier: String = method.argument(key: "identifier"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }

            let components = identifier.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0]) ?? 0
            let fieldName = components.count > 1 ? components[1] : ""
            let anchorForLabelField = AnchorForLabel(dataCaptureViewId: dataCaptureViewId,
                                                    anchorString: anchor,
                                                    trackingId: trackingId,
                                                    fieldName: fieldName)
            setAnchorForFieldOfLabel(anchorForFieldOfLabel: anchorForLabelField, result: result)

        case "setOffsetForCapturedLabel":
            guard let offsetJson: String = method.argument(key: "offset"),
                  let trackingId: Int = method.argument(key: "identifier"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            let offsetForLabel = OffsetForLabel(dataCaptureViewId: dataCaptureViewId,
                                               offsetJson: offsetJson,
                                               trackingId: trackingId)
            setOffsetForCapturedLabel(offsetForLabel: offsetForLabel, result: result)

        case "setOffsetForCapturedLabelField":
            guard let offsetJson: String = method.argument(key: "offset"),
                  let identifier: String = method.argument(key: "identifier"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            let components = identifier.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0]) ?? 0
            let fieldName = components.count > 1 ? components[1] : ""
            let offsetForLabelField = OffsetForLabel(dataCaptureViewId: dataCaptureViewId,
                                                    offsetJson: offsetJson,
                                                    trackingId: trackingId,
                                                    fieldName: fieldName)
            setOffsetForFieldOfLabel(offsetForFieldOfLabel: offsetForLabelField, result: result)

        case "clearCapturedLabelViews":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            clearTrackedCapturedLabelViews(dataCaptureViewId)
            result.success()

        case "updateLabelCaptureAdvancedOverlay":
            guard let overlayJson: String = method.argument(key: "advancedOverlayJson"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            updateAdvancedOverlay(dataCaptureViewId, overlayJson: overlayJson, result: result)

        case "addLabelCaptureAdvancedOverlayListener":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            addAdvancedOverlayListener(dataCaptureViewId)
            result.success()

        case "removeLabelCaptureAdvancedOverlayListener":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            removeAdvancedOverlayListener(dataCaptureViewId)
            result.success()

        case "addLabelCaptureBasicOverlayListener":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            addBasicOverlayListener(dataCaptureViewId)
            result.success()

        case "removeLabelCaptureBasicOverlayListener":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            removeBasicOverlayListener(dataCaptureViewId)
            result.success()

        case "updateLabelCaptureBasicOverlay":
            guard let overlayJson: String = method.argument(key: "basicOverlayJson"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            updateBasicOverlay(dataCaptureViewId, overlayJson: overlayJson, result: result)

        case "setLabelCaptureBasicOverlayBrushForFieldOfLabel":
            guard let jsonPayload: String = method.arguments() else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            let json = JSONValue(string: jsonPayload)
            let brushJson: String = json.string(forKey: "brush")
            let identifier: String = json.string(forKey: "identifier")
            let dataCaptureViewId: Int = json.integer(forKey: "dataCaptureViewId")
    
            let components = identifier.components(separatedBy: String(FrameworksLabelCaptureSession.separator))
            let trackingId = Int(components[0]) ?? 0
            let fieldName = components.count > 1 ? components[1] : ""
            let brushForField = BrushForLabelField(dataCaptureViewId: dataCaptureViewId,
                                                  brushJson: brushJson,
                                                  labelTrackingId: trackingId,
                                                  fieldName: fieldName)
            setBrushForFieldOfLabel(brushForFieldOfLabel: brushForField, result: result)

        case "setLabelCaptureBasicOverlayBrushForLabel":
            guard let jsonPayload: String = method.arguments() else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            let json = JSONValue(string: jsonPayload)
            let brushJson: String = json.string(forKey: "brush")
            let trackingId: Int = json.integer(forKey: "identifier")
            let dataCaptureViewId: Int = json.integer(forKey: "dataCaptureViewId")
            
            let brushForLabel = BrushForLabelField(dataCaptureViewId: dataCaptureViewId,
                                                  brushJson: brushJson,
                                                  labelTrackingId: trackingId)
            setBrushForLabel(brushForLabel: brushForLabel, result: result)

        case "registerListenerForValidationFlowEvents":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            addValidationFlowOverlayListener(dataCaptureViewId)
            result.success()

        case "unregisterListenerForValidationFlowEvents":
            let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") ?? -1
            removeValidationFlowOverlayListener(dataCaptureViewId)
            result.success()

        case "updateLabelCaptureValidationFlowOverlay":
            guard let overlayJson: String = method.argument(key: "overlayJson"),
                  let dataCaptureViewId: Int = method.argument(key: "dataCaptureViewId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            updateValidationFlowOverlay(dataCaptureViewId, overlayJson: overlayJson, result: result)
            
        case "updateLabelCaptureFeedback":
            guard let modeId: Int = method.argument(key: "modeId") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            guard let feedbackJson: String = method.argument(key: "feedbackJson") else {
                result.reject(error: ScanditFrameworksCoreError.nilArgument)
                return true
            }
            
            updateFeedback(modeId: modeId, feedbackJson: feedbackJson, result: result)
            
        default:
            return false
        }

        return true
    }

    // Helper methods to reduce duplication
    private func getDataCaptureView(for viewId: Int) -> FrameworksDataCaptureView? {
        return captureViewHandler.getView(viewId)
    }
}

extension LabelModule: DeserializationLifeCycleObserver {
    public func dataCaptureContext(addMode modeJson: String) throws {
        guard let dcContext = captureContext.context else {
            return
        }

        do {
            let creationParams = try LabelCaptureModeCreationData.fromJson(modeJson)

            if creationParams.modeType != "labelCapture" {
                return
            }

            let mode = try FrameworksLabelCaptureMode.create(
                emitter: emitter,
                captureContext: DefaultFrameworksCaptureContext.shared,
                creationData: creationParams,
                dataCaptureContext: dcContext,
                sessionHolder: sessionHolder
            )

            addModeToCache(modeId: creationParams.modeId, mode: mode)
            for action in getPostModeCreationActions(creationParams.modeId) {
                action()
            }
            for action in getPostModeCreationActionsByParent(creationParams.parentId ?? -1) {
                action()
            }
        } catch {
            Log.error("Error adding mode to context", error: error)
        }
    }

    public func dataCaptureContext(removeMode modeJson: String) {
        let json = JSONValue(string: modeJson)

        if json.string(forKey: "type") != "labelCapture" {
            return
        }

        let modeId = json.integer(forKey: "modeId", default: -1)

        guard let mode = getModeFromCache(modeId) else {
            return
        }
        mode.dispose()
        _ = removeModeFromCache(modeId)
        clearPostModeCreationActions(modeId)
    }

    public func dataCaptureContextAllModeRemoved() {
        for mode in getAllModesInCache() {
            mode.dispose()
        }
        removeAllModesFromCache()
        clearPostModeCreationActions(nil)
    }

    public func didDisposeDataCaptureContext() {
        dataCaptureContextAllModeRemoved()
    }

    public func dataCaptureView(addOverlay overlayJson: String, to view: FrameworksDataCaptureView) throws {
        let creationData = LabelCaptureOverlayCreationData.fromJson(overlayJson)
        if creationData.overlayType == nil {
            return
        }
        
        let parentId = view.parentId ?? -1
        
        var mode: FrameworksLabelCaptureMode?
        
        if parentId != -1 {
            mode = getModeFromCacheByParent(parentId) as? FrameworksLabelCaptureMode
        } else {
            mode = getModeFromCache(creationData.modeId)
        }
        
        guard let labelCapture = mode else {
            if parentId != -1 {
                addPostModeCreationActionByParent(parentId) {
                    try? self.dataCaptureView(addOverlay: overlayJson, to: view)
                }
            } else {
                addPostModeCreationAction(creationData.modeId) {
                    try? self.dataCaptureView(addOverlay: overlayJson, to: view)
                }
            }
            return
        }
        
        dispatchMain {  [weak self] in
            guard let self = self else {
                return
            }
            
            let overlay: DataCaptureOverlay
            
            do {
                switch creationData.overlayType {
                case .basic:
                    overlay = try self.deserializer.basicOverlay(fromJSONString: overlayJson, withMode: labelCapture.mode)
                    
                    if creationData.hasListener {
                        (overlay as? LabelCaptureBasicOverlay)?.delegate = basicOverlayListener
                    }
                case .advanced:
                    overlay = try  self.deserializer.advancedOverlay(fromJSONString: overlayJson, withMode: labelCapture.mode)
                    
                    if creationData.hasListener {
                        (overlay as? LabelCaptureAdvancedOverlay)?.delegate = advancedOverlayListener
                    }
                case .validationFlow:
                    overlay = try  self.deserializer.validationFlowOverlay(fromJSONString: overlayJson, withMode: labelCapture.mode)
                    
                    if creationData.hasListener {
                        (overlay as? LabelCaptureValidationFlowOverlay)?.delegate = validationFlowListener
                    }
                default:
                    return
                }
            } catch {
                Log.error(error)
                return
            }

            view.addOverlay(overlay)
        }
    }
}
