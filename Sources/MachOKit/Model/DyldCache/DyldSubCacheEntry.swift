//
//  DyldSubCacheEntry.swift
//
//
//  Created by p-x9 on 2024/01/15.
//  
//

import Foundation

public enum DyldSubCacheEntryType {
    case general
    case v1

    var layoutSize: Int {
        switch self {
        case .general:
            DyldSubCacheEntryGeneral.layoutSize
        case .v1:
            DyldSubCacheEntryV1.layoutSize
        }
    }
}

public enum DyldSubCacheEntry {
    case general(DyldSubCacheEntryGeneral)
    case v1(DyldSubCacheEntryV1)

    public var type: DyldSubCacheEntryType {
        switch self {
        case .general: .general
        case .v1: .v1
        }
    }

    /// UUID of sub cache
    public var uuid: UUID {
        switch self {
        case let .general(info): info.uuid
        case let .v1(info): info.uuid
        }
    }

    /// Offset of this subcache from the main cache base address
    public var cacheVMOffset: UInt64 {
        switch self {
        case let .general(info): info.cacheVMOffset
        case let .v1(info): info.cacheVMOffset
        }
    }

    /// File name suffix of the subCache file
    ///
    /// e.g. ".25.data", ".03.development"
    public var fileSuffix: String {
        switch self {
        case let .general(info): info.fileSuffix
        case let .v1(info): info.fileSuffix
        }
    }
}

// cache
extension DyldSubCacheEntry {
    public func subcache(for cache: DyldCache) throws -> DyldCache? {
        let url = URL(fileURLWithPath: cache.url.path + fileSuffix)
        return try DyldCache(subcacheUrl: url, mainCacheHeader: cache.header)
    }

    public func subcache(for cache: DyldCacheLoaded) throws -> DyldCacheLoaded? {
        try DyldCacheLoaded(
            subcachePtr: cache.ptr
                .advanced(by: numericCast(cacheVMOffset)),
            mainCacheHeader: cache.header
        )
    }
}

public struct DyldSubCacheEntryV1: LayoutWrapper {
    public typealias Layout = dyld_subcache_entry_v1

    public var layout: Layout
    public let index: Int
}

extension DyldSubCacheEntryV1 {
    /// UUID of sub cache
    public var uuid: UUID {
        .init(uuid: layout.uuid)
    }

    /// File name suffix of the subCache file
    ///
    /// e.g. ".01", ".02"
    public var fileSuffix: String {
        "." + String(format: "%02d", index)
    }
}

public struct DyldSubCacheEntryGeneral: LayoutWrapper {
    public typealias Layout = dyld_subcache_entry

    public var layout: Layout
    public let index: Int
}

extension DyldSubCacheEntryGeneral {
    /// UUID of sub cache
    public var uuid: UUID {
        .init(uuid: layout.uuid)
    }

    /// File name suffix of the subCache file
    ///
    /// e.g. ".25.data", ".03.development"
    public var fileSuffix: String {
        .init(tuple: layout.fileSuffix)
    }
}
