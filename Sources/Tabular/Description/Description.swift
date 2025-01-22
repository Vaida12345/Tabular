//
//  Description.swift
//  Tabular
//
//  Created by Vaida on 1/16/25.
//


extension Tabular.Row: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        self._write(to: &text)
        return text
    }
    
    private func _write(to target: inout some TextOutputStream) {
        let descriptor = Descriptor(self)
        descriptor.write(to: &target)
    }
}


extension Tabular: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        self._write(to: &text)
        return text
    }
    
    private func _write(to target: inout some TextOutputStream) {
        let descriptor = Descriptor(self)
        descriptor.write(to: &target)
    }
}
