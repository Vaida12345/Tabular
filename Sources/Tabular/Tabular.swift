//
//  Tabular.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//


/// A table.
public struct Tabular<Key: TabularKey>: Equatable {
    
    /// The rows in this table.
    public var rows: [Row]
    
    
    /// Append a row
    @inlinable
    public mutating func append(_ row: Row) {
        self.rows.append(row)
    }
    
    /// Append a row
    @inlinable
    public mutating func append(_ builder: (_ row: inout Row) -> Void) {
        var row = Row()
        builder(&row)
        self.append(row)
    }
    
    /// Creates a blank table.
    @inlinable
    public init() {
        self.rows = []
    }
    
    @inlinable
    public subscript(_ row: Int) -> Row {
        self.rows[row]
    }
    
}
