/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore

public struct BrushForLabelField {
    let brushJson: String?
    let labelTrackingId: Int
    let fieldName: String?

    public init(brushJson: String?, labelTrackingId: Int, fieldName: String? = nil) {
        self.brushJson = brushJson
        self.labelTrackingId = labelTrackingId
        self.fieldName = fieldName
    }
}
