/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

public class FrameworksLabelCaptureMode: FrameworksBaseMode {
    private let listener: FrameworksLabelCaptureListener
    private let captureContext: DefaultFrameworksCaptureContext
    private let deserializer: LabelCaptureDeserializer

    private var internalModeId: Int = -1
    private var internalParentId: Int? = nil

    public var modeId: Int {
        internalModeId
    }

    public var parentId: Int? {
        internalParentId
    }

    public private(set) var mode: LabelCapture!

    public var isEnabled: Bool {
        get {
            mode.isEnabled
        }
        set {
            mode.isEnabled = newValue
        }
    }

    public init(
        listener: FrameworksLabelCaptureListener,
        captureContext: DefaultFrameworksCaptureContext,
        deserializer: LabelCaptureDeserializer = LabelCaptureDeserializer()
    ) {
        self.listener = listener
        self.captureContext = captureContext
        self.deserializer = deserializer
    }

    private func deserializeMode(
        dataCaptureContext: DataCaptureContext,
        creationData: LabelCaptureModeCreationData
    ) throws {
        mode = try deserializer.mode(fromJSONString: creationData.modeJson, with: dataCaptureContext)
        captureContext.addMode(mode: mode)
        mode.addListener(listener)
        listener.setEnabled(enabled: creationData.hasListener)

        mode.isEnabled = creationData.isEnabled
        internalModeId = creationData.modeId
        internalParentId = creationData.parentId
    }

    public func dispose() {
        listener.reset()
        mode.removeListener(listener)
        captureContext.removeMode(mode: mode)
    }

    public func addListener() {
        listener.setEnabled(enabled: true)
    }

    public func removeListener() {
        listener.setEnabled(enabled: false)
    }

    public func finishDidUpdateSession(enabled: Bool) {
        listener.finishDidUpdateCallback(enabled: enabled)
    }

    public func applySettings(modeSettingsJson: String) throws {
        let settings = try deserializer.settings(fromJSONString: modeSettingsJson)
        mode.apply(settings)
    }

    public func updateModeFromJson(modeJson: String) throws {
        try deserializer.updateMode(mode, fromJSONString: modeJson)
    }

    public func updateLabelCaptureFeedback(feedbackJson: String) throws {
        mode.feedback = try LabelCaptureFeedback(fromJSONString: feedbackJson)
    }

    // MARK: - Factory Method

    public static func create(
        emitter: Emitter,
        captureContext: DefaultFrameworksCaptureContext,
        creationData: LabelCaptureModeCreationData,
        dataCaptureContext: DataCaptureContext,
        sessionHolder: SessionHolder<FrameworksLabelCaptureSession>
    ) throws -> FrameworksLabelCaptureMode {
        let listener = FrameworksLabelCaptureListener(
            emitter: emitter,
            modeId: creationData.modeId,
            sessionHolder: sessionHolder
        )

        let mode = FrameworksLabelCaptureMode(
            listener: listener,
            captureContext: captureContext
        )

        try mode.deserializeMode(dataCaptureContext: dataCaptureContext, creationData: creationData)
        return mode
    }
}
