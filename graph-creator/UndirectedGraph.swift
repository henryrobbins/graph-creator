//
//  UndirectedGraph.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import UIKit

class UndirectedGraph: Graph {
    
    // Setup Statistics
    var stats:UndirectedStatistics = UndirectedStatistics()
    
    override func reDraw() {
        
        // Draw Graphics in the img
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 725, height: 700), false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Sets stoke and colors
        context?.setLineWidth(1)
        context?.setFillColor(UIColor.black.cgColor)
        context?.setStrokeColor(UIColor.black.cgColor)
        
        if (tool == 1 && pressed) {
            context?.setFillColor(UIColor.gray.cgColor)
            context?.addEllipse(in: CGRect(x: mx-10,y: my-10,width: 20,height: 20))
            context?.fillPath()
            context?.setFillColor(UIColor.black.cgColor)
        }
        
        if (tool == 2 && pressed) {
            context?.move(to: CGPoint(x: (initialNode?.x)!, y: (initialNode?.y)!))
            context?.addLine(to: CGPoint(x: mx, y: my))
            context?.strokePath()
        }
        
        if (tool == 3 && pressed) {
            context?.setStrokeColor(UIColor.red.cgColor)
            context?.move(to: CGPoint(x: mx-10, y: my-10))
            context?.addLine(to: CGPoint(x: mx+10, y: my+10))
            context?.strokePath()
            context?.move(to: CGPoint(x: mx-10, y: my+10))
            context?.addLine(to: CGPoint(x: mx+10, y: my-10))
            context?.strokePath()
            context?.setStrokeColor(UIColor.black.cgColor)
        }
        
        for id in 0..<nodes.count {
            nodes[id].setID(id: id)
            nodes[id].drawNode(context: context)
        }
        
        for id in 0..<edges.count {
            edges[id].setID(id: id)
            edges[id].drawEdge(context: context)
        }
        
        // Update Stats
        if updateStats {
            if updateStatistics.isOn {
                stats.updateHashMap(hM: compileHashMap());
                updateStats = false;
            }
        }
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            text.text = ""
            for stat in stats.statistics {
                text.text = text.text! + "  \(stat.name): \(stat.statistic) \n"
            }
        } else {
            text.text = ""
            for id in -1...(stats.hashMap.count-1) {
                if (id >= 0) {
                    text.text = text.text! + "\n  \(id+1): ["
                    var first:Bool = true
                    for connection in stats.hashMap[id]! {
                        if (first) {
                            text.text = text.text! + "\(connection+1)"
                            first = false
                        } else {
                            text.text = text.text! + ", \(connection+1)"
                        }
                    }
                    text.text = text.text! + "]"
                }
            }
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = img
    }
    
    override func changeLabel(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            text.text = ""
            for stat in stats.statistics {
                text.text = text.text! + "  \(stat.name): \(stat.statistic) \n"
            }
        } else {
            text.text = ""
            for id in -1...(stats.hashMap.count-1) {
                if (id >= 0) {
                    text.text = text.text! + "\n  \(id+1): ["
                    var first:Bool = true
                    for connection in stats.hashMap[id]! {
                        if (first) {
                            text.text = text.text! + "\(connection+1)"
                            first = false
                        } else {
                            text.text = text.text! + ", \(connection+1)"
                        }
                    }
                    text.text = text.text! + "]"
                }
            }
        }
    }
    
    override func compileHashMap() -> [Int: [Int]]{
        
        var table = [Int: [Int]]()
        
        for id in 0..<nodes.count {
            nodes[id].connections.removeAll()
            nodes[id].setID(id: id)
        }
        
        edges = edges.filter { $0.n1 !== $0.n2 }
        
        for id in 0..<edges.count {
            edges[id].setID(id: id)
            edges[id].n1.addConnection(node: edges[id].n2)
            edges[id].n2.addConnection(node: edges[id].n1)
        }
        
        for node in nodes {
            table[node.id] = node.connections
        }
        
        return table
        
    }
    
    override func switchClicked(_ sender: Any) {
        if updateStatistics.isOn {
            stats.updateHashMap(hM: compileHashMap());
            updateStats = false;
        }
        reDraw()
    }
    
}
