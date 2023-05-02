//
//  UIHelper.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit


enum UIHelper{
    
    static func createLayout(in view: UIView) -> UICollectionViewCompositionalLayout{
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        // Group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.4)), repeatingSubitem: item, count: 2)
        // Sections
        let section = NSCollectionLayoutSection(group: group)
       
        // Return
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

