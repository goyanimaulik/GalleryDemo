//
//  ViewController.swift
//  GalleryDemo
//
//  Created by maulik on 17/08/21.
//

import UIKit
import SDWebImage
import DTPhotoViewerController

class ViewController: UIViewController {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var galleryData = [GalleryModel]()
    fileprivate var selectedImageIndex: Int = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.scrollDirection = .vertical
        layout1.minimumLineSpacing = 2
        layout1.minimumInteritemSpacing = 2
        layout1.itemSize = CGSize(width: (self.galleryCollectionView.frame.size.width/3) - 15, height: (self.galleryCollectionView.frame.size.width/3) - 4)
        self.galleryCollectionView.collectionViewLayout = layout1
        

        let api = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&count=42"
        
        ApiManager().requestWith(endPoint: api, model: [GalleryModel].self) { (result) in
            guard let data = result as? [GalleryModel] else {
                return
            }
            self.galleryData = data
            self.galleryCollectionView.delegate = self
            self.galleryCollectionView.dataSource = self
            self.galleryCollectionView.reloadData()

        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.galleryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GalleryCollectionViewCell.self)", for: indexPath) as! GalleryCollectionViewCell

        cell.galleryImgView.sd_setImage(with: URL(string: galleryData[indexPath.row].hdurl ?? ""), completed: {_,_,_,_ in

        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
        selectedImageIndex = indexPath.row
        let viewController = SimplePhotoViewerController(referencedView: cell?.galleryImgView, image: cell?.galleryImgView.image)
        viewController.dataSource = self
        viewController.delegate = self
        present(viewController, animated: true, completion: nil)
    }

}






// MARK: DTPhotoViewerControllerDataSource
extension ViewController: DTPhotoViewerControllerDataSource {
    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configureCell cell: DTPhotoCollectionViewCell, forPhotoAt index: Int) {
        // Set text for each item
        if let cell = cell as? CustomPhotoCollectionViewCell {
            cell.extraLabel.text = "\(index + 1) / \(galleryData.count)"
        }
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, referencedViewForPhotoAt index: Int) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        if let cell = galleryCollectionView?.cellForItem(at: indexPath) as? GalleryCollectionViewCell {
            return cell.galleryImgView
        }
        return nil
    }

    func numberOfItems(in photoViewerController: DTPhotoViewerController) -> Int {
        return galleryData.count
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, configurePhotoAt index: Int, withImageView imageView: UIImageView) {
        let url : String = galleryData[index].hdurl ?? ""
        imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "app_logo"))
    }
}

// MARK: DTPhotoViewerControllerDelegate
extension ViewController: SimplePhotoViewerControllerDelegate {
    func videoPlayed(index: Int) {
        
    }
    
    func photoViewerControllerDidEndPresentingAnimation(_ photoViewerController: DTPhotoViewerController) {
        photoViewerController.scrollToPhoto(at: selectedImageIndex, animated: false)
    }

    func photoViewerController(_ photoViewerController: DTPhotoViewerController, didScrollToPhotoAt index: Int) {
        selectedImageIndex = index
        if let collectionView = galleryCollectionView {
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)

            // If cell for selected index path is not visible
            if !collectionView.indexPathsForVisibleItems.contains(indexPath) {
                // Scroll to make cell visible
                collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    func photoViewerControllerDidReceiveTapGesture(_ photoViewerController: DTPhotoViewerController) {
        
    }
    func simplePhotoViewerController(_ viewController: SimplePhotoViewerController, savePhotoAt index: Int) {

    }
}
