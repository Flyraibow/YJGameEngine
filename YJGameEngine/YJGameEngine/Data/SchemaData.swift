//
//  SchemaData.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/3/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

let ErrorCodeSchemaAlreadyExist: Int = 100;
let ErrorCodeSchemaNotFound: Int = 101;

class SchemaData: NSObject {
  let name : String
  let path : String
  let type : Int
  var schemaDescription: String
  
  static func loadAllSchemas(schemaFolder : String) throws -> [SchemaData] {
    let fileURLs = try listFilesInFolder(folderPath: schemaFolder, ext: "json");
    var schemaList = [SchemaData]();
    for url in fileURLs {
      let schema = try SchemaData(path: url.path);
      schemaList.append(schema)
    }
    return schemaList;
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
    self.type = jsonContent["type"] as! Int;
    self.schemaDescription = jsonContent["description"] as! String;
  }
  
  init(name: String, type: Int, description: String) throws {
    let fileName = String(format: "%@.json", name);
    let path = try ProjectManager.shared.getSchemaPath(name: fileName)
    if FileManager.default.fileExists(atPath: path) {
      throw NSError(domain: String(format: "Schema (:%@) already exist", path), code: ErrorCodeSchemaAlreadyExist, userInfo: nil);
    }
    self.name = name;
    self.path = path;
    self.type = type;
    self.schemaDescription = description;
    let initialContent : [String: Any] = [
        "type" : type,
        "description" : description
    ];
    try writeJSONFile(path: self.path, content: initialContent)
  }
  
  func delteSchema() throws -> Void {
    try FileManager.default.removeItem(at: URL(fileURLWithPath: self.path))
  }
}
