//
//  MainVC.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit

class MainVC: DataLoadingVC {
    private var timer: Timer?
    private var pageOffset = 0
    private var isSearchingByRequest = Bool()
    private lazy var itemsArray: [GardenItem] = []
    private lazy var searchArray: [GardenItem]  = []
    private lazy var navBar = UINavigationBar(frame: .zero)
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createLayout(in: view))
    private lazy var searchTextField        = CustomTextField(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        isSearchingByRequest = false
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func configure(){
        configureNB()
        configureCollectionView()
        getItems(pageOffSet: pageOffset)
    }
    
    
    //MARK: - Get API Data
    private func getItems(pageOffSet: Int){
        showLoadingView()
        NetworkManager.shared.getItemsList(offset: pageOffset )  { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsResult):
                self.itemsArray.append(contentsOf: itemsResult)
                reloadCollectionView()
                self.dismissLoadingView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    
    private func getSearchRequestFromAPI(request: String){
        NetworkManager.shared.searchItems(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let flashSalesResult):
                self.searchArray = flashSalesResult
                reloadCollectionView()
            case .failure(let error):
                self.presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: error.rawValue, butonTitle: "Ok")
            }
        }
    }
    
    
    //MARK: - Configure UI
    private func configureSearchTextField(){
        view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.autocapitalizationType = .none
        searchTextField.font = UIFont(name: "Montserrat", size: 15)
        searchTextField.placeholder = "What are you looking for?"
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let magnifyingglassView    = UIImageView()
        magnifyingglassView.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(pointSize: 10)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        magnifyingglassView.image = image
        magnifyingglassView.tintColor = .label
        searchTextField.addSubview(magnifyingglassView)
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Values.padding),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Values.padding),
            searchTextField.heightAnchor.constraint(equalToConstant: 60),
            
            magnifyingglassView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: -0.5*Values.padding),
            magnifyingglassView.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
        ])
    }
    
    
    private func configureNB(){
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.shadowImage = UIImage()
        
        let goBackButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let goSearchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        let chevronImage = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        let magnifyingGlassImage = UIImage(systemName: "magnifyingglass", withConfiguration: configuration)
        goBackButton.setImage(chevronImage, for: .normal)
        goBackButton.tintColor = .white
        goBackButton.layer.cornerRadius = 10
        goBackButton.layer.masksToBounds = true
        goBackButton.addTarget(self, action: #selector(dismissSearch), for: .touchUpInside)
        
        goSearchButton.setImage(magnifyingGlassImage, for: .normal)
        goSearchButton.tintColor = .white
        goSearchButton.layer.cornerRadius = 10
        goSearchButton.layer.masksToBounds = true
        goSearchButton.addTarget(self, action: #selector(goSearch), for: .touchUpInside)
        let navItem = UINavigationItem()
        let backButton          = UIBarButtonItem(customView: goBackButton)
        let searchButton          = UIBarButtonItem(customView: goSearchButton)
        navItem.leftBarButtonItem = backButton
        navItem.rightBarButtonItem = searchButton
        navItem.title = "Болезни или средства"
        navBar.setItems([navItem], animated: false)
        navBar.backgroundColor = .systemGreen
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            navBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GardenItemCell.self, forCellWithReuseIdentifier: GardenItemCell.reuseID)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)//adds space in the end of tableView
        collectionView.contentInset = insets
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc private func goSearch(){
        configureSearchTextField()
    }
    
    @objc private func dismissSearch(){
        isSearchingByRequest = false
        searchTextField.text = ""
        reloadCollectionView()
    }
    
    
    //MARK: - TextField did started to change func
    @objc func textFieldDidChange(_ textField: UITextField) {
        timer?.invalidate()
        searchArray.removeAll()
        switch searchTextField.text?.isEmpty{
        case true:
            DispatchQueue.main.async { [self] in
                isSearchingByRequest = false
                reloadCollectionView()
            }
        default:
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false){ [self] _ in
                isSearchingByRequest = true
                self.getSearchRequestFromAPI(request: searchTextField.text!)
                reloadCollectionView()
            }
        }
    }
    
    
    //MARK: - DismissKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.removeFromSuperview()
        self.view.endEditing(true)
    }
}


extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard isSearchingByRequest else {
            return itemsArray.count
        }
        return searchArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GardenItemCell.reuseID, for: indexPath) as! GardenItemCell
        guard isSearchingByRequest else {
            let item = itemsArray[indexPath.row]
            cell.setValues(id: item.id, imageURL: item.image, name: item.name, descriprion: item.description)
            return cell
        }
        let item = searchArray[indexPath.row]
        cell.setValues(id: item.id, imageURL: item.image, name: item.name, descriprion: item.description)
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchTextField.removeFromSuperview()
        self.view.endEditing(true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.searchTextField.removeFromSuperview()
        let offSetY = scrollView.contentOffset.y//already scrolled data
        let contentHeight = scrollView.contentSize.height//total height of data
        let height = scrollView.frame.size.height//screen height
        if offSetY > contentHeight - height{
            pageOffset += 20
            getItems(pageOffSet: pageOffset)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.searchTextField.removeFromSuperview()
        let cell = collectionView.cellForItem(at: indexPath) as! GardenItemCell
        let id  = cell.id
        let destinationVC = DetailsVC(id: id)
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}



//MARK: - UITextFieldDelegate
extension MainVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case searchTextField:
            searchTextField.placeholder = ""
        default:
            break
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case searchTextField:
            searchTextField.placeholder = "What are you looking for?"
            timer?.invalidate()
        default:
            break
        }
    }
}





