//
//  CollectionItemClosurePresenter.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation

open class CollectionItemClosurePresenter<BaseSource, BaseItem>: BaseCollectionItemPresenter<BaseSource, BaseItem> {
    public typealias Item = BaseItem
    public typealias Source = BaseSource
    
    private var configureItem: (BaseSource, BaseItem) -> Void
    
    init(configureItem: @escaping (BaseSource, BaseItem) -> Void) {
        self.configureItem = configureItem
    }
    
    open override func configureItem(item: BaseItem, source: BaseSource) {
        configureItem(source, item)
    }
}
