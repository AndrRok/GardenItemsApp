//
//  ItemImage.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

class ItemImage: UIImageView {
    
    private let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect){
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius                          = 10
        clipsToBounds                               = true
        image                                       = Images.placeholder
        translatesAutoresizingMaskIntoConstraints   = true
    }
    
    
    public func downloadImage(fromURL url: String){
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {self.image = image ?? Images.placeholder}
        }
    }
    
    public func setDefaultImage(){
        DispatchQueue.main.async{
            self.image = Images.placeholder
        }
    }
}
