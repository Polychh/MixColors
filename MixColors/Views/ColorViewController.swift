//
//  ViewController.swift
//  MixColors
//
//  Created by Polina on 05.02.2024.
//

import UIKit
import Combine

final class ColorViewController: UIViewController {
    
    private let viewModel: ViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    private let colorFirstLabel = UILabel()
    private let colorSecondLabel = UILabel()
    private let colorMixedLabel = UILabel()
    private let buttonFirstColor =  UIButton()
    private let buttonSecondColor = UIButton()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let mixedColor: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        var segmentedControl = UISegmentedControl()
        let items = ["RU","EN"]
        segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(nil, action: #selector(segmentControl(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    init(viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabels(label: UILabel){
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpButtons(button: UIButton){
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 2
        button.layer.borderColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUpComponents(){
        setUpLabels(label: colorFirstLabel)
        setUpLabels(label: colorSecondLabel)
        setUpLabels(label: colorMixedLabel)
        setUpButtons(button: buttonFirstColor)
        setUpButtons(button: buttonSecondColor)
        buttonFirstColor.addTarget(nil, action: #selector(firstColorTapped), for: .touchUpInside)
        buttonSecondColor.addTarget(nil, action: #selector(secondColorTapped), for: .touchUpInside)
    }
    
    private func changeTag(button: UIButton, tag: Int){
        button.tag = tag
    }
    
    private func hideCollectionView(isHidden: Bool){
        collectionView.isHidden = isHidden
    }
    
    @objc private func segmentControl(_ segmentedControl: UISegmentedControl) {
        viewModel.choseSegment(segIndex: segmentedControl.selectedSegmentIndex)
    }
    
    @objc private func firstColorTapped() {
        UIView.animate(withDuration: 0.7) {self.buttonFirstColor.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)}
        changeTag(button: buttonFirstColor, tag: 1)
        hideCollectionView(isHidden: false)
    }
    
    @objc private func secondColorTapped() {
        UIView.animate(withDuration: 0.7) {self.buttonSecondColor.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)}
        changeTag(button: buttonSecondColor, tag: 2)
        hideCollectionView(isHidden: false)
    }
    
    private func updateColors(button: UIButton, label: UILabel, view: UIView, mixLabel: UILabel, colorObserve: UIColor, color: UIColor){
        button.backgroundColor = colorObserve
        label.text = colorObserve.name?.localized
        let mixedColor = self.viewModel.mixedColors(color1: colorObserve, color2: color)
        UIView.animate(withDuration: 1.0) {view.backgroundColor = mixedColor}
        mixLabel.text = mixedColor.name?.localized
    }
    
    private func observeColors(){
        viewModel.languagePublisher
            .receive(on: DispatchQueue.main)
            .sink {_ in
                self.colorFirstLabel.text =   self.viewModel.color1.name?.localized
                self.colorSecondLabel.text =  self.viewModel.color2.name?.localized
                self.colorMixedLabel.text = self.viewModel.mixedColors(color1:  self.viewModel.color1, color2: self.viewModel.color2).name?.localized
            }
            .store(in: &cancellables)
        
        viewModel.color1Publisher
            .receive(on: DispatchQueue.main)
            .sink { color1 in
                self.updateColors(button: self.buttonFirstColor, label: self.colorFirstLabel, view: self.mixedColor, mixLabel: self.colorMixedLabel , colorObserve: color1, color:  self.viewModel.color2)
            }
            .store(in: &cancellables)
        
        viewModel.color2Publisher
            .receive(on: DispatchQueue.main)
            .sink { color2 in
                self.updateColors(button: self.buttonSecondColor, label: self.colorSecondLabel, view: self.mixedColor, mixLabel: self.colorMixedLabel , colorObserve: color2, color:  self.viewModel.color1)
            }
            .store(in: &cancellables)
    }
    
//MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.saveInitialLang()
        view.backgroundColor = .white
        setUpComponents()
        configureCollectionView()
        setConstrains()
        observeColors()
    }
}

//MARK: - Configure UiCollectionView
private extension ColorViewController{
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.layer.borderWidth = 2
        collectionView.layer.borderColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        collectionView.layer.cornerRadius = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.resuseID)
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ColorViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.colorArray.array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.resuseID, for: indexPath) as? ColorCell else {return UICollectionViewCell()}
        cell.configColorView(color: viewModel.colorArray.array[indexPath.row].color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if buttonFirstColor.tag == 1 {
            UIView.animate(withDuration: 0.7) {self.buttonFirstColor.transform = CGAffineTransform(scaleX: 1, y: 1)}
            viewModel.updateColor1(colorIndex: indexPath.row)
            changeTag(button: buttonFirstColor, tag: 0)
        } else if buttonSecondColor.tag == 2 {
            UIView.animate(withDuration: 0.7) {self.buttonSecondColor.transform = CGAffineTransform(scaleX: 1, y: 1)}
            viewModel.updateColor2(colorIndex: indexPath.row)
            changeTag(button: buttonSecondColor, tag: 0)
        }
        hideCollectionView(isHidden: true)
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5 + 16// from left and right of the screen
        let minimumItemSpacing: CGFloat = 1// between columns
        let availableWidth = view.bounds.width - (padding * 2) - (minimumItemSpacing * 6)
        let widthPerItem = availableWidth / 7
        return CGSize(width: widthPerItem, height: widthPerItem - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        2
    }
}
//MARK: - Constrains
extension ColorViewController{
    func setConstrains(){
        view.addSubview(colorFirstLabel)
        view.addSubview(colorSecondLabel)
        view.addSubview(buttonFirstColor)
        view.addSubview(colorMixedLabel)
        view.addSubview(buttonSecondColor)
        view.addSubview(mixedColor)
        view.addSubview(collectionView)
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            
            colorFirstLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 75),
            colorFirstLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonFirstColor.topAnchor.constraint(equalTo: colorFirstLabel.bottomAnchor,constant: 24),
            buttonFirstColor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonFirstColor.heightAnchor.constraint(equalToConstant: 50),
            buttonFirstColor.widthAnchor.constraint(equalToConstant: 50),
            
            colorSecondLabel.topAnchor.constraint(equalTo: buttonFirstColor.bottomAnchor,constant: 48),
            colorSecondLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonSecondColor.topAnchor.constraint(equalTo: colorSecondLabel.bottomAnchor,constant: 24),
            buttonSecondColor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSecondColor.heightAnchor.constraint(equalToConstant: 50),
            buttonSecondColor.widthAnchor.constraint(equalToConstant: 50),
            
            colorMixedLabel.topAnchor.constraint(equalTo: buttonSecondColor.bottomAnchor,constant: 48),
            colorMixedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mixedColor.heightAnchor.constraint(equalToConstant: 100),
            mixedColor.widthAnchor.constraint(equalToConstant: 100),
            mixedColor.topAnchor.constraint(equalTo: colorMixedLabel.bottomAnchor, constant: 24),
            mixedColor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 40),
            collectionView.topAnchor.constraint(equalTo: buttonFirstColor.bottomAnchor, constant: 5),
            
            segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            segmentedControl.heightAnchor.constraint(equalToConstant: 45),
            segmentedControl.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}
