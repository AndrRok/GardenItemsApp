//
//  DetailsVC.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/30/23.
//

import UIKit

class DetailsVC: DataLoadingVC {
    private lazy var containerView     = UIView()
    private lazy var navBar = UINavigationBar(frame: .zero)
    private lazy var mainImageView     = ItemImage(frame: .zero)
    private lazy var brandImageView    = ItemImage(frame: .zero)
    private lazy var addToFavoritesButton   = UIButton()
    private lazy var nameLabel = UITextView()
    private lazy var descriptionLabel = UITextView()
    private lazy var locationButton   = UIButton()
    private lazy var mapPinImage = UIImageView(image: Images.mapPin)
    private lazy var locationLabel = UILabel()
    private var id: Int
    
    init(id: Int ) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        configure()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        brandImageView.setRounded()
    }
    
    
    private func configure(){
        getItemByID(id: id)
        configureNB()
        configureContainerView()
        configureAddToFavoritesButton()
        configureBrandImageView()
        configureMainImageView()
        configureLabels()
        configureButtonItems()
        configureLocationButton()
    }
    
    
    //MARK: - Get API Data
    private func getItemByID(id: Int){
        showLoadingView()
        NetworkManager.shared.getItemsByID(id: id){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemResult):
                DispatchQueue.main.async {
                    self.mainImageView.downloadImage(fromURL: itemResult.image)
                    self.nameLabel.text = itemResult.name
                    self.descriptionLabel.text = itemResult.description
                    self.brandImageView.downloadImage(fromURL: itemResult.categories.icon)
                }
                self.dismissLoadingView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    
    private func configureNB(){
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.shadowImage = UIImage()
        let goBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        goBackButton.setImage(chevronImage, for: .normal)
        goBackButton.tintColor = .white
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        let navItem = UINavigationItem()
        let backButton          = UIBarButtonItem(customView: goBackButton)
        navItem.leftBarButtonItem = backButton
        navBar.setItems([navItem], animated: false)
        navBar.backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureContainerView(){
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            containerView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    private func configureAddToFavoritesButton(){
        containerView.addSubview(addToFavoritesButton)
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.backgroundColor = .white
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .thin, scale: .small)
        let starImageResized = UIImage(systemName: "star", withConfiguration: largeConfig)
        addToFavoritesButton.setImage(starImageResized, for: .normal)
        addToFavoritesButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        addToFavoritesButton.tintColor = .systemGray2
        
        NSLayoutConstraint.activate([
            addToFavoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Values.padding),
            addToFavoritesButton.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Values.padding),
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 60),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    private func configureMainImageView(){
        containerView.addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Values.padding),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 180),
            mainImageView.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    
    private func configureBrandImageView(){
        containerView.addSubview(brandImageView)
        brandImageView.translatesAutoresizingMaskIntoConstraints = false
        brandImageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            brandImageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Values.padding),
            brandImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Values.padding),
            brandImageView.heightAnchor.constraint(equalToConstant: 60),
            brandImageView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func configureLabels(){
        containerView.addSubviews(nameLabel, descriptionLabel)
        let labelsArray = [nameLabel, descriptionLabel]
        for i in labelsArray{
            i.translatesAutoresizingMaskIntoConstraints = false
            i.isUserInteractionEnabled      = false
            i.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            i.isScrollEnabled = false
            i.textAlignment = .left
            i.backgroundColor = .white
        }
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 24)
        nameLabel.textContainer.maximumNumberOfLines = 5
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor  = .systemGray2
        descriptionLabel.textContainer.maximumNumberOfLines = 0
        descriptionLabel.textContainer.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 0.5*Values.padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.5*Values.padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.5*Values.padding),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0.5*Values.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.5*Values.padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0.5*Values.padding),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    
    private func configureButtonItems(){
        mapPinImage.translatesAutoresizingMaskIntoConstraints = false
        mapPinImage.contentMode = .scaleAspectFit
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = "ГДЕ КУПИТЬ"
        locationLabel.textColor = .black
        locationLabel.font = .systemFont(ofSize: 12)
    }
    
    
    private func configureLocationButton(){
        containerView.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.addSubviews(mapPinImage, locationLabel)
        locationButton.backgroundColor = .white
        locationButton.layer.cornerRadius = 10
        locationButton.layer.borderWidth = 1
        locationButton.layer.borderColor = UIColor.systemGray2.cgColor
        
        NSLayoutConstraint.activate([
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            locationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            locationButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50),
            
            mapPinImage.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            mapPinImage.widthAnchor.constraint(equalToConstant: 20),
            mapPinImage.centerXAnchor.constraint(equalTo: locationButton.centerXAnchor, constant: -30),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationButton.centerYAnchor),
            locationLabel.centerXAnchor.constraint(equalTo: locationButton.centerXAnchor, constant: 30),
            
        ])
    }
    
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    
    //MARK: - Buttons' actions
    @objc private func addToFavorites(){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .thin, scale: .small)
        guard !(addToFavoritesButton.tintColor == .systemGreen) else{
            let starImageResized = UIImage(systemName: "star", withConfiguration: largeConfig)
            addToFavoritesButton.setImage(starImageResized, for: .normal)
            addToFavoritesButton.tintColor = .systemGray2
            return
        }
        let starImageResized = UIImage(systemName: "star.fill", withConfiguration: largeConfig)
        addToFavoritesButton.setImage(starImageResized, for: .normal)
        addToFavoritesButton.tintColor = .systemGreen
    }
}


