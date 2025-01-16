//
//  IO.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Essentials
import Foundation
import FinderItem


extension Tabular {
    
    /// Writes the table as `csv` to `destination`.
    @inlinable
    public func write(to target: inout some TextOutputStream) async {
        let cases = Key.allCases
        let titles = cases.map({ text(for: $0.rawValue) }).joined(separator: ",") + "\n"
        target.write(titles)
        
        func text(for cell: String) -> String {
            let shouldQuote = cell.contains(",") || cell.contains("\n") || cell.contains("\"") || cell.hasPrefix(" ") || cell.hasSuffix(" ")
            let transformed = cell.replacingOccurrences(of: "\"", with: "\"\"")
            return shouldQuote ? "\"\(transformed)\"" : transformed
        }
        
        for (offset, row) in rows.enumerated() {
            target.write(cases.map { text(for: row[$0]) }.joined(separator: ","))
            if offset != rows.count - 1 { target.write("\n") }
        }
    }
    
    /// Writes the table as `csv` to `destination`.
    @inlinable
    public func write(to destination: FinderItem) async throws {
        var text = ""
        await self.write(to: &text)
        try text.write(to: destination)
    }
    
    /// Reads a table at `source`.
    ///
    /// - Bug: embedded line breaks not supported.
    public init(at source: FinderItem) async throws {
        var lines = await source.load(.lines).makeAsyncIterator()
        guard let titlesText = try await lines.next() else {
            throw DecodeError.emptyFile
        }
        let cases = Key.allCases
        let titles = try Tabular.parse(line: titlesText)
        let missing = Set(titles).subtracting(cases.map(\.rawValue))
        let extra = Set(cases.map(\.rawValue)).subtracting(titles)
        guard missing.isEmpty && extra.isEmpty else {
            throw DecodeError.titlesMismatch(missing: missing, extra: extra)
        }
        guard titles == cases.map(\.rawValue) else {
            throw DecodeError.titlesOrderMismatch
        }
        var rows: [Row] = []
        
        while let line = try await lines.next() {
            guard !line.isEmpty else { continue }
            let cells = try Tabular.parse(line: line)
            guard cells.count == titles.count else {
                throw DecodeError.validationError(.cellCountMismatch)
            }
            
            var row = Row()
            zip(cases, cells).forEach { row[$0] = $1 }
            rows.append(row)
        }
        
        self.rows = rows
    }
    
    private static func parse(line: String) throws -> [String] {
        var iterator = line.makeIterator()
        var curr = iterator.next()
        var next = iterator.next()
        var openQuote: Bool = false
        
        var currentGroup: String = ""
        var groups: [String] = []
        
        func increment() {
            curr = next
            next = iterator.next()
        }
        
        func finalize() {
            groups.append(currentGroup)
            currentGroup = ""
        }
        
        while let curr {
            switch curr {
            case "\"":
                if openQuote {
                    if next == "\"" {
                        currentGroup.append("\"")
                        increment()
                    } else {
                        openQuote = false
                        guard next.isNil(or: { $0 == "," }) else {
                            throw ValidationError.misplacementOfQuotes
                        }
                    }
                } else {
                    guard currentGroup.isEmpty else {
                        throw ValidationError.misplacementOfQuotes
                    }
                    openQuote = true
                }
            case ",":
                if openQuote {
                    fallthrough
                } else {
                    finalize()
                }
            default:
                currentGroup.append(curr)
            }
            
            increment()
        }
        
        finalize()
        guard !openQuote else {
            throw ValidationError.unterminatedQuote
        }
        
        return groups
    }
    
    
    /// An error raised by ``init(at:)``.
    public enum DecodeError: GenericError {
        case emptyFile
        /// CSV formatting error.
        case validationError(ValidationError)
        case titlesMismatch(missing: Set<String>, extra: Set<String>)
        case titlesOrderMismatch
        
        public var message: String {
            switch self {
            case .emptyFile:
                "The file is empty."
            case .validationError(let error):
                "CSV Formatting Error: \(error.message)"
            case .titlesMismatch(let missing, let extra):
                "Titles mismatch: In the declared titles, in comparison to the titles in the file, \(missing.joined(separator: ", ")) are missing, and \(extra.joined(separator: ", ")) are extra."
            case .titlesOrderMismatch:
                "The order in which titles are declared does not match the order in which they appear in the file."
            }
        }
    }
    
    /// CSV formatting error.
    public enum ValidationError: GenericError {
        case misplacementOfQuotes
        case unterminatedQuote
        case cellCountMismatch
        
        public var message: String {
            switch self {
            case .misplacementOfQuotes:
                "There is a misplaced quote."
            case .unterminatedQuote:
                "There is an unterminated quote."
            case .cellCountMismatch:
                "The number of cells in a row does not match the number of declared titles."
            }
        }
    }
    
}
