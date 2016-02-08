//
//  sectionalTestViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 1/3/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class SimpleCollectionReusableView : UICollectionReusableView {
    let label: UILabel = UILabel(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.textAlignment = .Center
        addSubview(label)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        label.textAlignment = .Center
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = bounds
    }
}

class SectionedCollectionViewController: PFQueryCollectionViewController {
    
    var sections: [Int: [PFObject]] = Dictionary()
    var sectionKeys: [Int] = Array()
    
    // MARK: Init
    
    convenience init(className: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        layout.minimumInteritemSpacing = 5.0
        self.init(collectionViewLayout: layout, className: className)
        
        title = "Sectioned Collection"
        pullToRefreshEnabled = true
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerClass(SimpleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let bounds = UIEdgeInsetsInsetRect(view.bounds, layout.sectionInset)
            let sideLength = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0 - layout.minimumInteritemSpacing
            layout.itemSize = CGSizeMake(sideLength, sideLength)
        }
    }
    
    // MARK: Data
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        sections.removeAll(keepCapacity: false)
        if let objects = objects as? [PFObject] {
            for object in objects {
                let priority = (object["priority"] as? Int) ?? 0
                var array = sections[priority] ?? Array()
                array.append(object)
                sections[priority] = array
            }
        }
        sectionKeys = sections.keys.sort(<)
        
        collectionView?.reloadData()
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        if let indexPath = indexPath {
            let array = sections[sectionKeys[indexPath.section]]
            return array?[indexPath.row]
        }
        return nil
    }
    
}

extension SectionedCollectionViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let array = sections[sectionKeys[section]]
        return array?.count ?? 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: object)
        
        cell?.textLabel.textAlignment = .Center
        cell?.textLabel.text = object?["title"] as? String
        
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as? SimpleCollectionReusableView {
                view.label.text = "Priority \(sectionKeys[indexPath.section])"
                return view
        }
        return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if sections.count > 0 {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 40.0)
        }
        return CGSizeZero
    }
    
}