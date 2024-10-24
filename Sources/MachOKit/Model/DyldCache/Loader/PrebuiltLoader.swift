//
//  PrebuiltLoader.swift
//  
//
//  Created by p-x9 on 2024/07/09
//  
//

import Foundation

public struct PrebuiltLoader: LayoutWrapper {
    public typealias Layout = prebuilt_loader

    public var layout: Layout
    public var address: Int
}

extension PrebuiltLoader {
    // always true
    public var isPrebuilt: Bool {
        layout.isPrebuilt != 0
    }

    public var ref: LoaderRef {
        .init(layout: layout.ref)
    }
}

extension PrebuiltLoader {
    public func path(in cache: DyldCache) -> String? {
        guard let offset = cache.fileOffset(
            of: numericCast(address) + numericCast(layout.pathOffset)
        ) else { return nil }
        return cache.fileHandle.readString(offset: offset)
    }

    public func dependentLoaderRefs(in cache: DyldCache) -> DataSequence<LoaderRef>? {
        guard layout.dependentLoaderRefsArrayOffset != 0,
              let offset = cache.fileOffset(
                of: numericCast(address) + numericCast(layout.dependentLoaderRefsArrayOffset)
              ) else {
            return nil
        }
        return cache.fileHandle.readDataSequence(
            offset: offset,
            numberOfElements: numericCast(layout.depCount)
        )
    }
}

extension PrebuiltLoader {
    public func path(in cache: DyldCacheLoaded) -> String? {
        // swiftlint:disable:previous unused_parameter
        guard let baseAddress = UnsafeRawPointer(bitPattern: address) else {
            return nil
        }
        return String(
            cString: baseAddress
                .advanced(by: numericCast(layout.pathOffset))
                .assumingMemoryBound(to: CChar.self)
        )
    }

    public func dependentLoaderRefs(in cache: DyldCache) -> MemorySequence<LoaderRef>? {
        // swiftlint:disable:previous unused_parameter
        guard layout.dependentLoaderRefsArrayOffset != 0,
              let baseAddress = UnsafeRawPointer(bitPattern: address) else {
            return nil
        }
        return .init(
            basePointer: baseAddress
                .advanced(by: numericCast(layout.dependentLoaderRefsArrayOffset))
                .assumingMemoryBound(to: LoaderRef.self),
            numberOfElements: numericCast(layout.depCount)
        )
    }
}
