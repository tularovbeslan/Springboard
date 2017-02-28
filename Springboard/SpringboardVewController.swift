//
//  SpringboardVewController.swift
//  Springboard
//
//  Created by BESLAN TULAROV on 28.02.17.
//  Copyright © 2017 BESLAN TULAROV. All rights reserved.
//

import UIKit

class SpringboardVewController: UIViewController {
    
    var applications = [Application]()
    var longGesture: UILongPressGestureRecognizer!
    var movingIndexPath: IndexPath?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelConfigure()
        
        let flowLayout = ReorderableFlowLayout()
        let size = (view.bounds.width - (80 * 4)) / 4
        flowLayout.sectionInset = UIEdgeInsetsMake(15, size, 0, size)
        flowLayout.itemSize = CGSize(width: 80.0, height: 89.0)
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 0.0
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SpringboardVewController.handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longGesture)
        longGesture.minimumPressDuration = 0.3
        
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        movingIndexPath = collectionView.indexPathForItem(at: location)
        switch gesture.state {
        case .began:
            guard let indexPath = movingIndexPath else { return }
            setEditing(true, animated: true)
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            animatePickingUpCell(pickedUpCell())
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
            animatePuttingDownCell(pickedUpCell())
            movingIndexPath = nil
        default:
            collectionView.cancelInteractiveMovement()
            animatePuttingDownCell(pickedUpCell())
            movingIndexPath = nil
        }
    }
    
    func pickedUpCell() -> CollectionViewCell? {
        guard let indexPath = movingIndexPath else { return nil }
        return collectionView.cellForItem(at: indexPath) as? CollectionViewCell
    }
    
    func animatePickingUpCell(_ cell: CollectionViewCell?) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 0.7
            cell?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }, completion: { finished in
            
        })
    }
    
    func animatePuttingDownCell(_ cell: CollectionViewCell?) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { () -> Void in
            cell?.alpha = 1.0
            cell?.transform = CGAffineTransform.identity
        }, completion: { finished in
            cell?.startWiggling()
        })
    }
    
    func startWigglingAllVisibleCells() {
        let cells = collectionView?.visibleCells as! [CollectionViewCell]
        for cell in cells {
            if isEditing { cell.startWiggling() } else { cell.stopWiggling() }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        startWigglingAllVisibleCells()
    }
    
    func modelConfigure() {
        applications.append(Application(name: "Message", image: "Message"))
        applications.append(Application(name: "Calendar", image: "Calendar"))
        applications.append(Application(name: "Photos", image: "Photos"))
        applications.append(Application(name: "Camera", image: "Camera"))
        applications.append(Application(name: "Weather", image: "Weather"))
        applications.append(Application(name: "Clock", image: "Clock"))
        applications.append(Application(name: "Maps", image: "Maps"))
        applications.append(Application(name: "Videos", image: "Videos"))
        applications.append(Application(name: "Notes", image: "Notes"))
        applications.append(Application(name: "Reminders", image: "Reminders"))
        applications.append(Application(name: "Stocks", image: "Stocks"))
        applications.append(Application(name: "Game Center", image: "Game Center"))
        applications.append(Application(name: "News", image: "News"))
        applications.append(Application(name: "iTunes Store", image: "iTunes Store"))
        applications.append(Application(name: "App Store", image: "App Store"))
        applications.append(Application(name: "iBooks", image: "iBooks"))
        applications.append(Application(name: "Health", image: "Health"))
        applications.append(Application(name: "Wallet", image: "Wallet"))
        applications.append(Application(name: "Settings", image: "Settings"))
        applications.append(Application(name: "Apple Watch", image: "Apple Watch"))
        applications.append(Application(name: "Compass", image: "Compass"))
        applications.append(Application(name: "Calculator", image: "Calculator"))
        applications.append(Application(name: "FaceTime", image: "FaceTime"))
        applications.append(Application(name: "Podcasts", image: "Podcasts"))
    }
    
    
}

extension SpringboardVewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! CollectionViewCell
        
        let application = applications[indexPath.item]
        cell.iconImageView.image = UIImage(named: application.image)
        cell.titleLabel.text = application.name
        cell.delegate = self
        if indexPath == movingIndexPath {
            cell.alpha = 0.7
            cell.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        } else {
            cell.alpha = 1.0
            cell.transform = CGAffineTransform.identity
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt source: IndexPath, to destination: IndexPath) {
        applications.insert(applications.remove(at: source.item), at: destination.item)
    }
}

extension SpringboardVewController: CollectionViewCellDelegate {
    func deleteItem(cell: CollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell) else { return }
        let application = self.applications[index.item]
        alert(title: "Delete \"\(application.name)\"?", message: "Deleting this app will also delete its data.", index: index)
    }
    
    func alert(title: String, message: String, index: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            DispatchQueue.main.async {
                self.applications.remove(at: index.item)
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [index])
                }, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
