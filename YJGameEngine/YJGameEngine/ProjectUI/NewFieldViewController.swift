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
  
  override func viewDidLoad() {
    super.viewDidLoad();
    _labSchemaName.stringValue = schema?.name ?? "";
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
                                defaultValue: defaulValue)
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Failed add field: %@", error.localizedDescription));
      return;
    }
    self.dismiss(nil);
  }
}
