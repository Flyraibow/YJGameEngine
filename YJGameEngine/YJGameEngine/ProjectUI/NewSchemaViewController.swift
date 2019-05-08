//
//  NewSchemaViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/4/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class NewSchemaViewController: NSViewController {
  
  @IBOutlet weak var _txtSchemaName: NSTextField!
  @IBOutlet weak var _txtDescription: NSTextField!
  @IBOutlet weak var _selectSchemaType: NSPopUpButton!
  
  weak var editSchema: SchemaData?
  
  override func viewDidAppear() {
    super.viewDidAppear();
    if self.editSchema != nil {
      // It's editing not creating
      _txtSchemaName.stringValue = self.editSchema!.name;
      _txtDescription.stringValue = self.editSchema!.schemaDescription;
      let type = self.editSchema!.type;
      _selectSchemaType.selectItem(withTag: type.rawValue);
    }
  }
  
  @IBAction func clickCancelButton(_ sender: Any) {
    self.dismiss(nil);
  }
  @IBAction func clickConfirmButton(_ sender: Any) {
    do {
      try isValidFileName(name: _txtSchemaName.stringValue)
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
      return;
    }
    let schemaType = SchemaDataType(rawValue: _selectSchemaType.selectedTag()) ?? SchemaDataType.SchemaDataType_KeyValue;
    let description = _txtDescription.stringValue;
    
    do {
      try ProjectManager.shared.addSchema(name: _txtSchemaName.stringValue, type: schemaType, description: description, replacingSchema: self.editSchema);
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Failed to %@ schema: %@", self.editSchema != nil ? "edit" : "add", error.localizedDescription));
      return;
    }
    self.dismiss(nil);
  }
}
