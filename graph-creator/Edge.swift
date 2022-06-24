//
//  Edge.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/24/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import Foundation
import UIKit

class Edge {
    
    var n1:Node
    var n2:Node
    var id:Int = 0;
    
    init (n1 :Node, n2 :Node) {
        self.n1 = n1
        self.n2 = n2
    }
    
    func setID(id : Int) {
        self.id = id
    }
    
    func drawEdge(context: CGContext?) {
        context?.move(to: CGPoint(x: n1.x, y: n1.y))
        context?.addLine(to: CGPoint(x: n2.x, y: n2.y))
        context?.strokePath()
    }
    
    // Gets the distance between the node and an x,y point
    func getDistance(mx :Double, my :Double) -> Double {
        return (pow((mx-((n1.x+n2.x)/2)),2)+pow((my-((n1.y+n2.y)/2)),2)).squareRoot();
    }
}
