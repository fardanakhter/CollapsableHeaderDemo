//
//  ViewController.swift
//  CollapsableHeaderDemo
//
//  Created by Fardan Akhter on 11/7/19.
//  Copyright © 2019 Fardan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var scrollViewRef: UIScrollView!
    
    var maxHeaderHeight: CGFloat = 250.0
    var minHeaderHeight: CGFloat = 150.0
    
    var maxImageHeight: CGFloat = 130.0
    var minImageHeight: CGFloat = 60.0
    
    var lastScrollOffset: CGFloat = 0.0
    var animationRate: CGFloat = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.scrollViewRef = scrollView
        
        let offset = scrollView.contentOffset.y
        
        //print("offset: \(offset)")
        
        if offset < 1.0 {
            self.imageViewHeightConst.constant = maxImageHeight
            self.headerHeightConst.constant = maxHeaderHeight
            return
        }
        
        var imageHeight = self.imageViewHeightConst.constant - (offset * animationRate) //Slow down rate
        var headerHeight = self.headerHeightConst.constant - (offset * animationRate) //Slow down rate
        
        if lastScrollOffset < offset {
            //Going down -> dec in height
            print("\nGoing down...\n")
            
            adjustHeightToImage(imageHeight: imageHeight)
            adjustHeightToHeader(headerHeight: headerHeight)
        }
        else {
            //Going up -> inc in height
            print("\nGoing up...\n")
            
            if offset < 200.0 {
                //Change in values to reflect gradual increase to avoid neg offset
                let tempOffset = offset - 200.0
                
                imageHeight = self.imageViewHeightConst.constant - (tempOffset * animationRate) //Slow down rate
                headerHeight = self.headerHeightConst.constant - (tempOffset * animationRate) //Slow down rate
                
                adjustHeightToImage(imageHeight: imageHeight)
                adjustHeightToHeader(headerHeight: headerHeight)
            }
        }
    
        lastScrollOffset = offset
    }
    
    func adjustHeightToImage(imageHeight: CGFloat){
        ////Operation on image
        UIView.animate(withDuration: 0.05) {
            
            print(imageHeight)
            
            if imageHeight > self.maxImageHeight{
                self.imageViewHeightConst.constant = self.maxImageHeight
            }
            else if imageHeight < self.minImageHeight {
                self.imageViewHeightConst.constant = self.minImageHeight
            }
            else {
                self.imageViewHeightConst.constant = imageHeight
            }
        }
    }
    
    func adjustHeightToHeader(headerHeight: CGFloat){
        ////Operation on header
        if headerHeight > maxHeaderHeight {
            self.headerHeightConst.constant = maxHeaderHeight
        }
        else if headerHeight < minHeaderHeight {
            self.headerHeightConst.constant = minHeaderHeight
        }
        else {
            UIView.animate(withDuration: 0.1, animations: {
                self.headerHeightConst.constant = headerHeight
            }, completion: { (_) in
                //self.scrollViewRef.contentOffset.y = 0.0 // to block scrolling
            })
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        }
        else {
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

