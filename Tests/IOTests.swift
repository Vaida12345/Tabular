//
//  IOTests.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Testing
@testable import Tabular

@Suite
struct IOTests {
    
    @Test
    func WikiWrite() async {
        let reference = #"""
        Year,Make,Model,Description,Price
        1997,Ford,E350,"ac, abs, moon",3000.00
        1999,Chevy,"Venture ""Extended Edition""",,4900.00
        1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
        1996,Jeep,Grand Cherokee,"MUST SELL!
        air, moon roof, loaded",4799.00
        """#
        
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
        
        var result = ""
        await table.write(to: &result)
        #expect(result == reference)
    }
    
    enum Keys: String, TabularKey {
        case year = "Year"
        case make = "Make"
        case model = "Model"
        case description = "Description"
        case price = "Price"
    }
    
}
