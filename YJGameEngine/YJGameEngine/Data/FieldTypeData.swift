//
//  FieldTypeData.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/8/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Foundation

enum FieldMainType : String {
  case String = "String"
  case Int = "Int"
  case Float = "Float"
  case Bool = "Bool"
  case Array = "Array"
  case Set = "Set"
  case Dict = "Dict"
  case Pair = "Pair"
  case Comment = "Comment"
  case Class = "Class"
  case Icon = "Icon"
  case Translation = "Translation"
}

class FieldTypeData : NSObject {
  static private var _typeMap = [String: FieldTypeData]();
  
  private let _className : String?
  let fieldTypeId : String;
  let mainType : FieldMainType;
  let subType1 : FieldTypeData?;
  let subType2 : FieldTypeData?;
  var typeDescription : String?;
  
  init(fieldTypeId : String, className : String) {
    self.fieldTypeId = fieldTypeId;
    self._className = className;
    self.mainType = FieldMainType.Class;
    self.subType1 = nil;
    self.subType2 = nil;
  }
  
  init(fieldTypeId: String, mainType : FieldMainType, subType1 : FieldTypeData? = nil, subType2 : FieldTypeData? = nil) {
    self.fieldTypeId = fieldTypeId;
    self._className = nil;
    self.mainType = mainType;
    self.subType1 = subType1;
    self.subType2 = subType2;
    
    assert(mainType != FieldMainType.Class, "For class type, need init class names");
    if mainType == FieldMainType.Dict || mainType == FieldMainType.Pair {
      assert(subType1 != nil && subType2 != nil, "For dict/pair type, must have key and value types");
    } else if mainType == FieldMainType.Array || mainType == FieldMainType.Set {
      assert(subType1 != nil && subType2 == nil, "For array/set type, must have only 1 sub type");
    } else {
      assert(subType1 == nil && subType2 == nil, "For non-container type, must have no sub types");
    }
  }
  
  override func isEqual(to object: Any?) -> Bool {
    let other : FieldTypeData? = object as? FieldTypeData;
    if other != nil && other!.mainType == self.mainType
      && other!.subType1 == self.subType1
      && other!.subType2 == self.subType1
      && other!._className == self._className {
      return true;
    }
    return false;
  }
  
  // Used in subClass
  static func getAllFieldTypes() -> [String] {
    // 1. get the pre-defined field
    var definedTypes = [
      FieldMainType.Int.rawValue,
      FieldMainType.Float.rawValue,
      FieldMainType.String.rawValue,
      FieldMainType.Bool.rawValue
    ];
    // 2. get the defined field
    definedTypes.append(contentsOf: _typeMap.keys.sorted());
    
    return definedTypes;
  }
  
  static func getFieldType(typeId : String) -> FieldTypeData?
  {
    if _typeMap[typeId] != nil {
      return _typeMap[typeId];
    }
    let type = FieldMainType(rawValue: typeId);
    if type != nil {
      return FieldTypeData(fieldTypeId: typeId, mainType: type!);
    }
    return nil;
  }
  
  static func addFieldType(fieldType : FieldTypeData) throws ->Void {
    if FieldMainType(rawValue: fieldType.fieldTypeId) != nil ||
      _typeMap[fieldType.fieldTypeId] != nil {
      throw NSError(domain: String(format: "cannot define existing type : %@", fieldType.fieldTypeId), code: ErrorCodeDefineTypeFailed, userInfo: nil);
    }
    _typeMap[fieldType.fieldTypeId] = fieldType;
  }
  
  static func getFieldTypeConfigPath() throws -> String {
    return String(format: "%@/types.json", try ProjectManager.shared.getProjectPath());
  }
  
  static func saveFieldTypes() throws -> Void {
    let fieldPath = try getFieldTypeConfigPath();
    let content : [String : Any] = _typeMap.mapValues { (fieldType : FieldTypeData) -> [String : Any] in
      return [
        "type" : fieldType.mainType.rawValue,
        "description" : fieldType.typeDescription ?? "",
        "subType1" : fieldType._className ?? fieldType.subType1!.fieldTypeId,
        "subType2" : fieldType.subType2?.fieldTypeId ?? "",
      ];
    }
    try writeJSONFile(path: fieldPath, content: content)
  }
  
  static func loadFieldTypes() throws -> Void {
    
  }
  
//  static func getAllMainTypes() -> [String : FieldMainType] {
//    return [
//      FieldMainType.Int.rawValue : FieldMainType.Int,
//      FieldMainType.Bool.rawValue : FieldMainType.Bool,
//      FieldMainType.String.rawValue : FieldMainType.String,
//      FieldMainType.Float.rawValue : FieldMainType.Float,
//      FieldMainType.Comment.rawValue : FieldMainType.Comment,
//      FieldMainType.Icon.rawValue : FieldMainType.Icon,
//      FieldMainType.Class.rawValue : FieldMainType.Class,
//      FieldMainType.Translation.rawValue : FieldMainType.Translation,
//      FieldMainType.Array.rawValue : FieldMainType.Array,
//      FieldMainType.Set.rawValue : FieldMainType.Set,
//      FieldMainType.Dict.rawValue : FieldMainType.Dict,
//      FieldMainType.Pair.rawValue : FieldMainType.Pair,
//    ]
//  }
}
