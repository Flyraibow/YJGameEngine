//
//  WindowManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/7/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class WindowManager: NSObject {
  
  static func openNewProject() -> Void {
    let storyboard = NSStoryboard(name: "NewProjectWindow", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("NewProjectViewController")
    let vc = storyboard.instantiateController(withIdentifier: identifier) as! NewProjectViewController
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
  
  static func openAddSchema(editSchemaName : String? = nil) -> Void {
    do {
      try ProjectManager.shared.verifyProject();
    } catch let error as NSError {
      errorAlert(title: "Error", text: error.localizedDescription);
      return;
    }
    let storyboard = NSStoryboard(name: "NewSchemaViewController", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("NewSchemaViewController")
    let vc = storyboard.instantiateController(withIdentifier: identifier) as! NewSchemaViewController
    if editSchemaName != nil {
      vc.editSchema = ProjectManager.shared.getSchema(schemaName: editSchemaName!);
    }
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
  
  static func openAddField(schemaName: String, editingFieldName : String? = nil) -> Void {
    do {
      try ProjectManager.shared.verifyProject();
    } catch let error as NSError {
      errorAlert(title: "Error", text: error.localizedDescription);
      return;
    }
    let schema = ProjectManager.shared.getSchema(schemaName: schemaName);
    if schema == nil {
      errorAlert(title: "Error", text: String(format: "Unable to find schema : %@", schemaName));
      return
    }
    let storyboard = NSStoryboard(name: "NewFieldViewController", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("NewFieldViewController")
    let vc = storyboard.instantiateController(withIdentifier: identifier) as! NewFieldViewController
    vc.schema = schema;
    if editingFieldName != nil {
      let field = schema!.fieldMap[editingFieldName!];
      vc.editingField = field;
    }
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
}
