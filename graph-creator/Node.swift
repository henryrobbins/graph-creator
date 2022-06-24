//
//  File.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/24/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation
import Darwin
import UIKit

class Node {
    
    var x:Double
    var y:Double
    var id:Int = 0;
    var connections = [Int]();
    
    init (x :Double, y :Double) {
        self.x = x+10;
        self.y = y+10;
    }
    
    func setID(id :Int) {
        self.id = id;
    }
    
    func drawNode(context: CGContext?) {
        context?.addEllipse(in: CGRect(x: x-10,y: y-10,width: 20,height: 20))
        context?.fillPath()
    }
    
    func setLocation(x :Double, y :Double) {
        self.x = x;
        self.y = y;
    }
    
    func addConnection(node: Node) {
        connections.append(node.id)
    }
    
    // Gets the distance between the node and an x,y point
    func getDistance(mx :Double, my :Double) -> Double {
        return (pow((mx-x),2)+pow((my-y),2)).squareRoot();
    }
    
    
    
}
