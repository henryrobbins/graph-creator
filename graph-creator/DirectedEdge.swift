//
//  DirectedEdge.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation
import UIKit

class DirectedEdge: Edge {
    
    override init (n1 :Node, n2 :Node) {
        super.init(n1: n1, n2: n2)
    }
    
    override func drawEdge(context: CGContext?) {
        context?.move(to: CGPoint(x: n1.x, y: n1.y))
        context?.addLine(to: CGPoint(x: n2.x, y: n2.y))
        context?.strokePath()
        
        var x = [Int](repeating: 0, count: 3)
        var y = [Int](repeating: 0, count: 3)
        
        var m:Double = 0;
        var rAngle:Double = 0;
        var height:Double = 0;
        var base:Double = 0;
        
        if (n2.x - n1.x == 0) {
            height = 10+(2.5*(3.squareRoot()));
            base = 0;
        } else {
            m = (Double)(n2.y-n1.y) / (Double)(n2.x-n1.x);
            rAngle = atan(abs(m));
            height = (10+2.5*(3.squareRoot()))*sin(rAngle);
            base = (pow((10+2.5*3.squareRoot()),2)-pow(height, 2)).squareRoot();
        }
        
        var tx:Double = 0;
        var ty:Double = 0;
        
        if (n2.y-n1.y < 0) {
            if (n2.x-n1.x < 0) {
                tx = (n2.x+base);
                ty = (n2.y+height);
            } else {
                tx = (n2.x-base);
                ty = (n2.y+height);
            }
        } else {
            if (n2.x-n1.x < 0) {
                tx = (n2.x+base);
                ty = (n2.y-height);
            } else {
                tx = (n2.x-base);
                ty = (n2.y-height);
            }
        }
        
        x[0] = (Int) (tx)
        y[0] = (Int) (ty - (2.5*(3.squareRoot())))
        x[1] = (Int) (tx - 5)
        y[1] = (Int) (ty + (2.5*(3.squareRoot())))
        x[2] = (Int) (tx + 5)
        y[2] = (Int) (ty + (2.5*(3.squareRoot())))
        
        var theta:Double = 0
        
        if (n2.x-n1.x != 0) {
            if (n2.y-n1.y < 0) {
                if (n2.x-n1.x < 0) {
                    theta = rAngle-(Double.pi/2)
                } else {
                    theta = (Double.pi/2)-rAngle
                }
            } else {
                if (n2.x-n1.x < 0) {
                    theta = ((Double.pi/2)-rAngle)+Double.pi
                } else {
                    theta = rAngle+(Double.pi/2)
                }
            }
        } else {
            if (n2.y > n1.y) {
                theta = Double.pi
            }
        }
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: x[0], y: y[0]))
        trianglePath.addLine(to: CGPoint(x: x[1], y: y[1]))
        trianglePath.addLine(to: CGPoint(x: x[2], y: y[2]))
        trianglePath.close()
        
        trianglePath.apply(CGAffineTransform(translationX: CGFloat(tx), y: CGFloat(ty)).inverted())
        trianglePath.apply(CGAffineTransform(rotationAngle: CGFloat(theta)))
        trianglePath.apply(CGAffineTransform(translationX: CGFloat(tx), y: CGFloat(ty)))
        
        trianglePath.fill()
        
        
    }
    
}
