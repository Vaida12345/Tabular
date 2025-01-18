//
//  Row.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//

import Essentials


extension Tabular {
    
    /// A row to a ``Tabular``.
    public struct Row: Equatable {
        
        private var dictionary: [Key : String]
        
        
        /// Creates a row.
        public init() {
            self.dictionary = [:]
            self.dictionary.reserveCapacity(Key.allCases.count)
        }
        
        
        /// Access the value associated with the given `index`.
        public subscript(_ index: Key) -> String {
            get {
                dictionary[index, default: ""]
            }
            set {
                dictionary[index] = newValue
            }
        }
        
        /// Access the value associated with the given `index`, or `nil` if the `index` is not valid.
        public subscript(_ index: String) -> String? {
            guard let index = Key(rawValue: index) else { return nil }
            return self[index]
        }
        
        public static func == (lhs: Row, rhs: Row) -> Bool {
            Key.allCases.allSatisfy { key in
                lhs[key] == rhs[key]
            }
        }
        
    }
    
}


extension Tabular.Row {
    
    /// Validates and ensures all keys have been assigned.
    public func validate() throws {
        let missingKeys = Set(Key.allCases).subtracting(self.dictionary.keys)
        guard missingKeys.isEmpty else { throw ValidationError.missingKeys(missingKeys) }
    }
    
    
    public enum ValidationError: GenericError {
        case missingKeys(Set<Key>)
        
        public var message: String {
            switch self {
            case .missingKeys(let keys): "Missing keys: \(keys)"
            }
        }
    }
    
}
