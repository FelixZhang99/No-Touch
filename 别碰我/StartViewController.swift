//
//  StartViewController.swift
//  别碰我
//
//  Created by Zhangfutian on 15/8/14.
//  Copyright (c) 2015年 Zhangfutian. All rights reserved.
//
import UIKit
import Foundation


var motion=1
var mpoint=200

class StartViewController:UIViewController{
    
    @IBOutlet var kaishi:UIButton!
    @IBOutlet var help:UIButton!
    
    let viewTransitionDelegate = TransitionDelegate()
    var buttonclick=0
    var again=false
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        save()
        
        if buttonclick==1{
            
            let modal=segue.destinationViewController as! GameViewController
            
            modal.transitioningDelegate = viewTransitionDelegate
            
            modal.modalPresentationStyle = .Custom
        }else if buttonclick==2{
            
            let modal2=segue.destinationViewController as! HelpViewController
            
            modal2.transitioningDelegate = viewTransitionDelegate
            
            modal2.modalPresentationStyle = .Custom
        }
        
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonclick=0
        
        width=self.view.bounds.width
        
        height=self.view.bounds.height
        
        println([width,height])
        
        kaishi.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        kaishi.layer.cornerRadius = 50
        
        kaishi.frame = CGRectMake(0, 0, width/3, width/3)
        
        kaishi.center = self.view.center
        
               self.view.setNeedsLayout()
     
        kaishi.addTarget(self, action: Selector("click"), forControlEvents: UIControlEvents.TouchDown)
    
        help.addTarget(self, action: Selector("click2"), forControlEvents: UIControlEvents.TouchDown)
    
        help.frame = CGRectMake(width/2-30, 9*height/10-10, 60, 20)
        
        var levelarray:[String] = ["简单","困难","地狱"]
        
        var segment:UISegmentedControl = UISegmentedControl(items: levelarray)
        
        segment.frame = CGRectMake(width/6, 2*height/3, 2*width/3, height/15)
        
        self.view.addSubview(segment)
        
        load()
        
        var label1:UILabel = UILabel(frame: CGRectMake(width/4-50, 4*height/5-25, 100, 50))
        
        label1.textAlignment = NSTextAlignment.Center
        
        label1.text = "\(bestscore0)"
        
        self.view.addSubview(label1)
        
        var label2:UILabel = UILabel(frame: CGRectMake(width/2-50, 4*height/5-25, 100, 50))
        
        label2.textAlignment = NSTextAlignment.Center
        
        label2.text = "\(bestscore1)"
        
        self.view.addSubview(label2)
        
        var label3:UILabel = UILabel(frame: CGRectMake(3*width/4-50, 4*height/5-25, 100, 50))
        
        label3.textAlignment = NSTextAlignment.Center
        
        label3.text = "\(bestscore2)"
        
        self.view.addSubview(label3)
        
         if width>600{
            kaishi.titleLabel?.font = UIFont.systemFontOfSize(35)
            help.titleLabel?.font = UIFont.systemFontOfSize(20)
            label1.font = UIFont.systemFontOfSize(20)
            label2.font = UIFont.systemFontOfSize(20)
            label3.font = UIFont.systemFontOfSize(20)
            
        }
        
        segment.selectedSegmentIndex = difficulty
        
        segment.addTarget(self, action: "segmentchange:", forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    func segmentchange(sender:AnyObject?){
        var segment:UISegmentedControl = sender as! UISegmentedControl
        
        difficulty = segment.selectedSegmentIndex
    
        score=0
        
        
        for balls in ballarray{
            balls.globe.hidden=true
            balls.globe.removeFromSuperview()
            
        }
        
        var smallsize=self.view.bounds.width/8
        
        ball1.blue()
        ball1.numberinarray=0
        
        ball2.red()
        ball2.numberinarray=1
        
        ball3.green()
        ball3.numberinarray=2
        
        ball1.setupball(width/3-width/16,Y: 2*height/5-width/16,size: smallsize)
        ball2.setupball(2*width/3-width/16,Y: 2*height/5-width/16,size: smallsize)
        ball3.setupball(width/2-width/16, Y: 3*height/5-width/16,size: smallsize)
        ballarray=[ball1,ball2,ball3]
        
        for balls in ballarray{
            balls.randomspeed()
        }
        
        println(difficulty)
    }
    
    func click(){
        
        buttonclick=1
    }
    
    func click2(){
        buttonclick=2
    }
    
    
    
}