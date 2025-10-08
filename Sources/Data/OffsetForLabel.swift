/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

public struct OffsetForLabel {
    let offset: PointWithUnit
    let trackingId: Int
    let fieldName: String?

    public init(offsetJson: String, trackingId: Int, fieldName: String? = nil) {
        var offset = PointWithUnit.zero
        SDCPointWithUnitFromJSONString(offsetJson, &offset)
        self.offset = offset
        self.trackingId = trackingId
        self.fieldName = fieldName
    }
}
