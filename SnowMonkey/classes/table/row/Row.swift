//
//  Row.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol Indexable {
    var index: IndexPath? { get }
}

@objc public protocol Identifiable {
    var id: String { get set }
}

public protocol CellProvider {
    func getCell<CellType: UITableViewCell>(cellIdentifier: String?, tableView: UITableView) -> CellType?
}

@objc public protocol RowType: RowLayout, RowEdition, RowSelection, Indexable, Identifiable {
    func resetCell()
    func updateCell(cell: UITableViewCell, tableView: UITableView)
    func getCell(tableView: UITableView) -> UITableViewCell
    @objc optional func setSection(section: BaseTableSection)
}

open class Row<SourceType, CellType: TableCell<SourceType>>: RowType, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    public var cellProvider: CellProvider
    
    // MARK: Indexable
    public var index: IndexPath? {
        guard let sectionIndex = section?.sectionIndex,
            let rowIndex = section?.getRowIndex(of: self) else {
                return nil
        }
        return IndexPath(row: rowIndex, section: sectionIndex)
    }
    
    // MARK: Identifiable
    public var id: String
    
    public typealias ReturnType = Row<SourceType, CellType>
    
    var data: SourceType?
    public var cell: CellType? {
        if let index = index {
            return section?.source?.tableView?.cellForRow(at: index) as? CellType
        }
        
        return nil
    }
    var cellIdentifier: String?
    var cellPresenter: BaseCellPresenter<CellType, SourceType>?
    
    private weak var section: BaseTableSection?
    
    var verbose: Bool?
    private var _verbose: Bool {
        get {
            return verbose ?? section?.verbose ?? false
        }
    }
    
    public init(id: String, data: SourceType? = nil, cellIdentifier: String? = nil, cellPresenter: BaseCellPresenter<CellType, SourceType>? = nil, cellProvider: CellProvider = DefaultCellProvider()) {
        self.id = id
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.cellPresenter = cellPresenter
        self.cellProvider = cellProvider
    }
    
    public init(id: String, data: SourceType? = nil, cellIdentifier: String? = nil, cellProvider: CellProvider = DefaultCellProvider(), configureCell: @escaping (CellType, SourceType) -> Void) {
        self.id = id
        self.data = data
        self.cellIdentifier = cellIdentifier
        let closurePresenter = CellClosurePresenter<CellType, SourceType>(configureCell: configureCell)
        self.cellPresenter = closurePresenter
        self.cellProvider = cellProvider
    }
    
    open func updateRow(data: SourceType) {
        section?.updateRow({ [weak self] in
            self?.data = data
            if let cell = self?.cell {
                cellPresenter?.configureCell(cell: cell, source: data)
            }
        })
    }
    
    //MARK: - RowType
    public func updateCell(cell: UITableViewCell, tableView: UITableView) {
        if let cell = (cell ?? getCell(tableView: tableView)) as? CellType,
           let data = self.data {
            cellPresenter?.configureCell(cell: cell, source: data)
        }
    }
    
    public func getCell(tableView: UITableView) -> UITableViewCell {
        let cell = cellProvider.getCell(cellIdentifier: cellIdentifier, tableView: tableView)
        
        if let data = data, let cell = cell as? CellType {
            cellPresenter?.configureCell(cell: cell, source: data)
        }
        return cell ?? UITableViewCell()
    }
    
    public func setSection(section: BaseTableSection) {
        self.section = section
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
    
    //MARK: - RowLayout
    public func rowHeight() -> CGFloat {
        return _height?(self) ??
            section?._height?(self) ??
            section?.source?._height?(self) ??
            UITableView.automaticDimension
    }
    
    public func estimatedRowHeight() -> CGFloat {
        return _estimatedHeight?(self) ??
            section?._estimatedHeight?(self) ??
            section?.source?._estimatedHeight?(self) ??
            UITableView.automaticDimension
    }
    
    public func selectionStyle() -> UITableViewCell.SelectionStyle {
        return _selectionStyle?(self) ??
            section?._selectionStyle?(self) ??
            section?.source?._selectionStyle?(self) ??
            cell?.selectionStyle ??
            UITableViewCell.SelectionStyle.default
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
    
    //MARK: - RowEdition
    public func isEditable() -> Bool {
        return _editable?(self) ??
            section?._editable?(self) ??
            section?.source?._editable?(self) ??
            false
    }
    public func getEditingStyle() -> UITableViewCell.EditingStyle {
        return _editingStyle?(self) ??
            section?._editingStyle?(self) ??
            section?.source?._editingStyle?(self) ??
            .none
    }
    public func getTitleForDeleteConfirmation() -> String? {
        return _titleForDeleteConfirmation?(self) ??
            section?._titleForDeleteConfirmation?(self) ??
            section?.source?._titleForDeleteConfirmation?(self)
    }
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((_ index: IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((_ index: IndexPath) -> IndexPath?)?
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
    
    //MARK: - RowSelection
    public func willSelect(index: IndexPath) -> IndexPath? {
        return _willSelect?(index) ??
            section?._willSelect?(index) ??
            section?.source?._willSelect?(index) ??
            index
    }
    
    public func didSelect(index: IndexPath) {
        _didSelect?(index) ??
            section?._didSelect?(index) ??
            section?.source?._didSelect?(index)
    }
    
    public func willDeselect(index: IndexPath) -> IndexPath? {
        return _willDeselect?(index) ??
            section?._willDeselect?(index) ??
            section?.source?._willDeselect?(index) ??
            index
    }
    
    public func didDeselect(index: IndexPath) {
        _didDeselect?(index) ??
            section?._didDeselect?(index) ??
            section?.source?._didDeselect?(index)
    }
}

public class DefaultCellProvider: CellProvider {
    public init() {}
    
    public func getCell<CellType: UITableViewCell>(cellIdentifier: String?, tableView: UITableView) -> CellType? {
        var returnCell: CellType?
        if returnCell == nil {
            if let cellIdentifier = cellIdentifier {
                tableView.register(CellType.self, forCellReuseIdentifier: cellIdentifier)
                returnCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellType
            } else {
                returnCell = CellType(frame: CGRect.zero)
            }
            
        }
        returnCell?.layoutSubviews()
        
        return returnCell
    }
}

public class NibCellProvider: CellProvider {
    
    var nibName: String
    
    public init(nibName: String) {
        self.nibName = nibName
    }
    
    public func getCell<CellType>(cellIdentifier: String?, tableView: UITableView) -> CellType? where CellType : UITableViewCell {
        
        var returnCell: CellType?
        
        let cellNib = UINib(nibName: nibName, bundle: nil)
        
        if let cellIdentifier = cellIdentifier {
            tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
            returnCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellType
        } else {
            returnCell = cellNib.instantiate(withOwner: nil, options: nil).first as? CellType
        }
        
        return returnCell
    }
}
