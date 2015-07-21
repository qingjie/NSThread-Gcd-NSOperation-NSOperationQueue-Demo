//
//  ViewController2.swift
//  NSThread-Gcd-NSOperation-NSOperationQueue-Demo
//
//  Created by qingjiezhao on 7/21/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//


import UIKit

class ViewController2: UIViewController {
    
    //线程同步方法通过锁来实现，每个线程都只用一个锁，这个锁与一个特定的线程关联。下面演示两个线程之间的同步。
    
    var thread1 : NSThread?
    var thread2 : NSThread?
    
    let condition1 = NSCondition()
    let condition2 = NSCondition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thread2 = NSThread(target: self, selector: "method2:", object: nil)
        thread1 = NSThread(target: self, selector: "method1:", object: nil)
        thread1?.start()
    }
    
    func method1(sender:AnyObject){
        for var i=0; i<10; i++ {
            println("NSThread 1 running \(i)")
            sleep(1)
            
            if i == 2 {
                thread2?.start()
                
                condition1.lock()
                condition1.wait()
                condition1.unlock()
            }
        }
        println("NSThread 1 over")
        
        condition2.signal()
    }
   
    func method2(sender:AnyObject){
        for var i = 0; i < 10; i++ {
            println("NSThread 2 running \(i)")
            sleep(1)
            
            if i == 2 {
                condition1.signal()
                
                condition2.lock()
                condition2.wait()
                condition2.unlock()
            }
        }
        println("NSThread 2 over")

    }
  
}