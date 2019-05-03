//
//  ProjectManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

class ProjectManager: NSObject {
  /* Returns the default singleton instance.
   */
  static let shared = ProjectManager();
  
  private var _projectFolerPath : String?;
  
  func createProject(path: String) throws -> Void {
    try createDirectory(path: path)
    
    // Create Schema Folder
    let schemaFolderPath = String(format: "%@/schema", path);
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
    
    NSLog("Complete Open Project: %@", (path as NSString).lastPathComponent);
  }
}
