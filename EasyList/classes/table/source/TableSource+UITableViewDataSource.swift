//
//  Source+UITableViewDataSource.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

extension TableSource: UITableViewDataSource {
    
    //MARK: - Section
    public func numberOfSections(in tableView: UITableView) -> Int {
        if verbose {
            print("[EasyList] DataSource numberOfSections \(sections.count)")
        }
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if verbose {
            print("[EasyList] DataSource numberOfRowsInSection \(getSection(index: section).section.rowCount())")
        }
        return getSection(index: section).section.rowCount()
    }
    
    //MARK: - Header
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = getHeader(index: section)
        
        if header is NativeHeader {
            return (header as! NativeHeader).title
        }
        
        return nil
    }
    
    //MARK: - Footer
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let footer = getFooter(index: section)
        
        if footer is NativeFooter {
            return (footer as! NativeFooter).title
        }
        
        return nil
    }
    
    //MARK: - Row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifiedRow = getRow(indexPath: indexPath)
        
        let cell = identifiedRow.row.getCell(tableView: tableView)
        cell.selectionStyle = identifiedRow.row.selectionStyle?() ?? cell.selectionStyle
        
        if verbose {
            print("[EasyList] DataSource cellForRowAt \(indexPath) - \(cell)")
        }
        
        return cell
    }
    
    //MARK: - Edit row
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let identifiedRow = getRow(indexPath: indexPath)
        return identifiedRow.row.isEditable?() ?? false
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.commitEditingStyle?(editingStyle: editingStyle, at: indexPath, for: tableView)
    }
    
    //MARK: - Move row
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return delegate?.canMoveRow?(at: indexPath, for: tableView) ?? false
    }
    
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.moveRowAt?(sourceIndexPath: sourceIndexPath, to: destinationIndexPath, for: tableView)
    }
    
    //MARK: - Section Titles
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return delegate?.sectionIndexTitles?(for: tableView) ?? []
    }
    
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return delegate?.sectionForSectionIndexTitle?(for: tableView, title: title, at: index)  ?? 0
    }
}
