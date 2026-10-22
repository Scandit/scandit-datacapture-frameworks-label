/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditLabelCapture
import os

public class FrameworksLabelCaptureSession {
    public static let separator: Character = "§"

    public let capturedLabels: [CapturedLabel]

    // Guards cachedFields: written on the recognition thread, read from bridge/main.
    private var lock = os_unfair_lock_s()
    private var cachedFields: [String: LabelField]?

    public var capturedLabelFields: [String: LabelField] {
        os_unfair_lock_lock(&lock)
        defer { os_unfair_lock_unlock(&lock) }
        if let cachedFields { return cachedFields }
        let fields = capturedLabels.reduce(into: [String: LabelField]()) { result, label in
            label.fields.forEach { field in
                result[Self.getFieldKey(trackingId: label.trackingId, fieldName: field.name)] = field
            }
        }
        cachedFields = fields
        return fields
    }

    public init(capturedLabels: [CapturedLabel]) {
        self.capturedLabels = capturedLabels
    }

    public func getLabel(byId id: Int) -> CapturedLabel? {
        capturedLabels.first { $0.trackingId == id }
    }

    public func getField(byKey fieldKey: String) -> LabelField? {
        capturedLabelFields[fieldKey]
    }

    public func getLabel(byFieldKey fieldKey: String) -> CapturedLabel? {
        let components = fieldKey.split(separator: Self.separator)
        guard let labelId = Int(components.first ?? "") else { return nil }
        return capturedLabels.first { $0.trackingId == labelId }
    }

    public func getLabelFieldKey(for labelField: LabelField) -> String? {
        capturedLabelFields.first { entry in
            let parts = entry.key.split(separator: FrameworksLabelCaptureSession.separator)
            return parts.count > 1 && String(parts[1]) == labelField.name
        }?.key
    }

    public static func getFieldKey(trackingId: Int, fieldName: String) -> String {
        "\(trackingId)\(separator)\(fieldName)"
    }

    public static func create(from session: LabelCaptureSession) -> FrameworksLabelCaptureSession {
        FrameworksLabelCaptureSession(capturedLabels: session.capturedLabels)
    }
}
