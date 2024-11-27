//
//  Footer.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 15/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol FooterLayout {
    @objc optional func footerHeight() -> CGFloat
    @objc optional func footerEstimatedHeight() -> CGFloat
}

@objc public protocol FooterDelegate {
    @objc optional func willDisplayFooterView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int)
    @objc optional func didEndDisplayFooterView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int)
}

open class BaseFooter: UIView, FooterLayout, FooterDelegate {
    public var section: BaseTableSection?
    public weak var delegate: FooterDelegate?
}

