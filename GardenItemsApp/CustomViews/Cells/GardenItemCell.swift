//
//  GardenItemCell.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

class GardenItemCell: UICollectionViewCell {
    
    static let reuseID = "gardenItemCell"
    private lazy var imageImageView     = ItemImage(frame: .zero)
    public var id = Int()
    
   
    
    private lazy var nameLabel          = UITextView()
    private lazy var descriptionLabel   = UITextView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornersRadius()
    }
    
    
    private func configure(){
        configureImageView()
        configureLabels()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageImageView.setDefaultImage()
    }
    
    public func setValues(id: Int, imageURL: String, name: String, descriprion: String){
        
        imageImageView.downloadImage(fromURL: imageURL)
        DispatchQueue.main.async { [self] in
            nameLabel.text = name
            descriptionLabel.text = descriprion
        }
    }
    
    
    //MARK: - Configure UI
    private func configureImageView(){
        contentView.addSubview(imageImageView)
        imageImageView.translatesAutoresizingMaskIntoConstraints = false
        imageImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            imageImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    
    private func configureLabels(){
        contentView.addSubviews(nameLabel, descriptionLabel)
        let labelsArray = [nameLabel, descriptionLabel]
        for i in labelsArray{
            i.translatesAutoresizingMaskIntoConstraints = false
            i.isUserInteractionEnabled      = false
            i.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            i.isScrollEnabled = false
            i.textAlignment = .left
        }
        
        nameLabel.textColor = .black
        nameLabel.textContainer.maximumNumberOfLines = 5
        nameLabel.font = .systemFont(ofSize: 24)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor  = .systemGray2
        descriptionLabel.textContainer.maximumNumberOfLines = 6
        descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    
    
    
    private func setCornersRadius(){
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        imageImageView.layer.cornerRadius = 20
        contentView.layer.borderColor  = UIColor.systemGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        contentView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        contentView.layer.shadowOpacity = 10.0
        contentView.layer.shadowRadius = 10.0
       
    }
}
