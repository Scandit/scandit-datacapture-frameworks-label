/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

public struct AnchorForLabel {
    let anchor: Anchor
    let trackingId: Int
    let fieldName: String?

    public init(anchorString: String, trackingId: Int, fieldName: String? = nil) {
        var anchor = Anchor.center
        SDCAnchorFromJSONString(anchorString, &anchor)
        self.anchor = anchor
        self.trackingId = trackingId
        self.fieldName = fieldName
    }
}
