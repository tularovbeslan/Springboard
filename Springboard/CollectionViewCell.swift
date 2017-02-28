//
//  CollectionViewCell.swift
//  Springboard
//
//  Created by BESLAN TULAROV on 28.02.17.
//  Copyright © 2017 BESLAN TULAROV. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate {
    func deleteItem(cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: CollectionViewCellDelegate?
    
    func startWiggling() {
        deleteButton.isHidden = false
        guard contentView.layer.animation(forKey: "wiggle") == nil else { return }
        guard contentView.layer.animation(forKey: "bounce") == nil else { return }
        
        let angle = 0.04
        
        let wiggle = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        wiggle.values = [-angle, angle]
        wiggle.autoreverses = true
        wiggle.duration = randomInterval(0.1, variance: 0.025)
        wiggle.repeatCount = Float.infinity
        contentView.layer.add(wiggle, forKey: "wiggle")
        
        let bounce = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounce.values = [4.0, 0.0]
        bounce.autoreverses = true
        bounce.duration = randomInterval(0.12, variance: 0.025)
        bounce.repeatCount = Float.infinity
        contentView.layer.add(bounce, forKey: "bounce")
    }
    
    func stopWiggling() {
        deleteButton.isHidden = true
        contentView.layer.removeAllAnimations()
    }
    
    func randomInterval(_ interval: TimeInterval, variance: Double) -> TimeInterval {
        return interval + variance * Double((Double(arc4random_uniform(1000)) - 500.0) / 500.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopWiggling()
    }
    
    @IBAction func deleteButtonDidPress(sender: UIButton) {
        delegate?.deleteItem(cell: self)
    }
}
