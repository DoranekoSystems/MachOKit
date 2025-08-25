//
//  Section+Attribute.swift
//
//
//  Created by p-x9 on 2023/12/01.
//  
//

import Foundation

public struct SectionAttributes: BitFlags {
    public typealias RawValue = UInt32

    public let rawValue: RawValue

    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    // TODO: SECTION_ATTRIBUTES_USR
    // TODO: SECTION_ATTRIBUTES_SYS

}

extension SectionAttributes {
    /// S_ATTR_PURE_INSTRUCTIONS
    public static let pure_instructions = SectionAttributes(
        rawValue: Bit.pure_instructions.rawValue
    )
    /// S_ATTR_NO_TOC
    public static let no_toc = SectionAttributes(
        rawValue: Bit.no_toc.rawValue
    )
    /// S_ATTR_STRIP_STATIC_SYMS
    public static let strip_static_syms = SectionAttributes(
        rawValue: Bit.strip_static_syms.rawValue
    )
    /// S_ATTR_NO_DEAD_STRIP
    public static let no_dead_strip = SectionAttributes(
        rawValue: Bit.no_dead_strip.rawValue
    )
    /// S_ATTR_LIVE_SUPPORT
    public static let live_support = SectionAttributes(
        rawValue: Bit.live_support.rawValue
    )
    /// S_ATTR_SELF_MODIFYING_CODE
    public static let self_modifying_code = SectionAttributes(
        rawValue: Bit.self_modifying_code.rawValue
    )
    /// S_ATTR_DEBUG
    public static let debug = SectionAttributes(
        rawValue: Bit.debug.rawValue
    )
    /// S_ATTR_SOME_INSTRUCTIONS
    public static let some_instructions = SectionAttributes(
        rawValue: Bit.some_instructions.rawValue
    )
    /// S_ATTR_EXT_RELOC
    public static let ext_reloc = SectionAttributes(
        rawValue: Bit.ext_reloc.rawValue
    )
    /// S_ATTR_LOC_RELOC
    public static let loc_reloc = SectionAttributes(
        rawValue: Bit.loc_reloc.rawValue
    )
}

extension SectionAttributes {
    public enum Bit: Sendable, CaseIterable {
        /// S_ATTR_PURE_INSTRUCTIONS
        case pure_instructions
        /// S_ATTR_NO_TOC
        case no_toc
        /// S_ATTR_STRIP_STATIC_SYMS
        case strip_static_syms
        /// S_ATTR_NO_DEAD_STRIP
        case no_dead_strip
        /// S_ATTR_LIVE_SUPPORT
        case live_support
        /// S_ATTR_SELF_MODIFYING_CODE
        case self_modifying_code
        /// S_ATTR_DEBUG
        case debug
        /// S_ATTR_SOME_INSTRUCTIONS
        case some_instructions
        /// S_ATTR_EXT_RELOC
        case ext_reloc
        /// S_ATTR_LOC_RELOC
        case loc_reloc
    }
}

extension SectionAttributes.Bit: RawRepresentable {
    public typealias RawValue = UInt32

    public init?(rawValue: RawValue) {
        switch rawValue {
        case RawValue(S_ATTR_PURE_INSTRUCTIONS): self = .pure_instructions
        case RawValue(S_ATTR_NO_TOC): self = .no_toc
        case RawValue(S_ATTR_STRIP_STATIC_SYMS): self = .strip_static_syms
        case RawValue(S_ATTR_NO_DEAD_STRIP): self = .no_dead_strip
        case RawValue(S_ATTR_LIVE_SUPPORT): self = .live_support
        case RawValue(S_ATTR_SELF_MODIFYING_CODE): self = .self_modifying_code
        case RawValue(S_ATTR_DEBUG): self = .debug
        case RawValue(S_ATTR_SOME_INSTRUCTIONS): self = .some_instructions
        case RawValue(S_ATTR_EXT_RELOC): self = .ext_reloc
        case RawValue(S_ATTR_LOC_RELOC): self = .loc_reloc
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .pure_instructions: RawValue(S_ATTR_PURE_INSTRUCTIONS)
        case .no_toc: RawValue(S_ATTR_NO_TOC)
        case .strip_static_syms: RawValue(S_ATTR_STRIP_STATIC_SYMS)
        case .no_dead_strip: RawValue(S_ATTR_NO_DEAD_STRIP)
        case .live_support: RawValue(S_ATTR_LIVE_SUPPORT)
        case .self_modifying_code: RawValue(S_ATTR_SELF_MODIFYING_CODE)
        case .debug: RawValue(S_ATTR_DEBUG)
        case .some_instructions: RawValue(S_ATTR_SOME_INSTRUCTIONS)
        case .ext_reloc: RawValue(S_ATTR_EXT_RELOC)
        case .loc_reloc: RawValue(S_ATTR_LOC_RELOC)
        }
    }
}

extension SectionAttributes.Bit: CustomStringConvertible {
    public var description: String {
        switch self {
        case .pure_instructions: "S_ATTR_PURE_INSTRUCTIONS"
        case .no_toc: "S_ATTR_NO_TOC"
        case .strip_static_syms: "S_ATTR_STRIP_STATIC_SYMS"
        case .no_dead_strip: "S_ATTR_NO_DEAD_STRIP"
        case .live_support: "S_ATTR_LIVE_SUPPORT"
        case .self_modifying_code: "S_ATTR_SELF_MODIFYING_CODE"
        case .debug: "S_ATTR_DEBUG"
        case .some_instructions: "S_ATTR_SOME_INSTRUCTIONS"
        case .ext_reloc: "S_ATTR_EXT_RELOC"
        case .loc_reloc: "S_ATTR_LOC_RELOC"
        }
    }
}
