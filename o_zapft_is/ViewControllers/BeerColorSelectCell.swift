//
//  BeerColorSelectCell.swift
//  o_zapft_is
//
//  Created by Jeanette Müller on 15.12.23.
//

import UIKit

protocol BeerColorSelectCellDelegate {
    func filterContentByColor(_ color: Float)
}

class BeerColorSelectCell: UICollectionViewCell {
    
    var delegate: BeerColorSelectCellDelegate?
    
    @IBOutlet weak var gradientContainer: UIView!
    @IBOutlet weak var positionMarker: UIView!
    
    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: "SRM_1")!.cgColor, UIColor(named: "SRM_40")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        return gradientLayer
    }()
    
    func updateGradient() {
        self.gradient.removeFromSuperlayer()
        self.gradient.frame = self.bounds
        self.gradientContainer.layer.insertSublayer(gradient, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.gestureChangedPan(_:))))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.gestureChangedTap(_:))))
        
        self.backgroundColor = UIColor(named: "MainBackgroundColor")
        
        self.positionMarker.layer.cornerRadius = 5
        self.positionMarker.layer.borderWidth = 2.0
        self.positionMarker.layer.borderColor = UIColor.darkGray.cgColor
        self.positionMarker.backgroundColor = .clear
        
        self.gradientContainer.layer.cornerRadius = 10
        self.gradientContainer.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func gestureChangedPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
                
            case .began, .changed:
                self.updatePointOfSelection(gesture.location(in: self).x)
            case .ended:
                self.updatePointOfSelection(gesture.location(in: self).x)
                sendUpdatedColorToDelegate(gesture.location(in: self).x)
            case .cancelled, .failed:
                break
            default:
                break
        }
    }
    
    @objc func gestureChangedTap(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
                
            case .ended:
                self.updatePointOfSelection(gesture.location(in: self).x)
                sendUpdatedColorToDelegate(gesture.location(in: self).x)
            case .cancelled, .failed:
                break
            default:
                break
        }
    }
    
    func updatePointOfSelection(_ position: CGFloat) {
        
        self.positionMarker.alpha = 1.0
        
        self.positionMarker.frame = CGRect(x: position-10, y: 0, width: 20, height: 100)
    }
    
    func sendUpdatedColorToDelegate(_ position: CGFloat) {
        let percentageValue = position / self.frame.size.width * 100
        
        let brewColor = 40 / 100 * percentageValue
        
        self.delegate?.filterContentByColor(Float(brewColor))
    }
}

extension BeerColorSelectCell: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

