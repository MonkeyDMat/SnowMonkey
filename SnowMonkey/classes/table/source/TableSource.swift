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
    case addSection
}

public typealias RowComparisonPredicate = ((RowType, RowType) -> Bool)

struct SourceUpdate {
    var kind: SourceUpdateKind
    var sectionId: String?
    var section: BaseTableSection
    var rows: (() -> [RowType])?
    var before: RowComparisonPredicate?
    var after: RowComparisonPredicate?
    var animation: UITableView.RowAnimation?
}

open class TableSource: NSObject, RowLayout, RowLayoutProvider, RowEdition, RowEditionProvider, RowSelection, RowSelectionProvider {
    
    public typealias ReturnType = TableSource
    
    public var verbose: Bool = false
    
    var sections: [IdentifiedTableSection]
    public var delegate: TableSourceDelegate?
    public weak var tableView: TableView?
    
    private var updateQueue = Queue<SourceUpdate>()
    private var isUpdating: Bool = false
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    public init(sections: [IdentifiedTableSection] = [], tableView: TableView, delegate: TableSourceDelegate? = nil) {
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
    public var numberOfSections: Int {
        return sections.count
    }
    
    @discardableResult
    public func addSection(_ section: BaseTableSection, id: String? = nil) -> BaseTableSection {
        section.source = self
        updateQueue.enqueue(element: SourceUpdate(kind: .addSection,
                                                  sectionId: id,
                                                  section: section))
        
        if verbose {
            print("[EasyList] ENQUEUE ADD SECTION : \(updateQueue.elements.last?.section)")
        }
        
        performUpdates()
        
        return section
        
        /*section.source = self
        sections.append((id: id, section: section))
        return section*/
    }
    
    public func getSection(id: String) -> IdentifiedTableSection? {
        return sections.first(where: { (arg) -> Bool in
            let (identifiedId, _) = arg
            return identifiedId == id
        })
    }
    
    public func getSection(index: Int) -> IdentifiedTableSection? {
        return sections[safe: index]
    }
    
    public func getLastSection() -> IdentifiedTableSection? {
        if let lastAddSectionUpdate = updateQueue.elements.last { (update) -> Bool in
            return update.kind == .addSection
        } {
            return (lastAddSectionUpdate.sectionId, lastAddSectionUpdate.section)
        }
        
        return sections.last
    }
    
    public func getSections() -> [IdentifiedTableSection] {
        return sections
    }
    
    func getIndex(of section: BaseTableSection) -> Int? {
        return sections.firstIndex(where: { (arg) -> Bool in
            let (_, currentSection) = arg
            return currentSection == section
        })
    }
    
    //MARK: - Header
    public func getHeader(index: Int) -> BaseHeader? {
        return getSection(index: index)?.section.getHeader()
    }
    
    //MARK: - Footer
    public func getFooter(index: Int) -> BaseFooter? {
        return getSection(index: index)?.section.getFooter()
    }
    
    //MARK: - Row
    public var numberOfRows: Int {
        return getAllRows().count
    }
    
    public func getRow(indexPath: IndexPath) -> RowType? {
        return getSection(index: indexPath.section)?.section.getRow(at: indexPath.row)
    }
    
    public func getRow(by id: String) -> RowType? {
        for identifiedSection in sections {
            if let row = identifiedSection.section.getRow(by: id) {
                return row
            }
        }
        
        return nil
    }
    
    public func getAllRows() -> [RowType] {
        return sections.flatMap { (id, section) -> [RowType] in
            return section.rows
        }
    }
    
    // MARK: - Queue
    func getQueuedRow(_ id: String) -> RowType? {
        for identifiedSection in sections {
            if let row = getQueuedRow(id, in: identifiedSection.section) {
                return row
            }
        }
        return nil
    }
    
    func getQueuedRow(_ id: String, in section: BaseTableSection) -> RowType? {
        if let update = updateQueue.toArray().first(where: { (update) -> Bool in
            return update.section === section && update.rows?().contains(where: { (row) -> Bool in
                return row.id == id
            }) == true
        }) {
            return update.rows?().first(where: { (row) -> Bool in
                return row.id == id
            })
        }
        return nil
    }
    
    @discardableResult
    func addRows(_ rows: [RowType], after: RowComparisonPredicate?, in section: BaseTableSection, animation: UITableView.RowAnimation? = nil) -> TableSource {
        
        updateQueue.enqueue(element: SourceUpdate(kind: .insert,
                                                  section: section,
                                                  rows: {
                                                    return rows
                                                  },
                                                  after: after,
                                                  animation: animation))
        
        if verbose {
            print("[EasyList] ENQUEUE INSERT : \(updateQueue.elements.last?.rows?())")
        }
        
        performUpdates()
        
        return self
    }
    
    @discardableResult
    func addRows(_ rows: [RowType], before: RowComparisonPredicate?, in section: BaseTableSection, animation: UITableView.RowAnimation? = nil) -> TableSource {
        
        updateQueue.enqueue(element: SourceUpdate(kind: .insert,
                                                  section: section,
                                                  rows: {
                                                    return rows
                                                  },
                                                  before: before,
                                                  animation: animation))
        
        if verbose {
            print("[EasyList] ENQUEUE INSERT : \(updateQueue.elements.last?.rows?())")
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
    func deleteRows(rows: @escaping () -> [RowType], in section: BaseTableSection, animation: UITableView.RowAnimation? = nil) -> TableSource {
        
        updateQueue.enqueue(element: SourceUpdate(kind: .delete,
                                                  section: section,
                                                  rows: rows,
                                                  after: nil,
                                                  animation: animation))
        
        if verbose {
            print("[EasyList] ENQUEUE DELETE : \(updateQueue.elements.last?.rows?())")
        }
        
        performUpdates()
        
        return self
    }
    
    @discardableResult
    public func deleteSection(at index: Int, animation: UITableView.RowAnimation = .none) -> TableSource {
        if index < sections.count {
            sections.remove(at: index)
            let indexSet = IndexSet([index])
            tableView?.deleteSections(indexSet, with: animation)
        }
        
        return self
    }
    
    @discardableResult
    public func deleteSection(_ section: BaseTableSection, animation: UITableView.RowAnimation = .none) -> TableSource {
        if let sectionIndex = getIndex(of: section) {
            return deleteSection(at: sectionIndex)
        }
        
        return self
    }
    
    @discardableResult
    public func clear(animation: UITableView.RowAnimation? = nil) -> TableSource {
        let sortedSections = sections.sorted { (identifiedSection1, identifiedSection2) -> Bool in
            let (_, section1) = identifiedSection1
            let (_, section2) = identifiedSection2
            switch(getIndex(of: section1), getIndex(of: section2)) {
            case (nil, nil):
                return true
            case (_, nil):
                return true
            case (nil, _):
                return false
            case (let index1, let index2):
                return index1! > index2!
            }
        }
        for section in sortedSections {
            section.section.deleteAllRows(animation: animation)
        }
        
        return self
    }
    
    private func performUpdates() {
        if !isUpdating {
            if verbose {
                print("[EasyList] UPDATE")
            }
            if let update = updateQueue.dequeue() {
                isUpdating = true
                if update.animation != nil {
                    if #available(iOS 11.0, *) {
                        tableView?.performBatchUpdates({
                            if verbose {
                                print("[EasyList] PROCESSING ANIMATED IOS >=11 : \(update.kind) - \(update.rows?())")
                            }
                            doUpdate(update)
                        }, completion: { (finished) in
                            self.isUpdating = false
                            if self.updateQueue.count() != 0 {
                                self.performUpdates()
                            }
                        })
                    } else {
                        CATransaction.begin()
                        CATransaction.setCompletionBlock {
                            self.isUpdating = false
                            if self.updateQueue.count() != 0 {
                                self.performUpdates()
                            }
                        }
                        tableView?.beginUpdates()
                        if verbose {
                            print("[EasyList] PROCESSING ANIMATED IOS <11 : \(update.kind) - \(update.rows?())")
                        }
                        doUpdate(update)
                        tableView?.endUpdates()
                        CATransaction.commit()
                    }
                } else {
                    switch update.kind {
                    case .insert:
                        if let rows = update.rows?(),
                           rows.count > 0 {
                            if verbose {
                                print("[EasyList] PROCESSING NOT ANIMATED : \(update.kind) - \(rows)")
                            }
                            let indexPaths = getIndexPath(for: update)
                            for (index, row) in rows.enumerated() {
                                update.section.insert(row: row, index: indexPaths[index].row)
                            }
                        }
                    case .delete:
                        if let rows = update.rows?(),
                           rows.count > 0 {
                            if verbose {
                                print("[EasyList] PROCESSING NOT ANIMATED : \(update.kind) - \(rows)")
                            }
                            let indexes = rows.map { (row) -> Int? in
                                return row.index?.row
                            }.removeNils().sorted(by: >)
                            for index in indexes {
                                update.section.removeRow(index: index)
                            }
                        }
                    case .addSection:
                        sections.append((id: update.sectionId, section: update.section))
                    }
                    tableView?.reloadData()
                    
                    self.isUpdating = false
                    self.performUpdates()
                }
            }
        } else {
            self.isUpdating = false
            if verbose {
                print("[EasyList] ALREADY UPDATING")
            }
        }
    }
    
    func doUpdate(_ update: SourceUpdate) {
        let indexPaths = getIndexPath(for: update)
        switch update.kind {
        case .insert:
            if let rows = update.rows?(),
               rows.count > 0 {
                for (index, row) in rows.enumerated() {
                    update.section.insert(row: row, index: indexPaths[index].row)
                }
                if verbose {
                    print("[EasyList] INSERTING ROWS : \(rows) at \(indexPaths)")
                }
                tableView?.insertRows(at: indexPaths, with: update.animation ?? .none)
            }
        case .delete:
            if let rows = update.rows?(),
               rows.count > 0 {
                let indexes = rows.map { (row) -> Int? in
                    return row.index?.row
                    }.removeNils().sorted(by: >)
                for index in indexes {
                    update.section.removeRow(index: index)
                }
                if verbose {
                    print("[EasyList] DELETING ROWS : at \(indexPaths)")
                }
                tableView?.deleteRows(at: indexPaths, with: update.animation ?? .none)
            }
        case .addSection:
            sections.append((id: update.sectionId, section: update.section))
        }
    }
    
    func getIndexPath(for update: SourceUpdate) -> [IndexPath] {
        guard let sectionIndex = getIndex(of: update.section) else {
            return []
        }
        
        guard let rows = update.rows?() else {
            return []
        }
        
        var indexes = [IndexPath]()
        
        if let predicate = update.before {
            var rowIndex = 0
            
            for (index, row) in rows.enumerated() {
                
                for (currentIndex, currentRow) in update.section.rows.enumerated() {
                    if predicate(currentRow, row) {
                        rowIndex = currentIndex
                        break
                    }
                }
                
                indexes.append(IndexPath(row: rowIndex + index, section: sectionIndex))
            }
            if verbose {
                print("[EasyList] ROWS => INDEXES : \(rows) => \(indexes)")
            }
        } else if let predicate = update.after {
            var rowIndex = 0
            
            for (index, row) in rows.enumerated() {
                
                for (currentIndex, currentRow) in update.section.rows.enumerated() {
                    if predicate(currentRow, row) {
                        rowIndex = max(rowIndex, currentIndex + 1)
                    }
                }
                
                indexes.append(IndexPath(row: rowIndex + index, section: sectionIndex))
            }
            if verbose {
                print("[EasyList] ROWS => INDEXES : \(rows) => \(indexes)")
            }
        } else {
            for row in rows {
                let rowIndex = row.index?.row ?? (update.section.rows.count + indexes.count)
                indexes.append(IndexPath(row: rowIndex, section: sectionIndex))
            }
            if verbose {
                print("[EasyList] ROWS => INDEXES : \(rows) => \(indexes)")
            }
        }
        
        return indexes
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
