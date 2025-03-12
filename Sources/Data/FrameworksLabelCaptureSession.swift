/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditLabelCapture

public class FrameworksLabelCaptureSession {
    public static let separator: Character = "§"

    public let capturedLabels: [CapturedLabel]
    public let capturedLabelFields: [String: LabelField]

    public init(capturedLabels: [CapturedLabel], capturedLabelFields: [String: LabelField]) {
        self.capturedLabels = capturedLabels
        self.capturedLabelFields = capturedLabelFields
    }

    public func getLabel(byId id: Int) -> CapturedLabel? {
        return capturedLabels.first { $0.trackingId == id }
    }

    public func getField(byKey fieldKey: String) -> LabelField? {
        return capturedLabelFields[fieldKey]
    }

    public func getLabel(byFieldKey fieldKey: String) -> CapturedLabel? {
        let components = fieldKey.split(separator: Self.separator)
        guard let labelId = Int(components.first ?? "") else { return nil }
        return capturedLabels.first { $0.trackingId == labelId }
    }

    public func getLabelFieldKey(for labelField: LabelField) -> String? {
        return capturedLabelFields.first { $0.value == labelField }?.key
    }

    public static func getFieldKey(trackingId: Int, fieldName: String) -> String {
        return "\(trackingId)\(separator)\(fieldName)"
    }

    public static func create(from session: LabelCaptureSession) -> FrameworksLabelCaptureSession {
        // Create unique IDs for LabelFields when called from overlay listeners
        let capturedLabelFields = session.capturedLabels.reduce(into: [String: LabelField]()) { result, label in
            label.fields.forEach { field in
                let key = getFieldKey(trackingId: label.trackingId, fieldName: field.name)
                result[key] = field
            }
        }

        return FrameworksLabelCaptureSession(
            capturedLabels: session.capturedLabels,
            capturedLabelFields: capturedLabelFields
        )
    }
}
