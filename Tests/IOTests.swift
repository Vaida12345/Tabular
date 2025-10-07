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
    
    @Suite
    struct WikiSuite {
        @Test
        func WikiWrite() async {
            let table = IOTests.WikiSuite.referenceTable()
            
            var result = ""
            table.write(to: &result)
            #expect(result == reference)
        }
        
        @Test
        func WikiRead() async throws {
            let file = try FinderItem.temporaryDirectory(intent: .general)/"\(UUID()).csv"
            try reference.write(to: file)
            defer {
                try? file.remove()
            }
            
            let table = try Tabular<Keys>(at: file)
            for (lhs, rhs) in zip(table.rows, IOTests.WikiSuite.referenceTable().rows) {
                #expect(lhs == rhs)
            }
        }
        
        let reference = #"""
        Year,Make,Model,Description,Price
        1997,Ford,E350,"ac, abs, moon",3000.00
        1999,Chevy,"Venture ""Extended Edition""",,4900.00
        1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
        1996,Jeep,Grand Cherokee,"MUST SELL!
        air, moon roof, loaded",4799.00
        """#
        
        static func referenceTable() -> Tabular<Keys> {
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
                row[.description] = "MUST SELL!\nair, moon roof, loaded"
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

    }
    
    @Test
    func readEmpty() async throws {
        #expect(throws: Tabular<WikiSuite.Keys>.DecodeError.emptyFile) {
            let _ = try Tabular<WikiSuite.Keys>(string: "")
        }
    }
    
    @Test
    func readTitlesMismatch() {
        #expect(throws: Tabular<WikiSuite.Keys>.DecodeError.titlesMismatch(missing: ["Model", "Price", "Description"], extra: ["Car"])) {
            let _ = try Tabular<WikiSuite.Keys>(string: "Year,Make,Car")
        }
    }
    
    
    @Suite
    struct TransactionSuite {
        @Test func read() throws {
            let table = try Tabular<TabularKeys>(string: """
            date,description,amount,category,additionalInfo,associative,origin
            "July 9, 2025","abcd","-$99999.00","Misc Fee","","","User"
            "July 31, 2025","acdw","0.00","Other Fee","","","User"
            """)
            #expect(table.rows.count == 2)
            #expect(table.rows.first!.values.count == 7)
            try table.rows.first!.validate()
        }
    }
    
    
    enum TabularKeys: String, TabularKey {
        case date, description, amount, category, additionalInfo, associative, origin
    }
    
}
