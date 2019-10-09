//
//  CollectionItemPresenter.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation

public protocol CollectionItemPresenter {
    associatedtype Item
    associatedtype Source
    
    func configureItem(item: Item, source: Source)
}

open class BaseCollectionItemPresenter<BaseSource, BaseItem>: CollectionItemPresenter {
    public typealias Item = BaseItem
    public typealias Source = BaseSource
    open func configureItem(item: BaseItem, source: BaseSource) {}
    
    public init() {}
}
