//
//  ViewController.swift
//  SwiftAirtableExample
//
//  Created by Nicolas Nascimento on 10/04/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation
import SwiftAirtable

// Standard Airtable Structure
struct AirtablePerson {
    // The airtable object id
    var id: String = ""
    var name: String = ""
    var age: Int = 0
    var photo: AirtableAttachment = AirtableAttachment(fileName: "", url: "")
    var date: Date = Date()
    var cool: Bool = false
}

extension AirtablePerson {
    enum AirtableField: String {
        case name = "name"
        case age = "age"
        case photo = "photo"
        case date = "date"
        case cool = "cool"
    }
}

// MARK: - AirtableObject
extension AirtablePerson: AirtableObject {
    
    static var fieldKeys: [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)] {
        var fields = [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)]()
        fields.append((fieldName: AirtableField.name.rawValue, fieldType: .singleLineText))
        fields.append((fieldName: AirtableField.age.rawValue, fieldType: .number))
        fields.append((fieldName: AirtableField.photo.rawValue, fieldType: .attachment))
        fields.append((fieldName: AirtableField.date.rawValue, fieldType: .dateWithHour))
        fields.append((fieldName: AirtableField.cool.rawValue, fieldType: .checkbox))
        return fields
    }
    
    func value(forKey key: AirtableTableSchemaFieldKey) -> AirtableValue? {
        switch key {
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.name.rawValue, fieldType: .singleLineText): return self.name
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.age.rawValue, fieldType: .number): return self.age
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.photo.rawValue, fieldType: .attachment): return self.photo
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.date.rawValue, fieldType: .dateWithHour): return self.date
        case AirtableTableSchemaFieldKey(fieldName: AirtableField.cool.rawValue, fieldType: .checkbox): return self.cool
        default: return nil
        }
    }
    
    init(withId id: String, populatedTableSchemaKeys tableSchemaKeys: [AirtableTableSchemaFieldKey : AirtableValue]) {
        self.id = id
        tableSchemaKeys.forEach { element in
            switch element.key {
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.name.rawValue, fieldType: .singleLineText): self.name = element.value.stringValue
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.age.rawValue, fieldType: .number): self.age = element.value.intValue
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.photo.rawValue, fieldType: .attachment):
                if let attachment = (element.value as? [AirtableAttachment])?.first {
                    self.photo = attachment
                }
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.date.rawValue, fieldType: .dateWithHour): self.date = element.value.dateValue
            case AirtableTableSchemaFieldKey(fieldName: AirtableField.cool.rawValue, fieldType: .checkbox): self.cool = element.value.boolValue
            default: break
            }
        }
    }
    
    
}
