//
//  DirectedGraph.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import UIKit

class DirectedGraph: Graph {
    
    // Setup Statistics
    var stats:DirectedStatistics = DirectedStatistics()
    
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
            drawArrow(mx: mx, my: my)
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
    
    func drawArrow(mx :Double, my :Double) {
        
        var x = [Int](repeating: 0, count: 3)
        var y = [Int](repeating: 0, count: 3)
        
        var m:Double = 0;
        var rAngle:Double = 0;
        var height:Double = 0;
        var base:Double = 0;
        
        if (mx - (initialNode?.x)! == 0) {
            height = 10+(2.5*(3.squareRoot()));
            base = 0;
        } else {
            m = (Double)(my-(initialNode?.y)!) / (Double)(mx-(initialNode?.x)!);
            rAngle = atan(abs(m));
            height = (2.5*(3.squareRoot()))*sin(rAngle);
            base = (pow((2.5*3.squareRoot()),2)-pow(height, 2)).squareRoot();
        }
        
        var tx:Double = 0;
        var ty:Double = 0;
        
        if (my-(initialNode?.y)! < 0) {
            if (mx-(initialNode?.x)! < 0) {
                tx = (mx+base);
                ty = (my+height);
            } else {
                tx = (mx-base);
                ty = (my+height);
            }
        } else {
            if (mx-(initialNode?.x)! < 0) {
                tx = (mx+base);
                ty = (my-height);
            } else {
                tx = (mx-base);
                ty = (my-height);
            }
        }
        
        x[0] = (Int) (tx)
        y[0] = (Int) (ty - (2.5*(3.squareRoot())))
        x[1] = (Int) (tx - 5)
        y[1] = (Int) (ty + (2.5*(3.squareRoot())))
        x[2] = (Int) (tx + 5)
        y[2] = (Int) (ty + (2.5*(3.squareRoot())))
        
        var theta:Double = 0
        
        if (mx-(initialNode?.x)! != 0) {
            if (my-(initialNode?.y)! < 0) {
                if (mx-(initialNode?.x)! < 0) {
                    theta = rAngle-(Double.pi/2)
                } else {
                    theta = (Double.pi/2)-rAngle
                }
            } else {
                if (mx-(initialNode?.x)! < 0) {
                    theta = ((Double.pi/2)-rAngle)+Double.pi
                } else {
                    theta = rAngle+(Double.pi/2)
                }
            }
        } else {
            if (my > (initialNode?.y)!) {
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
        }
        
        for node in nodes {
            table[node.id] = node.connections
        }
        
        return table
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-299
        my = Double(point.y)-68
        
        pressed = false
        
        if (tool == 1) {
            if (mx-10 >= 0 && mx-10 <= 725 && my-10 > 0 && my-10 <= 700) {
                nodes.append(Node(x: mx-10,y: my-10));
                nodes[nodes.count-1].setID(id: (nodes.count));
                updateStats = true
            }
        }
        
        if (tool == 2) {
            endNode = findClosestNode()
            edges.append(DirectedEdge(n1: initialNode!, n2: endNode!))
            edges[edges.count-1].setID(id: (edges.count));
            updateStats = true
        }
        
        reDraw()
        
    }
    
    override func switchClicked(_ sender: Any) {
        if updateStatistics.isOn {
            stats.updateHashMap(hM: compileHashMap());
            updateStats = false;
        }
        reDraw()
    }
    
}
