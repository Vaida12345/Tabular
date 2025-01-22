//
//  Descriptor.swift
//  Tabular
//
//  Created by Vaida on 1/22/25.
//

internal struct Descriptor<Key: TabularKey> {
    
    let widths: [Int]
    
    let allCases: Key.AllCases
    
    let rows: [Tabular<Key>.Row]
    
    
    func write(to target: inout some TextOutputStream) {
        self.writeTopBorder(to: &target)
        self.write(row: allCases.map(\.rawValue), separator: "┃", alignment: .centered, to: &target)
        self.writeTitleButtonBorder(to: &target)
        
        for row in rows {
            self.write(row: row.values, separator: "│", alignment: .leading, to: &target)
        }
        self.writeBottomBorder(to: &target)
    }
    
    func writeTopBorder(to target: inout some TextOutputStream) {
        target.write("┏━")
        for (offset, width) in widths.enumerated() {
            target.write(String(repeating: "━", count: width))
            if offset < widths.count - 1 {
                target.write("━┳━")
            } else {
                target.write("━┓")
            }
        }
        target.write("\n")
    }
    
    func writeTitleButtonBorder(to target: inout some TextOutputStream) {
        target.write("┡━")
        for (offset, width) in widths.enumerated() {
            target.write(String(repeating: "━", count: width))
            if offset < widths.count - 1 {
                target.write("━╇━")
            } else {
                target.write("━┩")
            }
        }
        target.write("\n")
    }
    
    func write(row: some Sequence<String>, separator: Character, alignment: Alignment, to target: inout some TextOutputStream) {
        var matrix: [[String]] = row.map({ $0.split(separator: "\n").map({ String($0) }) })
        let maxDepth = matrix.max(of: \.count) ?? 1
        for i in 0..<matrix.count {
            if matrix[i].count < maxDepth {
                matrix[i].append(contentsOf: Array(repeating: "", count: maxDepth - matrix[i].count))
            }
        }
        
        let transposed = (0..<maxDepth).map { columnIndex in
            matrix.map { row in row[columnIndex] }
        }
        
        for row in transposed {
            target.write("\(separator) ")
            for (offset, width) in widths.enumerated() {
                let value = align(row[offset], width: width, alignment: alignment)
                target.write(value)
                if offset < widths.count - 1 {
                    target.write(" \(separator) ")
                } else {
                    target.write(" \(separator)")
                }
            }
            target.write("\n")
        }
    }
    
    func writeBottomBorder(to target: inout some TextOutputStream) {
        target.write("└─")
        for (offset, width) in widths.enumerated() {
            target.write(String(repeating: "─", count: width))
            if offset < widths.count - 1 {
                target.write("─┴─")
            } else {
                target.write("─┘")
            }
        }
    }
    
    
    init(_ row: Tabular<Key>.Row) {
        self.allCases = Key.allCases
        self.widths = allCases.map { key in
            let cell = row[key]
            return max(cell.split(separator: "\n").max(of: \.count) ?? 1, key.rawValue.split(separator: "\n").max(of: \.count) ?? 1)
        }
        self.rows = [row]
    }
    
    init(_ tabular: Tabular<Key>) {
        self.allCases = Key.allCases
        self.widths = allCases.map { key in
            let cell = tabular.rows.reduce(0) { max($0, $1[key].split(separator: "\n").max(of: \.count) ?? 1) }
            return max(cell, key.rawValue.split(separator: "\n").max(of: \.count) ?? 1)
        }
        self.rows = tabular.rows
    }
    
    
    private func align(_ text: String, width: Int, alignment: Alignment) -> String {
        let valueCount = text.count
        
        switch alignment {
        case .leading:
            return text + String(repeating: " ", count: max(width - valueCount, 0))
        case .centered:
            let padding = (width - valueCount) / 2
            
            if valueCount >= width {
                return text
            } else if padding <= 0 {
                return text + String(repeating: " ", count: max(width - valueCount, 0))
            }
            
            return String(repeating: " ", count: padding) + text + String(repeating: " ", count: width - text.count - padding)
        }
    }
    
    enum Alignment {
        case leading
        case centered
    }
}
