//
//  DescriptionTests.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Testing
import Foundation
@testable import Tabular


@Suite
struct DescriptionTests {
    
    @Test
    func row() {
        var row = Tabular<Keys>.Row()
        row[.a] = "a"
        row[.b] = "123"
        
        let reference = """
        ┏━━━┳━━━━━┳━━━┓
        ┃ a ┃  b  ┃ c ┃
        ┡━━━╇━━━━━╇━━━┩
        │ a │ 123 │   │
        └───┴─────┴───┘
        """
        
        #expect(row.description == reference)
    }
    
    @Test
    func table() {
        let table = referenceTable()
        
        let reference = """
        ┏━━━━━━┳━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━┓
        ┃ Year ┃ Make  ┃                 Model                  ┃            Description            ┃  Price  ┃
        ┡━━━━━━╇━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━┩
        │ 1997 │ Ford  │ E350                                   │ ac, abs, moon                     │ 3000.00 │
        │ 1999 │ Chevy │ Venture "Extended Edition"             │                                   │ 4900.00 │
        │ 1999 │ Chevy │ Venture "Extended Edition, Very Large" │                                   │ 5000.00 │
        │ 1996 │ Jeep  │ Grand Cherokee                         │ MUST SELL! air, moon roof, loaded │ 4799.00 │
        └──────┴───────┴────────────────────────────────────────┴───────────────────────────────────┴─────────┘
        """
        #expect(table.description == reference)
    }
    
    
    enum Keys: String, TabularKey {
        case a
        case b
        case c
    }
    
}
