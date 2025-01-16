//
//  BasicTests.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Testing
@testable import Tabular

@Suite
struct BasicTests {
    @Test func row() async throws {
        var row = Tabular<Keys>.Row()
        row[.a] = "a"
        
        #expect(row[.a] == "a")
        #expect(row["b"] == "")
        #expect(row[.c] == "")
        #expect(row["d"] == nil)
    }
    
    @Test func table() async throws {
        var table = Tabular<Keys>()
        var row = Tabular<Keys>.Row()
        row[.a] = "a"
        table.append(row)
        
        #expect(table[0][.a] == "a")
    }
    
    enum Keys: String, TabularKey {
        case a
        case b
        case c
    }
}
