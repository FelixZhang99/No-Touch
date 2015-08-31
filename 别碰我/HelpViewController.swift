//
//  HelpViewController.swift
//  别碰我
//
//  Created by Zhangfutian on 15/8/17.
//  Copyright (c) 2015年 Zhangfutian. All rights reserved.
//
import UIKit
import Foundation


class HelpViewController:UIViewController,UIScrollViewDelegate{
    
    let pagenumber = 4
    let pagewidth = width
    let pageheight = height-100
    var scrollView :UIScrollView = UIScrollView(frame: CGRectMake(0, 0, width, height-100))
    var pagecontrol:UIPageControl = UIPageControl(frame: CGRectMake(width/2-150, 9*height/10, 300, 40))
    let content = [
        0:"通过倾斜手机使小球在屏幕上混动",
        1:"使不同颜色的小球避免碰撞，撞击会扣分",
        2:"一段时间后会有新的小球出现，将相同颜色的球靠近会合并加分",
        3:"游戏目标就是尽可能获得更多的分",
    ]
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
       
        
        scrollView.contentSize = CGSizeMake(pagewidth * CGFloat(pagenumber) , pageheight)
        
        scrollView.pagingEnabled = true
        
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.scrollsToTop = false
        
        scrollView.delegate = self
        
        var View1:UIView = UIView(frame: CGRectMake(0, 0, width, height-100))
        scrollView.addSubview(View1)
            
        var View2:UIView = UIView(frame: CGRectMake(width, 0, width, height-100))
        scrollView.addSubview(View2)
    
        var View3:UIView = UIView(frame: CGRectMake(width*2, 0, width, height-100))
        scrollView.addSubview(View3)
        
        var View4:UIView = UIView(frame: CGRectMake(width*3, 0, width, height-100))
        scrollView.addSubview(View4)
        
        var viewarray = [View1,View2,View3,View4]
        
        for i in 0 ... pagenumber-1 {
        
            var contentlabel = UILabel(frame: CGRectMake(width / 10, height/5, 4*width/5, height/5))
        
            contentlabel.font = UIFont.systemFontOfSize(20)
    
            contentlabel.text = content[i]
        
            contentlabel.numberOfLines = 3
        
            viewarray[i].addSubview(contentlabel)
        }
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        
        button.frame = CGRectMake(width/2-80 , 2*height/3, 160, 60)
        
        button.setTitle("开始游戏", forState: .Normal)
        
        button.backgroundColor = UIColor.brownColor()
        
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(27, weight: 4)
        
        button.layer.cornerRadius = 10
        
        button.enabled = true
        
        button.addTarget(self, action: "gogame", forControlEvents: UIControlEvents.TouchUpInside)
        
        View4.addSubview(button)
        
        self.view.addSubview(scrollView)
    
        pagecontrol.numberOfPages = 4
        
        pagecontrol.currentPage = 0
        
        pagecontrol.backgroundColor = UIColor.grayColor()
        
        pagecontrol.layer.cornerRadius = 10
        
        self.view.addSubview(pagecontrol)
    }
    
    
    func gogame(){
        var gameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("sb") as! UIViewController
        
        self.presentViewController(gameViewController, animated: false, completion: nil)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var offX:CGFloat = scrollView.contentOffset.x
        
        var index:Int = Int(offX/width)
        println(index)
        pagecontrol.currentPage = index
    }
    
}





