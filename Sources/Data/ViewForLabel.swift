/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore

public struct ViewForLabel {
    let view: TappableView?
    let trackingId: Int
    let fieldName: String?

    public init(view: TappableView?, trackingId: Int, fieldName: String? = nil) {
        self.view = view
        self.trackingId = trackingId
        self.fieldName = fieldName
    }
}
