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
  
  private let _className : String?
  let mainType : FieldMainType;
  let subType1 : FieldTypeData?;
  let subType2 : FieldTypeData?;
  var typeDescription : String?;
  
  init(className : String) {
    self._className = className;
    self.mainType = FieldMainType.Class;
    self.subType1 = nil;
    self.subType2 = nil;
  }
  
  init(mainType : FieldMainType, subType1 : FieldTypeData? = nil, subType2 : FieldTypeData? = nil) {
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
  static func getAllFieldTypes() -> [String : FieldTypeData] {
    var fieldTypes = [String : FieldTypeData]();
    // 1. List all basic types
    fieldTypes[FieldMainType.Int.rawValue] = FieldTypeData(mainType: FieldMainType.Int);
    fieldTypes[FieldMainType.Float.rawValue] = FieldTypeData(mainType: FieldMainType.Float);
    fieldTypes[FieldMainType.String.rawValue] = FieldTypeData(mainType: FieldMainType.String);
    fieldTypes[FieldMainType.Bool.rawValue] = FieldTypeData(mainType: FieldMainType.Bool);
    // 2. Add all defined types
    
    return fieldTypes;
  }
  
  static func getAllMainTypes() -> [String : FieldMainType] {
    return [
      FieldMainType.Int.rawValue : FieldMainType.Int,
      FieldMainType.Bool.rawValue : FieldMainType.Bool,
      FieldMainType.String.rawValue : FieldMainType.String,
      FieldMainType.Float.rawValue : FieldMainType.Float,
      FieldMainType.Comment.rawValue : FieldMainType.Comment,
      FieldMainType.Icon.rawValue : FieldMainType.Icon,
      FieldMainType.Class.rawValue : FieldMainType.Class,
      FieldMainType.Translation.rawValue : FieldMainType.Translation,
      FieldMainType.Array.rawValue : FieldMainType.Array,
      FieldMainType.Set.rawValue : FieldMainType.Set,
      FieldMainType.Dict.rawValue : FieldMainType.Dict,
      FieldMainType.Pair.rawValue : FieldMainType.Pair,
    ]
  }
}
