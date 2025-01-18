//
//  Key.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//


/// The protocol that the `Key`s of ``Tabular`` conforms.
///
/// Use this protocol to declare the titles to a tabular, where the `rawValue`s will be used as titles.
public protocol TabularKey: RawRepresentable, CaseIterable, Equatable, Hashable, Sendable where Self.RawValue == String {
    
}
