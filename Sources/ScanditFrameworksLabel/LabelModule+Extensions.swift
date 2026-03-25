/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

extension LabelModule {
    func handleError(_ error: Error, result: FrameworksResult) {
        result.reject(error: error)
    }

    // MARK: - Label and Field Retrieval

    func getLabel(byId id: Int, result: FrameworksResult) -> CapturedLabel? {
        guard let label = sessionHolder.value?.getLabel(byId: id) else {
            handleError(FrameworksLabelCaptureError.noSuchLabel(id), result: result)
            return nil
        }
        return label
    }

    func getField(forLabel labelId: Int, fieldName: String, result: FrameworksResult) -> (CapturedLabel, LabelField)? {
        guard let label = getLabel(byId: labelId, result: result) else { return nil }

        let fieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: labelId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: fieldKey) else {
            handleError(FrameworksLabelCaptureError.noSuchField(labelId, fieldName), result: result)
            return nil
        }

        return (label, field)
    }

    // MARK: - Overlay Operations

    // MARK: - View Creation

    func createView(from data: Data?, identifier: String) -> UIView? {
        data.flatMap { data in
            advancedOverlayViewCache?.getOrCreateView(
                fromBase64EncodedData: data,
                withIdentifier: identifier
            )
        }
    }

    // MARK: - Brush Operations

    func createBrush(from json: String?, result: FrameworksResult) -> Brush? {
        guard let brushJson = json else { return nil }
        guard let brush = Brush(jsonString: brushJson) else {
            handleError(FrameworksLabelCaptureError.invalidBrush(brushJson), result: result)
            return nil
        }
        return brush
    }
}
