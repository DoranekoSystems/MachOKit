//
//  Rebase.swift
//
//
//  Created by p-x9 on 2023/12/15.
//
//

import Foundation

public struct Rebase: Sendable {
    public let type: RebaseType
    public let segmentIndex: Int
    public let segmentOffset: UInt
}

extension Rebase {
    public func segment64(in machO: MachOImage) -> SegmentCommand64? {
        let segments = Array(machO.segments64)
        let index = Int(segmentIndex)
        guard segments.indices.contains(index) else { return nil }
        return segments[index]
    }

    public func segment32(in machO: MachOImage) -> SegmentCommand? {
        let segments = Array(machO.segments32)
        let index = Int(segmentIndex)
        guard segments.indices.contains(index) else { return nil }
        return segments[index]
    }

    public func segment64(in machO: MachOFile) -> SegmentCommand64? {
        let segments = Array(machO.segments64)
        let index = Int(segmentIndex)
        guard segments.indices.contains(index) else { return nil }
        return segments[index]
    }

    public func segment32(in machO: MachOFile) -> SegmentCommand? {
        let segments = Array(machO.segments32)
        let index = Int(segmentIndex)
        guard segments.indices.contains(index) else { return nil }
        return segments[index]
    }
}

extension Rebase {
    public func section64(in machO: MachOImage) -> Section64? {
        guard let segment = segment64(in: machO) else { return nil  }
        let sections = segment.sections(cmdsStart: machO.cmdsStartPtr)

        let segmentStart = UInt(segment.vmaddr)
        return sections.first(where: { section in
            let offset = UInt(section.layout.offset)
            let size = UInt(section.layout.size)
            if offset <= segmentStart + segmentOffset &&
                segmentStart + segmentOffset < offset + size {
                return true
            } else {
                return false
            }
        })
    }

    public func section32(in machO: MachOImage) -> Section? {
        guard let segment = segment32(in: machO) else { return nil  }
        let sections = segment.sections(cmdsStart: machO.cmdsStartPtr)

        let segmentStart = UInt(segment.vmaddr)
        return sections.first(where: { section in
            let offset = UInt(section.layout.offset)
            let size = UInt(section.layout.size)
            if offset <= segmentStart + segmentOffset &&
                segmentStart + segmentOffset < offset + size {
                return true
            } else {
                return false
            }
        })
    }

    public func section64(in machO: MachOFile) -> Section64? {
        guard let segment = segment64(in: machO) else { return nil }
        let sections = segment.sections(in: machO)

        let segmentStart = UInt(segment.fileoff)
        return sections.first(where: { section in
            let offset = UInt(section.layout.offset)
            let size = UInt(section.layout.size)
            if offset <= segmentStart + segmentOffset &&
                segmentStart + segmentOffset < offset + size {
                return true
            } else {
                return false
            }
        })
    }

    public func section32(in machO: MachOFile) -> Section? {
        guard let segment = segment32(in: machO) else { return nil  }
        let sections = segment.sections(in: machO)

        let segmentStart = UInt(segment.fileoff)
        return sections.first(where: { section in
            let offset = UInt(section.layout.offset)
            let size = UInt(section.layout.size)
            if offset <= segmentStart + segmentOffset &&
                segmentStart + segmentOffset < offset + size {
                return true
            } else {
                return false
            }
        })
    }
}

extension Rebase {
    public func address(in machO: MachOImage) -> UInt? {
        if machO.is64Bit, let segment = segment64(in: machO) {
            return UInt(segment.vmaddr) + segmentOffset
        } else if let segment = segment32(in: machO) {
            return UInt(segment.vmaddr) + segmentOffset
        }
        return nil
    }

    public func address(in machO: MachOFile) -> UInt? {
        if machO.is64Bit, let segment = segment64(in: machO) {
            return UInt(segment.vmaddr) + segmentOffset
        } else if let segment = segment32(in: machO) {
            return UInt(segment.vmaddr) + segmentOffset
        }
        return nil
    }
}
