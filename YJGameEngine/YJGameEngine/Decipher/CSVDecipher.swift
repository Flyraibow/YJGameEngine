//
//  CSVDecipher.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/8/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

class CSVDecipher: NSObject {
  static func extractSchemaFromCSV(url : URL) throws -> SchemaData? {
    let csvDataList = try readCSVFile(url: url);
    let schemaName = url.deletingPathExtension().lastPathComponent;
    var schemaType = SchemaDataType.SchemaDataType_SingleValue;
    
    let CSVTypes : [String: String] = [
      "int" : "Int",
      "doube" : "Float",
      "string" : "String",
      "bool" : "Bool",
    ]
    
    if csvDataList.count >= 4 {
      let fieldNames = csvDataList[0];
      let fieldTypes = csvDataList[1];
      let subTypes = csvDataList[2];
      let isMutables = csvDataList[3];
      schemaType = fieldTypes.firstIndex(of: "id") != nil ? SchemaDataType.SchemaDataType_KeyValue : SchemaDataType.SchemaDataType_SingleValue;
      
      let schema = try SchemaData(name: schemaName, type: schemaType, description: "no description.");
      let fieldNum = fieldNames.count;
      if (fieldNum == fieldTypes.count && fieldNum == isMutables.count && fieldNum == subTypes.count) {
        for i in 0..<fieldNames.count {
          let type = fieldTypes[i];
          if type == "id" {
            continue;
          }
          let fieldName = fieldNames[i];
          let _ = fieldTypes[i];
          let isMutable = isMutables[i] == "Y";
          let fieldType = CSVTypes[type] ?? "String";
          let fieldData = SchemaField(fieldName: fieldName, fieldType: fieldType, isMutable: isMutable, description: "", defaultValue: "no description");
          try schema.addField(field: fieldData)
        }
      } else {
        throw NSError(domain: String(format: "Failed import %@, due to different length of types", url.path), code: ErrorWrongCSVFields, userInfo: nil);
      }
      return schema;
    }
    return nil;
  }
}
