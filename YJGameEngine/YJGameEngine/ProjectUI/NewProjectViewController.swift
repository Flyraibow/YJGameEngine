//
//  NewProjectViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class NewProjectViewController: NSViewController {
  
  @IBOutlet weak var _txtProjectName: NSTextField!
  @IBOutlet weak var _txtProjectPath: NSTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  @IBAction func clickSelectPathButton(_ sender: Any) {
    let path = selectFolderPath(text: "Select Your Project Directory");
    if path != nil {
      _txtProjectPath.stringValue = path!;
    }
  }
  
  @IBAction func clickCancelButton(_ sender: Any) {
    self.dismiss(nil)
  }
  
  @IBAction func clickConfirmButton(_ sender: Any) {
    if _txtProjectName.stringValue.isEmpty || _txtProjectPath.stringValue.isEmpty {
      errorAlert(title: "Error", text: "You need input valid project name and path first")
      return;
    }
    var isDir : ObjCBool = false
    if !FileManager.default.fileExists(atPath: _txtProjectPath.stringValue, isDirectory : &isDir) && isDir.boolValue {
      errorAlert(title: "Error", text: String(format: "The folder path (%@) doesn't exist", _txtProjectPath.stringValue));
      return
    }
    let projectPath = String(format: "%@/%@", _txtProjectPath.stringValue, _txtProjectName.stringValue);
    if FileManager.default.fileExists(atPath: projectPath) {
      errorAlert(title: "Error", text: String(format: "The folder path (%@) is not empty", projectPath));
      return
    }
    
    do {
      try ProjectManager.shared.createProject(path: projectPath)
    } catch let error as NSError {
      errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
      return;
    }
    
    self.dismiss(nil);
  }
}
