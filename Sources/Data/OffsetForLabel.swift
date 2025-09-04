/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

public struct OffsetForLabel {
    let dataCaptureViewId: Int
    let offset: PointWithUnit
    let trackingId: Int
    let fieldName: String?

    public init(dataCaptureViewId: Int, offsetJson: String, trackingId: Int, fieldName: String? = nil) {
        self.dataCaptureViewId = dataCaptureViewId
        var offset = PointWithUnit.zero
        SDCPointWithUnitFromJSONString(offsetJson, &offset)
        self.offset = offset
        self.trackingId = trackingId
        self.fieldName = fieldName
    }
}
