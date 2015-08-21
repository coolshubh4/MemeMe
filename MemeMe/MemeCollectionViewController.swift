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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = (UIApplication.sharedApplication().delegate) as! AppDelegate
        self.memes = appDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeSentCollectionViewCell", forIndexPath: indexPath) as! MemeSentCollectionViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memedImage.image = meme.memeImage
        return cell
    }
}