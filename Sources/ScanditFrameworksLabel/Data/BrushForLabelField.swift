/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore

public struct BrushForLabelField {
    let dataCaptureViewId: Int
    let brushJson: String?
    let labelTrackingId: Int
    let fieldName: String?

    public init(dataCaptureViewId: Int, brushJson: String?, labelTrackingId: Int, fieldName: String? = nil) {
        self.dataCaptureViewId = dataCaptureViewId
        self.brushJson = brushJson
        self.labelTrackingId = labelTrackingId
        self.fieldName = fieldName
    }
}
