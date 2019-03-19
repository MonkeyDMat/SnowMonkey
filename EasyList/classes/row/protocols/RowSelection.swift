//
//  RowSelection.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol RowSelection {
    @objc optional func willSelect(index: IndexPath) -> IndexPath?
    @objc optional func didSelect(index: IndexPath)
    @objc optional func willDeselect(index: IndexPath) -> IndexPath?
    @objc optional func didDeselect(index: IndexPath)
}

protocol RowSelectionProvider: class {
    associatedtype ReturnType
    
    var _willSelect: ((_ index: IndexPath) -> IndexPath?)? { get set }
    var _didSelect: ((_ index: IndexPath) -> Void)? { get set }
    var _willDeselect: ((_ index: IndexPath) -> IndexPath?)? { get set }
    var _didDeselect: ((_ index: IndexPath) -> Void)? { get set }
}

extension RowSelectionProvider {
    
    @discardableResult
    public func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willSelect = willSelect
        return self as! ReturnType
    }
    
    
    @discardableResult
    public func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didSelect = didSelect
        return self as! ReturnType
    }
    
    @discardableResult
    public func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willDeselect = willDeselect
        return self as! ReturnType
    }
    
    @discardableResult
    public func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didDeselect = didDeselect
        return self as! ReturnType
    }
}
