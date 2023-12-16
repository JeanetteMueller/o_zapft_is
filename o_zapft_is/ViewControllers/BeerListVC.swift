//
//  BeerListVC.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 14.12.23.
//

import UIKit
import Combine

class BeerListVC: UICollectionViewController, Storyboarded {
    weak var coordinator: RootCoordinator?
    var cancellables: Set<AnyCancellable> = []
    
    var beers = [BeerType]()
    
    enum SectionTypes: Int {
        case colorSelect, beers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default
            .publisher(for: .StorageManagerDidChange)
            .sink { notification in
                
                self.beers = StorageManager.shared.getAllBeer()
                
                self.collectionView.reloadData()
                
            }
            .store(in: &cancellables)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == SectionTypes.colorSelect.rawValue {
            return 1
        }
        
        return self.beers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BeerListHeaderView", for: indexPath) as! BeerListHeaderView
        
        switch indexPath.section {
            case SectionTypes.colorSelect.rawValue:
                view.titleLabel.text = "Destil by color".localized
            case SectionTypes.beers.rawValue:
                view.titleLabel.text = "Select your beer".localized
            default:
                view.titleLabel.text = "–"
        }
        
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == SectionTypes.colorSelect.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerColorSelectCell", for: indexPath) as! BeerColorSelectCell
            
            cell.delegate = self
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeerCell", for: indexPath) as! BeerCell
        
        cell.layer.cornerRadius = 10
        
        let beer = self.beers[indexPath.item]
        
        cell.titleLabel.text = beer.name
        cell.imageView.image = nil
        
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == SectionTypes.beers.rawValue {
            let beer = self.beers[indexPath.item]
            
            self.coordinator?.showBeer(beer)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let colorCell = cell as? BeerColorSelectCell {
            colorCell.updateGradient()
        }
        
        if let beerCell = cell as? BeerCell {
            
            let beer = self.beers[indexPath.item]
            
            if let imageUrlPath = beer.imageUrl, let imageUrl = URL(string: imageUrlPath) {
                
                beerCell.imageView.showImage(from: imageUrl)
            }
        }
    }
}

extension BeerListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: CGFloat.infinity, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let currentWidth = self.view.frame.size.width - 5
        
        if indexPath.section == SectionTypes.colorSelect.rawValue {
            
            let maxWidth = currentWidth - 10
            
            return CGSize(width: maxWidth, height: 100)
        }
        
        let itemWith = ((currentWidth / 2) - 5).rounded(.down)
        
        return CGSize(width: itemWith, height: itemWith)
    }
}

extension BeerListVC: BeerColorSelectCellDelegate {
    func filterContentByColor(_ color: Float) {
        
        self.beers = StorageManager.shared.getBeerInColorRange(min: color - 2, max: color + 2)
        
        self.collectionView.reloadData()
    }
}

extension BeerListVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
