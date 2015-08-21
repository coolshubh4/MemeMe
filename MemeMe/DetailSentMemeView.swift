//
//  DetailSentMemeView.swift
//  MemeMe
//
//  Created by Shubham Tripathi on 22/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//

import UIKit

class DetailSentMemeView: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImage.image = meme.memeImage
        memedImage.contentMode = UIViewContentMode.ScaleAspectFit
    }
}