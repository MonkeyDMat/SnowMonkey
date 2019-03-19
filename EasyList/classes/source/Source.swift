//
//  Source.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

public class Source: NSObject, RowLayout, RowLayoutProvider, RowEdition, RowEditionProvider, RowSelection, RowSelectionProvider {
    
    typealias ReturnType = Source
    
    var sections: [BaseSection]
    public var delegate: SourceDelegate?
    public weak var tableView: TableView?
    
    public init(sections: [BaseSection] = [], tableView: TableView, delegate: SourceDelegate? = nil) {
        self.sections = sections
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.tableView?.source = self
    }
    
    //MARK: - Section
    @discardableResult
    public func addSection(_ section: BaseSection) -> BaseSection {
        section.source = self
        sections.append(section)
        return section
    }
    
    func getSection(index: Int) -> BaseSection {
        return sections[index]
    }
    
    //MARK: - Header
    func getHeader(index: Int) -> BaseHeader? {
        return getSection(index: index).getHeader()
    }
    
    //MARK: - Footer
    func getFooter(index: Int) -> BaseFooter? {
        return getSection(index: index).getFooter()
    }
    
    //MARK: - Row
    func getRow(indexPath: IndexPath) -> RowType {
        return getSection(index: indexPath.section).getRow(at: indexPath.row)
    }
    
    @discardableResult
    public func insertRow(_ row: RowType, at index: IndexPath, animation: UITableView.RowAnimation = .automatic) -> Source {
        let section = getSection(index: index.section)
        section.addRow(row, at: index.row)
        tableView?.insertRows(at: [index], with: animation)
        return self
    }
    
    @discardableResult
    public func insertRow<RowTypeToInsert: RowType>(_ row: RowTypeToInsert, in section: Int, after predicate: (RowType, RowTypeToInsert) -> Bool, animation: UITableView.RowAnimation = .automatic) -> Source {
        let currentSection = getSection(index: section)
        var insertIndex = 0
        for (currentIndex, currentRow) in currentSection.rows.enumerated() {
            if predicate(currentRow, row) {
                insertIndex = max(insertIndex, currentIndex + 1)
            }
        }
        insertRow(row, at: IndexPath(row: insertIndex, section: section))
        return self
    }
    
    
    @discardableResult
    public func deleteRow(at index: IndexPath, animation: UITableView.RowAnimation = .automatic) -> Source {
        let section = getSection(index: index.section)
        section.deleteRow(at: index.row)
        tableView?.deleteRows(at: [index], with: animation)
        return self
    }
    
    //MARK: - RowLayoutProvider
    var _height: (() -> CGFloat)?
    var _estimatedHeight: (() -> CGFloat)?
    var _selectionStyle: (() -> UITableViewCell.SelectionStyle)?
    
    //MARK: - RowEditionProvider
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((IndexPath) -> IndexPath?)?
    var _didDeselect: ((_ index: IndexPath) -> Void)?
}

@objc public protocol SourceDelegate {
    @objc optional func canMoveRow(at: IndexPath, for tableView: UITableView) -> Bool
    @objc optional func sectionIndexTitles(for tableView: UITableView) -> [String]?
    @objc optional func sectionForSectionIndexTitle(for tableView: UITableView, title: String, at index: Int) -> Int
    @objc optional func commitEditingStyle(editingStyle: UITableViewCell.EditingStyle, at index: IndexPath, for: UITableView)
    @objc optional func moveRowAt(sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath, for tableView: UITableView)
    
    @objc optional func willDisplayRow(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    @objc optional func didEndDisplayRow(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    
    @objc optional func accessoryButtonTappedForRowWith(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    @objc optional func shouldHighlightRowAt(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    @objc optional func didHighlightRowAt(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    @objc optional func didUnhighlightRowAt(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    
    @objc optional func willSelectRowAt(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func willDeselectRowAt(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    @objc optional func didSelectRowAt(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    @objc optional func didDeselectRowAt(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    
    @objc optional func editActionsForRowAt(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    @available(iOS 11.0, *)
    @objc optional func leadingSwipeActionsConfigurationForRowAt(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @available(iOS 11.0, *)
    @objc optional func trailingSwipeActionsConfigurationForRowAt(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    @objc optional func shouldIndentWhileEditingRowAt(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    @objc optional func willBeginEditingRowAt(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    @objc optional func didEndEditingRowAt(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    @objc optional func targetIndexPathForMoveFromRowAt(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
    @objc optional func indentationLevelForRowAt(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
    @objc optional func shouldShowMenuForRowAt(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool
    @objc optional func canPerformActionForRowAt(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool
    @objc optional func performActionForRowAt(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?)
    @objc optional func canFocusRowAt(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    @objc optional func shouldUpdateFocusIn(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool
    @objc optional func didUpdateFocusIn(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    @objc optional func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath?
    @available(iOS 11.0, *)
    @objc optional func shouldSpringLoadRowAt(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool
}
