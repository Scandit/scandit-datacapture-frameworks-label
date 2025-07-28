/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditFrameworksCore

public enum LabelCaptureOverlayType {
    case basic
    case advanced
    case validationFlow
}

public struct LabelCaptureOverlayCreationData {
    let overlayType: LabelCaptureOverlayType?
    let overlayJsonString: String
    let hasListener: Bool

    private init(overlayType: LabelCaptureOverlayType?, overlayJsonString: String, hasListener: Bool) {
        self.overlayType = overlayType
        self.overlayJsonString = overlayJsonString
        self.hasListener = hasListener
    }

    static func fromJson(_ overlayJsonString: String) -> LabelCaptureOverlayCreationData {
        let overlayJson = JSONValue(string: overlayJsonString)

        let overlayType: LabelCaptureOverlayType? = {
            switch overlayJson.string(forKey: "type") {
            case "labelCaptureAdvanced":
                return .advanced
            case "labelCaptureBasic":
                return .basic
            case "validationFlow":
                return .validationFlow
            default:
                return nil
            }
        }()

        let hasListener = overlayJson.bool(forKey: "hasListener", default: false)

        return LabelCaptureOverlayCreationData(
            overlayType: overlayType,
            overlayJsonString: overlayJsonString,
            hasListener: hasListener
        )
    }
}
