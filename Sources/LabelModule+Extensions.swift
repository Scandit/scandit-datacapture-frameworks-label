/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore
import ScanditLabelCapture

extension LabelModule {
    // MARK: - Label and Field Retrieval

    func getLabel(byId id: Int, result: FrameworksResult) -> CapturedLabel? {
        guard let label = sessionHolder.value?.getLabel(byId: id) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchLabel(id))
            return nil
        }
        return label
    }

    func getField(forLabel labelId: Int, fieldName: String, result: FrameworksResult) -> (CapturedLabel, LabelField)? {
        guard let label = getLabel(byId: labelId, result: result) else { return nil }

        let fieldKey = FrameworksLabelCaptureSession.getFieldKey(trackingId: labelId, fieldName: fieldName)
        guard let field = sessionHolder.value?.getField(byKey: fieldKey) else {
            result.reject(error: FrameworksLabelCaptureError.noSuchField(labelId, fieldName))
            return nil
        }

        return (label, field)
    }

    // MARK: - Overlay Operations

    func withAdvancedOverlay<T>(_ operation: @escaping (LabelCaptureAdvancedOverlay) -> T,
                               result: FrameworksResult,
                               completion: @escaping (T) -> Void) {
        guard let overlay: LabelCaptureAdvancedOverlay = advancedOverlay else {
            result.reject(error: FrameworksLabelCaptureError.noAdvancedOverlay)
            return
        }

        dispatchMain {
            let operationResult = operation(overlay)
            completion(operationResult)
        }
    }

    func withBasicOverlay<T>(_ operation: @escaping (LabelCaptureBasicOverlay) -> T,
                            result: FrameworksResult,
                            completion: @escaping (T) -> Void) {
        guard let overlay: LabelCaptureBasicOverlay = basicOverlay else {
            result.reject(error: FrameworksLabelCaptureError.noAdvancedOverlay)
            return
        }

        dispatchMain {
            let operationResult = operation(overlay)
            completion(operationResult)
        }
    }

    // MARK: - View Creation

    func createView(from data: Data?, identifier: String) -> UIView? {
        return data.flatMap { data in
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
            result.reject(error: FrameworksLabelCaptureError.invalidBrush(brushJson))
            return nil
        }
        return brush
    }
}
