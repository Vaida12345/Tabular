//
//  Description.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//


extension Tabular.Row: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        self.write(to: &text)
        return text
    }
    
    private func write(to target: inout some TextOutputStream) {
        let allCases = Key.allCases
        let widths = allCases.map { key in
            let cell = self[key]
            return max(cell.count, key.rawValue.count)
        }
        
        
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
        
        
        target.write("┃ ")
        for (offset, (width, key)) in zip(widths, allCases).enumerated() {
            let value = centeredAligned(key.rawValue, width: width)
            target.write(value)
            if offset < widths.count - 1 {
                target.write(" ┃ ")
            } else {
                target.write(" ┃")
            }
        }
        target.write("\n")
        
        
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
        
        
        target.write("│ ")
        for (offset, (width, key)) in zip(widths, allCases).enumerated() {
            let value = centeredAligned(self[key], width: width)
            target.write(value)
            if offset < widths.count - 1 {
                target.write(" │ ")
            } else {
                target.write(" │")
            }
        }
        target.write("\n")
        
        
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
}


extension Tabular: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        self.write(to: &text)
        return text
    }
    
    private func write(to target: inout some TextOutputStream) {
        let allCases = Key.allCases
        let widths = allCases.map { key in
            let cell = self.rows.reduce(0) { max($0, $1[key].count) }
            return max(cell, key.rawValue.count)
        }
        
        
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
        
        
        target.write("┃ ")
        for (offset, (width, key)) in zip(widths, allCases).enumerated() {
            let value = centeredAligned(key.rawValue, width: width)
            target.write(value)
            if offset < widths.count - 1 {
                target.write(" ┃ ")
            } else {
                target.write(" ┃")
            }
        }
        target.write("\n")
        
        
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
        
        
        for row in rows {
            target.write("│ ")
            for (offset, (width, key)) in zip(widths, allCases).enumerated() {
                let value = leftAligned(row[key], width: width)
                target.write(value)
                if offset < widths.count - 1 {
                    target.write(" │ ")
                } else {
                    target.write(" │")
                }
            }
            target.write("\n")
        }
        
        
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
}


private func centeredAligned(_ text: String, width: Int) -> String {
    let valueCount = text.count
    let padding = (width - valueCount) / 2
    
    if valueCount >= width {
        return text
    } else if padding <= 0 {
        return text + String(repeating: " ", count: max(width - valueCount, 0))
    }
    
    return String(repeating: " ", count: padding) + text + String(repeating: " ", count: width - text.count - padding)
}


private func leftAligned(_ text: String, width: Int) -> String {
    let valueCount = text.count
    return text + String(repeating: " ", count: max(width - valueCount, 0))
}
