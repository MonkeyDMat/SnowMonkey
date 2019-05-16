//
//  CollectionSource.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

open class CollectionSource: NSObject, CollectionItemLayout, CollectionItemLayoutProvider {
    
    typealias ReturnType = CollectionSource
    
    var sections: [BaseCollectionSection]
    public var delegate: CollectionSourceDelegate?
    public weak var collection: CollectionView?
    
    public init(sections: [BaseCollectionSection] = [], collection: CollectionView, delegate: CollectionSourceDelegate? = nil) {
        self.sections = sections
        self.collection = collection
        self.delegate = delegate
        
        super.init()
        
        self.collection?.source = self
    }
    
    public func reloadData() {
        collection?.reloadData()
    }
    
    // MARK: - Section
    @discardableResult
    public func addSection(_ section: BaseCollectionSection) -> BaseCollectionSection {
        section.source = self
        sections.append(section)
        return section
    }
    
    func getSection(index: Int) -> BaseCollectionSection {
        return sections[index]
    }
    
    func getIndex(of section: BaseCollectionSection) -> Int? {
        return sections.firstIndex(of: section)
    }
    
    // MARK: - Item
    func getItem(indexPath: IndexPath) -> CollectionItemType {
        return getSection(index: indexPath.section).getItem(at: indexPath.row)
    }
    
    @discardableResult
    func addItem(at index: Int, in section: BaseCollectionSection) -> CollectionSource {
        guard let sectionIndex = getIndex(of: section) else {
            return self
        }
        let indexPath = IndexPath(row: index, section: sectionIndex)
        //collection?.insertItems(at: [indexPath])
        return self
    }
    
    @discardableResult
    func deleteItem(at index: Int, in section: BaseCollectionSection) -> CollectionSource {
        guard let sectionIndex = getIndex(of: section) else {
            return self
        }
        let indexPath = IndexPath(row: index, section: sectionIndex)
        //collection?.deleteItems(at: [indexPath])
        return self
    }
}

@objc public protocol CollectionSourceDelegate {
}
