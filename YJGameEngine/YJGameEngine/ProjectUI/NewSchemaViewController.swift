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
    let tag = _selectSchemaType.selectedTag();
    let description = _txtDescription.stringValue;
    
    do {
      try ProjectManager.shared.addSchema(name: _txtSchemaName.stringValue, type: tag, description: description);
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Failed add schema: %@", error.localizedDescription));
      return;
    }
    self.dismiss(nil);
  }
}
