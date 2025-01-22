//
//  write.swift
//  Tabular
//
//  Created by Vaida on 1/22/25.
//

import Essentials
import Foundation
import FinderItem


extension Tabular {
    
    /// Writes the table as `csv` to `destination`.
    @inlinable
    public func write(to target: inout some TextOutputStream) {
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
    public func write(to destination: FinderItem) throws {
        var text = ""
        self.write(to: &text)
        try text.write(to: destination)
    }
    
}
