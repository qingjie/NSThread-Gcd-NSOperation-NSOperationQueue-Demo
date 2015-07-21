//
//  ViewController5.swift
//  NSThread-Gcd-NSOperation-NSOperationQueue-Demo
//
//  Created by qingjiezhao on 7/21/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController5: UIViewController {
    
    /*
    GCD是Apple开发的一个多核编程的解决方法，基本概念就是dispatch queue（调度队列），queue是一个对象，它可以接受任务，并将任务以先到先执行的顺序来执行。dispatch queue可以是并发的或串行的。GCD的底层依然是用线程实现，不过我们可以不用关注实现的细节。其优点有如下几点：
    （1）易用：GCD比thread更简单易用。基于block的特效使它能极为简单地在不同代码作用域之间传递上下文。
    （2）效率：GCD实现功能轻量，优雅，使得它在很多地方比专门创建消耗资源的线程更加实用且快捷。
    （3）性能：GCD自动根据系统负载来增减线程数量，从而减少了上下文切换并增加了计算效率。
    （4）安全：无需加锁或其他同步机制。
     GCD三种创建队列的方法
    */
    
    /*
    GCD三种创建队列的方法
    （1）自己创建一个队列
    第一个参数代表队列的名称，可以任意起名
    第二个参数代表队列属于串行还是并行执行任务
    串行队列一次只执行一个任务。一般用于按顺序同步访问，但我们可以创建任意数量的串行队列，各个串行队列之间是并发的。
    并行队列的执行顺序与其加入队列的顺序相同。可以并发执行多个任务，但是执行完成的顺序是随机的。
    */
    
    var serial:dispatch_queue_t = dispatch_queue_create("serialQueue1", DISPATCH_QUEUE_SERIAL)
    
    var concurrent:dispatch_queue_t = dispatch_queue_create("concurrentQueue1", DISPATCH_QUEUE_CONCURRENT)
    
    
    /*
    (2）获取系统存在的全局队列
    Global Dispatch Queue有4个执行优先级：
    DISPATCH_QUEUE_PRIORITY_HIGH  高
    DISPATCH_QUEUE_PRIORITY_DEFAULT  正常
    DISPATCH_QUEUE_PRIORITY_LOW  低
    DISPATCH_QUEUE_PRIORITY_BACKGROUND 非常低的优先级（这个优先级只用于不太关心完成时间的真正的后台任务）
    */
    var globalQueue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    /*
    （3）运行在主线程的Main Dispatch Queue 
    应为主线程只有一个，所有这自然是串行队列。一起跟UI有关的操作必须放在主线程中执行
    */
    var mainQueue:dispatch_queue_t = dispatch_get_main_queue()
    
    
    
    /*
    添加任务到队列的两种方法
    (1）dispatch_async异步追加Block块（dispatch_async函数不做任何等待）
    */
    
    //添加异步代码块到dispatch_get_global_queue队列
    func method1(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{ () -> Void in
            //处理耗时操作的代码块...
            println("doing some work")
            
            //操作完成，调用主线程来刷新界面
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                println("main refresh")
            })
            
        })
    }
    
    
    
    //（2）dispatch_sync同步追加Block块
    //添加同步代码块到dispatch_get_global_queue队列, 不会造成死锁，当会一直等待代码块执行完毕
    func method2(){
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            println("sync1")
        })
        println("end1")
        
        //添加同步代码块到dispatch_get_main_queue队列,会引起死锁
        //因为在主线程里面添加一个任务，因为是同步，所以要等添加的任务执行完毕后才能继续走下去。但是新添加的任务排在队列的末尾，要执行完成必须等前面的任务执行完成，由此又回到了第一步，程序卡死
        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
            println("sync2")
        })
        println("end2")
    }
    
    
    /*
    5，暂停或者继续队列
    这两个函数是异步的，而且只在不同的blocks之间生效，对已经正在执行的任务没有影响。
    dispatch_suspend后，追加到Dispatch Queue中尚未执行的任务在此之后停止执行。
    而dispatch_resume则使得这些任务能够继续执行。
    */
    //创建并行队列
    func method3(){
        var conQueue:dispatch_queue_t = dispatch_queue_create("concurrentQueue1", DISPATCH_QUEUE_CONCURRENT)
        //暂停一个队列
        dispatch_suspend(conQueue)
        //继续队列
        dispatch_resume(conQueue)
    }
    
    
    /*
    6，dispatch_once 一次执行
    保证dispatch_once中的代码块在应用程序里面只执行一次，无论是不是多线程。因此其可以用来实现单例模式，安全，简洁，方便。
    */
    func method4(){
        //往dispatch_get_global_queue队列中添加代码块，只执行一次
        var predicate:dispatch_once_t = 0
        dispatch_once(&predicate, { () -> Void in
            //只执行一次，可用于创建单例
            println("work")
        })
    }
    
    
    
    /*
    7, dispatch_after 延迟调用
    dispatch_after并不是在指定时间后执行任务处理，而是在指定时间后把任务追加到Dispatch Queue里面。因此会有少许延迟。注意，我们不能（直接）取消我们已经提交到dispatch_after里的代码。
    */
    
    func method5(){
        //延时2秒执行
        let delta = 2.0 * Double(NSEC_PER_SEC)
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(delta))
        dispatch_after(dtime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            println("deplay 2 seconds")
        }
    }
    
    /*
    8，多个任务全部结束后做一个全部结束的处理
    dispatch_group_async：用来监视一组block对象的完成，你可以同步或异步地监视
    dispatch_group_notify：用来汇总结果，所有任务结束汇总，不阻塞当前线程
    dispatch_group_wait：等待直到所有任务执行结束，中途不能取消，阻塞当前线程
    */
    
    func method6(){
        //获取系统存在的全局队列
        var queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        //定义一个group
        var group:dispatch_group_t = dispatch_group_create()
        //并发任务，顺序执行
        dispatch_group_async(group, queue, {() -> Void in
            println("block1")
        })
        dispatch_group_async(group, queue, {() -> Void in
            println("block2")
        })
        dispatch_group_async(group, queue, {() -> Void in
            println("block3")
        })
        
        //所有任务执行结束汇总，不阻塞当前线程
        dispatch_group_notify(group, dispatch_get_main_queue(), {() -> Void in
            println("group done")
        })
        
        //永久等待，直到所有任务执行结束，中途不能取消，阻塞当前线程
        var result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        if result == 0{
            println("all tasks are done")
        }else{
            println("one of tasks is running")
        }
    }
    
    /*
    9,dipatch_apply 指定次数的Block最加到指定队列中
    dipatch_apply函数是dispatch_sync函数和Dispatch Group的关联API。按指定的次数将指定的Block追加到指定的Dispatch Queue中，并等待全部处理执行结束。
    因为dispatch_apply函数也与dispatch_sync函数一样，会等待处理结束，因此推荐在dispatch_async函数中异步执行dispatch_apply函数。dispatch_apply函数可以实现高性能的循环迭代。
    */
    
    func method7(){
        //获取系统存在的全局队列
        var queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        //定义一个一步代码块
        dispatch_async(queue, {() -> Void in
            
            //通过dispatch_apply，循环变量数组
            dispatch_apply(6, queue, {(index) -> Void in
                println(index)
            })
            
            //执行完毕，主线程更新
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                println("done")
            })
        })
    }
    
    /*
    10,信号，信号量
    dispatch_semaphore_create：用于创建信号量，可以指定初始化信号量计数值，这里我们默认1.
    dispatch_semaphore_waite：会判断信号量，如果为1，则往下执行。如果是0，则等待。
    dispatch_semaphore_signal：代表运行结束，信号量加1，有等待的任务这个时候才会继续执行。
    */
    func method8(){
        //获取系统存在的全局队列
        var queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        //当并行执行的任务更新数据时，会产生数据不一样的情况
        for i in 1...20
        {
            dispatch_async(queue,{ () -> Void in
                println("\(i)")
            })
        }
        
        //使用信号量保证正确性
        //创建一个初始计数值为1的信号
        var semaphore:dispatch_semaphore_t = dispatch_semaphore_create(1)
        for i in 1...20
        {
            dispatch_async(queue,{ () -> Void in
                //永久等待，直到Dispatch Semaphore的计数值 >= 1
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                println("\(i)")
                //发信号，使原来的信号计数值+1
                dispatch_semaphore_signal(semaphore)
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    

}
