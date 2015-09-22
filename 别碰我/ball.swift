//
//  ball.swift
//  别碰我
//
//  Created by Zhangfutian on 15/8/14.
//  Copyright (c) 2015年 Zhangfutian. All rights reserved.
//
import UIKit
import Foundation

var ball1 = ball()
var ball2 = ball()
var ball3 = ball()
var ballarray:[ball] = []
var width = CGFloat()
var height = CGFloat()
var score = 0

var newscore = 0
var pointview=""
var vp=false
var gap=0
var gapbool=false
var stop=false
var supertime=false
var bestscore0:Int = 0
var bestscore1:Int = 0
var bestscore2:Int = 0
var needbegin=false
var difficulty = 0


class ball:UIView{
    
    var globe:UIImageView=UIImageView(image: UIImage(named: "whiteball.png"))
    var elasticity:Double = -0.4
    var speedX:Double=0.0
    var speedY:Double=0.0
    var size=CGFloat()
    var change=false
    var galary=1.0
    var numberinarray = 0
    
    func setupball(X:CGFloat,Y:CGFloat,size:CGFloat){
        self.globe.frame=CGRectMake(X, Y, size, size)
        self.size=size
    }
    
    func randomspeed(){
        speedX=Double(random()%10 - 5)
        speedY=Double(random()%10 - 5)
    }
    
    
    func gun(X:Double,Y:Double)->(){
        
        self.speedX += X * galary
        self.speedY += Y * galary
        
        var posX=self.globe.center.x+CGFloat(speedX)
        var posY=self.globe.center.y-CGFloat(speedY)
        
        
        
        if posX<size/2{
            posX=size/2
            speedX *= self.elasticity
        } else if posX>width - size/2 {
            posX=width-size/2
            speedX *= self.elasticity
        }
        
        if posY<size/2{
            posY=size/2
            speedY *= self.elasticity
        } else if posY>height - size/2 {
            posY=height - size/2
            speedY *= self.elasticity
            
        }
        self.globe.center=CGPointMake(posX, posY)
    
        
    }
    
    func crash(sball:ball)->(){
        
        var speedX2=sball.speedX
        var speedY2=sball.speedY
        
        let dirX=Double(self.globe.center.x - sball.globe.center.x)
        let dirY=Double(sball.globe.center.y - self.globe.center.y)
        let dir=sqrt(dirX*dirX+dirY*dirY)
        
        
        if dir < Double(size) {
            
            //penalty
            
            if self.getcolor() != sball.getcolor(){
                
                
                //go
                
                let avgspeedX =  (abs(speedX - speedX2))/2
                let avgspeedY =  (abs(speedY - speedY2))/2
                
                
                if ((dirX>0)&&(speedX>0))||((dirX<0)&&(speedX<0)){
                    if speedX>0{
                        speedX += avgspeedX
                    }
                    else{
                        speedX -= avgspeedX
                    }
                }else{
                    
                    speedX *= (-avgspeedX) / abs(speedX)
                }
                
                if ((dirX>0)&&(speedX2<0))||((dirX<0)&&(speedX2>0)){
                    
                    
                    if speedX2>0{
                        speedX2 += avgspeedX
                    }else{
                        speedX2 -= avgspeedX
                    }
                    
                    
                    
                }else{
                    
                    speedX2 *= (-avgspeedX) / abs(speedX2)
                    
                }
                
                
                if ((dirY>0)&&(speedY>0))||((dirY<0)&&(speedY<0)){
                    if speedY>0{
                        speedY += avgspeedY
                    }else{
                        speedY -= avgspeedY
                    }
                }else{
                    speedY *= (-avgspeedY) /  abs(speedY)
                    
                }
                if ((dirY>0)&&(speedY2<0))||((dirY<0)&&(speedY2>0)){
                    
                    if speedY2>0{
                        
                        speedY2 += avgspeedY
                    }else{
                        speedY2 -= avgspeedY
                    }
                }else{
                    
                    speedY2 *= (-avgspeedY) / abs(speedY2)
                }
                
                let temX=self.globe.center.x
                let temY=self.globe.center.y
                let temX2=sball.globe.center.x
                let temY2=sball.globe.center.y
                
                
                self.globe.center=CGPointMake(temX2 + CGFloat(dirX/dir * Double(size)), temY2 - CGFloat(dirY/dir * Double(size)))
                sball.globe.center=CGPointMake(temX - CGFloat(dirX/dir * Double(size)), temY + CGFloat(dirY/dir * Double(size)))
                
                sball.speedX=speedX2
                sball.speedY=speedY2
                
                if supertime && sball == ballarray[ballarray.count-1]{
                    
                    
                    
                }else if gapbool==false{
                    
                    pointview="-\(mpoint)"
                    
                    
                    vp=true
                    
                }
                
                //merge
                
            }else{
                
                
                pointview="+500"
                vp=true
                
                score+=500
                
                
                UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {()-> Void in
                    sball.globe.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(CGFloat(dirX+self.speedX*8), CGFloat(-dirY+self.speedY*8)),
                        CGAffineTransformMakeScale(0.5, 0.5))
                    
                    
                    }, completion: {(finished:Bool)-> Void in
                        
                        sball.globe.removeFromSuperview()
                        sball.globe.hidden=true
                        
                        
                        
                })
                
                ballarray.removeAtIndex(sball.numberinarray)
                
                for number in ballarray{
                    if number.numberinarray > sball.numberinarray{
                        number.numberinarray--
                    }
                    
                }
                
                
                
            }
            
            
        }
        
        
        
    }
    
    //color
    
    
    var redball = false
    var blueball = false
    var greenball = false
    
    func red(){
        redball=true
        blueball=false
        greenball=false
        self.globe=UIImageView(image: UIImage(named: "ball1.tif"))
        self.elasticity = -0.39
        self.galary=1.02
        
    }
    
    
    func blue(){
        redball=false
        blueball=true
        greenball=false
        self.globe=UIImageView(image: UIImage(named: "ball.tif"))
        self.elasticity = -0.4
        self.galary = 0.98
    }
    
    
    func green(){
        redball=false
        blueball=false
        greenball=true
        self.globe=UIImageView(image: UIImage(named: "ball2.tif"))
        self.elasticity = -0.41
        self.galary = 1.01
    }
    
    func isred()->Bool{
        return redball
    }
    
    func isblue()->Bool{
        return blueball
        
    }
    
    func isgreen()->Bool{
        return greenball
    }
    
    func getcolor()->String{
        var name:String="nocolor"
        if redball==true{
            name="red"
        }
        if blueball==true{
            name="blue"
        }
        if greenball==true{
            name="green"
        }
        return name
    }
    
    
    
}


//save
var firsttime = false


let filemanager = NSFileManager.defaultManager()

let Documenturl = filemanager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)

let url = Documenturl[0] 

var error:NSErrorPointer = nil

let file = url.URLByAppendingPathComponent("save number.txt")

let file2 = url.URLByAppendingPathComponent("save ball.txt")

let file3 = url.URLByAppendingPathComponent("save difficulty.txt")

func save(){
    
    let nsarray : NSArray = [score,bestscore0,bestscore1,bestscore2]
    
    nsarray.writeToURL(file, atomically: true)
    
    var temarray : Array = [Double(ballarray.count)]
    
    for i in 0...ballarray.count-1{
        for data in 1...5{
            switch data{
            case 1:var colornumber=0
                if ballarray[i].isred(){
                    colornumber=0
                }else if ballarray[i].isblue(){
                    colornumber=1
                }else if ballarray[i].isgreen(){
                    colornumber=2
            }
            
            temarray.append(Double(colornumber))
            ;
            case 2: temarray.append(Double(ballarray[i].globe.center.x));
            case 3: temarray.append(Double(ballarray[i].globe.center.y));
            case 4: temarray.append(Double(ballarray[i].speedX));
            case 5: temarray.append(Double(ballarray[i].speedY));
                
            default:""
            }
            
        }
    }
    
    let nsarray2 : NSArray = temarray
    
    nsarray2.writeToURL(file2, atomically: true)
    
    print(nsarray)
    
    print(nsarray2)
    
    firsttime=false
    
    let nsarray3 : NSArray = [difficulty]
    
    nsarray3.writeToURL(file3, atomically: true)
    
    print(nsarray3)
}



func load(){
    
    let exist = filemanager.fileExistsAtPath(file.path!)
    
    if !exist{
        let nsarray : NSArray = [0,0,0,0]
        
        nsarray.writeToURL(file, atomically: true)
    
        firsttime = true
    }
    
    let exist2 = filemanager.fileExistsAtPath(file2.path!)
    
    if !exist2{
        let nsarray2 : NSArray = [3 , 1.0 , width/3 , 2*height/5 , 0.0 , 0.0 , 0.0 , 2*width/3, 2*height/5, 0.0 , 0.0 , 2.0 , width/2,  3*height/5 , 0.0 , 0.0]
        
        nsarray2.writeToURL(file2, atomically: true)
    }
    
    let exist3 = filemanager.fileExistsAtPath(file3.path!)
    
    if !exist3{
        let nsarray3 : NSArray = [0]
        
        nsarray3.writeToURL(file3, atomically: true)
    }
    
    //score
    
    let scorearray: NSArray = NSArray(contentsOfURL: file)!
    
    let number = (scorearray.firstObject) as! NSNumber
    
    let number2 = (scorearray[1]) as! NSNumber
    
    let number3 = (scorearray[2]) as! NSNumber
    
    let number4 = (scorearray[3]) as! NSNumber
    
    score = number.integerValue
    
    bestscore0 = number2.integerValue
    
    bestscore1 = number3.integerValue
    
    bestscore2 = number4.integerValue
    
    //ball
    
    let loadball : NSArray = NSArray(contentsOfURL: file2)!
    
    let temarray : Array = loadball as! [Double]
    
    print(temarray, terminator: "")
        
    var numberinarray=0
    
    ballarray=[]
    
    for i in 0...Int(temarray[0]-1){
        
        
        let newball=ball()
    
        var posX:CGFloat=0
        
        var posY:CGFloat=0
        
        
        ballarray.append(newball)
        
        
        for data in 1...5{
            numberinarray++
            
            
            
            print(numberinarray)
            switch data{
            case 1: let colornumber=temarray[numberinarray]
            if colornumber == 0{
                ballarray[i].red()
            }else if colornumber==1{
                ballarray[i].blue()
            }else if colornumber==2{
                ballarray[i].green()
            };
            case 2: posX = CGFloat(temarray[numberinarray]);
            case 3: posY = CGFloat(temarray[numberinarray]);
            case 4: ballarray[i].speedX = temarray[numberinarray];
            case 5: ballarray[i].speedY = temarray[numberinarray];
            
            default:""
            }
        
            
            
        }
        newball.setupball(posX - width/16 , Y: posY - width/16 , size: width/8)
        
    }
    
    if firsttime==true{
        for balls in ballarray{
            balls.randomspeed()
        }
    }
    
    //difficulty
    
    let darray:NSArray = NSArray(contentsOfURL: file3)!
    
    let dnumber = (darray[0]) as! NSNumber
    
    difficulty = dnumber.integerValue
    
    
}






