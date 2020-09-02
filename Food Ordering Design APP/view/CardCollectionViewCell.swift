//
//  CardCollectionViewCell.swift
//  Food Ordering Design APP
//
//  Created by Hossam on 9/2/20.
//  Copyright © 2020 Hossam. All rights reserved.
//


import UIKit

class CardCollectionViewCell: UICollectionViewCell {
     
    var data:CellData?{
        didSet{
            manageData()
        }
    }
    
    lazy var cardView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.setCardShadow()
        v.layer.cornerRadius = 20
        return v
    }()
    
     lazy var overlayView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        v.constrainHeight(constant: 300)
        return v
    }()
    
     lazy var cardImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 20
        img.constrainWidth(constant: 200)
        img.constrainHeight(constant: 200)
        return img
    }()
    
     lazy var brandName:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        l.textColor = .black
        return l
    }()
    
     lazy var subTitle:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
     lazy var timeLabel = UILabel(text: "10 - 15 min", font: .systemFont(ofSize: 17), textColor: .black)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(cardView)
        
        cardView.addSubViews(views: overlayView,brandName,subTitle,timeLabel)
        overlayView.addSubview(cardImage)
        
        cardView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 10, left: 20, bottom: 10, right: 10))
        overlayView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor,padding: .init(top: 20, left: 20, bottom: 0, right: 20))
        brandName.anchor(top: overlayView.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        subTitle.anchor(top: brandName.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        timeLabel.anchor(top: subTitle.bottomAnchor, leading: nil, bottom: nil, trailing: nil,padding: .init(top: 20, left: 0, bottom: 0, right: 0))

        
        NSLayoutConstraint.activate([
            
            cardImage.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            cardImage.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            brandName.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            subTitle.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        overlayView.backgroundColor = data.overlayBackground
        cardImage.image = UIImage(named:data.image)
        brandName.text = data.brandName
        setUpAttributeText(data.rating, data.category, data.priceTrend)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpAttributeText( _ rating:String , _ category:String , _ priceTrend:String ){
        let starImg = UIImage(named:"star")?.withRenderingMode(.alwaysOriginal)
        let font = UIFont.systemFont(ofSize: 15)
        let starImage = NSTextAttachment()
        starImage.image = starImg
        starImage.bounds = CGRect(x: 0, y: (font.capHeight - 15).rounded() / 2, width: 15, height: 15)
        starImage.setImageHeight(height: 15)
        let spaceString = NSAttributedString(attachment: starImage)
        let attributedText = NSMutableAttributedString(string:" ")
        attributedText.append(spaceString)
        attributedText.append(NSAttributedString(string: " \(rating)   \(category)   \(priceTrend)" , attributes:[NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15) , NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        subTitle.attributedText = attributedText
    }
    
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
