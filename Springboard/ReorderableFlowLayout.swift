//
//  ReorderableFlowLayout.swift
//  Springboard
//
//  Created by BESLAN TULAROV on 28.02.17.
//  Copyright © 2017 BESLAN TULAROV. All rights reserved.
//

import UIKit

class ReorderableFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        
        attributes.alpha = 0.7
        attributes.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        return attributes
    }
}
