//
//  EngineFileManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/2/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

func isValidFileName(name: String) throws -> Void {
  if name.isEmpty {
    throw NSError(domain: "Empty Name", code: ErrorCodeInvalidFileName, userInfo: nil);
  }
  
  for chr in name {
    if !chr.isLetter {
      throw NSError(domain: String(format: "Invalid Character : %@", String(chr)), code: ErrorCodeInvalidFileName, userInfo: nil);
    }
  }
}

func createDirectory(path: String) throws -> Void {
  let urlPath = NSURL(fileURLWithPath: path, isDirectory: true);
  NSLog("Create Directory : %@", urlPath.path!);
  var isDir : ObjCBool = false
  if !FileManager.default.fileExists(atPath: urlPath.path!, isDirectory: &isDir) || !isDir.boolValue {
    try FileManager.default.createDirectory(atPath: urlPath.path!, withIntermediateDirectories: true, attributes: nil)
  }
}

func listFilesInFolder(folderPath: String, ext: String?) throws -> [URL] {
  let fileManager = FileManager.default
  var fileURLs = try fileManager.contentsOfDirectory(at: URL(fileURLWithPath: folderPath), includingPropertiesForKeys: nil)
  if ext != nil {
    fileURLs = fileURLs.filter { (url) -> Bool in
      return url.pathExtension == ext!;
    }
  }
  return fileURLs;
}

func writeJSONFile(path: String, content: Any) throws -> Void {
  if !JSONSerialization.isValidJSONObject(content) {
    throw NSError(domain: "Invalid JSON content", code: ErrorCodeInvalidJSON, userInfo: nil);
  }
  let data = try JSONSerialization.data(withJSONObject: content, options:.init(rawValue: 0))
  
  NSLog("Write json file at : %@", path);
  try data.write(to: URL(fileURLWithPath: path))
}

func readJSONFile(path: String) throws -> Any {
  let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
  let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []);
  if !JSONSerialization.isValidJSONObject(jsonDict) {
    throw NSError(domain: String(format: "Load Invalid JSON content: %@", path), code: ErrorCodeInvalidJSON, userInfo: nil);
  }
  return jsonDict;
}
