//
//  NewFieldViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/7/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class NewFieldViewController: NSViewController {

  @IBOutlet weak var _txtFieldName: NSTextField!
  @IBOutlet weak var _checkBoxIsMutable: NSButton!
  @IBOutlet weak var _txtDefaultValue: NSTextField!
  @IBOutlet weak var _txtDescription: NSTextField!
  @IBOutlet weak var _popUpFieldType: NSPopUpButton!
  
  @IBOutlet weak var _labSchemaName: NSTextField!
  weak var schema: SchemaData?
  weak var editingField : SchemaField?
  
  override func viewDidLoad() {
    super.viewDidLoad();
    _labSchemaName.stringValue = schema?.name ?? "";
    if self.editingField != nil {
      _txtFieldName.stringValue = self.editingField!.fieldName;
      _txtDefaultValue.stringValue = self.editingField!.defaultValue;
      _txtDescription.stringValue = self.editingField!.descriptionValue;
      _checkBoxIsMutable.state = self.editingField!.isMutable ? NSControl.StateValue.on: NSControl.StateValue.off;
      _popUpFieldType.selectItem(withTitle: self.editingField!.fieldType);
    }
  }
  
  @IBAction func clickCancelButton(_ sender: Any) {
    self.dismiss(nil);
  }
  
  
  @IBAction func clickConfirmButton(_ sender: Any) {
    do {
      try isValidFileName(name: _txtFieldName.stringValue)
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
      return;
    }
    let fieldType = _popUpFieldType.titleOfSelectedItem
    let description = _txtDescription.stringValue;
    let defaulValue = _txtDefaultValue.stringValue;
    let isMutable = _checkBoxIsMutable.state == NSControl.StateValue.on;
    
    do {
      try self.schema!.addField(fieldName: _txtFieldName.stringValue,
                                fieldType: fieldType!,
                                isMutable: isMutable,
                                description: description,
                                defaultValue: defaulValue,
                                replacingField: self.editingField);
      try self.schema!.update()
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Failed %@ field: %@", self.editingField != nil ? "edit" : "add", error.localizedDescription));
      return;
    }
    self.dismiss(nil);
  }
}
