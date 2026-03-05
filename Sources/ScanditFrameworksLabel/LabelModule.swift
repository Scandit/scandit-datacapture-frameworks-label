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

open class LabelCaptureModule: BasicFrameworkModule<FrameworksLabelCaptureMode> {
    private let deserializer: LabelCaptureDeserializer
    internal let emitter: Emitter
    private let basicOverlayListener: FrameworksLabelCaptureBasicOverlayListener
    private let validationFlowListener: FrameworksLabelCaptureValidationFlowListener
    private let advancedOverlayListener: FrameworksLabelCaptureAdvancedOverlayListener
    private let adaptiveRecognitionListener: FrameworksLabelCaptureAdaptiveRecognitionListener
    private let captureContext = DefaultFrameworksCaptureContext.shared
    let sessionHolder = SessionHolder<FrameworksLabelCaptureSession>()
    var advancedOverlayViewCache: AdvancedOverlayViewCache?

    private let captureViewHandler = DataCaptureViewHandler.shared
    private let viewFromJsonResolver: ViewFromJsonResolver

    internal let didTapViewForFieldOfLabelEvent = Event(.didTapOnViewForFieldOfLabel)

    public init(
        emitter: Emitter,
        deserializer: LabelCaptureDeserializer = LabelCaptureDeserializer(),
        captureViewHandler: DataCaptureViewHandler = DataCaptureViewHandler.shared,
        viewFromJsonResolver: ViewFromJsonResolver = DefaultViewFromJsonResolver()
    ) {
        self.emitter = emitter
        self.deserializer = deserializer
        self.viewFromJsonResolver = viewFromJsonResolver
        self.basicOverlayListener = FrameworksLabelCaptureBasicOverlayListener(emitter: emitter)
        self.advancedOverlayListener = FrameworksLabelCaptureAdvancedOverlayListener(emitter: emitter)
        self.validationFlowListener = FrameworksLabelCaptureValidationFlowListener(emitter: emitter)
        self.adaptiveRecognitionListener = FrameworksLabelCaptureAdaptiveRecognitionListener(emitter: emitter)
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

    public override func getDefaults() -> [String: Any?] {
        LabelCaptureDefaults.shared.toEncodable()
    }

    public func addLabelCaptureListener(modeId: Int, result: FrameworksResult) {
        guard let mode = getModeFromCache(modeId) else {
            addPostModeCreationAction(
                modeId,
                action: {
                    self.addLabelCaptureListener(modeId: modeId, result: result)
                }
            )
            return
        }
        mode.addListener()
        result.successAndKeepCallback(result: nil)
    }

    public func removeLabelCaptureListener(modeId: Int, result: FrameworksResult) {
        if let mode = getModeFromCache(modeId) {
            mode.removeListener()
        }
        result.success()
    }

    public func addLabelCaptureBasicOverlayListener(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = basicOverlayListener
        }
        result.successAndKeepCallback(result: nil)
    }

    public func removeLabelCaptureBasicOverlayListener(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = nil
        }
        result.success()
    }

    public func addLabelCaptureAdvancedOverlayListener(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = advancedOverlayListener
        }
        result.successAndKeepCallback(result: nil)
    }

    public func removeLabelCaptureAdvancedOverlayListener(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = nil
        }
        result.success()
    }

    public func registerListenerForValidationFlowEvents(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = validationFlowListener
        }
        result.successAndKeepCallback(result: nil)
    }

    public func unregisterListenerForValidationFlowEvents(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = nil
        }
        result.success()
    }

    public func registerListenerForAdaptiveRecognitionOverlayEvents(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdaptiveRecognitionOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = adaptiveRecognitionListener
        }
        result.successAndKeepCallback(result: nil)
    }

    public func unregisterListenerForAdaptiveRecognitionOverlayEvents(
        dataCaptureViewId: Int,
        result: FrameworksResult
    ) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdaptiveRecognitionOverlay = dcView.findFirstOfType()
        {
            overlay.delegate = nil
        }
        result.success()
    }

    public func finishLabelCaptureListenerDidUpdateSession(modeId: Int, isEnabled: Bool, result: FrameworksResult) {
        if let mode = getModeFromCache(modeId) {
            mode.finishDidUpdateSession(enabled: isEnabled)
        }
        result.success()
    }

    public func setLabelCaptureModeEnabledState(modeId: Int, isEnabled: Bool, result: FrameworksResult) {
        guard let mode = self.getModeFromCache(modeId) else {
            result.success()
            return
        }
        mode.isEnabled = isEnabled
        result.success()
    }

    public func label(
        for labelTrackingId: Int,
        frameSequenceId: Int? = nil
    ) throws -> CapturedLabel {
        guard let label = sessionHolder.value?.getLabel(byId: labelTrackingId) else {
            throw FrameworksLabelCaptureError.noSuchLabel(labelTrackingId)
        }
        return label
    }

    public func labelAndField(
        for labelTrackingId: Int,
        fieldName: String
    ) -> (CapturedLabel, LabelField)? {
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

    public func setLabelCaptureBasicOverlayBrushForLabel(
        dataCaptureViewId: Int,
        brushJson: String?,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        do {
            guard let label = session.getLabel(byId: trackingId) else {
                throw FrameworksLabelCaptureError.noSuchLabel(trackingId)
            }
            guard let brushJson = brushJson else {
                result.success()
                return
            }
            guard let brush = Brush(jsonString: brushJson) else {
                handleError(FrameworksLabelCaptureError.invalidBrush(brushJson), result: result)
                return
            }

            if let dcView = getDataCaptureView(for: dataCaptureViewId),
                let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType()
            {
                overlay.setBrush(brush, for: label)
            }
            result.success()
        } catch {
            handleError(error, result: result)
        }
    }

    public func setLabelCaptureBasicOverlayBrushForFieldOfLabel(
        dataCaptureViewId: Int,
        brushJson: String?,
        fieldName: String,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        do {
            guard let label = session.getLabel(byId: trackingId) else {
                throw FrameworksLabelCaptureError.noSuchLabel(trackingId)
            }
            let labelFieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: trackingId, fieldName: fieldName)
            guard let field = session.getField(byKey: labelFieldKey) else {
                throw FrameworksLabelCaptureError.noSuchField(trackingId, fieldName)
            }

            guard let brushJson = brushJson else {
                result.success()
                return
            }
            guard let brush = Brush(jsonString: brushJson) else {
                handleError(FrameworksLabelCaptureError.invalidBrush(brushJson), result: result)
                return
            }

            if let dcView = getDataCaptureView(for: dataCaptureViewId),
                let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType()
            {
                overlay.setBrush(brush, for: field, of: label)
            }

            result.success()
        } catch {
            handleError(error, result: result)
        }
    }

    public func setViewForCapturedLabel(
        dataCaptureViewId: Int,
        viewJson: String?,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        guard let label = session.getLabel(byId: trackingId) else {
            handleError(FrameworksLabelCaptureError.noSuchLabel(trackingId), result: result)
            return
        }

        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain { [weak self] in
                guard let self = self else {
                    result.success()
                    return
                }
                let view = self.viewFromJsonResolver.getView(viewJson: viewJson)
                if let view = view {
                    self.addTapGestureRecognizer(to: view, for: label)
                    self.advancedOverlayViewCache?.addToCache(
                        viewIdentifier: String(trackingId),
                        view: view
                    )
                } else {
                    self.advancedOverlayViewCache?.removeView(withIdentifier: String(trackingId))
                }
                overlay.setView(view, for: label)
                result.success()
            }
        } else {
            result.success()
        }
    }

    public func setViewForCapturedLabelFromBytes(
        dataCaptureViewId: Int,
        viewBytes: Data?,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let dcView = self.captureViewHandler.getView(dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        else {
            result.success()
            return
        }

        guard let session = sessionHolder.value else {
            result.success()
            return
        }

        guard let label = session.getLabel(byId: trackingId) else {
            handleError(FrameworksLabelCaptureError.noSuchLabel(trackingId), result: result)
            return
        }

        guard let widgetData = viewBytes else {
            advancedOverlayViewCache?.removeView(withIdentifier: String(trackingId))
            dispatchMain {
                overlay.setView(nil, for: label)
            }
            return
        }

        dispatchMain { [weak self] in
            guard let self = self else {
                result.success()
                return
            }
            let view = self.advancedOverlayViewCache?.getOrCreateView(
                fromBase64EncodedData: widgetData,
                withIdentifier: String(trackingId)
            )
            if let view = view {
                self.addTapGestureRecognizer(to: view, for: label)
                self.advancedOverlayViewCache?.addToCache(
                    viewIdentifier: String(trackingId),
                    view: view
                )
            } else {
                self.advancedOverlayViewCache?.removeView(withIdentifier: String(trackingId))
            }
            overlay.setView(view, for: label)
            result.success()
        }

    }

    public func setViewForCapturedLabelField(
        dataCaptureViewId: Int,
        identifier: String,
        viewJson: String?,
        result: FrameworksResult
    ) {
        guard let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        else {
            handleError(FrameworksLabelCaptureError.noAdvancedOverlay, result: result)
            return
        }

        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier),
            let labelField = sessionHolder.value?.getField(byKey: identifier)
        else {
            // Most probably session already changed
            result.success()
            return
        }

        dispatchMain { [weak self] in
            guard let self = self else {
                result.success()
                return
            }
            let view = self.viewFromJsonResolver.getView(viewJson: viewJson)
            if let view = view {
                self.addTapGestureRecognizer(to: view, for: labelField, of: label)
                self.advancedOverlayViewCache?.addToCache(
                    viewIdentifier: identifier,
                    view: view
                )
            } else {
                self.advancedOverlayViewCache?.removeView(withIdentifier: identifier)
            }
            overlay.setView(view, for: labelField, of: label)
            result.success()
        }
    }

    public func setViewForCapturedLabelFieldFromBytes(
        dataCaptureViewId: Int,
        viewBytes: Data?,
        identifier: String,
        result: FrameworksResult
    ) {
        guard let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        else {
            handleError(FrameworksLabelCaptureError.noAdvancedOverlay, result: result)
            return
        }

        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier),
            let labelField = sessionHolder.value?.getField(byKey: identifier)
        else {
            // Most probably session already changed
            result.success()
            return
        }

        guard let widgetData = viewBytes else {
            advancedOverlayViewCache?.removeView(withIdentifier: identifier)
            dispatchMain {
                overlay.setView(nil, for: label)
            }
            return
        }

        dispatchMain { [weak self] in
            guard let self = self else {
                result.success()
                return
            }
            let view = self.advancedOverlayViewCache?.getOrCreateView(
                fromBase64EncodedData: widgetData,
                withIdentifier: identifier
            )
            if let view = view {
                self.addTapGestureRecognizer(to: view, for: labelField, of: label)
                self.advancedOverlayViewCache?.addToCache(
                    viewIdentifier: identifier,
                    view: view
                )
            } else {
                self.advancedOverlayViewCache?.removeView(withIdentifier: identifier)
            }
            overlay.setView(view, for: labelField, of: label)
            result.success()
        }
    }

    public func setViewForCapturedLabelField(
        _ dataCaptureViewId: Int,
        for label: CapturedLabel,
        and labelField: LabelField,
        view: UIView?,
        result: FrameworksResult
    ) {
        dispatchMain { [weak self] in
            guard let dcView = self?.getDataCaptureView(for: dataCaptureViewId),
                let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
            else {
                self?.handleError(FrameworksLabelCaptureError.noAdvancedOverlay, result: result)
                return
            }

            overlay.setView(view, for: labelField, of: label)
            result.success()
        }
    }

    public func setAnchorForCapturedLabel(
        dataCaptureViewId: Int,
        anchorJson: String,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let label = sessionHolder.value?.getLabel(byId: trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }

        var anchor: Anchor = .center
        SDCAnchorFromJSONString(anchorJson, &anchor)

        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.setAnchor(anchor, for: label)
                result.success()
            }
        } else {
            result.success()
        }
    }

    public func setOffsetForCapturedLabel(
        dataCaptureViewId: Int,
        offsetJson: String,
        trackingId: Int,
        result: FrameworksResult
    ) {
        guard let label = sessionHolder.value?.getLabel(byId: trackingId) else {
            // Most probably session already changed
            result.success()
            return
        }

        var offset: PointWithUnit = .zero
        SDCPointWithUnitFromJSONString(offsetJson, &offset)

        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.setOffset(offset, for: label)
                result.success()
            }
        } else {
            result.success()
        }
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
        let barcodeFieldKey = FrameworksLabelCaptureSession.getFieldKey(
            trackingId: viewForFieldOfLabel.trackingId,
            fieldName: fieldName
        )
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
                    "field": field.jsonString,
                ]
            )
        }

        if let dcView = getDataCaptureView(for: viewForFieldOfLabel.dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.setView(view, for: field, of: label)
            }
        }
        result.success()
    }

    public func setAnchorForCapturedLabelField(
        dataCaptureViewId: Int,
        anchorJson: String,
        identifier: String,
        result: FrameworksResult
    ) {
        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier) else {
            // Most probably session already changed
            result.success()
            return
        }
        guard let field = sessionHolder.value?.getField(byKey: identifier) else {
            // Most probably session already changed
            result.success()
            return
        }

        var anchor: Anchor = .center
        SDCAnchorFromJSONString(anchorJson, &anchor)

        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.setAnchor(anchor, for: field, of: label)
                result.success()
            }
        } else {
            result.success()
        }
    }

    public func setOffsetForCapturedLabelField(
        dataCaptureViewId: Int,
        offsetJson: String,
        identifier: String,
        result: FrameworksResult
    ) {
        guard let label = sessionHolder.value?.getLabel(byFieldKey: identifier) else {
            // Most probably session already changed
            result.success()
            return
        }
        guard let field = sessionHolder.value?.getField(byKey: identifier) else {
            // Most probably session already changed
            result.success()
            return
        }

        var offset: PointWithUnit = .zero
        SDCPointWithUnitFromJSONString(offsetJson, &offset)

        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.setOffset(offset, for: field, of: label)
                result.success()
            }
        } else {
            result.success()
        }
    }

    public func clearCapturedLabelViews(dataCaptureViewId: Int, result: FrameworksResult) {
        if let dcView = getDataCaptureView(for: dataCaptureViewId),
            let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
        {
            dispatchMain {
                overlay.clearTrackedCapturedLabelViews()
                result.success()
            }
        } else {
            result.success()
        }
    }

    public func updateLabelCaptureMode(modeJson: String, result: FrameworksResult) {
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

    public func updateLabelCaptureSettings(modeId: Int, settingsJson: String, result: FrameworksResult) {
        guard let mode = getModeFromCache(modeId) else {
            result.success(result: nil)
            return
        }
        do {
            try mode.applySettings(modeSettingsJson: settingsJson)
            result.success()
        } catch {
            handleError(error, result: result)
        }
    }

    public func updateLabelCaptureBasicOverlay(
        dataCaptureViewId: Int,
        basicOverlayJson: String,
        result: FrameworksResult
    ) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                    let overlay: LabelCaptureBasicOverlay = dcView.findFirstOfType()
                {
                    dcView.removeOverlay(overlay)

                    try self.dataCaptureView(addOverlay: basicOverlayJson, to: dcView)
                }

                result.success(result: nil)
            } catch {
                self.handleError(error, result: result)
            }
        }
        dispatchMain(block)
    }

    public func updateLabelCaptureAdvancedOverlay(
        dataCaptureViewId: Int,
        advancedOverlayJson: String,
        result: FrameworksResult
    ) {
        let block = { [weak self] in
            guard let self = self else {
                self?.handleError(ScanditFrameworksCoreError.nilSelf, result: result)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                    let overlay: LabelCaptureAdvancedOverlay = dcView.findFirstOfType()
                {
                    dcView.removeOverlay(overlay)

                    try self.dataCaptureView(addOverlay: advancedOverlayJson, to: dcView)
                }
                result.success(result: nil)
            } catch {
                self.handleError(error, result: result)
            }
        }
        dispatchMain(block)
    }

    public func updateLabelCaptureValidationFlowOverlay(
        dataCaptureViewId: Int,
        overlayJson: String,
        result: FrameworksResult
    ) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                    let overlay: LabelCaptureValidationFlowOverlay = dcView.findFirstOfType()
                {
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

    public func applyLabelCaptureAdaptiveRecognitionSettings(
        dataCaptureViewId: Int,
        overlayJson: String,
        result: FrameworksResult
    ) {
        let block = { [weak self] in
            guard let self = self else {
                result.reject(error: ScanditFrameworksCoreError.nilSelf)
                return
            }
            do {
                if let dcView = self.getDataCaptureView(for: dataCaptureViewId),
                    let overlay: LabelCaptureAdaptiveRecognitionOverlay = dcView.findFirstOfType()
                {
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

    public func updateLabelCaptureFeedback(modeId: Int, feedbackJson: String, result: FrameworksResult) {
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

    public override func createCommand(_ method: any FrameworksMethodCall) -> (any BaseCommand)? {
        LabelCaptureModuleCommandFactory.create(module: self, method)
    }

    // Helper methods to reduce duplication
    private func getDataCaptureView(for viewId: Int) -> FrameworksDataCaptureView? {
        captureViewHandler.getView(viewId)
    }
}

extension LabelCaptureModule: DeserializationLifeCycleObserver {
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

        dispatchMain { [weak self] in
            guard let self = self else {
                return
            }

            let overlay: DataCaptureOverlay

            do {
                switch creationData.overlayType {
                case .basic:
                    overlay = try self.deserializer.basicOverlay(
                        fromJSONString: overlayJson,
                        withMode: labelCapture.mode
                    )

                    if creationData.hasListener {
                        (overlay as? LabelCaptureBasicOverlay)?.delegate = basicOverlayListener
                    }
                case .advanced:
                    overlay = try self.deserializer.advancedOverlay(
                        fromJSONString: overlayJson,
                        withMode: labelCapture.mode
                    )

                    if creationData.hasListener {
                        (overlay as? LabelCaptureAdvancedOverlay)?.delegate = advancedOverlayListener
                    }
                case .validationFlow:
                    overlay = try self.deserializer.validationFlowOverlay(
                        fromJSONString: overlayJson,
                        withMode: labelCapture.mode
                    )

                    if creationData.hasListener {
                        (overlay as? LabelCaptureValidationFlowOverlay)?.delegate = validationFlowListener
                    }
                case .receiptScanning:
                    overlay = try self.deserializer.adaptiveRecognitionOverlay(
                        fromJSONString: overlayJson,
                        withMode: labelCapture.mode
                    )

                    if creationData.hasListener {
                        let arOverlay = overlay as? LabelCaptureAdaptiveRecognitionOverlay
                        arOverlay?.delegate = adaptiveRecognitionListener
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
