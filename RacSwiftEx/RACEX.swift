//
//  RACEX.swift
//  ex-ios
//
//  Created by r.t on 15/4/13.
//  Copyright (c) 2015年 r.t. All rights reserved.
//

import Foundation

func rac_basic_1(){
    "A B C D E F G H I".componentsSeparatedByString(" ")
    var letters: RACSignal = ("A B C D E F G H I".componentsSeparatedByString(" ") as NSArray).rac_sequence.signal()
    letters.subscribeNext{ x in
        println(x)
    }
}

func rac_basic_2(){
    var subscriptions = 0
    
    var signal = RACSignal.createSignal({ (subscriber) -> RACDisposable! in
        subscriptions++
        subscriber.sendCompleted()
        return nil
    }).finally { () -> Void in
        //println("finally")
    }
    
    signal = signal.doCompleted({ () -> Void in
        println("about to complete subscription: \(subscriptions)")
    })
    
    signal.subscribeCompleted({ (_) -> Void in
        println("subscriptions: \(subscriptions)")
    })
    
    signal.subscribeCompleted({ (_) -> Void in
        println("subscriptions: \(subscriptions)")
    })
}

func rac_basic_3(){
    var letters = ("A B C D E F G H I".componentsSeparatedByString(" ") as NSArray).rac_sequence
    var nums = ("1 2 3 4 5 6 7 8 9".componentsSeparatedByString(" ") as NSArray).rac_sequence
    
    
    // map
    var mapped = letters.map { (value) -> AnyObject! in
        return  value.stringByAppendingString(value as! String)
    }
    println(mapped.array)
    
    // filter
    var filtered = nums.filter({ (value) -> Bool in
        return (value.intValue % 2) == 0;
    })
    println(filtered.array)
    
    // concat
    var concatenated = letters.concat(nums)
    println(concatenated.array)

    // flatten
    var sequenceOfSequences = ([letters, nums] as NSArray).rac_sequence
    var flattened = sequenceOfSequences.flatten()
    println(flattened.array)
}

func rac_basic_4(){
    var letters = RACSubject()
    var numbers = RACSubject()
    var signalOfSignals = RACSignal.createSignal { (subscriber) -> RACDisposable! in
        subscriber.sendNext(letters)
        subscriber.sendNext(numbers)
        subscriber.sendCompleted()
        return nil
    }
    
    var flattened = signalOfSignals.flatten()
    flattened.subscribeNext { (x) -> Void in
        println("\(x)")
    }
    
    letters.sendNext("A")
    numbers.sendNext("1")
    letters.sendNext("B")
    letters.sendNext("D")
    numbers.sendNext("5")
}

func btnRAC(container:UIView){
    var btn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    btn.frame = CGRectMake(0,60,80,20)
    btn.setTitle("UP",forState:UIControlState.Normal)
    
    btn.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
        .subscribeNext{ _ in
            
            println("按钮点击事件")
    }
    
    container.addSubview(btn)
}