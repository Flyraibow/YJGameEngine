//
//  SchemaData.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/3/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

let ErrorCodeSchemaAlreadyExist: Int = -100;
let ErrorCodeSchemaNotFound: Int = -101;
let ErrorCodeSchemaFieldAlreadyExist: Int = -103;
let ErrorCodeSchemaDeleteFieldFailed: Int = -104;

enum SchemaDataType:Int {
  case SchemaDataType_KeyValue = 0
  case SchemaDataType_SingleValue = 1;
}

class SchemaData: NSObject {
  let name : String
  let path : String
  let type : SchemaDataType
  var schemaDescription: String
  var fieldMap = [String : SchemaField]()
  
  static func loadAllSchemas(schemaFolder : String) throws -> [SchemaData] {
    let fileURLs = try listFilesInFolder(folderPath: schemaFolder, ext: "json");
    var schemaList = [SchemaData]();
    for url in fileURLs {
      let schema = try SchemaData(path: url.path);
      schemaList.append(schema)
    }
    return schemaList;
  }
  
  func save() throws -> Void {
    let fieldList = self.fieldMap.map { (_, value) -> [String: Any] in
      return value.convertToJSON();
    }
    
    let content : [String: Any] = [
      "type" : self.type.rawValue,
      "description" : self.schemaDescription,
      "fields" : fieldList,
    ];
    try writeJSONFile(path: self.path, content: content)
  }
  
  // load Schema From path
  init(path: String) throws {
    if !FileManager.default.fileExists(atPath: path) {
      throw NSError(domain: String(format: "Schema (:%@) not found", path), code: ErrorCodeSchemaNotFound, userInfo: nil);
    }
    let jsonDict = try readJSONFile(path: path);
    
    self.path = path;
    self.name = ((path as NSString).lastPathComponent as NSString).deletingPathExtension;
    let jsonContent : [String: Any] = jsonDict as! [String : Any];
    self.type = SchemaDataType(rawValue: jsonContent["type"] as! Int) ?? SchemaDataType.SchemaDataType_KeyValue;
    self.schemaDescription = jsonContent["description"] as! String;
    let fieldJsons = jsonContent["fields"] as? [Any] ?? [];
    self.fieldMap = try fieldJsons.reduce(into: [String:SchemaField]()) {
      let field = try SchemaField(jsonContent: $1 as! [String:Any])
      $0[field.fieldName] = field
    }
  }
  
  init(name: String, type: SchemaDataType, description: String) throws {
    let fileName = String(format: "%@.json", name);
    let path = try ProjectManager.shared.getSchemaPath(name: fileName)
    if FileManager.default.fileExists(atPath: path) {
      throw NSError(domain: String(format: "Schema (:%@) already exist", path), code: ErrorCodeSchemaAlreadyExist, userInfo: nil);
    }
    self.name = name;
    self.path = path;
    self.type = type;
    self.schemaDescription = description;
    // Add Id field for keyValuedType
    var schemaFieldMap = [String : SchemaField]();
    if type == SchemaDataType.SchemaDataType_KeyValue {
      let schemaField = SchemaField(fieldName: "id", fieldType: "string", isMutable: false)
      schemaFieldMap[schemaField.fieldName] = schemaField;
      self.fieldMap = schemaFieldMap;
    }
    super.init();
    try save();
  }
  
  func delteSchema() throws -> Void {
    try FileManager.default.removeItem(at: URL(fileURLWithPath: self.path))
  }
  
  func addField(fieldName: String, fieldType: String, isMutable: Bool, description: String, defaultValue: String) throws -> Void {
    let schemaField = SchemaField(fieldName: fieldName, fieldType: fieldType, isMutable: isMutable, description: description, defaultValue: defaultValue);
    try addField(field: schemaField);
  }
  
  func addField(field : SchemaField) throws -> Void {
    if field.fieldName.isEmpty || self.fieldMap[field.fieldName] != nil {
      throw NSError(domain: String(format: "Schema Field (:%@) already exist", field.fieldName), code: ErrorCodeSchemaFieldAlreadyExist, userInfo: nil);
    }
    self.fieldMap[field.fieldName] = field;
    try save();
    
    NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: YJEngineObserverSchemaChange)));
  }
  
  func deleteField(fieldName : String) throws -> Void {
    let field = self.fieldMap[fieldName];
    if field != nil && self.type == SchemaDataType.SchemaDataType_KeyValue && field?.fieldName == "id" {
      throw NSError(domain: "You can't remove id field for key-value data", code: ErrorCodeSchemaDeleteFieldFailed, userInfo: nil);
    }
    self.fieldMap[fieldName] = nil;
    try save();
    
    NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: YJEngineObserverSchemaChange)));
  }
  
  func getAllFields() -> [SchemaField] {
    return Array(fieldMap.values).sorted { (schema1, schema2) -> Bool in
      return schema1.fieldName < schema2.fieldName;
    }
  }
}
