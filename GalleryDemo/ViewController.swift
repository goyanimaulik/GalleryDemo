//
//  ViewController.swift
//  GalleryDemo
//
//  Created by maulik on 17/08/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var galleryData = [GalleryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.minimumLineSpacing = 2
        layout1.minimumInteritemSpacing = 2
        layout1.itemSize = CGSize(width: (self.galleryCollectionView.frame.size.width/3) - 10, height: (self.galleryCollectionView.frame.size.width/3) - 4)
        self.galleryCollectionView.collectionViewLayout = layout1
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        self.galleryCollectionView.reloadData()

        let api = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=42"
        
        ApiManager().requestWith(endPoint: api, model: [GalleryModel].self) { (result) in
            guard let data = result as? [GalleryModel] else {
                return
            }
            self.galleryData = data
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.galleryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GalleryCollectionViewCell.self)", for: indexPath) as! GalleryCollectionViewCell
        cell.galleryImgView.sd_setImage(with: URL(string: galleryData[indexPath.row].hdurl ?? ""), completed: nil)
        return cell
    }
}





