//
//  ViewController1.swift
//  NSThread-Gcd-NSOperation-NSOperationQueue-Demo
//
//  Created by qingjiezhao on 7/21/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Class method
        //（1）直接创建线程并且自动运行线程
      
        println("------Class method-------")
        NSThread.detachNewThreadSelector("downloadImage", toTarget: self, withObject: nil)
        
        //object method
        //  （2）先创建一个线程对象，然后手动运行线程，在运行线程操作之前可以设置线程的优先级等线程信息
        println("------object method-------")
        var myThread:NSThread = NSThread(target: self, selector: "downloadImage", object: nil)
        myThread.start()
        
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