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
        
        /// The values stored in the row.
        @inlinable
        public var values: [String] {
            Key.allCases.map({ self[$0] })
        }
        
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
        
        /// Creates the sequence with the values stored.
        ///
        /// - throws: ``ValidationError/invalid(expected:got:)``.
        public init(_ sequence: some Sequence<String>) throws {
            self.dictionary = [:]
            let allKeys = Key.allCases
            let keysCount = allKeys.count
            self.dictionary.reserveCapacity(keysCount)
            for (key, value) in zip(allKeys, sequence) {
                self.dictionary[key] = value
            }
            guard self.dictionary.count == keysCount else {
                throw ValidationError.incorrectCount(expected: keysCount, got: self.dictionary.count)
            }
        }
        
        /// Access the value associated with the given `index`, or `nil` if the `index` is not valid.
        @inlinable
        public subscript(_ index: String) -> String? {
            guard let index = Key(rawValue: index) else { return nil }
            return self[index]
        }
        
        @inlinable
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
        case incorrectCount(expected: Int, got: Int)
        
        public var message: String {
            switch self {
            case .missingKeys(let keys): "Missing keys: \(keys)"
            case .incorrectCount(let expected, let got): "Incorrect number of columns: expected \(expected), got \(got)"
            }
        }
    }
    
}
