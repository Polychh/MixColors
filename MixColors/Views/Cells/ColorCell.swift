//
//  File.swift
//  MixColors
//
//  Created by Polina on 05.02.2024.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let resuseID = "ColorCell"
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstrains()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//MARK: - Configure Cell UI
extension ColorCell{
    func configColorView(color: UIColor){
        colorView.backgroundColor = color
    }
}

//MARK: - Constrains
extension ColorCell{
    private func setConstrains(){
        contentView.layer.cornerRadius = 16
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
