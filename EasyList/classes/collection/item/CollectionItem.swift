//
//  CollectionItem.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol CollectionItemType: CollectionItemLayout {
    func getCell(collectionView: UICollectionView) -> UICollectionViewCell
    @objc optional func setSection(section: BaseCollectionSection)
}

open class CollectionItem<SourceType, CellType: CollectionCell<SourceType>>: CollectionItemType, CollectionItemLayoutProvider {
    
    typealias ReturnType = CollectionItem<SourceType, CellType>
    
    var data: SourceType?
    var itemIdentifier: String?
    var itemPresenter: BaseCollectionItemPresenter<SourceType, CellType>?
    var indexPath: IndexPath
    
    private var section: BaseCollectionSection?
    
    public init(data: SourceType? = nil, itemIdentifier: String? = nil, indexPath: IndexPath, itemPresenter: BaseCollectionItemPresenter<SourceType, CellType>? = nil) {
        self.data = data
        self.itemIdentifier = itemIdentifier
        self.indexPath = indexPath
        self.itemPresenter = itemPresenter
    }
    
    public init(data: SourceType? = nil, itemIdentifier: String? = nil, indexPath: IndexPath, configureItem: @escaping (SourceType, CellType) -> Void) {
        self.data = data
        self.itemIdentifier = itemIdentifier
        self.indexPath = indexPath
        let closurePresenter = CollectionItemClosurePresenter<SourceType, CellType>(configureItem: configureItem)
        self.itemPresenter = closurePresenter
    }
    
    // MARK: - CollectionItemType
    public func getCell(collectionView: UICollectionView) -> UICollectionViewCell {
        var cell: CellType?
        
        if let itemIdentifier = itemIdentifier {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemIdentifier, for: indexPath) as? CellType
        }
        
        cell?.layoutSubviews()
        
        if let data = data, cell != nil {
            itemPresenter?.configureItem(item: cell!, source: data)
        }
        
        return cell ?? UICollectionViewCell()
    }
}
