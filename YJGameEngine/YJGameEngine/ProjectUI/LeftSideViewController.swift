//
//  LeftSideViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/3/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

enum DefinedCategory {
  case top
  case schema
  case type
  case undefined
}

let TopDefinedCategoryTypes : [DefinedCategory : String] = [
  DefinedCategory.schema : "Schema",
  DefinedCategory.type : "type",
  DefinedCategory.undefined : "undefined"
]

let TopDefinedCategory = [
  Cell(name: TopDefinedCategoryTypes[DefinedCategory.schema]),
  Cell(name: TopDefinedCategoryTypes[DefinedCategory.type]),
]


class Cell: NSObject {
  let name: String
  let type: DefinedCategory
  
  init(name: String?, type: DefinedCategory = DefinedCategory.top) {
    self.name = name ?? "undefined"
    self.type = type
  }
}

class LeftSideViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate , NSMenuItemValidation, NSMenuDelegate {
  
  
  @IBOutlet weak var _outlineView: NSOutlineView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(dataRefresh),
                                           name: NSNotification.Name(rawValue: YJEngineObserverSchemaChange),
                                           object: nil);
  }
  
  @objc func dataRefresh() -> Void {
    _outlineView.reloadData();
  }
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
  {
    if item == nil {
      return TopDefinedCategory.count;
    } else {
      if let feed = item as? Cell {
        if feed.name == "Schema" {
          return ProjectManager.shared.getAllSchemas().count;
        }
      }
    }
    return 0;
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
  {
    if item == nil {
      return TopDefinedCategory[index];
    } else {
      if let feed = item as? Cell {
        if feed.name == "Schema" {
          let schemaList = ProjectManager.shared.getAllSchemas();
          return Cell(name: schemaList[index].name, type: DefinedCategory.schema);
        }
      }
    }
    return Cell(name: "error", type: DefinedCategory.undefined);
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
  {
    let cell = item as? Cell
    if cell != nil && cell?.type == DefinedCategory.top {
      return true;
    }
    return false;
  }
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    if let feed = item as? Cell {
      view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
      if let textField = view?.textField {
        textField.stringValue = feed.name
      }
    }
    return view;
  }
  
  func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    let cell : Cell? = menuItem.representedObject as? Cell;
    if cell != nil && cell!.type == DefinedCategory.schema {
      return true;
    }
    return false;
  }
  
  func menuNeedsUpdate(_ menu: NSMenu) {
    let row = _outlineView.clickedRow
    let cell = _outlineView.item(atRow: row);
    
    guard row != -1 else { return }
    for item in menu.items {
      item.representedObject = cell
    }
  }
  
  @IBAction func clickDelete(_ menuItem: NSMenuItem) {
    let cell : Cell? = menuItem.representedObject as? Cell;
    if cell != nil && cell!.type == DefinedCategory.schema {
      if (selectionAlert(title: "Warning", text: String(format: "Are you sure to delete this schema : %@", cell!.name))) {
        // delete the schema
        do {
          try ProjectManager.shared.deleteSchema(schemaName: cell!.name)
        } catch let error as NSError {
          errorAlert(title: "Error", text: String(format: "Failed delete schema: %@", error.localizedDescription));
          return;
        }
      }
    }
  }
}
