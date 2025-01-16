//
//  IOTests.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import FinderItem
import Testing
import Foundation
@testable import Tabular


@Suite
struct IOTests {
    
    @Test
    func WikiWrite() async {
        let table = referenceTable()
        
        var result = ""
        await table.write(to: &result)
        #expect(result == reference)
    }
    
    @Test
    func WikiRead() async throws {
        let file = try FinderItem.temporaryDirectory(intent: .general)/"\(UUID()).csv"
        try reference.write(to: file)
        defer {
            try? file.remove()
        }
        
        let table = try await Tabular<Keys>(at: file)
        for (lhs, rhs) in zip(table.rows, referenceTable().rows) {
            #expect(lhs == rhs)
        }
    }
    
}


let reference = #"""
        Year,Make,Model,Description,Price
        1997,Ford,E350,"ac, abs, moon",3000.00
        1999,Chevy,"Venture ""Extended Edition""",,4900.00
        1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
        1996,Jeep,Grand Cherokee,"MUST SELL! air, moon roof, loaded",4799.00
        """#

func referenceTable() -> Tabular<Keys> {
    var table = Tabular<Keys>()
    
    table.append { row in
        row[.year] = "1997"
        row[.make] = "Ford"
        row[.model] = "E350"
        row[.description] = "ac, abs, moon"
        row[.price] = "3000.00"
    }
    
    table.append { row in
        row[.year] = "1999"
        row[.make] = "Chevy"
        row[.model] = #"Venture "Extended Edition""#
        row[.price] = "4900.00"
    }
    
    table.append { row in
        row[.year] = "1999"
        row[.make] = "Chevy"
        row[.model] = #"Venture "Extended Edition, Very Large""#
        row[.price] = "5000.00"
    }
    
    table.append { row in
        row[.year] = "1996"
        row[.make] = "Jeep"
        row[.model] = "Grand Cherokee"
        row[.description] = "MUST SELL! air, moon roof, loaded"
        row[.price] = "4799.00"
    }
    
    return table
}


enum Keys: String, TabularKey {
    case year = "Year"
    case make = "Make"
    case model = "Model"
    case description = "Description"
    case price = "Price"
}
