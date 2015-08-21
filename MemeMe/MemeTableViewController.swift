//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Shubham Tripathi on 21/08/15.
//  Copyright (c) 2015 coolshubh4. All rights reserved.
//
import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes = [Meme]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = appDelegate.memes
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeSentTableViewCell") as! MemeSentTableViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memeImage.image = meme.memeImage
        cell.topTextLabel.text = meme.topText
        cell.bottomTextLabel.text = meme.bottomText
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("DetailSentMemeView") as! DetailSentMemeView
        
        controller.meme = memes[indexPath.row]
        
        self.navigationController!.pushViewController(controller, animated: true)
    }
}