//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Shubham Tripathi on 21/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var memes = [Meme]()
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.width - (2 * space)) / space
        let heightDimension = (self.view.frame.height - (2 * space)) / space
        
        // Defining the size of CollectionView cells
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(widthDimension, heightDimension)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        self.memes = appDelegate.memes
        
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeSentCollectionViewCell", forIndexPath: indexPath) as! MemeSentCollectionViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memedImage.image = meme.memeImage
        cell.memedImage.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("DetailSentMemeView") as! DetailSentMemeView
        
        controller.meme = memes[indexPath.row]
        
        // Pushing the DetailSentMemeView controller
        navigationController?.pushViewController(controller, animated: true)
    }
}