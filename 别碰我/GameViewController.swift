//
//  GameViewController.swift
//  别碰我
//
//  Created by Zhangfutian on 15/8/14.
//  Copyright (c) 2015年 Zhangfutian. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    var bestscore = 0
    var runtime=0
    var motionManager=CMMotionManager()
    var temarray=ballarray
    
    var stopbuttom=UIButton(frame: CGRectMake(width-60, 20, 50, 40))
    var buttonshow=false
    
    var startViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("start") 
    
    let viewTransitionDelegate = TransitionDelegate()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let modal=segue.destinationViewController as! StartViewController
            
        modal.transitioningDelegate = viewTransitionDelegate
            
        modal.modalPresentationStyle = .Custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
           
            
            switch difficulty{
            case 0:
                bestscore = bestscore0
                motion=60
                mpoint=250
            case 1:
                bestscore = bestscore1
                motion=70
                mpoint=500
            case 2:
                bestscore = bestscore2
                motion=80
                mpoint=1000
            default:""
            }
            
            
            if firsttime == true{
                startgame()
            }
            stopbuttom.addTarget(self, action: Selector("suspend"), forControlEvents: UIControlEvents.TouchUpInside)
            
            stop=true
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("begin"), userInfo: nil, repeats: false)
            
            for show in ballarray{
                self.view.addSubview(show.globe)
                show.globe.bounds.size = CGSizeMake(width/8, width/8)
            }
            
            needbegin=false
            
            
            motionManager.accelerometerUpdateInterval = NSTimeInterval(1/motion)
            
            scoreandbest()
            
            
        
            
            if (motionManager.accelerometerAvailable)  {
                var queue=NSOperationQueue.currentQueue()
                
                motionManager.startAccelerometerUpdatesToQueue(queue! , withHandler: {( accelerometerData :CMAccelerometerData!,error:NSError!) in
                    
                   
                    
                    if stop{
                        self.stopbuttom.enabled = false
                        
                    }
                    
                    if needbegin{
                        if !self.buttonshow{
                            self.suspend()
                        }
                        needbegin=false
                    }
                    
                    if !stop{
                        
                     
                        self.stopbuttom.enabled = true
                        
                        var X = accelerometerData.acceleration.x
                        var Y = accelerometerData.acceleration.y
                        
                        //gun
                        
                        for ballgun in ballarray{
                            
                            ballgun.gun(X,Y:Y)
                            
                        }
                        
                        
                        
                        //crash
                        
                        
                        self.temarray=ballarray
                        for ballcrash in ballarray{
                            self.temarray.removeAtIndex(0)
                            
                            for ball2crash in self.temarray{
                                if ballcrash != ball2crash{
                                    ballcrash.crash(ball2crash)
                                }
                                
                            }
                            
                        }
                        
                        //point
                        
                        if score<0{
                            score=0
                        }
                        
                        if newscore<0{
                            newscore=0
                        }
                        
                        if newscore>1000{
                            newscore=0
                            
                            
                            supertime=true
                            var newball=ball()
                            
                            var colornumber=random()%3
                            newball.globe.hidden=false
                            if colornumber == 0{
                                newball.red()
                                
                            }else if colornumber==1{
                                newball.blue()
                            }else if colornumber==2{
                                newball.green()
                            }
                            
                            newball.setupball(166.5, Y: width/16, size: width/8)
                            
                            newball.randomspeed()
                            newball.numberinarray = ballarray.count
                            newball.globe.alpha=0
                            
                            ballarray.append(newball)
                            
                            self.view.addSubview(newball.globe)
                            
                            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {()->Void in
                                newball.globe.alpha=1
                                
                                
                                }, completion: {(finished:Bool)->Void in
                                    
                                    supertime=false
                                    
                            })
                            
                        }
                        
                        
                        
                        score++
                        newscore++
                        
                        if score>self.bestscore{
                            self.bestscore=score
                        }
                        
                        self.view.bringSubviewToFront(self.scores)
                        self.view.bringSubviewToFront(self.best)
                        self.view.bringSubviewToFront(self.stopbuttom)
                        
                       
                        self.scores.text="分数：\(score)"
                        self.best.text="最高分数：\(self.bestscore)"
                        
                        switch difficulty{
                        case 0:bestscore0=self.bestscore
                        case 1:bestscore1=self.bestscore
                        case 2:bestscore2=self.bestscore
                        default:""
                        }
                        
                        //pointview
                        if vp==true{
                            
                            vp=false
                            
                            
                            let pointlabel=UILabel(frame: CGRectMake(width/3, height/10+8, 100, 50))
                            
                            pointlabel.textAlignment = NSTextAlignment.Center
                            
                            switch pointview{
                            case "-250":
                                score -= 250
                                newscore -= 250
                                pointlabel.textColor=UIColor.redColor()
                            case "-500":
                                score -= 500
                                newscore -= 500
                                pointlabel.textColor=UIColor.redColor()
                            case "-1000":
                                score -= 1000
                                newscore -= 1000
                                pointlabel.textColor=UIColor.redColor()
                            case "+500":
                                score += 500
                                pointlabel.textColor=UIColor.greenColor()
                            default:""
                            }
                            
                            pointlabel.font=UIFont.systemFontOfSize(14)
                            
                            
                            pointlabel.text=pointview
                            
                            self.view.addSubview(pointlabel)
                            
                            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {()->Void in
                                pointlabel.transform = CGAffineTransformMakeTranslation(0, -30)
                                
                                }, completion: {(finished:Bool)->Void in
                                    UIView.animateWithDuration(0.3, animations: {()-> Void in
                                        pointlabel.alpha=0
                                      
                                        }, completion: {(finished:Bool)->Void in
                                        
                                            pointlabel.removeFromSuperview()
                                        
                                        } )
                                    
                                    
                            })
                            
                            gapbool=true
                            
                        }
                        if gapbool==true{
                            gap++
                            if gap>=30{
                                gapbool=false
                                gap=0
                            }
                        }
                    }
                })
                
            }
            
        }
    }
    
    
    
    //start
    
    func startgame(){
        
        
        let smallsize=self.view.bounds.width/8
        
        needbegin=false
        
        firsttime=false
        
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
        
        
        
    }
    
    
    //stop
    
    var continuegame:UIButton!
    var restart:UIButton!
    var help:UIButton!
    var meun:UIButton!
    
    
    func suspend(){
        
        save()
        
        
       
        buttonshow=true
        
        stop=true
        
        continuegame = mybutton("继续游戏", y: height/2-90)
        
        restart = mybutton("重新开始", y: height/2 - 45)
            
        help = mybutton("帮助", y: height/2)
            
        meun = mybutton("返回菜单", y: height/2 + 45)
            
        continuegame.addTarget(self, action: Selector("cg"), forControlEvents: UIControlEvents.TouchUpInside)
            
        restart.addTarget(self, action: Selector("replay"), forControlEvents: UIControlEvents.TouchUpInside)
        
        help.addTarget(self, action: Selector("gohelp"), forControlEvents: UIControlEvents.TouchUpInside)
        
        meun.addTarget(self, action: Selector("gomeun"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    func mybutton(txt:String,y:CGFloat)-> UIButton{
        let button : UIButton = UIButton(type: UIButtonType.System)
        
        button.frame = CGRectMake(width, y, 120, 40)
        
        button.setTitle(txt, forState: .Normal)
        
        button.backgroundColor = UIColor.brownColor()
        
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        button.titleLabel?.font = UIFont.systemFontOfSize(20, weight: 4)
        
        button.layer.cornerRadius = 10
        
        self.view.addSubview(button)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            button.transform = CGAffineTransformMakeTranslation( -(width/2)-60 , 0)
        })
        return button
    }
    
    func cg(){
      
        
        
        continuegame.removeFromSuperview()
        
        restart.removeFromSuperview()
        
        help.removeFromSuperview()
        
        meun.removeFromSuperview()
        
        begin()
        
        buttonshow=false
        
        
        
    }
    
    func replay(){
        
        score=0
        
        newscore=0
        
        buttonshow=false
        
        for balls in ballarray{
            balls.globe.hidden=true
            balls.globe.removeFromSuperview()
            
        }
        
        scores.removeFromSuperview()
        
        best.removeFromSuperview()
       
        continuegame.removeFromSuperview()
        
        restart.removeFromSuperview()
       
        help.removeFromSuperview()
       
        meun.removeFromSuperview()
        
        stopbuttom.addTarget(self, action: Selector("suspend"), forControlEvents: UIControlEvents.TouchUpInside)
        
        stop=true
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("begin"), userInfo: nil, repeats: false)
        
        
        motionManager.accelerometerUpdateInterval=1/80
        scoreandbest()
        
        startgame()
        
        for show in ballarray{
            self.view.addSubview(show.globe)
            show.randomspeed()
        }
    }
    
    func gohelp(){
        
        
        
        let helpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("help") 
        
        self.presentViewController(helpViewController, animated: false, completion: nil)
    }
    
    func gomeun(){
        
        
        save()
        
        self.presentViewController(startViewController, animated: false, completion: nil)
        
    }
    //score
    
    var scores:UILabel!
    var best:UILabel!
    
    func scoreandbest(){
        
        
        stopbuttom.setBackgroundImage(UIImage(named: "stop.tif"), forState: UIControlState.Normal)
        self.view.addSubview(stopbuttom)
        
        scores=UILabel(frame: CGRectMake(width/3-100, height/10, 150,30))
        scores.textAlignment = NSTextAlignment.Center
        scores.text="分数：\(score)"

        scores.textColor=UIColor.blackColor()
        self.view.addSubview(scores)
        
        
        
        best=UILabel(frame: CGRectMake(2*width/3-65, height/10, 180, 30))
        best.textAlignment = NSTextAlignment.Center
        best.text="最高分数：\(bestscore)"

        best.textColor=UIColor.blackColor()
        self.view.addSubview(best)
    }
    
    //321
    
    func begin(){
        stop=true
        var timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("wait"), userInfo: nil, repeats: false)
        jumpnumber("准备")
        
        var timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("go1"), userInfo: nil, repeats: false)
        
        var timer3 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("go2"), userInfo: nil, repeats: false)
        
        var timer4 = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("go3"), userInfo: nil, repeats: false)
        
        
    }
    
    func wait(){
        stop=false
    }
    func go1(){
        jumpnumber("3")
    }
    
    func go2(){
        jumpnumber("2")
    }
    
    func go3(){
        jumpnumber("1")
    }
    
    func jumpnumber(number:String){
        let label=UILabel(frame: CGRectMake(width/2-60, height/2-60, 120, 120))
        label.textAlignment = NSTextAlignment.Center

        
        label.text=number
        
        label.textColor = UIColor.yellowColor()
        
        label.font = UIFont.systemFontOfSize(60, weight: 2.5)
        
        self.view.addSubview(label)
        
        
        UIView.animateWithDuration(0.5, delay: 0 , options: UIViewAnimationOptions.CurveLinear, animations:{()->Void in
            
            label.transform = CGAffineTransformMakeScale(0.7, 0.7)
            }, completion: {(finished:Bool)->Void in
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    label.alpha=0
                    },completion:{(finished:Bool)->Void in
                
                        label.removeFromSuperview()
                
                
                })
                
                
        })
        
        
    }
    
   

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
