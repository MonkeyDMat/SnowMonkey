//
//  Source.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

enum SourceUpdateKind {
    case insert
    case delete
}

struct SourceUpdate: CustomStringConvertible {
    var kind: SourceUpdateKind
    var section: BaseTableSection
    var id: String?
    var row:RowType?
    var index: Int?
    var after: ((IdentifiedTableRow, RowType) -> Bool)?
    var animation: UITableView.RowAnimation?
    
    var description: String {
        return "\(kind) - \(id) - \(row) at \(index) using \(animation)"
    }
}

open class TableSource: NSObject, RowLayout, RowLayoutProvider, RowEdition, RowEditionProvider, RowSelection, RowSelectionProvider {
    
    public typealias ReturnType = TableSource
    
    public var verbose: Bool = false
    
    var sections: [BaseTableSection]
    public var delegate: TableSourceDelegate?
    public weak var tableView: TableView?
    
    private var updateQueue = Queue<SourceUpdate>()
    private var isUpdating: Bool = false
    
    public init(sections: [BaseTableSection] = [], tableView: TableView, delegate: TableSourceDelegate? = nil) {
        self.sections = sections
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.tableView?.source = self
    }
    
    public func reloadData() {
        tableView?.reloadData()
    }
    
    //MARK: - Section
    @discardableResult
    public func addSection(_ section: BaseTableSection) -> BaseTableSection {
        section.source = self
        sections.append(section)
        return section
    }
    
    public func getSection(index: Int) -> BaseTableSection {
        return sections[index]
    }
    
    func getIndex(of section: BaseTableSection) -> Int? {
        return sections.firstIndex(of: section)
    }
    
    //MARK: - Header
    public func getHeader(index: Int) -> BaseHeader? {
        return getSection(index: index).getHeader()
    }
    
    //MARK: - Footer
    public func getFooter(index: Int) -> BaseFooter? {
        return getSection(index: index).getFooter()
    }
    
    //MARK: - Row
    public func getRow(indexPath: IndexPath) -> IdentifiedTableRow {
        return getSection(index: indexPath.section).getRow(at: indexPath.row)
    }
    
    public func getRow(by id: String) -> IdentifiedTableRow? {
        for section in sections {
            if let row = section.getRow(by: id) {
                return row
            }
        }
        
        return nil
    }
    
    // MARK: - Queue
    func getQueuedRow(_ id: String) -> IdentifiedTableRow? {
        for section in sections {
            if let row = getQueuedRow(id, in: section) {
                return row
            }
        }
        return nil
    }
    
    func getQueuedRow(_ id: String, in section: BaseTableSection) -> IdentifiedTableRow? {
        if let update = updateQueue.toArray().first(where: { (update) -> Bool in
            return update.section === section && update.id == id
        }) {
            return (id: update.id, row: update.row) as? IdentifiedTableRow
        }
        return nil
    }
    
    @discardableResult
    func addRow(_ row: RowType, id: String?, at index: Int?, after: ((IdentifiedTableRow, RowType) -> Bool)?, in section: BaseTableSection, animation: UITableView.RowAnimation? = nil) -> TableSource {
        
        updateQueue.enqueue(element: SourceUpdate(kind: .insert,
                                                  section: section,
                                                  id: id,
                                                  row: row,
                                                  index: index,
                                                  after: after,
                                                  animation: animation))
        
        if verbose {
            print("[EasyList] QUEUE : \(updateQueue)")
        }
        
        performUpdates()
        
        return self
    }
    
    func updateRow(_ updateBlock: () -> Void) {
        tableView?.beginUpdates()
        updateBlock()
        tableView?.endUpdates()
    }
    
    @discardableResult
    func deleteRow(at index: Int, in section: BaseTableSection, animation: UITableView.RowAnimation? = nil) -> TableSource {
        
        updateQueue.enqueue(element: SourceUpdate(kind: .delete,
                                                  section: section,
                                                  id: nil,
                                                  row: nil,
                                                  index: index,
                                                  after: nil,
                                                  animation: animation))
        
        performUpdates()
        
        return self
    }
    
    private func performUpdates() {
        if !isUpdating {
            if verbose {
                print("[EasyList] UPDATE")
            }
            isUpdating = true
            if #available(iOS 11.0, *) {
                if let update = updateQueue.dequeue() {
                    tableView?.performBatchUpdates({
                        if verbose {
                            print("[EasyList] PROCESSING : \(update)")
                        }
                        doUpdate(update)
                    }, completion: { (finished) in
                        self.isUpdating = false
                        if self.updateQueue.count() != 0 {
                            self.performUpdates()
                        }
                    })
                }
            } else {
                if let update = updateQueue.dequeue() {
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        self.isUpdating = false
                        if self.updateQueue.count() != 0 {
                            self.performUpdates()
                        }
                    }
                    tableView?.beginUpdates()
                    if verbose {
                        print("[EasyList] PROCESSING : \(update)")
                    }
                    doUpdate(update)
                    tableView?.endUpdates()
                    CATransaction.commit()
                }
            }
        } else {
            if verbose {
                print("[EasyList] ALREADY UPDATING")
            }
        }
    }
    
    func doUpdate(_ update: SourceUpdate) {
        if let indexPath = getIndexPath(for: update) {
            print("[EasyList DEBUG] \(indexPath.row)")
            switch update.kind {
            case .insert:
                guard let row = update.row else {
                    return
                }
                update.section.insert(id: update.id, row: row, index: indexPath.row)
                tableView?.insertRows(at: [indexPath], with: update.animation ?? .none)
            case .delete:
                update.section.removeRow(index: indexPath.row)
                tableView?.deleteRows(at: [indexPath], with: update.animation ?? .none)
            }
        }
    }
    
    func getIndexPath(for update: SourceUpdate) -> IndexPath? {
        guard let sectionIndex = getIndex(of: update.section) else {
            return nil
        }
        
        if let predicate = update.after {
            var rowIndex = 0
            guard let row = update.row else {
                    return nil
            }
            for (currentIndex, currentRow) in update.section.rows.enumerated() {
                if predicate(currentRow, row) {
                    rowIndex = max(rowIndex, currentIndex + 1)
                }
            }
            return IndexPath(row: rowIndex, section: sectionIndex)
        } else {
            let rowIndex = update.index ?? update.section.rows.count
            return IndexPath(row: rowIndex, section: sectionIndex)
        }
    }
    
    //MARK: - RowLayoutProvider
    var _height: ((RowType) -> CGFloat)?
    var _estimatedHeight: ((RowType) -> CGFloat)?
    var _selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?
    
    @discardableResult
    open func setRowHeight(_ height: ((RowType) -> CGFloat)?) -> ReturnType {
        _height = height
        return self
    }
    
    @discardableResult
    open func setRowEstimatedHeight(_ estimatedHeight: ((RowType) -> CGFloat)?) -> ReturnType {
        _estimatedHeight = estimatedHeight
        return self
    }
    
    @discardableResult
    open func setRowSelectionStyle(_ selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?) -> ReturnType {
        _selectionStyle = selectionStyle
        return self
    }
    
    //MARK: - RowEditionProvider
    var _editable: ((RowType) -> Bool)?
    var _editingStyle: ((RowType) -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: ((RowType) -> String?)?
    
    @discardableResult
    // ToDo add row as callback parameter
    open func setEditable(editable: ((RowType) -> Bool)?, editingStyle: ((RowType) -> UITableViewCell.EditingStyle)? = { row in return .delete}, titleForDeleteConfirmation: ((RowType) -> String?)? = nil) -> ReturnType {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self
    }
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((IndexPath) -> IndexPath?)?
    var _didDeselect: ((_ index: IndexPath) -> Void)?
    
    @discardableResult
    open func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willSelect = willSelect
        return self
    }
    
    
    @discardableResult
    open func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didSelect = didSelect
        return self
    }
    
    @discardableResult
    open func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willDeselect = willDeselect
        return self
    }
    
    @discardableResult
    open func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didDeselect = didDeselect
        return self
    }
}

@objc public protocol TableSourceDelegate: UIScrollViewDelegate {
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
