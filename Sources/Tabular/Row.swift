//
//  Row.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//


extension Tabular {
    
    /// A row to a ``Tabular``.
    public struct Row {
        
        private var dictionary: [String : String]
        
        
        /// Creates a row.
        public init() {
            self.dictionary = [:]
            self.dictionary.reserveCapacity(Key.allCases.count)
        }
        
        
        /// Access the value associated with the given `index`.
        public subscript(_ index: Key) -> String {
            get {
                dictionary[index.rawValue, default: ""]
            }
            set {
                dictionary[index.rawValue] = newValue
            }
        }
        
        /// Access the value associated with the given `index`, or `nil` if the `index` is not valid.
        public subscript(_ index: String) -> String? {
            guard let index = Key(rawValue: index) else { return nil }
            return dictionary[index.rawValue, default: ""]
        }
        
    }
    
}
