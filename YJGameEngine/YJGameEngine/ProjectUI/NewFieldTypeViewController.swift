//
//  NewFieldTypeViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/9/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class NewFieldTypeViewController: NSViewController {
  
  @IBOutlet weak var _txtFieldTypeId: NSTextField!
  @IBOutlet weak var _popUpMainType: NSPopUpButton!
  @IBOutlet weak var _popUpSubType1: NSPopUpButton!
  @IBOutlet weak var _popUpSubType2: NSPopUpButton!
  @IBOutlet weak var _txtDescription: NSTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad();
    // Set Main Type List
    _popUpMainType.addItems(withTitles: [
      FieldMainType.Array.rawValue,
      FieldMainType.Set.rawValue,
      FieldMainType.Dict.rawValue,
      FieldMainType.Pair.rawValue,
      FieldMainType.Class.rawValue
      ]
    );
    mainTypeChanged(_popUpMainType!);
  }
  
  @IBAction func mainTypeChanged(_ sender: Any) {
    let mainType = FieldMainType(rawValue: _popUpMainType.titleOfSelectedItem!)!;
    switch mainType {
    case FieldMainType.Array, FieldMainType.Set:
      _popUpSubType1.removeAllItems();
      _popUpSubType2.removeAllItems();
      _popUpSubType1.addItems(withTitles: FieldTypeData.getAllFieldTypes());
      break;
    case FieldMainType.Dict, FieldMainType.Pair:
      _popUpSubType1.removeAllItems();
      _popUpSubType2.removeAllItems();
      _popUpSubType1.addItems(withTitles: FieldTypeData.getAllFieldTypes());
      _popUpSubType2.addItems(withTitles: FieldTypeData.getAllFieldTypes());
      break;
    case FieldMainType.Class:
      _popUpSubType1.removeAllItems();
      _popUpSubType2.removeAllItems();
      let classNames = ProjectManager.shared.getAllSchemas().map { (schema : SchemaData) -> String in
        return schema.name
      }
      _popUpSubType1.addItems(withTitles: classNames);
      break;
    default:
      assert(false, String(format:"Unrecoginize main types: %@", mainType.rawValue));
    }
    typeChanged(sender);
  }
  
  @IBAction func typeChanged(_ sender: Any) {
    // Auto calculate the field Id
    let mainType = _popUpMainType.titleOfSelectedItem!
    let subType1 = _popUpSubType1.titleOfSelectedItem;
    let subType2 = _popUpSubType2.titleOfSelectedItem;
    if subType1 != nil && subType2 != nil {
      _txtFieldTypeId.stringValue = String(format: "%@[%@,%@]", mainType, subType1!, subType2!);
    } else if subType1 != nil {
      _txtFieldTypeId.stringValue = String(format: "%@[%@]", mainType, subType1!);
    } else {
      _txtFieldTypeId.stringValue = String(format: "%@[]", mainType);
    }
  }
  
  
  @IBAction func clickCancel(_ sender: Any) {
    self.dismiss(nil);
  }
  
  @IBAction func clickConfirm(_ sender: Any) {
    let typeId = _txtFieldTypeId.stringValue;
    if typeId.isEmpty {
      errorAlert(title: "Error", text: "No type Id");
      return;
    }
    
    var fieldData : FieldTypeData? = nil;
    let subTypeStr1 = _popUpSubType1.titleOfSelectedItem;
    let subTypeStr2 = _popUpSubType2.titleOfSelectedItem;
    let mainType = FieldMainType(rawValue: _popUpMainType.titleOfSelectedItem!)!;
    if mainType == FieldMainType.Class {
      fieldData = FieldTypeData(fieldTypeId: typeId, className: subTypeStr1!);
    } else {
      let subType1 = FieldTypeData.getFieldType(typeId: subTypeStr1!);
      let subType2 = subTypeStr2 != nil ? FieldTypeData.getFieldType(typeId: subTypeStr2!) : nil;
      fieldData = FieldTypeData(fieldTypeId: typeId, mainType: mainType, subType1: subType1, subType2: subType2);
    }
    do {
      fieldData!.typeDescription = _txtDescription.stringValue;
      try FieldTypeData.addFieldType(fieldType: fieldData!);
      try FieldTypeData.saveFieldTypes();
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
      return;
    }
    self.dismiss(nil);
  }
}

