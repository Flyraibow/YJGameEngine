//
//  ProjectManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

let SCHEMA : String = "schema";

let YJEngineObserverSchemaChange = "YJEngineObserverSchemaChange"

class ProjectManager: NSObject {
  /* Returns the default singleton instance.
   */
  static let shared = ProjectManager();
  
  private var _projectFolerPath : String?;
  private var _schemaMap = [String: SchemaData]();
  
  func verifyProject() throws -> Void {
    if _projectFolerPath == nil {
      throw NSError(domain: "Need Open Project First", code: ErrorCodeNeedOpenProjectFirst, userInfo: nil);
    }
  }
  
  func createProject(path: String) throws -> Void {
    try createDirectory(path: path)
    
    // Create Schema Folder
    let schemaFolderPath = String(format: "%@/%@", path, SCHEMA);
    try createDirectory(path: schemaFolderPath)
    
    // Create Data Folder
    let dataFolderPath = String(format: "%@/data", path);
    try createDirectory(path: dataFolderPath)
    
    // Create config.json
    let configPath = String(format: "%@/config.json", path);
    let configJsonObject: [String: Any] = [
      "project_name": (path as NSString).lastPathComponent,
    ]
    try writeJSONFile(path: configPath, content: configJsonObject);
    NSLog("Complete Create Project: %@", (path as NSString).lastPathComponent);
    
    try openProject(path: path);
  }
  
  func openProject(path: String) throws -> Void {
    let configPath = String(format: "%@/config.json", path);
    if (FileManager.default.fileExists(atPath: configPath)) {
      _projectFolerPath = path;
    } else {
      throw NSError(domain: "Failed Open Project, config.json not exist", code: ErrorCodeFailedOpenProject, userInfo: nil);
    }
    // Load All schemas
    let schemaFolderPath = String(format: "%@/%@", path, SCHEMA);
    let schemas = try SchemaData.loadAllSchemas(schemaFolder: schemaFolderPath);
    for schema in schemas {
      addSchema(schema: schema);
    }
    
    UserDefaults.standard.set(path, forKey: kLastOpenedProjectPath);
    NSLog("Complete Open Project: %@", (path as NSString).lastPathComponent);
  }
  
  func getSchemaPath(name : String) throws -> String {
    try verifyProject();
    return String(format: "%@/%@/%@", _projectFolerPath!, SCHEMA, name);
  }
  
  func addSchema(name: String, type: SchemaDataType, description: String) throws -> Void {
    try verifyProject();
    let schema = try SchemaData(name: name, type: type, description: description);
    addSchema(schema: schema);
  }
  
  func addSchema(schema:SchemaData) -> Void {
    _schemaMap[schema.name] = schema;
    NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: YJEngineObserverSchemaChange)));
  }
  
  func deleteSchema(schemaName: String) throws -> Void {
    if _schemaMap[schemaName] != nil {
      try _schemaMap[schemaName]!.delteSchema();
      _schemaMap.removeValue(forKey: schemaName);
      NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: YJEngineObserverSchemaChange)));
    } else {
      throw NSError(domain: String(format: "schema %@ not exist", schemaName), code: ErrorSchemaNotExist, userInfo: nil);
    }
  }
  
  func getSchema(schemaName : String) -> SchemaData? {
    return _schemaMap[schemaName];
  }
  
  func getAllSchemas() -> [SchemaData] {
    return Array(_schemaMap.values).sorted { (schema1, schema2) -> Bool in
      return schema1.name < schema2.name;
    }
  }
}
