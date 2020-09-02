//
//  ViewController.swift
//  Food Ordering Design APP
//
//  Created by Hossam on 9/2/20.
//  Copyright © 2020 Hossam. All rights reserved.
//

import UIKit


struct CellData {
    let image:String
    let overlayBackground:UIColor
    let brandName:String
    let rating:String
    let category:String
    let priceTrend:String
    let brandLogoImage:String
}

struct CustomColors {
    static let color1:UIColor = UIColor(red: 248/255, green: 126/255, blue: 5/255, alpha: 1)
    static let color2:UIColor = UIColor(red: 171/255, green: 24/255, blue: 47/255, alpha: 1)
    static let color3:UIColor = UIColor(red: 22/255, green: 191/255, blue: 0/255, alpha: 1)
    static let color4:UIColor = UIColor(red: 5/255, green: 147/255, blue: 248/255, alpha: 1)
}

class CardsViewController: UIViewController {
    
    var  data = [
        CellData(image: "img1", overlayBackground: CustomColors.color1, brandName: "McDonald's", rating: "4.8", category: "Burgers, American", priceTrend: "$$$", brandLogoImage: "logo1"),
        CellData(image: "img2", overlayBackground: CustomColors.color2, brandName: "KFC", rating: "4.8", category: "Chicken, American", priceTrend: "$$$", brandLogoImage: "logo2"),
        CellData(image: "img3", overlayBackground: CustomColors.color3, brandName: "Subway", rating: "4.9", category: "Drinks, American", priceTrend: "$$", brandLogoImage: "logo3"),
        CellData(image: "img4", overlayBackground: CustomColors.color4, brandName: "Dominos", rating: "4.5", category: "Pizza, American", priceTrend: "$$$", brandLogoImage: "logo4"),
    ]
    let colors = [CustomColors.color1, CustomColors.color2 , CustomColors.color3, CustomColors.color4]
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.setCollectionViewLayout(layout, animated: false)
        cv.constrainHeight(constant: 620)
                cv.delegate = self
                cv.dataSource = self
                cv.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return cv
    }()
    
    lazy var orderHereBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Order from here", for: .normal)
        btn.backgroundColor = .black
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btn.layer.cornerRadius = 30
        btn.constrainWidth(constant: 250)
        btn.constrainHeight(constant: 60)
        return btn
    }()
    
    lazy var logoImage:UIImageView = {
        let img = UIImageView(image: UIImage(named: "logo1"))
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.constrainWidth(constant: 150)
        img.constrainHeight(constant: 150)
        return img
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews()  {
        view.backgroundColor = colors[0]
        
        view.addSubViews(views: collectionView,orderHereBtn,logoImage)
        
        collectionView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        orderHereBtn.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 20, right: 0))
        logoImage.anchor(top: nil, leading: nil, bottom: collectionView.topAnchor, trailing: nil,padding: .init(top: 0, left: 0, bottom: 30, right: 0))
        
        NSLayoutConstraint.activate([
            
            orderHereBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}


extension CardsViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        cell.data = data[indexPath.row]
        cell.cardView.transform = .identity
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x / collectionView.frame.width
        self.view.backgroundColor = self.colors[Int(x)]
        self.logoImage.image = UIImage(named: self.data[Int(x)].brandLogoImage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x / collectionView.frame.width
        let y = Double(x)
        let item = Int(x)
        let index = IndexPath(row: item, section: 0)
        let postPoint = Double(item + 1)
        if let cell = self.collectionView.cellForItem(at: index) as? CardCollectionViewCell {
            print(y)
            if y < 0 {
                cell.cardView.transform = .identity
            } else if CGFloat(postPoint - y) > 0.6 {
                cell.cardView.transform = .init(scaleX: CGFloat(postPoint - y), y: CGFloat(postPoint - y))
            } else {
                cell.cardView.transform = .init(scaleX: 0.6, y: 0.6)
            }
            cell.alpha = CGFloat(postPoint - y)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
