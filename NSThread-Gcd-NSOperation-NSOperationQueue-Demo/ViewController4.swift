//
//  ViewController4.swift
//  NSThread-Gcd-NSOperation-NSOperationQueue-Demo
//
//  Created by qingjiezhao on 7/21/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var downloadImageOperation:DownloadImageOperation = DownloadImageOperation()
        
        var queue:NSOperationQueue = NSOperationQueue()
        queue.addOperation(downloadImageOperation)
        
        
        
        /*
        设置运行队列并发数
        NSOperationQueue队列里可以加入很多个NSOperation，可以把NSOperationQueue看做一个线程池，可往线程池中添加操作（NSOperation）到队列中。
        可以设置线程池中的线程数，也就是并发操作数。默认情况下是-1，-1表示没有限制，这样可以同时运行队列中的全部操作。
        */
        //设置并发数
        queue.maxConcurrentOperationCount = 3
        
//        /*取消队列所有操作*/
        //取消所有线程操作
        queue.cancelAllOperations()
        
        /*每个NSOperation完成都会有一个回调表示任务结束*/
        //定义一个回调
        var completionBlock:(() -> Void)?
        //给operation设置回调
        downloadImageOperation.completionBlock = completionBlock
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4), dispatch_get_main_queue(), {
            println("Complete")
        })
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}

class DownloadImageOperation: NSOperation {
    override func main(){
        var imageUrl = "http://www.natcom.org/uploadedImages/More_Scholarly_Resources/Doctoral_Program_Resource_Guide/Syracuse%20Logo.jpg"
        var data = NSData(contentsOfURL: NSURL(string: imageUrl)!,options:nil,error:nil)
        println(data?.length)
    }
}