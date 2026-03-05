/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore

public struct ViewForLabel {
    let dataCaptureViewId: Int
    let view: TappableView?
    let trackingId: Int
    let fieldName: String?

    public init(dataCaptureViewId: Int, view: TappableView?, trackingId: Int, fieldName: String? = nil) {
        self.dataCaptureViewId = dataCaptureViewId
        self.view = view
        self.trackingId = trackingId
        self.fieldName = fieldName
    }
}
