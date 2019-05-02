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
  
  func createProject(path: String) throws -> Void {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    
    // TODO: Initialize folder
    // 1. Add config.json
    // 2. Create Folders (Data, Data/Schema)
  }
}
