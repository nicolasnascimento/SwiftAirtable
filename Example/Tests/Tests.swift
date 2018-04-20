import XCTest
import SwiftAirtable

class Tests: XCTestCase {
    
    func testAirtableInit() {
        var fields = [(fieldName: String, fieldType: AirtableTableSchemaFieldKey.KeyType)]()
        fields.append((fieldName: "name", fieldType: .singleLineText))
        let fieldsKey = fields.map{ AirtableTableSchemaFieldKey(fieldName: $0.fieldName, fieldType: $0.fieldType) }
        let _ = Airtable(apiKey: "AN_API_KEY", apiBaseUrl: "AN_API_BASE_URL", schema: AirtableTableSchema(fieldsKeys: fieldsKey))

    }
}
