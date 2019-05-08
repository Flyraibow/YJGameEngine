//
//  AppDelegate.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

let kLastOpenedProjectPath : String = "kLastOpenedProjectPath"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    
    let folderPath = UserDefaults.standard.string(forKey: kLastOpenedProjectPath)
    if folderPath != nil {
      do {
        try ProjectManager.shared.openProject(path: folderPath!)
      } catch let error as NSError {
        errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
        return;
      }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  @IBAction func clickNewProject(_ sender: Any) {
    WindowManager.openNewProject();
  }
  
  @IBAction func clickOpenProject(_ sender: Any) {
    let projectFolder = selectFolderPath(text: "Select Your Project Path");
    if projectFolder != nil {
      do {
        try ProjectManager.shared.openProject(path: projectFolder!)
      } catch let error as NSError {
        errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
        return;
      }
    }
  }
  
  @IBAction func clickAddSchema(_ sender: Any) {
    WindowManager.openAddSchema();
  }
}

