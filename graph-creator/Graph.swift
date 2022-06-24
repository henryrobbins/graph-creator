//
//  Graph.swift
//  Graph Creator
//
//  Created by Henry Robbins on 5/30/17.
//  Copyright © 2017 HenryRobbins. All rights reserved.
//

import UIKit

class Graph: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var updateStatistics: UISwitch!
    
    var nodes = [Node]()
    var edges = [Edge]()

    var mx:Double = 0.0
    var my:Double = 0.0
    
    var X_OFFSET:Double = 60
    var Y_OFFSET:Double = 30
    
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
    }
    
    @IBAction func Back(_ sender: Any) {
        let startScreen:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartScreen") as UIViewController
        self.present(startScreen, animated: false, completion: nil)
    }
    
    func reDraw() {
        
    }
    
    @IBAction func switchClicked(_ sender: Any) {

    }
    
    @IBAction func changeLabel(_ sender: Any) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-X_OFFSET
        my = Double(point.y)-Y_OFFSET
        
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
        mx = Double(point.x)-X_OFFSET
        my = Double(point.y)-Y_OFFSET
        
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
            edges.append(Edge(n1: initialNode!, n2: endNode!))
            edges[edges.count-1].setID(id: (edges.count));
            updateStats = true
        }
        
        reDraw()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let point = touch!.location(in: self.view)
        mx = Double(point.x)-X_OFFSET
        my = Double(point.y)-Y_OFFSET
        
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
    
    func compileHashMap() -> [Int: [Int]]{
        return [0:[0]]
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
