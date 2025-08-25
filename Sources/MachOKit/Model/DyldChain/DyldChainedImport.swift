//
//  DyldChainedImport.swift
//
//
//  Created by p-x9 on 2024/01/11.
//  
//

import Foundation
import MachOKitC

public enum DyldChainedImport: Sendable {
    case general(DyldChainedImportGeneral)
    case addend(DyldChainedImportAddend)
    case addend64(DyldChainedImportAddend64)

    public var info: any DyldChainedImportProtocol {
        switch self {
        case let .general(info): info
        case let .addend(info): info
        case let .addend64(info): info
        }
    }
}

public struct DyldChainedImportGeneral: DyldChainedImportProtocol {
    public typealias Layout = dyld_chained_import

    public var layout: Layout

    public var libraryOrdinal: Int {
        numericCast(Int8(bitPattern: UInt8(layout.lib_ordinal)))
    }

    public var isWeakImport: Bool {
        layout.weak_import != 0
    }

    public var nameOffset: Int {
        numericCast(layout.name_offset)
    }

    public var addend: Int {
        0
    }
}

public struct DyldChainedImportAddend: DyldChainedImportProtocol {
    public typealias Layout = dyld_chained_import_addend

    public var layout: Layout

    public var libraryOrdinal: Int {
        numericCast(Int8(bitPattern: UInt8(layout.lib_ordinal)))
    }

    public var isWeakImport: Bool {
        layout.weak_import != 0
    }

    public var nameOffset: Int {
        numericCast(layout.name_offset)
    }

    public var addend: Int {
        numericCast(layout.addend)
    }
}

public struct DyldChainedImportAddend64: DyldChainedImportProtocol {
    public typealias Layout = dyld_chained_import_addend64

    public var layout: Layout

    public var libraryOrdinal: Int {
        numericCast(Int16(bitPattern: UInt16(layout.lib_ordinal)))
    }

    public var isWeakImport: Bool {
        layout.weak_import != 0
    }

    public var nameOffset: Int {
        numericCast(layout.name_offset)
    }

    public var addend: Int {
        numericCast(layout.addend)
    }
}

extension DyldChainedImportGeneral {
    public var swapped: Self {
        var layout = self.layout
        return withUnsafeMutablePointer(to: &layout) {
            let ptr = UnsafeMutableRawPointer(mutating: $0)
            let bytes = UnsafeMutableBufferPointer(
                start: ptr
                    .assumingMemoryBound(to: UInt32.self),
                count: 1
            )
            bytes[0] = bytes[0].byteSwapped

            return .init(
                layout: ptr
                    .assumingMemoryBound(to: Layout.self)
                    .pointee
            )
        }
    }
}

extension DyldChainedImportAddend {
    public var swapped: Self {
        var layout = self.layout
        return withUnsafeMutablePointer(to: &layout) {
            let ptr = UnsafeMutableRawPointer(mutating: $0)
            let bytes = UnsafeMutableBufferPointer(
                start: ptr
                    .assumingMemoryBound(to: UInt32.self),
                count: layoutSize / MemoryLayout<UInt32>.size
            )
            bytes[0] = bytes[0].byteSwapped
            bytes[1] = bytes[1].byteSwapped

            return .init(
                layout: ptr
                    .assumingMemoryBound(to: Layout.self)
                    .pointee
            )
        }
    }
}

extension DyldChainedImportAddend64 {
    public var swapped: Self {
        var layout = self.layout
        return withUnsafeMutablePointer(to: &layout) {
            let ptr = UnsafeMutableRawPointer(mutating: $0)
            let bytes = UnsafeMutableBufferPointer(
                start: ptr
                    .assumingMemoryBound(to: UInt64.self),
                count: layoutSize / MemoryLayout<UInt64>.size
            )
            bytes[0] = bytes[0].byteSwapped
            bytes[1] = bytes[1].byteSwapped

            return .init(
                layout: ptr
                    .assumingMemoryBound(to: Layout.self)
                    .pointee
            )
        }
    }
}
