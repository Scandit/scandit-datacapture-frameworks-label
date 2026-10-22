/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/label.json
//
// Codable structs/enums derived from the serialization JSON schemas
// referenced by this module's bridge params -- the Swift twin of
// `SchemaTypes.kt` (SDC-32644) / `schemaTypes.ts` / `schema_types.dart`. No
// runtime dependency beyond Foundation: validation rides Codable's own
// throwing contract, hand-extended below for the keywords Codable doesn't
// natively enforce.
//
// init(from:) enforces the same JSON Schema keywords the Kotlin/Dart
// emitters do: required, type, enum, string const, additionalProperties,
// null-ness, and root-level oneOf (dispatched on the discriminator). NOT
// enforced -- a payload violating one of these still decodes: pattern,
// minimum/maximum, minLength/maxLength, multipleOf.
//
// Like the Kotlin emitter's `SchemaAssertions.requireValid` (SDC-33621:
// throws unconditionally in every build variant), every check below
// throws unconditionally in every build configuration: there is no
// `#if DEBUG` idiom in frameworks/shared/ios today, and Codable's
// `Decodable.init(from:)` throws by contract regardless of build config
// -- gating strictness behind DEBUG would fight the protocol it
// implements. Required-field absence, a null on a non-optional
// property, and a type mismatch are all
// surfaced automatically by `KeyedDecodingContainer.decode(_:forKey:)`
// (native `DecodingError.keyNotFound` / `.valueNotFound` /
// `.typeMismatch`) -- EXCEPT for a property that is both `required` and
// `nullable`, which must accept an explicit null while still rejecting a
// missing key; `decode(_:forKey:)` can't express that (it rejects null
// too) and plain `decodeIfPresent` can't express it either (it treats a
// missing key and an explicit null identically, both -> nil), so that case
// gets a hand-rolled `container.contains(forKey:)` guard below that throws
// `DecodingError.keyNotFound` before falling through to `decodeIfPresent`.
// unknown-enum-value and unknown-key (`additionalProperties: false`)
// checks are likewise hand-rolled below and throw
// `DecodingError.dataCorrupted` with a message naming the offending
// key/value.
//
// Full required/nullable matrix, kept coherent across every property kind
// (plain scalar, enum, array, ref, union) and both directions:
//
//   not required (nullable or not):
//     decode: missing key -> nil; explicit `null` -> nil.
//     encode: `nil` -> key omitted (`encodeIfPresent` / `if let`).
//   required, non-nullable:
//     decode: missing key -> throws `keyNotFound`; explicit `null` -> throws
//       `valueNotFound` (from `decode(_:forKey:)`, or from the union
//       parser's own decode when it hits null).
//     encode: always encodes the key (non-optional Swift property).
//   required, nullable:
//     decode: missing key -> throws `keyNotFound` (hand-rolled
//       `required_key_guard` below, since `decodeIfPresent`/`decodeNil`
//       alone can't distinguish missing-key from explicit-null); explicit
//       `null` -> nil.
//     encode: `nil` -> key present with an explicit `null`
//       (`encodeNil(forKey:)`), never omitted -- omitting it here would
//       make `init(from:)` throw `keyNotFound` on round-trip.
//
// A union-typed property follows the same matrix, but "decode" means
// dispatching through `<Union>Parser.parse(from:)` against a
// `superDecoder`; since that parser cannot itself observe null (it reads a
// discriminator key out of the nested container), every union branch below
// checks `decodeNil`/`contains` itself before ever calling into the parser.

import Foundation
// `UnknownPropertyError` is declared once, by hand, in core -- see its doc comment.
import ScanditFrameworksCore

// Reusable dynamic `CodingKey` for enumerating every key actually present
// in the payload -- needed only to implement `additionalProperties: false`
// (an unknown-key check), since a container keyed by a fixed `CodingKeys`
// enum never surfaces keys it doesn't already know about.
private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int? { nil }

    init(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

// Codable stand-in for a property (or array element) the generator cannot
// give a nominal type -- an inline anonymous object with no `$ref`/`$defs`,
// like `barcode_ar_filter_filter_barcodes.json`'s `barcodes` items.
//
// Kotlin, Dart and TypeScript can spell "untyped" directly (`Any?`,
// `Object?`, `unknown`), so they render such a property as-is. Swift cannot:
// `Any` is not `Codable`, so `container.decode([Any].self, ...)` has no
// matching overload and the file does not compile. This enum is the Swift
// spelling of the same idea -- it round-trips arbitrary JSON without
// asserting a shape, so element-level validation stays exactly as absent
// here as it is on the other three platforms.
// Internal rather than `private`: unlike `AnyCodingKey` (used only inside
// function bodies), this type appears in the stored-property types of the
// generated structs, and Swift rejects an internal property whose type is
// private.
enum AnyJSON: Codable {
    case string(String)
    case number(Double)
    case integer(Int)
    case bool(Bool)
    case array([AnyJSON])
    case object([String: AnyJSON])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Int.self) {
            // Int before Double: `decode(Double.self)` also accepts an
            // integer literal, and matching Double first would turn every
            // whole number into `1.0` on re-encode.
            self = .integer(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([AnyJSON].self) {
            self = .array(value)
        } else if let value = try? container.decode([String: AnyJSON].self) {
            self = .object(value)
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "AnyJSON: value is not representable as JSON"
                )
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .number(let value): try container.encode(value)
        case .integer(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        case .null: try container.encodeNil()
        }
    }

    // Projection back to the plain Foundation JSON types that
    // `Event.emit(on:payload: [String: Any])` serializes.
    var jsonObject: Any {
        switch self {
        case .string(let value): return value
        case .number(let value): return value
        case .integer(let value): return value
        case .bool(let value): return value
        case .array(let value): return value.map(\.jsonObject)
        case .object(let value): return value.mapValues(\.jsonObject)
        case .null: return NSNull()
        }
    }
}

// Namespace container for every generated type below. A schema title is
// only unique within its own schema file (`serialization/schemas/**`); the
// Kotlin emitter gets collision safety for free from its
// `...command.generated` *package*, and the TS/Dart emitters keep their
// generated types out of the public barrel -- but a Swift target has no
// per-directory namespace and no barrel to exclude from, so an unqualified
// top-level type here can shadow an unrelated SDK type of the same name
// (e.g. a schema titled "SequenceFrameSource" collided with
// `SDCSequenceFrameSource`'s `NS_SWIFT_NAME(SequenceFrameSource)` from
// ScanditCaptureCore -- see SDC-32645). Wrapping every generated
// declaration in this uninhabited `enum` namespaces all of them under
// `SchemaTypes.<Name>`, so unqualified references elsewhere in the module
// keep resolving to the real SDK type.
enum SchemaTypes {

    /// Notifies the listener that LabelCapture updated its session.
    struct LabelCaptureListenerDidUpdateSession: Codable {
        let session: String
        let frameId: String?
        let modeId: Int
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            session: String,
            frameId: String? = nil,
            modeId: Int,
            event: String
        ) {
            self.session = session
            self.frameId = frameId
            self.modeId = modeId
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "session",
            "frameId",
            "modeId",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureListener.didUpdateSession"]

        enum CodingKeys: String, CodingKey {
            case session
            case frameId
            case modeId
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "LabelCaptureListenerDidUpdateSession: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            session = try container.decode(String.self, forKey: .session)
            guard container.contains(.frameId) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.frameId,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "LabelCaptureListenerDidUpdateSession.frameId: missing required property"
                    )
                )
            }
            frameId = try container.decodeIfPresent(String.self, forKey: .frameId)
            modeId = try container.decode(Int.self, forKey: .modeId)
            guard modeId >= Int(Int32.min), modeId <= Int(Int32.max) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "LabelCaptureListenerDidUpdateSession.modeId: out of Int32 range"
                    )
                )
            }
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "LabelCaptureListenerDidUpdateSession.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(session, forKey: .session)
            if let frameId {
                try container.encode(frameId, forKey: .frameId)
            } else {
                try container.encodeNil(forKey: .frameId)
            }
            try container.encode(modeId, forKey: .modeId)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["session"] = session
            dict["frameId"] = frameId ?? NSNull()
            dict["modeId"] = modeId
            dict["event"] = event
            return dict
        }
    }

    /// Notifies the listener that the user tapped a captured label in the basic overlay.
    struct LabelCaptureBasicOverlayListenerDidTapLabel: Codable {
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            label: String,
            event: String
        ) {
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureBasicOverlayListener.didTapLabel"]

        enum CodingKeys: String, CodingKey {
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "LabelCaptureBasicOverlayListenerDidTapLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureBasicOverlayListenerDidTapLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the brush to use for a captured label in the basic overlay.
    struct LabelCaptureBasicOverlayListenerBrushForLabel: Codable {
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            label: String,
            event: String
        ) {
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureBasicOverlayListener.brushForLabel"]

        enum CodingKeys: String, CodingKey {
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "LabelCaptureBasicOverlayListenerBrushForLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureBasicOverlayListenerBrushForLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the brush to use for a captured label field in the basic overlay.
    struct LabelCaptureBasicOverlayListenerBrushForFieldOfLabel: Codable {
        let field: String
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            field: String,
            label: String,
            event: String
        ) {
            self.field = field
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "field",
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureBasicOverlayListener.brushForFieldOfLabel"]

        enum CodingKeys: String, CodingKey {
            case field
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureBasicOverlayListenerBrushForFieldOfLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            field = try container.decode(String.self, forKey: .field)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureBasicOverlayListenerBrushForFieldOfLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(field, forKey: .field)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["field"] = field
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the view to display for a captured label in the advanced overlay.
    struct LabelCaptureAdvancedOverlayListenerViewForLabel: Codable {
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            label: String,
            event: String
        ) {
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdvancedOverlayListener.viewForLabel"]

        enum CodingKeys: String, CodingKey {
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerViewForLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerViewForLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the view to display for a captured label field in the advanced overlay.
    struct LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel: Codable {
        let field: String
        let identifier: String?
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            field: String,
            identifier: String? = nil,
            event: String
        ) {
            self.field = field
            self.identifier = identifier
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "field",
            "identifier",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdvancedOverlayListener.viewForFieldOfLabel"]

        enum CodingKeys: String, CodingKey {
            case field
            case identifier
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            field = try container.decode(String.self, forKey: .field)
            guard container.contains(.identifier) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.identifier,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.identifier: missing required property"
                    )
                )
            }
            identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerViewForFieldOfLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(field, forKey: .field)
            if let identifier {
                try container.encode(identifier, forKey: .identifier)
            } else {
                try container.encodeNil(forKey: .identifier)
            }
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["field"] = field
            dict["identifier"] = identifier ?? NSNull()
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the anchor point to use for a captured label's view in the advanced
    /// overlay.
    struct LabelCaptureAdvancedOverlayListenerAnchorForLabel: Codable {
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            label: String,
            event: String
        ) {
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdvancedOverlayListener.anchorForLabel"]

        enum CodingKeys: String, CodingKey {
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerAnchorForLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerAnchorForLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the anchor point to use for a captured label field's view in the advanced
    /// overlay.
    struct LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel: Codable {
        let field: String
        let identifier: String?
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            field: String,
            identifier: String? = nil,
            event: String
        ) {
            self.field = field
            self.identifier = identifier
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "field",
            "identifier",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = [
            "LabelCaptureAdvancedOverlayListener.anchorForFieldOfLabel"
        ]

        enum CodingKeys: String, CodingKey {
            case field
            case identifier
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            field = try container.decode(String.self, forKey: .field)
            guard container.contains(.identifier) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.identifier,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.identifier: missing required property"
                    )
                )
            }
            identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerAnchorForFieldOfLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(field, forKey: .field)
            if let identifier {
                try container.encode(identifier, forKey: .identifier)
            } else {
                try container.encodeNil(forKey: .identifier)
            }
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["field"] = field
            dict["identifier"] = identifier ?? NSNull()
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the offset to apply to a captured label's view in the advanced overlay.
    struct LabelCaptureAdvancedOverlayListenerOffsetForLabel: Codable {
        let label: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            label: String,
            event: String
        ) {
            self.label = label
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "label",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdvancedOverlayListener.offsetForLabel"]

        enum CodingKeys: String, CodingKey {
            case label
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerOffsetForLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decode(String.self, forKey: .label)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerOffsetForLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["label"] = label
            dict["event"] = event
            return dict
        }
    }

    /// Asks the listener for the offset to apply to a captured label field's view in the advanced
    /// overlay.
    struct LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel: Codable {
        let field: String
        let identifier: String?
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            field: String,
            identifier: String? = nil,
            event: String
        ) {
            self.field = field
            self.identifier = identifier
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "field",
            "identifier",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = [
            "LabelCaptureAdvancedOverlayListener.offsetForFieldOfLabel"
        ]

        enum CodingKeys: String, CodingKey {
            case field
            case identifier
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            field = try container.decode(String.self, forKey: .field)
            guard container.contains(.identifier) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.identifier,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.identifier: missing required property"
                    )
                )
            }
            identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdvancedOverlayListenerOffsetForFieldOfLabel.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(field, forKey: .field)
            if let identifier {
                try container.encode(identifier, forKey: .identifier)
            } else {
                try container.encodeNil(forKey: .identifier)
            }
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["field"] = field
            dict["identifier"] = identifier ?? NSNull()
            dict["event"] = event
            return dict
        }
    }

    /// Notifies the listener that the validation flow captured a label with the given fields.
    struct LabelCaptureValidationFlowListenerDidCaptureLabelWithFields: Codable {
        let fields: [String]
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            fields: [String],
            event: String
        ) {
            self.fields = fields
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "fields",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = [
            "LabelCaptureValidationFlowListener.didCaptureLabelWithFields"
        ]

        enum CodingKeys: String, CodingKey {
            case fields
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureValidationFlowListenerDidCaptureLabelWithFields: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            fields = try container.decode([String].self, forKey: .fields)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidCaptureLabelWithFields.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fields, forKey: .fields)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["fields"] = fields
            dict["event"] = event
            return dict
        }
    }

    /// Notifies the listener that the user manually submitted a value for a label field in the
    /// validation flow.
    struct LabelCaptureValidationFlowListenerDidSubmitManualInputForField: Codable {
        let fields: [String]
        let oldValue: String?
        let newValue: String
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            fields: [String],
            oldValue: String? = nil,
            newValue: String,
            event: String
        ) {
            self.fields = fields
            self.oldValue = oldValue
            self.newValue = newValue
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "fields",
            "oldValue",
            "newValue",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = [
            "LabelCaptureValidationFlowListener.didSubmitManualInputForField"
        ]

        enum CodingKeys: String, CodingKey {
            case fields
            case oldValue
            case newValue
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureValidationFlowListenerDidSubmitManualInputForField: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            fields = try container.decode([String].self, forKey: .fields)
            guard container.contains(.oldValue) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.oldValue,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.oldValue: missing required property"
                    )
                )
            }
            oldValue = try container.decodeIfPresent(String.self, forKey: .oldValue)
            newValue = try container.decode(String.self, forKey: .newValue)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidSubmitManualInputForField.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fields, forKey: .fields)
            if let oldValue {
                try container.encode(oldValue, forKey: .oldValue)
            } else {
                try container.encodeNil(forKey: .oldValue)
            }
            try container.encode(newValue, forKey: .newValue)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["fields"] = fields
            dict["oldValue"] = oldValue ?? NSNull()
            dict["newValue"] = newValue
            dict["event"] = event
            return dict
        }
    }

    /// Notifies the listener that the validation flow result was updated.
    struct LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult: Codable {
        let fields: [String]
        let type: String
        let asyncId: Int
        let frameId: String?
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            fields: [String],
            type: String,
            asyncId: Int,
            frameId: String? = nil,
            event: String
        ) {
            self.fields = fields
            self.type = type
            self.asyncId = asyncId
            self.frameId = frameId
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "fields",
            "type",
            "asyncId",
            "frameId",
            "event",
        ]
        private static let typeAllowedValues: Set<String> = ["Sync", "AsyncStarted", "AsyncFinished"]
        private static let eventAllowedValues: Set<String> = [
            "LabelCaptureValidationFlowListener.didUpdateValidationFlowResult"
        ]

        enum CodingKeys: String, CodingKey {
            case fields
            case type
            case asyncId
            case frameId
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            fields = try container.decode([String].self, forKey: .fields)
            let typeRaw = try container.decode(String.self, forKey: .type)
            guard Self.typeAllowedValues.contains(typeRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.type: unknown enum value '\(typeRaw)'"
                    )
                )
            }
            type = typeRaw
            asyncId = try container.decode(Int.self, forKey: .asyncId)
            guard asyncId >= Int(Int32.min), asyncId <= Int(Int32.max) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.asyncId: out of Int32 range"
                    )
                )
            }
            guard container.contains(.frameId) else {
                throw DecodingError.keyNotFound(
                    CodingKeys.frameId,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.frameId: missing required property"
                    )
                )
            }
            frameId = try container.decodeIfPresent(String.self, forKey: .frameId)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureValidationFlowListenerDidUpdateValidationFlowResult.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(fields, forKey: .fields)
            try container.encode(type, forKey: .type)
            try container.encode(asyncId, forKey: .asyncId)
            if let frameId {
                try container.encode(frameId, forKey: .frameId)
            } else {
                try container.encodeNil(forKey: .frameId)
            }
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["fields"] = fields
            dict["type"] = type
            dict["asyncId"] = asyncId
            dict["frameId"] = frameId ?? NSNull()
            dict["event"] = event
            return dict
        }
    }

    /// Notifies the listener that the adaptive recognition overlay recognized a result.
    struct LabelCaptureAdaptiveRecognitionListenerRecognized: Codable {
        let result: ReceiptScanningResult
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            result: ReceiptScanningResult,
            event: String
        ) {
            self.result = result
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "result",
            "event",
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdaptiveRecognitionListener.recognized"]

        enum CodingKeys: String, CodingKey {
            case result
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message:
                            "LabelCaptureAdaptiveRecognitionListenerRecognized: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            result = try container.decode(ReceiptScanningResult.self, forKey: .result)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdaptiveRecognitionListenerRecognized.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(result, forKey: .result)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["result"] = result.toDictionary()
            dict["event"] = event
            return dict
        }
    }

    /// The result of a receipt scanning operation: store information, payment details and the purchased
    /// line items. Produced by the C++ framework-bridge serializer, which both iOS
    /// (SDCReceiptScanningResult.JSONString) and Android (ReceiptScanningResult.toJson()) delegate to,
    /// so the two platforms emit identical keys. Frameworks parse this strictly (additionalProperties:
    /// false), so a key added to the serializer without updating this schema drops the recognized event
    /// on Android, iOS and Flutter; the emitted key set is pinned by
    /// native/libs/sdc/label/main/test/test_receipt_scanning_result_serializer.cc, which must change in
    /// lockstep with this file. The analytics event carries the same data under snake_case keys pinned
    /// by its own schema; that surface is separate and is not modelled here.
    struct ReceiptScanningResult: Codable {
        let storeName: String?
        let storeCity: String?
        let storeAddress: String?
        let date: String?
        let time: String?
        let paymentPreTaxTotal: Double?
        let paymentTax: Double?
        let paymentTotal: Double?
        let loyaltyNumber: Int?
        let lineItems: [ReceiptScanningLineItem]?

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            storeName: String? = nil,
            storeCity: String? = nil,
            storeAddress: String? = nil,
            date: String? = nil,
            time: String? = nil,
            paymentPreTaxTotal: Double? = nil,
            paymentTax: Double? = nil,
            paymentTotal: Double? = nil,
            loyaltyNumber: Int? = nil,
            lineItems: [ReceiptScanningLineItem]? = nil
        ) {
            self.storeName = storeName
            self.storeCity = storeCity
            self.storeAddress = storeAddress
            self.date = date
            self.time = time
            self.paymentPreTaxTotal = paymentPreTaxTotal
            self.paymentTax = paymentTax
            self.paymentTotal = paymentTotal
            self.loyaltyNumber = loyaltyNumber
            self.lineItems = lineItems
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "storeName",
            "storeCity",
            "storeAddress",
            "date",
            "time",
            "paymentPreTaxTotal",
            "paymentTax",
            "paymentTotal",
            "loyaltyNumber",
            "lineItems",
        ]

        enum CodingKeys: String, CodingKey {
            case storeName
            case storeCity
            case storeAddress
            case date
            case time
            case paymentPreTaxTotal
            case paymentTax
            case paymentTotal
            case loyaltyNumber
            case lineItems
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "ReceiptScanningResult: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            storeName = try container.decodeIfPresent(String.self, forKey: .storeName)
            storeCity = try container.decodeIfPresent(String.self, forKey: .storeCity)
            storeAddress = try container.decodeIfPresent(String.self, forKey: .storeAddress)
            date = try container.decodeIfPresent(String.self, forKey: .date)
            time = try container.decodeIfPresent(String.self, forKey: .time)
            paymentPreTaxTotal = try container.decodeIfPresent(Double.self, forKey: .paymentPreTaxTotal)
            paymentTax = try container.decodeIfPresent(Double.self, forKey: .paymentTax)
            paymentTotal = try container.decodeIfPresent(Double.self, forKey: .paymentTotal)
            loyaltyNumber = try container.decodeIfPresent(Int.self, forKey: .loyaltyNumber)
            if let loyaltyNumber {
                guard loyaltyNumber >= Int(Int32.min), loyaltyNumber <= Int(Int32.max) else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: decoder.codingPath,
                            debugDescription: "ReceiptScanningResult.loyaltyNumber: out of Int32 range"
                        )
                    )
                }
            }
            lineItems = try container.decodeIfPresent([ReceiptScanningLineItem].self, forKey: .lineItems)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(storeName, forKey: .storeName)
            try container.encodeIfPresent(storeCity, forKey: .storeCity)
            try container.encodeIfPresent(storeAddress, forKey: .storeAddress)
            try container.encodeIfPresent(date, forKey: .date)
            try container.encodeIfPresent(time, forKey: .time)
            try container.encodeIfPresent(paymentPreTaxTotal, forKey: .paymentPreTaxTotal)
            try container.encodeIfPresent(paymentTax, forKey: .paymentTax)
            try container.encodeIfPresent(paymentTotal, forKey: .paymentTotal)
            try container.encodeIfPresent(loyaltyNumber, forKey: .loyaltyNumber)
            try container.encodeIfPresent(lineItems, forKey: .lineItems)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["storeName"] = storeName ?? NSNull()
            dict["storeCity"] = storeCity ?? NSNull()
            dict["storeAddress"] = storeAddress ?? NSNull()
            dict["date"] = date ?? NSNull()
            dict["time"] = time ?? NSNull()
            dict["paymentPreTaxTotal"] = paymentPreTaxTotal ?? NSNull()
            dict["paymentTax"] = paymentTax ?? NSNull()
            dict["paymentTotal"] = paymentTotal ?? NSNull()
            dict["loyaltyNumber"] = loyaltyNumber ?? NSNull()
            if let lineItems { dict["lineItems"] = lineItems.map { $0.toDictionary() } }
            return dict
        }
    }

    /// A single purchased item identified on a scanned receipt.
    struct ReceiptScanningLineItem: Codable {
        let name: String?
        let unitPrice: Double?
        let discount: Double?
        let quantity: Double?
        let totalPrice: Double?

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            name: String? = nil,
            unitPrice: Double? = nil,
            discount: Double? = nil,
            quantity: Double? = nil,
            totalPrice: Double? = nil
        ) {
            self.name = name
            self.unitPrice = unitPrice
            self.discount = discount
            self.quantity = quantity
            self.totalPrice = totalPrice
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "name",
            "unitPrice",
            "discount",
            "quantity",
            "totalPrice",
        ]

        enum CodingKeys: String, CodingKey {
            case name
            case unitPrice
            case discount
            case quantity
            case totalPrice
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "ReceiptScanningLineItem: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decodeIfPresent(String.self, forKey: .name)
            unitPrice = try container.decodeIfPresent(Double.self, forKey: .unitPrice)
            discount = try container.decodeIfPresent(Double.self, forKey: .discount)
            quantity = try container.decodeIfPresent(Double.self, forKey: .quantity)
            totalPrice = try container.decodeIfPresent(Double.self, forKey: .totalPrice)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(name, forKey: .name)
            try container.encodeIfPresent(unitPrice, forKey: .unitPrice)
            try container.encodeIfPresent(discount, forKey: .discount)
            try container.encodeIfPresent(quantity, forKey: .quantity)
            try container.encodeIfPresent(totalPrice, forKey: .totalPrice)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            if let name { dict["name"] = name }
            dict["unitPrice"] = unitPrice ?? NSNull()
            dict["discount"] = discount ?? NSNull()
            if let quantity { dict["quantity"] = quantity }
            dict["totalPrice"] = totalPrice ?? NSNull()
            return dict
        }
    }

    /// Notifies the listener that the adaptive recognition overlay failed to recognize a result.
    struct LabelCaptureAdaptiveRecognitionListenerFailure: Codable {
        let event: String

        // Explicit memberwise init -- defining `init(from decoder:)` below suppresses Swift's
        // synthesized memberwise initializer, but emit sites need to build these payloads (not
        // just decode them), so both must coexist.
        init(
            event: String
        ) {
            self.event = event
        }

        // Built once per type rather than per decode -- see the per-property
        // `AllowedValues` sets below for the same rationale.
        private static let allowedKeys: Set<String> = [
            "event"
        ]
        private static let eventAllowedValues: Set<String> = ["LabelCaptureAdaptiveRecognitionListener.failure"]

        enum CodingKeys: String, CodingKey {
            case event
        }

        init(from decoder: Decoder) throws {
            let anyContainer = try decoder.container(keyedBy: AnyCodingKey.self)
            for key in anyContainer.allKeys {
                guard Self.allowedKeys.contains(key.stringValue) else {
                    throw UnknownPropertyError(
                        message: "LabelCaptureAdaptiveRecognitionListenerFailure: unknown property '\(key.stringValue)'"
                    )
                }
            }
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let eventRaw = try container.decode(String.self, forKey: .event)
            guard Self.eventAllowedValues.contains(eventRaw) else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "LabelCaptureAdaptiveRecognitionListenerFailure.event: unknown enum value '\(eventRaw)'"
                    )
                )
            }
            event = eventRaw
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(event, forKey: .event)
        }

        // Dictionary projection for `Event.emit(on:payload: [String: Any])`
        // (frameworks/shared/ios/.../Event/Event.swift) -- a NULLABLE property keeps
        // its key, written as NSNull when nil: omitting it changed the emitted bytes
        // for payloads that previously rode through as raw JSON (SDC-33900), and a
        // strict parser accepts an explicit null but throws on a missing key
        // (SDC-33544). A non-nullable optional is omitted when nil, because the
        // decoder rejects an explicit null for it.
        func toDictionary() -> [String: Any] {
            var dict: [String: Any] = [:]
            dict["event"] = event
            return dict
        }
    }
}
