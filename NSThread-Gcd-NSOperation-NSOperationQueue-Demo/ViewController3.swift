//
//  ViewController3.swift
//  NSThread-Gcd-NSOperation-NSOperationQueue-Demo
//
//  Created by qingjiezhao on 7/21/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var operation:NSBlockOperation = NSBlockOperation(block: {[weak self] in
            self?.downloadImage()
            return
            })
        //创建一个NSOperationQueue实例并添加operation
        var queue:NSOperationQueue = NSOperationQueue()
        queue.addOperation(operation)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func downloadImage(){
        var imageUrl = "http://www.natcom.org/uploadedImages/More_Scholarly_Resources/Doctoral_Program_Resource_Guide/Syracuse%20Logo.jpg"
        var data = NSData(contentsOfURL: NSURL(string: imageUrl)!,options:nil,error:nil)
        println(data?.length)
        
    }
    
}