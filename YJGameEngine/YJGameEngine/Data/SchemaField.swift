//
//  SchemaField.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/6/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

class SchemaField: NSObject {
  var fieldName : String;
  var fieldType : String;
  var isMutable : Bool;
  var defaultValue : String;
  var descriptionValue: String
  
  init(jsonContent : [String: Any]) throws {
    self.fieldName = jsonContent["name"] as! String;
    self.fieldType = jsonContent["type"] as! String;
    self.isMutable = jsonContent["is_mutable"] as! Bool;
    self.descriptionValue = jsonContent["description"] as! String;
    self.defaultValue = jsonContent["default_value"] as! String;
  }
  
  init(fieldName: String, fieldType: String, isMutable: Bool, description: String = "", defaultValue: String = "") {
    self.fieldName = fieldName;
    self.fieldType = fieldType;
    self.isMutable = isMutable
    self.defaultValue = defaultValue;
    self.descriptionValue = description;
  }
  
  func convertToJSON() -> [String: Any] {
    let content : [String: Any] = [
      "name" : self.fieldName,
      "type" : self.fieldType,
      "is_mutable" : self.isMutable,
      "description" : self.descriptionValue,
      "default_value" : self.defaultValue,
    ];
    return content;
  }
}
