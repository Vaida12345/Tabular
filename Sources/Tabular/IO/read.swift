//
//  read.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Essentials
import Foundation
import FinderItem


extension Tabular {
    
    /// Reads a table at `source`.
    public init(at source: FinderItem) throws {
        try self.init(string: source.load(.string()))
    }
    
    /// Reads a table at `source`.
    public init(string: String) throws {
        guard !string.isEmpty else { throw DecodeError.emptyFile }
        
        let lines = string
        let matrix = try Tabular.parse(lines: lines)
        
        let cases = Key.allCases
        let titles = matrix.first!
        let extra = Set(titles).subtracting(cases.map(\.rawValue))
        let missing = Set(cases.map(\.rawValue)).subtracting(titles)
        guard missing.isEmpty && extra.isEmpty else {
            throw DecodeError.titlesMismatch(missing: missing, extra: extra)
        }
        guard titles == cases.map(\.rawValue) else {
            throw DecodeError.titlesOrderMismatch
        }
        var rows: [Row] = []
        
        for (line, cells) in matrix.dropFirst().enumerated() {
            guard !cells.isEmpty else { continue }
            guard cells.count == titles.count else {
                throw DecodeError.validationError(.cellCountMismatch(line: line + 1))
            }
            
            var row = Row()
            zip(cases, cells).forEach { row[$0] = $1 }
            rows.append(row)
        }
        
        self.rows = rows
    }
    
    private static func parse(lines: String) throws -> [[String]] {
        var iterator = lines.makeIterator()
        var curr = iterator.next()
        var next = iterator.next()
        var openQuote: Bool = false
        var lineNumber = 0
        
        var currentGroup: String = ""
        var groups: [String] = []
        var metaGroups: [[String]] = []
        
        func increment() {
            curr = next
            next = iterator.next()
            lineNumber += 1
        }
        
        func finalize() {
            groups.append(currentGroup)
            currentGroup = ""
        }
        
        func finalizeMetaGroup() {
            finalize()
            metaGroups.append(groups)
            groups = []
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
                            throw ValidationError.misplacementOfQuotes(line: lineNumber)
                        }
                    }
                } else {
                    guard currentGroup.isEmpty else {
                        throw ValidationError.misplacementOfQuotes(line: lineNumber)
                    }
                    openQuote = true
                }
            case ",":
                if openQuote {
                    fallthrough
                } else {
                    finalize()
                }
            case "\n":
                if openQuote {
                    fallthrough
                } else {
                    finalizeMetaGroup()
                }
            default:
                currentGroup.append(curr)
            }
            
            increment()
        }
        
        finalizeMetaGroup()
        guard !openQuote else {
            throw ValidationError.unterminatedQuote(line: lineNumber)
        }
        
        return metaGroups
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
                "Titles mismatch: In the declared titles, in comparison to the titles in the file, \(missing) are missing, and \(extra) are extra."
            case .titlesOrderMismatch:
                "The order in which titles are declared does not match the order in which they appear in the file."
            }
        }
    }
    
    /// CSV formatting error.
    public enum ValidationError: GenericError {
        case misplacementOfQuotes(line: Int)
        case unterminatedQuote(line: Int)
        case cellCountMismatch(line: Int)
        
        public var message: String {
            switch self {
            case let .misplacementOfQuotes(line):
                "There is a misplaced quote on line \(line)."
            case let .unterminatedQuote(line):
                "There is an unterminated quote on line \(line)."
            case let .cellCountMismatch(line):
                "The number of cells in a row does not match the number of declared titles on line \(line)."
            }
        }
    }
}
