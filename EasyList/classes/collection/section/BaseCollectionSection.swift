//
//  BaseCollectionSection.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

open class BaseCollectionSection: NSObject, CollectionItemLayoutProvider {
    
    typealias ReturnType = CollectionSource
    
    public weak var source: CollectionSource?
    var items: [CollectionItemType] = []
    
    @discardableResult
    public func addItem(_ item: CollectionItemType, at index: Int? = nil) -> BaseCollectionSection {
        item.setSection?(section: self)
        let itemIndex = index ?? items.count
        items.insert(item, at: itemIndex)
        source?.addItem(at: itemIndex, in: self)
        return self
    }
    
    @discardableResult
    public func addItem<ItemTypeToInsert: CollectionItemType>(_ item: ItemTypeToInsert, after predicate: (CollectionItemType, ItemTypeToInsert) -> Bool) -> BaseCollectionSection {
        item.setSection?(section: self)
        var itemIndex = 0
        for (currentIndex, currentItem) in items.enumerated() {
            if predicate(currentItem, item) {
                itemIndex = max(itemIndex, currentIndex + 1)
            }
        }
        items.insert(item, at: itemIndex)
        source?.addItem(at: itemIndex, in: self)
        return self
    }
    
    @discardableResult
    public func deleteItem(at index: Int) -> BaseCollectionSection {
        items.remove(at: index)
        source?.deleteItem(at: index, in :self)
        return self
    }
    
    @discardableResult
    public func deleteAllItems(where predicate: (CollectionItemType) -> Bool) -> BaseCollectionSection {
        items.removeAll(where: predicate)
        return self
    }
    
    @discardableResult
    public func deleteAllItems() -> BaseCollectionSection {
        items.removeAll()
        return self
    }
    
    public func getItem(at index: Int) -> CollectionItemType? {
        return items[safe: index]
    }
    
    internal func itemCount() -> Int {
        return items.count
    }
}
