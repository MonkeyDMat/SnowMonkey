//
//  Header.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 15/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol HeaderLayout {
    @objc optional func headerHeight() -> CGFloat
    @objc optional func headerEstimatedHeight() -> CGFloat
}

@objc public protocol HeaderDelegate: class {
    @objc optional func willDisplayHeaderView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    @objc optional func didEndDisplayHeaderView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int)
}

open class BaseHeader: UIView, HeaderLayout, HeaderDelegate {
    public var section: BaseTableSection?
    public weak var delegate: HeaderDelegate?
    
    // ToDo: Add a method setHeaderHeight
}
