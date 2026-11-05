/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/label.json
//
// Fixture-driven round-trip tests: every fixture under
// serialization/tests/<module>/<name>/valid/ must decode without throwing
// (and its re-encoded/re-decoded form must decode too); every fixture
// under .../invalid/ must throw UNLESS the validation keyword that rejects
// it (minimum, pattern, oneOf, ...) is outside the set the hand-rolled
// validator supports, in which case the test is skipped (`XCTSkip`) rather
// than asserting a throw the code can't produce.

// For `UnknownPropertyError`, which core declares once for every module.
import ScanditFrameworksCore
import XCTest

@testable import ScanditFrameworksLabel

final class SchemaTypesTest: XCTestCase {

    func testLabelCaptureListenerDidUpdateSessionAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": "frame-1",
              "modeId": 1,
              "event": "LabelCaptureListener.didUpdateSession"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw)
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: reEncoded)
        )
    }

    func testLabelCaptureListenerDidUpdateSessionAcceptsValid_null_frame_id_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": null,
              "modeId": 1,
              "event": "LabelCaptureListener.didUpdateSession"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw)
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: reEncoded)
        )
    }

    func testLabelCaptureListenerDidUpdateSessionRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": "frame-1",
              "modeId": 1
            }
            """#.utf8
        )
        XCTAssertThrowsError(try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw))
    }

    func testLabelCaptureListenerDidUpdateSessionRejectsInvalid_missing_session_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "frameId": "frame-1",
              "modeId": 1,
              "event": "LabelCaptureListener.didUpdateSession"
            }
            """#.utf8
        )
        XCTAssertThrowsError(try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw))
    }

    func testLabelCaptureListenerDidUpdateSessionRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": "frame-1",
              "modeId": 1,
              "event": "LabelCaptureListener.didUpdateSession",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw))
        { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureListenerDidUpdateSessionRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": "frame-1",
              "modeId": 1,
              "event": "LabelCaptureListener.didUpdateSession.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw))
    }

    func testLabelCaptureListenerDidUpdateSessionRejectsInvalid_wrong_type_modeId_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "session": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "frameId": "frame-1",
              "modeId": "not-an-int",
              "event": "LabelCaptureListener.didUpdateSession"
            }
            """#.utf8
        )
        XCTAssertThrowsError(try JSONDecoder().decode(SchemaTypes.LabelCaptureListenerDidUpdateSession.self, from: raw))
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.didTapLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: reEncoded)
        )
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelRejectsInvalid_missing_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureBasicOverlayListener.didTapLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.didTapLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.didTapLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerDidTapLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": 123,
              "event": "LabelCaptureBasicOverlayListener.didTapLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerDidTapLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: reEncoded)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelRejectsInvalid_missing_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureBasicOverlayListener.brushForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": 123,
              "event": "LabelCaptureBasicOverlayListener.brushForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelRejectsInvalid_missing_field_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForFieldOfLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureBasicOverlayListener.brushForFieldOfLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureBasicOverlayListenerBrushForFieldOfLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "label": 123,
              "event": "LabelCaptureBasicOverlayListener.brushForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.viewForLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: reEncoded)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelRejectsInvalid_missing_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdvancedOverlayListener.viewForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.viewForLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.viewForLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": 123,
              "event": "LabelCaptureAdvancedOverlayListener.viewForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelAcceptsValid_null_identifier_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": null,
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelRejectsInvalid_missing_field_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerViewForFieldOfLabelRejectsInvalid_wrong_type_identifier_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": 123,
              "event": "LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelRejectsInvalid_missing_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdvancedOverlayListener.anchorForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": 123,
              "event": "LabelCaptureAdvancedOverlayListener.anchorForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelAcceptsValid_null_identifier_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": null,
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelRejectsInvalid_missing_field_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: raw
            )
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabelRejectsInvalid_wrong_type_identifier_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": 123,
              "event": "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelRejectsInvalid_missing_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdvancedOverlayListener.offsetForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": "{\"name\":\"LABEL-1\",\"trackingId\":1,\"fields\":[]}",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForLabelRejectsInvalid_wrong_type_label_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "label": 123,
              "event": "LabelCaptureAdvancedOverlayListener.offsetForLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForLabel.self, from: raw)
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelAcceptsValid_null_identifier_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": null,
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelRejectsInvalid_missing_field_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: raw
            )
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": "sku",
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabelRejectsInvalid_wrong_type_identifier_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "field": "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}",
              "identifier": 123,
              "event": "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "event": "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ]
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsRejectsInvalid_missing_fields_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "event": "LabelCaptureValidationFlowListener.didCaptureLabelWithFields",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: raw
            )
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "event": "LabelCaptureValidationFlowListener.didCaptureLabelWithFields.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidCaptureLabelWithFieldsRejectsInvalid_wrong_type_fields_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": "not-an-array",
              "event": "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "newValue": "new-sku",
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldAcceptsValid_null_old_value_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": null,
              "newValue": "new-sku",
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "newValue": "new-sku"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldRejectsInvalid_missing_newValue_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldRejectsInvalid_unknown_property_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "newValue": "new-sku",
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: raw
            )
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldRejectsInvalid_wrong_event_const_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "newValue": "new-sku",
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidSubmitManualInputForFieldRejectsInvalid_wrong_type_newValue_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "oldValue": "old-sku",
              "newValue": 123,
              "event": "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidSubmitManualInputForField.self,
                from: raw
            )
        )
    }

    func
        testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultAcceptsValid_async_started_with_frame_id_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "AsyncStarted",
              "asyncId": 7,
              "frameId": "frame-9",
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "Sync",
              "asyncId": -1,
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "Sync",
              "asyncId": -1,
              "frameId": null
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_missing_type_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "asyncId": -1,
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_unknown_property_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "Sync",
              "asyncId": -1,
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_wrong_event_const_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "Sync",
              "asyncId": -1,
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_wrong_type_asyncId_json()
        throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "Sync",
              "asyncId": "not-an-int",
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        )
    }

    func testLabelCaptureValidationFlowListenerDidUpdateValidationFlowResultRejectsInvalid_wrong_type_type_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "fields": [
                "{\"name\":\"sku\",\"type\":\"barcode\",\"state\":\"captured\"}"
              ],
              "type": "NotARealType",
              "asyncId": -1,
              "frameId": null,
              "event": "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.self,
                from: raw
            )
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "paymentTotal": 10.5,
                "lineItems": []
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedAcceptsValid_null_fields_and_line_items_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "storeCity": null,
                "storeAddress": null,
                "paymentTotal": 24.9,
                "lineItems": [
                  {
                    "name": "Bananas",
                    "unitPrice": 1.2,
                    "quantity": 3,
                    "discount": null
                  }
                ]
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(
                SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self,
                from: reEncoded
            )
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "paymentTotal": 24.9,
                "lineItems": []
              }
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_missing_result_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_result_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "notAReceiptProperty": "rejected by receipt_scanning_result.json's additionalProperties:false"
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "paymentTotal": 24.9,
                "lineItems": []
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "paymentTotal": 24.9,
                "lineItems": []
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_wrong_type_result_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": "not-an-object",
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerRecognizedRejectsInvalid_wrong_type_result_line_items_json() throws
    {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "result": {
                "storeName": "Scandit Market",
                "lineItems": "not-an-array"
              },
              "event": "LabelCaptureAdaptiveRecognitionListener.recognized"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerRecognized.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerFailureAcceptsValid_basic_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdaptiveRecognitionListener.failure"
            }
            """#.utf8
        )
        let parsed = try JSONDecoder().decode(
            SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure.self,
            from: raw
        )
        let reEncoded = try JSONEncoder().encode(parsed)
        XCTAssertNoThrow(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure.self, from: reEncoded)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerFailureRejectsInvalid_missing_event_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {}
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure.self, from: raw)
        )
    }

    func testLabelCaptureAdaptiveRecognitionListenerFailureRejectsInvalid_unknown_property_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdaptiveRecognitionListener.failure",
              "unknownProperty": true
            }
            """#.utf8
        )
        // Asserts the TYPE: the unknown-key class must surface as core's one shared
        // `UnknownPropertyError`, so a cross-module catch keeps matching.
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure.self, from: raw)
        ) { error in
            XCTAssertTrue(error is UnknownPropertyError, "expected UnknownPropertyError, got \(error)")
        }
    }

    func testLabelCaptureAdaptiveRecognitionListenerFailureRejectsInvalid_wrong_event_const_json() throws {
        // Raw string literal (#"""..."""#): a plain Swift multi-line literal processes
        // backslash escapes, so a fixture carrying an embedded JSON string (any property
        // with contentMediaType: application/json) would have its \" collapsed to a bare "
        // and stop being valid JSON. Raw literals keep the fixture bytes verbatim.
        let raw = Data(
            #"""
            {
              "event": "LabelCaptureAdaptiveRecognitionListener.failure.wrongEventName"
            }
            """#.utf8
        )
        XCTAssertThrowsError(
            try JSONDecoder().decode(SchemaTypes.LabelCaptureAdaptiveRecognitionListenerFailure.self, from: raw)
        )
    }
}
