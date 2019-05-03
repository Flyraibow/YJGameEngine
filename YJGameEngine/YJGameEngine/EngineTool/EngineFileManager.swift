//
//  EngineFileManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/2/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

func createDirectory(path: String) throws -> Void {
  let urlPath = NSURL(fileURLWithPath: path, isDirectory: true);
  NSLog("Create Directory : %@", urlPath.path!);
  var isDir : ObjCBool = false
  if !FileManager.default.fileExists(atPath: urlPath.path!, isDirectory: &isDir) || !isDir.boolValue {
    try FileManager.default.createDirectory(atPath: urlPath.path!, withIntermediateDirectories: true, attributes: nil)
  }
}

func writeJSONFile(path: String, content: Any) throws -> Void {
  if !JSONSerialization.isValidJSONObject(content) {
    throw NSError(domain: "Invalid JSON content", code: ErrorCodeInvalidJSON, userInfo: nil);
  }
  let data = try JSONSerialization.data(withJSONObject: content, options:.init(rawValue: 0))
  
  NSLog("Write json file at : %@", path);
  try data.write(to: URL(fileURLWithPath: path))
}
