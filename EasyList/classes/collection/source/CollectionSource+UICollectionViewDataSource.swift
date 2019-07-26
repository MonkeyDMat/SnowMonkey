//
//  Source+UICollectionViewDataSource.swift
//  EasyList
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

extension CollectionSource: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("[EasyList] ITEMS IN SECTION \(section) : \(getSection(index: section)?.itemCount())")
        return getSection(index: section)?.itemCount() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = getItem(indexPath: indexPath)
        
        let cell = item?.getCell(collectionView: collectionView)
        
        print("[EasyList]CELL FOR ITEM : \(cell)")
        
        return cell ?? UICollectionViewCell()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("[EasyList]SECTIONS COUNT : \(sections.count)")
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: CGRect.zero)
    }
    
    // MARK: - Move
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    // MARK: - Index titles
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return nil
    }
    
    public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return IndexPath(row: 0, section: 0)
    }
}
