/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore
import ScanditFrameworksCore

public enum LabelCaptureOverlayType {
    case basic
    case advanced
    case validationFlow
    case receiptScanning
}

public struct LabelCaptureOverlayCreationData {
    let overlayType: LabelCaptureOverlayType?
    let overlayJsonString: String
    let hasListener: Bool
    let modeId: Int

    private init(overlayType: LabelCaptureOverlayType?, overlayJsonString: String, hasListener: Bool, modeId: Int) {
        self.overlayType = overlayType
        self.overlayJsonString = overlayJsonString
        self.hasListener = hasListener
        self.modeId = modeId
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
            case "receiptScanning":
                return .receiptScanning
            default:
                return nil
            }
        }()

        let hasListener = overlayJson.bool(forKey: "hasListener", default: false)
        let modeId = overlayJson.integer(forKey: "modeId", default: -1)

        return LabelCaptureOverlayCreationData(
            overlayType: overlayType,
            overlayJsonString: overlayJsonString,
            hasListener: hasListener,
            modeId: modeId
        )
    }
}
