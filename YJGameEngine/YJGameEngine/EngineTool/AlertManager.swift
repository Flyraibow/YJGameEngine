//
//  AlertManager.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

func errorAlert(title: String, text: String) -> Void {
  let alert: NSAlert = NSAlert()
  alert.messageText = title
  alert.informativeText = text
  alert.alertStyle = NSAlert.Style.warning
  alert.addButton(withTitle: "OK")
  alert.runModal()
}

func selectFolderPath(text: String) -> String? {
  let dialog = NSOpenPanel();
  dialog.title                   = text;
  dialog.showsResizeIndicator    = true;
  dialog.showsHiddenFiles        = false;
  dialog.canChooseDirectories    = true;
  dialog.canCreateDirectories    = true;
  dialog.allowsMultipleSelection = false;

  if (dialog.runModal() == NSApplication.ModalResponse.OK) {
    let result = dialog.url // Pathname of the file
    if (result != nil) {
      let path = result!.path
      return path;
    }
  }
  return nil;
}

func selectionAlert(title: String, text: String) -> Bool {
  let alert: NSAlert = NSAlert()
  alert.messageText = title
  alert.informativeText = text
  alert.alertStyle = NSAlert.Style.warning
  alert.addButton(withTitle: "YES")
  alert.addButton(withTitle: "Cancel")
  let res = alert.runModal()
  if res == NSApplication.ModalResponse.alertFirstButtonReturn {
    return true
  }
  return false
}
