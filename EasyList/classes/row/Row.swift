//
//  Row.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol RowLayout {
    @objc optional func rowHeight() -> CGFloat
    @objc optional func estimatedRowHeight() -> CGFloat
}

@objc public protocol RowEdition {
    @objc optional func isEditable() -> Bool
    @objc optional func getEditingStyle() -> UITableViewCell.EditingStyle
    @objc optional func getTitleForDeleteConfirmation() -> String?
}

@objc public protocol RowSelection {
    @objc optional func willSelect(index: IndexPath) -> IndexPath?
    @objc optional func didSelect(index: IndexPath)
    @objc optional func willDeselect(index: IndexPath) -> IndexPath?
    @objc optional func didDeselect(index: IndexPath)
}

@objc public protocol RowType: RowLayout, RowEdition, RowSelection {
    func getCell(tableView: UITableView) -> UITableViewCell
    @objc optional func setSection(section: BaseSection)
}

public class Row<SourceType, CellType: Cell<SourceType>>: RowType {
    
    var data: SourceType?
    var cellIdentifier: String?
    var cellPresenter: BaseCellPresenter<CellType, SourceType>?
    
    private var section: BaseSection?
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, cellPresenter: BaseCellPresenter<CellType, SourceType>? = nil) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.cellPresenter = cellPresenter
    }
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, configureCell: @escaping (CellType, SourceType) -> Void) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        let closurePresenter = ClosureCellPresenter<CellType, SourceType>(configureCell: configureCell)
        self.cellPresenter = closurePresenter
    }
    
    //MARK: - RowType
    public func getCell(tableView: UITableView) -> UITableViewCell {
        if let cellIdentifier = cellIdentifier,
            let data = data,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellType {
            
            cellPresenter?.configureCell(cell: cell, source: data)
            
            return cell
        } else {
            if let data = data {
                let cell = CellType()
                
                cellPresenter?.configureCell(cell: cell, source: data)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    public func setSection(section: BaseSection) {
        self.section = section
    }
    
    //MARK: - RowLayout
    var _height: (() -> CGFloat)?
    @discardableResult
    public func setHeight(_ height: (() -> CGFloat)?) -> Row<SourceType, CellType> {
        _height = height
        return self
    }
    public func rowHeight() -> CGFloat {
        return _height?() ??
            section?._height?() ??
            section?.source?._height?() ??
            CGFloat(40)
    }
    
    var _estimatedHeight: (() -> CGFloat)?
    @discardableResult
    public func setEstimatedHeight(_ estimatedHeight: (() -> CGFloat)?) -> Row<SourceType, CellType> {
        _estimatedHeight = estimatedHeight
        return self
    }
    public func estimatedRowHeight() -> CGFloat {
        return _estimatedHeight?() ??
            section?._estimatedHeight?() ??
            section?.source?._estimatedHeight?() ??
            CGFloat(40)
    }
    
    //MARK: - RowEdition
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    @discardableResult
    public func setEditable(editable: (() -> Bool)?, editingStyle: (() -> UITableViewCell.EditingStyle)? = {return .delete}, titleForDeleteConfirmation: (() -> String?)? = nil) -> Row<SourceType, CellType> {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self
    }
    public func isEditable() -> Bool {
        return _editable?() ??
            section?._editable?() ??
            section?.source?._editable?() ??
            false
    }
    public func getEditingStyle() -> UITableViewCell.EditingStyle {
        return _editingStyle?() ??
            section?._editingStyle?() ??
            section?.source?._editingStyle?() ??
            .none
    }
    public func getTitleForDeleteConfirmation() -> String? {
        return _titleForDeleteConfirmation?() ??
            section?._titleForDeleteConfirmation?() ??
            section?.source?._titleForDeleteConfirmation?()
    }
    
    //MARK: - RowSelection
    var _willSelect: ((_ index: IndexPath) -> IndexPath?)?
    @discardableResult
    public func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath?)?) -> Row<SourceType, CellType> {
        _willSelect = willSelect
        return self
    }
    public func willSelect(index: IndexPath) -> IndexPath? {
        return _willSelect?(index) ??
            section?._willSelect?(index) ??
            section?.source?._willSelect?(index) ??
            index
    }
    
    var _didSelect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> Row<SourceType, CellType> {
        _didSelect = didSelect
        return self
    }
    public func didSelect(index: IndexPath) {
        _didSelect?(index) ??
            section?._didSelect?(index) ??
            section?.source?._didSelect?(index)
    }
    
    var _willDeselect: ((_ index: IndexPath) -> IndexPath?)?
    @discardableResult
    public func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath?)?) -> Row<SourceType, CellType> {
        _willDeselect = willDeselect
        return self
    }
    public func willDeselect(index: IndexPath) -> IndexPath? {
        return _willDeselect?(index) ??
            section?._willDeselect?(index) ??
            section?.source?._willDeselect?(index) ??
            index
    }
    
    var _didDeselect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> Row<SourceType, CellType> {
        _didDeselect = didDeselect
        return self
    }
    public func didDeselect(index: IndexPath) {
        _didDeselect?(index) ??
            section?._didDeselect?(index) ??
            section?.source?._didDeselect?(index)
    }
}
