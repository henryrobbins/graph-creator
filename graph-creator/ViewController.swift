//
//  ViewController.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    var nodes = [Node]()
    var edges = [Edge]()
    
    var mx:Double = 0.0
    var my:Double = 0.0
    
    var initialNode:Node?
    var endNode:Node?
    var moveNode:Node?
    var deleteNode:Node?
    var deleteEdge:Edge?
    
    var pressed = false
    var tool:Int = 3
    
    var updateStats:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func reDraw() {
        
        // Draw Graphics in the img
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 725, height: 700), false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Sets stoke and colors
        context?.setLineWidth(2)
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
        
        if updateStats {
            // compileTable()
            text.numberOfLines = 0
            text.text = " Nodes: \(nodes.count) \n Edges: \(edges.count)"
            updateStats = false
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = img
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-299
        my = Double(point.y)-68
        
        pressed = true
        
        if (tool == 2) {
            initialNode = findClosestNode()
        }
        
        if (tool == 3) {
            if (nodes.count>0 && edges.count>0) {
                deleteNode = findClosestNode();
                let nodeDistance:Double = (deleteNode?.getDistance(mx: mx, my: my))!
                deleteEdge = findClosestEdge();
                let edgeDistance:Double = (deleteEdge?.getDistance(mx: mx, my: my))!
                if (nodeDistance < edgeDistance) {
                    nodes.remove(at: (deleteNode?.id)!)
                    edges = edges.filter { $0.n1 !== deleteNode && $0.n2 !== deleteNode}
                } else {
                    edges.remove(at: (deleteEdge?.id)!)
                }
            } else if (nodes.count>0) {
                deleteNode = findClosestNode();
                nodes.remove(at: (deleteNode?.id)!)
                edges = edges.filter { $0.n1 !== deleteNode && $0.n2 !== deleteNode}
                
            } else if (edges.count>0){
                deleteEdge = findClosestEdge();
                edges.remove(at: (deleteEdge?.id)!)
            }
            updateStats = true
        }
        
        if (tool == 4) {
            moveNode = findClosestNode()
        }
        
        reDraw()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-299
        my = Double(point.y)-68
        
        pressed = false
        
        if (tool == 1) {
            nodes.append(Node(x: mx-10,y: my-10));
            nodes[nodes.count-1].setID(id: (nodes.count));
            updateStats = true
        }
        
        if (tool == 2) {
            endNode = findClosestNode()
            edges.append(Edge(n1: initialNode!, n2: endNode!))
            edges[edges.count-1].setID(id: (edges.count));
            updateStats = true
        }
        
        reDraw()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-299
        my = Double(point.y)-68
        
        pressed = true
        
        if (tool == 4) {
            moveNode?.setLocation(x: mx, y: my)
        }
        
        reDraw()
        
    }
    
    @IBAction func addNode(_ sender: UIButton) {
        tool = 1;
        
    }
    
    @IBAction func addEdge(_ sender: UIButton) {
        tool = 2;
    }
    
    @IBAction func deleteTool(_ sender: UIButton) {
        tool = 3;
    }
    
    
    @IBAction func moveTool(_ sender: UIButton) {
        tool = 4;
    }
    
    func compileTable() -> [Int: [Int]]{
        
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
            table[node.id+1] = node.connections
        }
        
        return table
        
        
    }
    
    // Finds the closest node to the current mousePosition
    func findClosestNode() -> Node {
        
        var min:Double = nodes[0].getDistance(mx: mx, my: my-25);
        var closest:Node = nodes[0];
        
        for node in nodes {
            if (node.getDistance(mx: mx, my: my-25) < min) {
                min = node.getDistance(mx: mx, my: my-25);
                closest = node;
            }
        }
        
        return closest;
    }
    
    // Finds the closest edge to the current mousePosition
    func findClosestEdge() -> Edge {
        
        var min:Double = edges[0].getDistance(mx: mx, my: my-25);
        var closest:Edge = edges[0];
        
        for edge in edges {
            if (edge.getDistance(mx: mx, my: my-25) < min) {
                min = edge.getDistance(mx: mx, my: my-25);
                closest = edge;
            }
        }
        
        return closest;
    }
    
    
}
