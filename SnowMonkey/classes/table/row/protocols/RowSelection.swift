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
